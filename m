Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab2FMP3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:29:00 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:55181 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754463Ab2FMP25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:28:57 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVP16UmHe-GGydrSMgGHwnkSvYhnY339=zr=BfCehvS8Kw@mail.gmail.com>
References: <CACVXFVO-Wm1Qwporby1M=+yPz81AWHpZRBZSbr5tgT32b6sSEA@mail.gmail.com>
	<CANrkHUYd8Ww6De4MiZ8_oPfcnhvtsZXOySLRiWSBU4QUQ6beHw@mail.gmail.com>
	<CACVXFVP16UmHe-GGydrSMgGHwnkSvYhnY339=zr=BfCehvS8Kw@mail.gmail.com>
Date: Wed, 13 Jun 2012 20:58:54 +0530
Message-ID: <CANrkHUaxJGcv2bdUWTCB_oKct-iFCKCdb7OQPTUjS4MuKeCS2w@mail.gmail.com>
Subject: Re: MMC: commit dba3c29 ruins mmc card data on beagle-xm revB
From: "T Krishnamoorthy, Balaji" <balajitk@ti.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-mmc@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Venkatraman S <svenkatr@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 12:50 PM, Ming Lei <ming.lei@canonical.com> wrote:
>
> On Mon, Jun 11, 2012 at 2:21 PM, T Krishnamoorthy, Balaji
> <balajitk@ti.com> wrote:
> > Hi Ming Lei,
> > Can you let me know if you noticed any write/timeout errors ?
>
> Nothing error logs found during writing.
Hi,

Couldn't reproduce the issue with BeagleXM rev C, Might be a combination
of rev and SD card. How often do you see mis-match in file content?

Can you please try the inlined patch to get more info?

---
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 9a7a60a..77aabe6 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -60,6 +60,7 @@
 #define OMAP_HSMMC_STAT		0x0130
 #define OMAP_HSMMC_IE		0x0134
 #define OMAP_HSMMC_ISE		0x0138
+#define OMAP_HSMMC_AC12		0x013C
 #define OMAP_HSMMC_CAPA		0x0140

 #define VS18			(1 << 26)
@@ -177,6 +178,7 @@ struct omap_hsmmc_host {
 	int			reqs_blocked;
 	int			use_reg;
 	int			req_in_progress;
+	int			autocmd_err;
 	unsigned int		flags;
 	struct omap_hsmmc_next	next_data;

@@ -983,6 +985,7 @@ static void omap_hsmmc_do_irq(struct
omap_hsmmc_host *host, int status)
 {
 	struct mmc_data *data;
 	int end_cmd = 0, end_trans = 0;
+	u32 autocmd12;

 	if (!host->req_in_progress) {
 		do {
@@ -998,6 +1001,13 @@ static void omap_hsmmc_do_irq(struct
omap_hsmmc_host *host, int status)

 	if (status & ERR) {
 		omap_hsmmc_dbg_report_irq(host, status);
+		if (status & (1 << 24)) {
+			host->autocmd_err = 1;
+			dev_err(mmc_dev(host->mmc), "AutoCMD error STAT 0x%x\n", status);
+			autocmd12 = OMAP_HSMMC_READ(host->base, AC12);
+			dev_err(mmc_dev(host->mmc), "AutoCMD error 0x%x\n", autocmd12);
+		}
+
 		if ((status & CMD_TIMEOUT) ||
 			(status & CMD_CRC)) {
 			if (host->cmd) {
---
>
> Below is one of my test case.
>
> root@beagleboard:~# upk
> updateing kernel...
> flush storage...
> root@beagleboard:~# cat bin/upk
> #!/bin/sh
>
> echo "updateing kernel..."
> cp -f /mnt/nfs/t/uImage /media/mmcblk0p1/
>
> echo "flush storage..."
> sync
> root@beagleboard:~# diff /mnt/nfs/t/uImage /media/mmcblk0p1/uImage
> Binary files /mnt/nfs/t/uImage and /media/mmcblk0p1/uImage differ
> root@beagleboard:~# umount /media/mmcblk0p1
> root@beagleboard:~# mount -t vfat /dev/mmcblk0p1 /media/mmcblk0p1
> root@beagleboard:~#
> root@beagleboard:~#
> root@beagleboard:~# diff /mnt/nfs/t/uImage /media/mmcblk0p1/uImage
> Binary files /mnt/nfs/t/uImage and /media/mmcblk0p1/uImage differ
>
>
> Thanks,
> --
> Ming Lei
