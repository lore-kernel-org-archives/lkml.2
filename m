Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab2IIHjH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 03:39:07 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54139 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2IIHjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 03:39:05 -0400
Date: Sun, 9 Sep 2012 00:38:27 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Arvydas Sidorenko <asido4@gmail.com>
cc: Jeff Garzik <jgarzik@pobox.com>, Zheng Liu <wenqing.lz@taobao.com>,
        linux-kernel@vger.kernel.org,
        IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Storage related regression in linux-next 20120824
In-Reply-To: <503BB4BB.4080307@gmail.com>
Message-ID: <alpine.LSU.2.00.1209090012390.2416@eggly.anvils>
References: <CA+6av4=uxu_q5U_46HtpUt=FSgbh3pZuAEY54J5_xK=MKWq-YQ@mail.gmail.com> <CAFtxgO536xEMjMw_D1u3utT1f1iy-6EsjcawdYvbocRxc=Wu=A@mail.gmail.com> <503BA2DB.9080704@gmail.com> <503BB4BB.4080307@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2012, Arvydas Sidorenko wrote:
> On 08/27/2012 06:39 PM, Arvydas Sidorenko wrote:
> > > Can you pastebin 'dmesg' and 'lspci'?  Did this occur only once, or is
> > > it reproducible?
> > > 
> > >       Jeff
> > It does happen every time when booting into -next 20120824.

I don't know what went into next-20120824 versus next-20120813 (which
you reported to be good), but I'm seeing similar behaviour on PowerMac
G5 on Thursday's mmotm based on next-20120907 - critical target error,
root remounted read-only, the reboot with good kernel then has to fsck
(although fsck doesn't find anything interesting to fix in my case).

> > [   11.035530] sd 0:0:0:0: [sda]
> > [   11.035533] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> > [   11.035535] sd 0:0:0:0: [sda]
> > [   11.035536] Sense Key : Illegal Request [current]
> > [   11.035539] sd 0:0:0:0: [sda]
> > [   11.035541] Add. Sense: Invalid field in cdb
> > [   11.035543] sd 0:0:0:0: [sda] CDB:
> > [   11.035544] Write(10): 2a 08 0b ad d1 78 00 00 08 00
> > [   11.035550] end_request: critical target error, dev sda, sector
> > 195940728
> > [   11.035552] end_request: critical target error, dev sda, sector
> > 195940728
> > [   11.035557] Aborting journal on device sda4-8.
> > [   11.046413] EXT4-fs error (device sda4): ext4_journal_start_sb:348:
> > Detected aborted journal
> > [   11.046418] EXT4-fs (sda4): Remounting filesystem read-only
> > 
> I believe the problem is in SCSI. Mode sense command catches my attention:
>     [    3.955397] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 10
> All logs from older kernels has different mode page code: 00 3a 00 00
> 
> sg_modes from broken kernel shows DPOFUA set, which is 0x10th bit.
> Anyone knowing SCSI better could tell if that might cause the problems?

I think you know your way around SCSI/libata much better than I do.

I just bisected linux-next, and it comes down to the commit below, which
introduces the regression for me, and I'm guessing for you also.  Maybe
it can be fixed up to satisfy us, but otherwise will have to be reverted:
we don't invert a default if it's going to break older working systems.

A good workaround for me meanwhile is to add boot option "libata.fua=0":
please try that (or reverting the commit) and let us know the result.

Thanks,
Hugh

commit 91895b786e631ab47b618c901231f22b5a44115b
Author: Zheng Liu <wenqing.lz@taobao.com>
Date:   Tue May 8 11:24:03 2012 +0800

    libata: enable SATA disk fua detection on default
    
    Currently, SATA disk fua detection is disabled on default because most of
    devices don't support this feature at that time.  With the development of
    technology, more and more SATA disks support this feature.  So now we can enable
    this detection on default.
    
    Although fua detection is defined as a kernel module parameter, it is too hard
    to set its value because it must be loaded and set before system starts up.
    That needs to modify initrd file.  So it is inconvenient for administrator who
    needs to manage a huge number of servers.
    
    Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 5eee1c1..c3fbdca 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -135,9 +135,9 @@ int atapi_passthru16 = 1;
 module_param(atapi_passthru16, int, 0444);
 MODULE_PARM_DESC(atapi_passthru16, "Enable ATA_16 passthru for ATAPI devices (0=off, 1=on [default])");
 
-int libata_fua = 0;
+int libata_fua = 1;
 module_param_named(fua, libata_fua, int, 0444);
-MODULE_PARM_DESC(fua, "FUA support (0=off [default], 1=on)");
+MODULE_PARM_DESC(fua, "FUA support (0=off, 1=on [default])");
 
 static int ata_ignore_hpa;
 module_param_named(ignore_hpa, ata_ignore_hpa, int, 0644);
