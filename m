Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab0JORFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 13:05:34 -0400
Received: from void.printf.net ([89.145.121.20]:59521 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512Ab0JORFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 13:05:32 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Sven Neumann <s.neumann@raumfeld.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [GIT PULL] MMC fix for 2.6.36
Date: Fri, 15 Oct 2010 13:10:49 -0400
Message-ID: <m3zkuf4c12.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

to fix an SDIO suspend/resume regression introduced in -rc1.  Thanks.

The following changes since commit 8fd01d6cfbf75465d84a4e533ed70c5f57b3ff51:
  Linus Torvalds (1):
        Export dump_{write,seek} to binary loader modules

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

Ohad Ben-Cohen (1):
      mmc: sdio: fix SDIO suspend/resume regression

 drivers/mmc/core/core.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)


From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 13 Oct 2010 09:31:56 +0200
Subject: [PATCH] mmc: sdio: fix SDIO suspend/resume regression

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
Cc: <stable@kernel.org>
Acked-by: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Chris Ball <cjb@laptop.org>
---
 drivers/mmc/core/core.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 5db49b1..09eee6d 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1631,6 +1631,19 @@ int mmc_suspend_host(struct mmc_host *host)
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
 
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
