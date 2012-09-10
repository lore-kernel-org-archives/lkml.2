Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab2IJRnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:43:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37014 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756997Ab2IJRns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:43:48 -0400
Date: Mon, 10 Sep 2012 10:43:13 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Jeff Garzik <jgarzik@pobox.com>
cc: Arvydas Sidorenko <asido4@gmail.com>, Dieter Ries <clip3@gmx.de>,
        Zheng Liu <wenqing.lz@taobao.com>, linux-kernel@vger.kernel.org,
        IDE/ATA development list <linux-ide@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Storage related regression in linux-next 20120824
In-Reply-To: <504CFBE3.401@pobox.com>
Message-ID: <alpine.LSU.2.00.1209101021590.2474@eggly.anvils>
References: <CA+6av4=uxu_q5U_46HtpUt=FSgbh3pZuAEY54J5_xK=MKWq-YQ@mail.gmail.com> <CAFtxgO536xEMjMw_D1u3utT1f1iy-6EsjcawdYvbocRxc=Wu=A@mail.gmail.com> <503BA2DB.9080704@gmail.com> <503BB4BB.4080307@gmail.com> <alpine.LSU.2.00.1209090012390.2416@eggly.anvils>
 <CA+6av4=6WeLcde5me2FCpBtQJAOTtHZvf4pkMExgMW9agVNLWg@mail.gmail.com> <504CFBE3.401@pobox.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Sep 2012, Jeff Garzik wrote:
> On 09/09/2012 04:11 PM, Arvydas Sidorenko wrote:
> > > I think you know your way around SCSI/libata much better than I do.
> > > 
> > > I just bisected linux-next, and it comes down to the commit below, which
> > > introduces the regression for me, and I'm guessing for you also.  Maybe
> > > it can be fixed up to satisfy us, but otherwise will have to be reverted:
> > > we don't invert a default if it's going to break older working systems.
> > > 
> > > A good workaround for me meanwhile is to add boot option "libata.fua=0":
> > > please try that (or reverting the commit) and let us know the result.
> > > 
> > > Thanks,
> > > Hugh
> > > 
> > > commit 91895b786e631ab47b618c901231f22b5a44115b
> > > Author: Zheng Liu <wenqing.lz@taobao.com>
> > > Date:   Tue May 8 11:24:03 2012 +0800
> > > 
> > >      libata: enable SATA disk fua detection on default
> > > 
> > >      Currently, SATA disk fua detection is disabled on default because
> > > most of
> > >      devices don't support this feature at that time.  With the
> > > development of
> > >      technology, more and more SATA disks support this feature.  So now
> > > we can enable
> > >      this detection on default.
> > > 
> > >      Although fua detection is defined as a kernel module parameter, it
> > > is too hard
> > >      to set its value because it must be loaded and set before system
> > > starts up.
> > >      That needs to modify initrd file.  So it is inconvenient for
> > > administrator who
> > >      needs to manage a huge number of servers.
> > > 
> > >      Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > >      Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> > > 
> > > diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> > > index 5eee1c1..c3fbdca 100644
> > > --- a/drivers/ata/libata-core.c
> > > +++ b/drivers/ata/libata-core.c
> > > @@ -135,9 +135,9 @@ int atapi_passthru16 = 1;
> > >   module_param(atapi_passthru16, int, 0444);
> > >   MODULE_PARM_DESC(atapi_passthru16, "Enable ATA_16 passthru for ATAPI
> > > devices (0=off, 1=on [default])");
> > > 
> > > -int libata_fua = 0;
> > > +int libata_fua = 1;
> > >   module_param_named(fua, libata_fua, int, 0444);
> > > -MODULE_PARM_DESC(fua, "FUA support (0=off [default], 1=on)");
> > > +MODULE_PARM_DESC(fua, "FUA support (0=off, 1=on [default])");
> > > 
> > >   static int ata_ignore_hpa;
> > >   module_param_named(ignore_hpa, ata_ignore_hpa, int, 0644);
> > 
> > Indeed, disabling FUA explicitly solved the issue on my disk as well.

Good, thanks for letting us know.

> > Hugh, what hard drive you have this issue on?

The machine is a PowerMac G5, and here are (I think)
the relevant lines from dmesg (from a libata.fua=0 bootup):

ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: WDC WD2500JS-41MVB1, 10.02E01, max UDMA/133
ata1.00: 488397168 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      WDC WD2500JS-41M 10.0 PQ: 0 ANSI: 5
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: [mac] sda1 sda2 sda3 sda4 sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 sda13 sda14 sda15
sd 0:0:0:0: [sda] Attached SCSI disk

I have not jotted down the more interesting lines near the critical
target failure on a bad libata.fua=1 boot, but can certainly do so
later if we think they may help. 

> > 
> > I believe there are two solutions:
> > - Revert FUA default back to '0'
> > - Start filling SATA drive blacklist in function:
> 
> I think the right thing to do for release is disable it (again), then we can
> try again later with better logic.
> 
> I'll send Linus a patch to disable.

We've got some time to play before it goes to Linus (agreed in later mail),
and we've got a good libata.fua=0 workaround for now, with only Arvydas and
me complaining (there was a report from Dieter Ries in the thread, but that
was actually on 3.6-rc3, so must be something else).

So I think it would be okay to keep the commit in your tree for the moment,
if anyone has ideas of what we could try out.  Looking at the code, I see
that libata.fua=1 _ought_ to be harmless, but somehow is not.

I notice in the dmesg above that the SCSI end is reporting "doesn't support
DPO or FUA" whereas the ATA must be believing that FUA is supported on that
device.

I'm probably making a fool of myself by speculating in this area,
but I wonder if we could update the ATA view from the SCSI view
once it's known.

> 
> It is entirely possible that this is a software problem, where we missing
> some detail turning on FUA (thereby engaging some less traveled core block
> layer machinery), or even a remote possibility of triggering a filesystem
> bug.

Please let me know if you have anything for me to try,
or just want more debug output to help.

Thanks,
Hugh
