Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab2IIULT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 16:11:19 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55440 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab2IIULO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 16:11:14 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1209090012390.2416@eggly.anvils>
References: <CA+6av4=uxu_q5U_46HtpUt=FSgbh3pZuAEY54J5_xK=MKWq-YQ@mail.gmail.com>
	<CAFtxgO536xEMjMw_D1u3utT1f1iy-6EsjcawdYvbocRxc=Wu=A@mail.gmail.com>
	<503BA2DB.9080704@gmail.com>
	<503BB4BB.4080307@gmail.com>
	<alpine.LSU.2.00.1209090012390.2416@eggly.anvils>
Date: Sun, 9 Sep 2012 22:11:13 +0200
Message-ID: <CA+6av4=6WeLcde5me2FCpBtQJAOTtHZvf4pkMExgMW9agVNLWg@mail.gmail.com>
Subject: Re: Storage related regression in linux-next 20120824
From: Arvydas Sidorenko <asido4@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Zheng Liu <wenqing.lz@taobao.com>,
        linux-kernel@vger.kernel.org,
        "IDE/ATA development list" <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think you know your way around SCSI/libata much better than I do.
>
> I just bisected linux-next, and it comes down to the commit below, which
> introduces the regression for me, and I'm guessing for you also.  Maybe
> it can be fixed up to satisfy us, but otherwise will have to be reverted:
> we don't invert a default if it's going to break older working systems.
>
> A good workaround for me meanwhile is to add boot option "libata.fua=0":
> please try that (or reverting the commit) and let us know the result.
>
> Thanks,
> Hugh
>
> commit 91895b786e631ab47b618c901231f22b5a44115b
> Author: Zheng Liu <wenqing.lz@taobao.com>
> Date:   Tue May 8 11:24:03 2012 +0800
>
>     libata: enable SATA disk fua detection on default
>
>     Currently, SATA disk fua detection is disabled on default because most of
>     devices don't support this feature at that time.  With the development of
>     technology, more and more SATA disks support this feature.  So now we can enable
>     this detection on default.
>
>     Although fua detection is defined as a kernel module parameter, it is too hard
>     to set its value because it must be loaded and set before system starts up.
>     That needs to modify initrd file.  So it is inconvenient for administrator who
>     needs to manage a huge number of servers.
>
>     Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
>     Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
>
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 5eee1c1..c3fbdca 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -135,9 +135,9 @@ int atapi_passthru16 = 1;
>  module_param(atapi_passthru16, int, 0444);
>  MODULE_PARM_DESC(atapi_passthru16, "Enable ATA_16 passthru for ATAPI devices (0=off, 1=on [default])");
>
> -int libata_fua = 0;
> +int libata_fua = 1;
>  module_param_named(fua, libata_fua, int, 0444);
> -MODULE_PARM_DESC(fua, "FUA support (0=off [default], 1=on)");
> +MODULE_PARM_DESC(fua, "FUA support (0=off, 1=on [default])");
>
>  static int ata_ignore_hpa;
>  module_param_named(ignore_hpa, ata_ignore_hpa, int, 0644);

Indeed, disabling FUA explicitly solved the issue on my disk as well.
Hugh, what hard drive you have this issue on?

I believe there are two solutions:
- Revert FUA default back to '0'
- Start filling SATA drive blacklist in function:
> static int ata_dev_supports_fua(u16 *id)

Arvydas
