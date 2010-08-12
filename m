Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488Ab0HLAN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:13:29 -0400
Received: from kroah.org ([198.145.64.141]:47884 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933182Ab0HLAIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:39 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:16 2010
Message-Id: <20100812000616.534552802@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:05:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Catalin Marinas <catalin.marinas@arm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [42/67] smsc911x: Add spinlocks around registers access
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 492c5d943d6a04b124ba3a719dc746dc36b14cfb upstream.

On SMP systems, the SMSC911x registers may be accessed by multiple CPUs
and this seems to put the chip in an inconsistent state. The patch adds
spinlocks to the smsc911x_reg_read, smsc911x_reg_write,
smsc911x_rx_readfifo and smsc911x_tx_writefifo functions.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/smsc911x.c |   92 +++++++++++++++++++++++++++----------------------
 1 file changed, 52 insertions(+), 40 deletions(-)

--- a/drivers/net/smsc911x.c
+++ b/drivers/net/smsc911x.c
@@ -84,8 +84,7 @@ struct smsc911x_data {
 	 */
 	spinlock_t mac_lock;
 
-	/* spinlock to ensure 16-bit accesses are serialised.
-	 * unused with a 32-bit bus */
+	/* spinlock to ensure register accesses are serialised */
 	spinlock_t dev_lock;
 
 	struct phy_device *phy_dev;
@@ -118,37 +117,33 @@ struct smsc911x_data {
 	unsigned int hashlo;
 };
 
-/* The 16-bit access functions are significantly slower, due to the locking
- * necessary.  If your bus hardware can be configured to do this for you
- * (in response to a single 32-bit operation from software), you should use
- * the 32-bit access functions instead. */
-
-static inline u32 smsc911x_reg_read(struct smsc911x_data *pdata, u32 reg)
+static inline u32 __smsc911x_reg_read(struct smsc911x_data *pdata, u32 reg)
 {
 	if (pdata->config.flags & SMSC911X_USE_32BIT)
 		return readl(pdata->ioaddr + reg);
 
-	if (pdata->config.flags & SMSC911X_USE_16BIT) {
-		u32 data;
-		unsigned long flags;
-
-		/* these two 16-bit reads must be performed consecutively, so
-		 * must not be interrupted by our own ISR (which would start
-		 * another read operation) */
-		spin_lock_irqsave(&pdata->dev_lock, flags);
-		data = ((readw(pdata->ioaddr + reg) & 0xFFFF) |
+	if (pdata->config.flags & SMSC911X_USE_16BIT)
+		return ((readw(pdata->ioaddr + reg) & 0xFFFF) |
 			((readw(pdata->ioaddr + reg + 2) & 0xFFFF) << 16));
-		spin_unlock_irqrestore(&pdata->dev_lock, flags);
-
-		return data;
-	}
 
 	BUG();
 	return 0;
 }
 
-static inline void smsc911x_reg_write(struct smsc911x_data *pdata, u32 reg,
-				      u32 val)
+static inline u32 smsc911x_reg_read(struct smsc911x_data *pdata, u32 reg)
+{
+	u32 data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pdata->dev_lock, flags);
+	data = __smsc911x_reg_read(pdata, reg);
+	spin_unlock_irqrestore(&pdata->dev_lock, flags);
+
+	return data;
+}
+
+static inline void __smsc911x_reg_write(struct smsc911x_data *pdata, u32 reg,
+					u32 val)
 {
 	if (pdata->config.flags & SMSC911X_USE_32BIT) {
 		writel(val, pdata->ioaddr + reg);
@@ -156,44 +151,54 @@ static inline void smsc911x_reg_write(st
 	}
 
 	if (pdata->config.flags & SMSC911X_USE_16BIT) {
-		unsigned long flags;
-
-		/* these two 16-bit writes must be performed consecutively, so
-		 * must not be interrupted by our own ISR (which would start
-		 * another read operation) */
-		spin_lock_irqsave(&pdata->dev_lock, flags);
 		writew(val & 0xFFFF, pdata->ioaddr + reg);
 		writew((val >> 16) & 0xFFFF, pdata->ioaddr + reg + 2);
-		spin_unlock_irqrestore(&pdata->dev_lock, flags);
 		return;
 	}
 
 	BUG();
 }
 
+static inline void smsc911x_reg_write(struct smsc911x_data *pdata, u32 reg,
+				      u32 val)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&pdata->dev_lock, flags);
+	__smsc911x_reg_write(pdata, reg, val);
+	spin_unlock_irqrestore(&pdata->dev_lock, flags);
+}
+
 /* Writes a packet to the TX_DATA_FIFO */
 static inline void
 smsc911x_tx_writefifo(struct smsc911x_data *pdata, unsigned int *buf,
 		      unsigned int wordcount)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&pdata->dev_lock, flags);
+
 	if (pdata->config.flags & SMSC911X_SWAP_FIFO) {
 		while (wordcount--)
-			smsc911x_reg_write(pdata, TX_DATA_FIFO, swab32(*buf++));
-		return;
+			__smsc911x_reg_write(pdata, TX_DATA_FIFO,
+					     swab32(*buf++));
+		goto out;
 	}
 
 	if (pdata->config.flags & SMSC911X_USE_32BIT) {
 		writesl(pdata->ioaddr + TX_DATA_FIFO, buf, wordcount);
-		return;
+		goto out;
 	}
 
 	if (pdata->config.flags & SMSC911X_USE_16BIT) {
 		while (wordcount--)
-			smsc911x_reg_write(pdata, TX_DATA_FIFO, *buf++);
-		return;
+			__smsc911x_reg_write(pdata, TX_DATA_FIFO, *buf++);
+		goto out;
 	}
 
 	BUG();
+out:
+	spin_unlock_irqrestore(&pdata->dev_lock, flags);
 }
 
 /* Reads a packet out of the RX_DATA_FIFO */
@@ -201,24 +206,31 @@ static inline void
 smsc911x_rx_readfifo(struct smsc911x_data *pdata, unsigned int *buf,
 		     unsigned int wordcount)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&pdata->dev_lock, flags);
+
 	if (pdata->config.flags & SMSC911X_SWAP_FIFO) {
 		while (wordcount--)
-			*buf++ = swab32(smsc911x_reg_read(pdata, RX_DATA_FIFO));
-		return;
+			*buf++ = swab32(__smsc911x_reg_read(pdata,
+							    RX_DATA_FIFO));
+		goto out;
 	}
 
 	if (pdata->config.flags & SMSC911X_USE_32BIT) {
 		readsl(pdata->ioaddr + RX_DATA_FIFO, buf, wordcount);
-		return;
+		goto out;
 	}
 
 	if (pdata->config.flags & SMSC911X_USE_16BIT) {
 		while (wordcount--)
-			*buf++ = smsc911x_reg_read(pdata, RX_DATA_FIFO);
-		return;
+			*buf++ = __smsc911x_reg_read(pdata, RX_DATA_FIFO);
+		goto out;
 	}
 
 	BUG();
+out:
+	spin_unlock_irqrestore(&pdata->dev_lock, flags);
 }
 
 /* waits for MAC not busy, with timeout.  Only called by smsc911x_mac_read


