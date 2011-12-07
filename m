Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513Ab1LGQWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:22:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933498Ab1LGQWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:22:04 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:18 2011
Message-Id: <20111207161218.068071699@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:42 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Michael Buesch <m@bues.ch>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [040/104] p54spi: Fix workqueue deadlock
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>

commit 2d1618170eb493d18f66f2ac03775409a6fb97c6 upstream.

priv->work must not be synced while priv->mutex is locked, because
the mutex is taken in the work handler.
Move cancel_work_sync down to after the device shutdown code.
This is safe, because the work handler checks fw_state and bails out
early in case of a race.

Signed-off-by: Michael Buesch <m@bues.ch>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/p54spi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -589,8 +589,6 @@ static void p54spi_op_stop(struct ieee80
 
 	WARN_ON(priv->fw_state != FW_STATE_READY);
 
-	cancel_work_sync(&priv->work);
-
 	p54spi_power_off(priv);
 	spin_lock_irqsave(&priv->tx_lock, flags);
 	INIT_LIST_HEAD(&priv->tx_pending);
@@ -598,6 +596,8 @@ static void p54spi_op_stop(struct ieee80
 
 	priv->fw_state = FW_STATE_OFF;
 	mutex_unlock(&priv->mutex);
+
+	cancel_work_sync(&priv->work);
 }
 
 static int __devinit p54spi_probe(struct spi_device *spi)


