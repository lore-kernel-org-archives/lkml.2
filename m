Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031739Ab2I1Tx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:53:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964947Ab2I1S53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:57:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Attila Kinali <attila@kinali.ch>,
        Lauri Hintsala <lauri.hintsala@bluegiga.com>,
        Shawn Guo <shawn.guo@linaro.org>, Chris Ball <cjb@laptop.org>
Subject: [ 074/262] mmc: mxs-mmc: fix deadlock caused by recursion loop
Date: Fri, 28 Sep 2012 11:50:03 -0700
Message-Id: <20120928183006.777324166@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lauri Hintsala <lauri.hintsala@bluegiga.com>

commit fc108d24d3a6da63576a460e122fa1df0cbdea20 upstream.

Release the lock before mmc_signal_sdio_irq is called by
mxs_mmc_enable_sdio_irq.

Backtrace:
[   65.470000] =============================================
[   65.470000] [ INFO: possible recursive locking detected ]
[   65.470000] 3.5.0-rc5 #2 Not tainted
[   65.470000] ---------------------------------------------
[   65.470000] ksdioirqd/mmc0/73 is trying to acquire lock:
[   65.470000]  (&(&host->lock)->rlock#2){-.-...}, at: [<bf054120>] mxs_mmc_enable_sdio_irq+0x18/0xdc [mxs_mmc]
[   65.470000]
[   65.470000] but task is already holding lock:
[   65.470000]  (&(&host->lock)->rlock#2){-.-...}, at: [<bf054120>] mxs_mmc_enable_sdio_irq+0x18/0xdc [mxs_mmc]
[   65.470000]
[   65.470000] other info that might help us debug this:
[   65.470000]  Possible unsafe locking scenario:
[   65.470000]
[   65.470000]        CPU0
[   65.470000]        ----
[   65.470000]   lock(&(&host->lock)->rlock#2);
[   65.470000]   lock(&(&host->lock)->rlock#2);
[   65.470000]
[   65.470000]  *** DEADLOCK ***
[   65.470000]
[   65.470000]  May be due to missing lock nesting notation
[   65.470000]
[   65.470000] 1 lock held by ksdioirqd/mmc0/73:
[   65.470000]  #0:  (&(&host->lock)->rlock#2){-.-...}, at: [<bf054120>] mxs_mmc_enable_sdio_irq+0x18/0xdc [mxs_mmc]
[   65.470000]
[   65.470000] stack backtrace:
[   65.470000] [<c0014990>] (unwind_backtrace+0x0/0xf4) from [<c005ccb8>] (__lock_acquire+0x14f8/0x1b98)
[   65.470000] [<c005ccb8>] (__lock_acquire+0x14f8/0x1b98) from [<c005d3f8>] (lock_acquire+0xa0/0x108)
[   65.470000] [<c005d3f8>] (lock_acquire+0xa0/0x108) from [<c02f671c>] (_raw_spin_lock_irqsave+0x48/0x5c)
[   65.470000] [<c02f671c>] (_raw_spin_lock_irqsave+0x48/0x5c) from [<bf054120>] (mxs_mmc_enable_sdio_irq+0x18/0xdc [mxs_mmc])
[   65.470000] [<bf054120>] (mxs_mmc_enable_sdio_irq+0x18/0xdc [mxs_mmc]) from [<bf0541d0>] (mxs_mmc_enable_sdio_irq+0xc8/0xdc [mxs_mmc])
[   65.470000] [<bf0541d0>] (mxs_mmc_enable_sdio_irq+0xc8/0xdc [mxs_mmc]) from [<c0219b38>] (sdio_irq_thread+0x1bc/0x274)
[   65.470000] [<c0219b38>] (sdio_irq_thread+0x1bc/0x274) from [<c003c324>] (kthread+0x8c/0x98)
[   65.470000] [<c003c324>] (kthread+0x8c/0x98) from [<c00101ac>] (kernel_thread_exit+0x0/0x8)
[   65.470000] BUG: spinlock lockup suspected on CPU#0, ksdioirqd/mmc0/73
[   65.470000]  lock: 0xc3358724, .magic: dead4ead, .owner: ksdioirqd/mmc0/73, .owner_cpu: 0
[   65.470000] [<c0014990>] (unwind_backtrace+0x0/0xf4) from [<c01b46b0>] (do_raw_spin_lock+0x100/0x144)
[   65.470000] [<c01b46b0>] (do_raw_spin_lock+0x100/0x144) from [<c02f6724>] (_raw_spin_lock_irqsave+0x50/0x5c)
[   65.470000] [<c02f6724>] (_raw_spin_lock_irqsave+0x50/0x5c) from [<bf054120>] (mxs_mmc_enable_sdio_irq+0x18/0xdc [mxs_mmc])
[   65.470000] [<bf054120>] (mxs_mmc_enable_sdio_irq+0x18/0xdc [mxs_mmc]) from [<bf0541d0>] (mxs_mmc_enable_sdio_irq+0xc8/0xdc [mxs_mmc])
[   65.470000] [<bf0541d0>] (mxs_mmc_enable_sdio_irq+0xc8/0xdc [mxs_mmc]) from [<c0219b38>] (sdio_irq_thread+0x1bc/0x274)
[   65.470000] [<c0219b38>] (sdio_irq_thread+0x1bc/0x274) from [<c003c324>] (kthread+0x8c/0x98)
[   65.470000] [<c003c324>] (kthread+0x8c/0x98) from [<c00101ac>] (kernel_thread_exit+0x0/0x8)

Reported-by: Attila Kinali <attila@kinali.ch>
Signed-off-by: Lauri Hintsala <lauri.hintsala@bluegiga.com>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/mxs-mmc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -637,11 +637,6 @@ static void mxs_mmc_enable_sdio_irq(stru
 		       host->base + HW_SSP_CTRL0 + STMP_OFFSET_REG_SET);
 		writel(BM_SSP_CTRL1_SDIO_IRQ_EN,
 		       host->base + HW_SSP_CTRL1(host) + STMP_OFFSET_REG_SET);
-
-		if (readl(host->base + HW_SSP_STATUS(host)) &
-				BM_SSP_STATUS_SDIO_IRQ)
-			mmc_signal_sdio_irq(host->mmc);
-
 	} else {
 		writel(BM_SSP_CTRL0_SDIO_IRQ_CHECK,
 		       host->base + HW_SSP_CTRL0 + STMP_OFFSET_REG_CLR);
@@ -650,6 +645,11 @@ static void mxs_mmc_enable_sdio_irq(stru
 	}
 
 	spin_unlock_irqrestore(&host->lock, flags);
+
+	if (enable && readl(host->base + HW_SSP_STATUS(host)) &
+			BM_SSP_STATUS_SDIO_IRQ)
+		mmc_signal_sdio_irq(host->mmc);
+
 }
 
 static const struct mmc_host_ops mxs_mmc_ops = {


