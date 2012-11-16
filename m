Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab2KPDF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 22:05:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:64158 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab2KPDF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 22:05:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,261,1352102400"; 
   d="scan'208";a="247785719"
Subject: [PATCH] serial: ifx6x60: ifx_spi_write don't need to do
 mrdy_assert when fifo is not empty.
From: Jun Chen <jun.d.chen@intel.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Jun Chen <jun.d.chen@intel.com>, Bi Chao <chao.bi@intel.com>,
        serial <linux-serial@vger.kernel.org>,
        "russ.gorby" <russ.gorby@intel.com>, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com, gregkh@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Nov 2012 06:08:37 -0500
Message-ID: <1353064117.24092.4.camel@chenjun-workstation>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch check whether the fifo lenth is empty before writing new data to fifo.If condition
is true,ifx_spi_write need to trigger one mrdy_assert. If condition is false,the mrdy_assert
will be trigger by the next ifx_spi_io.
Cc: Bi Chao <chao.bi@intel.com>
Signed-off-by: Chen Jun <jun.d.chen@intel.com>
---
 drivers/tty/serial/ifx6x60.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index 5b9bc19..aa01989 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -469,9 +469,17 @@ static int ifx_spi_write(struct tty_struct *tty, const unsigned char *buf,
 {
 	struct ifx_spi_device *ifx_dev = tty->driver_data;
 	unsigned char *tmp_buf = (unsigned char *)buf;
-	int tx_count = kfifo_in_locked(&ifx_dev->tx_fifo, tmp_buf, count,
-				   &ifx_dev->fifo_lock);
-	mrdy_assert(ifx_dev);
+	int tx_count;
+	unsigned long flags;
+	bool is_fifo_empty;
+
+	spin_lock_irqsave(&ifx_dev->fifo_lock, flags);
+	is_fifo_empty = kfifo_is_empty(&ifx_dev->tx_fifo);
+	tx_count = kfifo_in(&ifx_dev->tx_fifo, tmp_buf, count);
+	spin_unlock_irqrestore(&ifx_dev->fifo_lock, flags);
+	if (is_fifo_empty)
+		mrdy_assert(ifx_dev);
+
 	return tx_count;
 }
 
-- 
1.7.4.1



