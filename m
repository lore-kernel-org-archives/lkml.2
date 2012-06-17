Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab2FQNsj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 09:48:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53046 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271Ab2FQNsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 09:48:38 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 2/2] staging/rtl8182u: cleanup eprom_read function and clean all checkpatch warnings / errors
Date: Sun, 17 Jun 2012 19:18:31 +0530
Message-Id: <1339940911-20648-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch cleans up the copying of the addr data into addr_str fields
by using for loops.

and also with the previous patch all the checkpatch warnings / errors are
eliminated

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/rtl8192u/r8180_93cx6.c |   53 ++++++++++++++------------------
 1 file changed, 23 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8180_93cx6.c b/drivers/staging/rtl8192u/r8180_93cx6.c
index e48a5aa..50b88fc 100644
--- a/drivers/staging/rtl8192u/r8180_93cx6.c
+++ b/drivers/staging/rtl8192u/r8180_93cx6.c
@@ -73,7 +73,7 @@ short eprom_r(struct net_device *dev)
 	bit = (read_nic_byte_E(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT));
 	udelay(EPROM_DELAY);
 
-	return bit ? 1: 0;
+	return bit ? 1 : 0;
 }
 
 
@@ -81,7 +81,7 @@ void eprom_send_bits_string(struct net_device *dev, short b[], int len)
 {
 	int i;
 
-	for(i=0; i<len; i++){
+	for (i = 0; i < len; i++) {
 		eprom_w(dev, b[i]);
 		eprom_ck_cycle(dev);
 	}
@@ -91,50 +91,43 @@ void eprom_send_bits_string(struct net_device *dev, short b[], int len)
 u32 eprom_read(struct net_device *dev, u32 addr)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	short read_cmd[]={1,1,0};
+	short read_cmd[] = {1, 1, 0};
 	short addr_str[8];
 	int i;
 	int addr_len;
-	u32 ret;
+	u32 ret = 0;
 
-	ret=0;
-        //enable EPROM programming
+	/* enable EPROM programming */
 	write_nic_byte_E(dev, EPROM_CMD,
 		       (EPROM_CMD_PROGRAM<<EPROM_CMD_OPERATING_MODE_SHIFT));
 	force_pci_posting(dev);
 	udelay(EPROM_DELAY);
 
-	if (priv->epromtype==EPROM_93c56){
-		addr_str[7]=addr & 1;
-		addr_str[6]=addr & (1<<1);
-		addr_str[5]=addr & (1<<2);
-		addr_str[4]=addr & (1<<3);
-		addr_str[3]=addr & (1<<4);
-		addr_str[2]=addr & (1<<5);
-		addr_str[1]=addr & (1<<6);
-		addr_str[0]=addr & (1<<7);
-		addr_len=8;
-	}else{
-		addr_str[5]=addr & 1;
-		addr_str[4]=addr & (1<<1);
-		addr_str[3]=addr & (1<<2);
-		addr_str[2]=addr & (1<<3);
-		addr_str[1]=addr & (1<<4);
-		addr_str[0]=addr & (1<<5);
-		addr_len=6;
+	if (priv->epromtype == EPROM_93c56) {
+		addr_len = 8;
+		for (i = 0; i < addr_len; i++)
+			addr_str[i] = addr & (1 << (addr_len - (i + 1)));
+	} else {
+		addr_len = 6;
+		for (i = 0; i < addr_len; i++)
+			addr_str[i] = addr & (1 << (addr_len - (i + 1)));
 	}
 	eprom_cs(dev, 1);
 	eprom_ck_cycle(dev);
 	eprom_send_bits_string(dev, read_cmd, 3);
 	eprom_send_bits_string(dev, addr_str, addr_len);
 
-	//keep chip pin D to low state while reading.
-	//I'm unsure if it is necessary, but anyway shouldn't hurt
+	/**
+	  * keep chip pin D to low state while reading.
+	  * I'm unsure if it is necessary, but anyway shouldn't hurt
+	  */
 	eprom_w(dev, 0);
 
-	for(i=0;i<16;i++){
-		//eeprom needs a clk cycle between writing opcode&adr
-		//and reading data. (eeprom outs a dummy 0)
+	for (i = 0; i < 16; i++) {
+		/**
+		  * eeprom needs a clk cycle between writing opcode&adr
+		  * and reading data. (eeprom outs a dummy 0)
+		  */
 		eprom_ck_cycle(dev);
 		ret |= (eprom_r(dev)<<(15-i));
 	}
@@ -142,7 +135,7 @@ u32 eprom_read(struct net_device *dev, u32 addr)
 	eprom_cs(dev, 0);
 	eprom_ck_cycle(dev);
 
-	//disable EPROM programming
+	/* disable EPROM programming */
 	write_nic_byte_E(dev, EPROM_CMD,
 		       (EPROM_CMD_NORMAL<<EPROM_CMD_OPERATING_MODE_SHIFT));
 	return ret;
-- 
1.7.9.5

