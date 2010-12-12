Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab0LLX5X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:57:23 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36653 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab0LLXsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:04 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: g.liakhovetski@gmx.de, cjb@laptop.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [178/223] mmc: fix rmmod race for hosts using card-detection polling
Message-Id: <20101212234803.3F5FFB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

commit d9bcbf343ec63e1104b5276195888ee06b4d086f upstream.

MMC hosts that poll for card detection by defining the MMC_CAP_NEEDS_POLL
flag have a race on rmmod, where the delayed work is cancelled without
waiting for completed polling. To prevent this a _sync version of the work
cancellation has to be used.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/mmc/core/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/mmc/core/core.c
===================================================================
--- linux.orig/drivers/mmc/core/core.c
+++ linux/drivers/mmc/core/core.c
@@ -1160,7 +1160,7 @@ void mmc_stop_host(struct mmc_host *host
 
 	if (host->caps & MMC_CAP_DISABLE)
 		cancel_delayed_work(&host->disable);
-	cancel_delayed_work(&host->detect);
+	cancel_delayed_work_sync(&host->detect);
 	mmc_flush_scheduled_work();
 
 	/* clear pm flags now and let card drivers set them as needed */
