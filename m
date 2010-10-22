Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759648Ab0JVTG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:06:27 -0400
Received: from kroah.org ([198.145.64.141]:34304 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759149Ab0JVS4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:50 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:33 2010
Message-Id: <20101022185233.728945353@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Nicolas Pitre <nico@fluxnic.net>, Chris Ball <cjb@laptop.org>
Subject: [071/103] mmc: sdio: fix SDIO suspend/resume regression
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ohad Ben-Cohen <ohad@wizery.com>

commit 1c8cf9c997a4a6b36e907c7ede5f048aeaab1644 upstream.

Fix SDIO suspend/resume regression introduced by 4c2ef25fe0b "mmc: fix
all hangs related to mmc/sd card insert/removal during suspend/resume":

  PM: Syncing filesystems ... done.
  Freezing user space processes ... (elapsed 0.01 seconds) done.
  Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
  Suspending console(s) (use no_console_suspend to debug)
  pm_op(): platform_pm_suspend+0x0/0x5c returns -38
  PM: Device pxa2xx-mci.0 failed to suspend: error -38
  PM: Some devices failed to suspend

4c2ef25fe0b moved the card removal/insertion mechanism out of MMC's
suspend/resume path and into pm notifiers (mmc_pm_notify), and that
broke SDIO's expectation that mmc_suspend_host() will remove the card,
and squash the error, in case -ENOSYS is returned from the bus suspend
handler (mmc_sdio_suspend() in this case).

mmc_sdio_suspend() is using this whenever at least one of the card's SDIO
function drivers does not have suspend/resume handlers - in that case
it is agreed to force removal of the entire card.

This patch fixes this regression by trivially bringing back that part of
mmc_suspend_host(), which was removed by 4c2ef25fe0b.

Reported-and-tested-by: Sven Neumann <s.neumann@raumfeld.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Acked-by: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/core/core.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1277,6 +1277,19 @@ int mmc_suspend_host(struct mmc_host *ho
 	if (host->bus_ops && !host->bus_dead) {
 		if (host->bus_ops->suspend)
 			err = host->bus_ops->suspend(host);
+		if (err == -ENOSYS || !host->bus_ops->resume) {
+			/*
+			 * We simply "remove" the card in this case.
+			 * It will be redetected on resume.
+			 */
+			if (host->bus_ops->remove)
+				host->bus_ops->remove(host);
+			mmc_claim_host(host);
+			mmc_detach_bus(host);
+			mmc_release_host(host);
+			host->pm_flags = 0;
+			err = 0;
+		}
 	}
 	mmc_bus_put(host);
 


