Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab3AHXsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:48:51 -0500
Received: from mail.windriver.com ([147.11.1.11]:63557 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695Ab3AHXho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:44 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: =?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 28/77] p54spi: Fix workqueue deadlock
Date: Tue, 8 Jan 2013 18:35:07 -0500
Message-ID: <1357688156-25387-29-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Büsch <m@bues.ch>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 2d1618170eb493d18f66f2ac03775409a6fb97c6 upstream.

priv->work must not be synced while priv->mutex is locked, because
the mutex is taken in the work handler.
Move cancel_work_sync down to after the device shutdown code.
This is safe, because the work handler checks fw_state and bails out
early in case of a race.

Signed-off-by: Michael Buesch <m@bues.ch>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/p54/p54spi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 4cede24..8cf0301 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -582,8 +582,6 @@ static void p54spi_op_stop(struct ieee80211_hw *dev)
 
 	WARN_ON(priv->fw_state != FW_STATE_READY);
 
-	cancel_work_sync(&priv->work);
-
 	p54spi_power_off(priv);
 	spin_lock_irqsave(&priv->tx_lock, flags);
 	INIT_LIST_HEAD(&priv->tx_pending);
@@ -591,6 +589,8 @@ static void p54spi_op_stop(struct ieee80211_hw *dev)
 
 	priv->fw_state = FW_STATE_OFF;
 	mutex_unlock(&priv->mutex);
+
+	cancel_work_sync(&priv->work);
 }
 
 static int __devinit p54spi_probe(struct spi_device *spi)
-- 
1.7.12.1

