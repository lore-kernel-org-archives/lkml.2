Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2LJJqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 04:46:11 -0500
Received: from mx3.cyfra.ua ([62.80.160.182]:59424 "EHLO mx3.cyfra.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab2LJJqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 04:46:10 -0500
From: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Organization: Factor-SPE
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Fix concurrency issue
Date: Mon, 10 Dec 2012 11:46:07 +0200
User-Agent: KMail/1.9.10
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Cong Ding <dinggnu@gmail.com>
References: <201212101118.08463.vitas@nppfactor.kiev.ua>
In-Reply-To: <201212101118.08463.vitas@nppfactor.kiev.ua>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201212101146.07235.vitas@nppfactor.kiev.ua>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a SMP case there was a race condition issue between
uio_pdrv_genirq_irqcontrol() running on one CPU and irq handler on another
CPU. Fix it by spin_locking shared resources access inside irq handler.
Also:
 - Change disable_irq to disable_irq_nosync to avoid deadlock, because
disable_irq waits for the completion of the irq handler
 - Change atomic bit-manipulation routines to their non-atomic counterparts as
we already are guarding the code by spinlock.

Signed-off-by: Vitalii Demianets <vitas@nppfactor.kiev.ua>
---
 drivers/uio/uio_pdrv_genirq.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index cc5233b..8075367 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -68,8 +68,10 @@ static irqreturn_t uio_pdrv_genirq_handler(int irq, struct uio_info *dev_info)
 	 * remember the state so we can allow user space to enable it later.
 	 */
 
-	if (!test_and_set_bit(UIO_IRQ_DISABLED, &priv->flags))
+	spin_lock(&priv->lock);
+	if (!__test_and_set_bit(UIO_IRQ_DISABLED, &priv->flags))
 		disable_irq_nosync(irq);
+	spin_unlock(&priv->lock);
 
 	return IRQ_HANDLED;
 }
@@ -83,16 +85,17 @@ static int uio_pdrv_genirq_irqcontrol(struct uio_info *dev_info, s32 irq_on)
 	 * in the interrupt controller, but keep track of the
 	 * state to prevent per-irq depth damage.
 	 *
-	 * Serialize this operation to support multiple tasks.
+	 * Serialize this operation to support multiple tasks and concurrency
+	 * with irq handler on SMP systems.
 	 */
 
 	spin_lock_irqsave(&priv->lock, flags);
 	if (irq_on) {
-		if (test_and_clear_bit(UIO_IRQ_DISABLED, &priv->flags))
+		if (__test_and_clear_bit(UIO_IRQ_DISABLED, &priv->flags))
 			enable_irq(dev_info->irq);
 	} else {
-		if (!test_and_set_bit(UIO_IRQ_DISABLED, &priv->flags))
-			disable_irq(dev_info->irq);
+		if (!__test_and_set_bit(UIO_IRQ_DISABLED, &priv->flags))
+			disable_irq_nosync(dev_info->irq);
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-- 
1.7.8.6
