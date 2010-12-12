Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab0LLXy7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:54:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36742 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab0LLXsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:18 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: Larry.Finger@lwfinger.net, ak@linux.intel.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [191/223] staging: rtl8187se: Change panic to warn when RF switch turned off
Message-Id: <20101212234817.23571B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Larry Finger <Larry.Finger@lwfinger.net>

commit f36d83a8cb7224f45fdfa1129a616dff56479a09 upstream.

This driver issues a kernel panic over conditions that do not
justify such drastic action. Change these to log entries with
a stack dump.

This patch fixes the system crash reported in
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/674285.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reported-and-Tested-by: Robie Basik <rb-oss-3@justgohome.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rtl8187se/r8185b_init.c |   32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

Index: linux/drivers/staging/rtl8187se/r8185b_init.c
===================================================================
--- linux.orig/drivers/staging/rtl8187se/r8185b_init.c
+++ linux/drivers/staging/rtl8187se/r8185b_init.c
@@ -268,8 +268,12 @@ HwHSSIThreeWire(
 			}
 			udelay(10);
 		}
-		if (TryCnt == TC_3W_POLL_MAX_TRY_CNT)
-			panic("HwThreeWire(): CmdReg: %#X RE|WE bits are not clear!!\n", u1bTmp);
+		if (TryCnt == TC_3W_POLL_MAX_TRY_CNT) {
+			printk(KERN_ERR "rtl8187se: HwThreeWire(): CmdReg:"
+			       " %#X RE|WE bits are not clear!!\n", u1bTmp);
+			dump_stack();
+			return 0;
+		}
 
 		// RTL8187S HSSI Read/Write Function
 		u1bTmp = read_nic_byte(dev, RF_SW_CONFIG);
@@ -309,13 +313,23 @@ HwHSSIThreeWire(
 				int idx;
 				int ByteCnt = nDataBufBitCnt / 8;
                                 //printk("%d\n",nDataBufBitCnt);
-				if ((nDataBufBitCnt % 8) != 0)
-				panic("HwThreeWire(): nDataBufBitCnt(%d) should be multiple of 8!!!\n",
-				nDataBufBitCnt);
-
-			       if (nDataBufBitCnt > 64)
-				panic("HwThreeWire(): nDataBufBitCnt(%d) should <= 64!!!\n",
-				nDataBufBitCnt);
+				if ((nDataBufBitCnt % 8) != 0) {
+					printk(KERN_ERR "rtl8187se: "
+					       "HwThreeWire(): nDataBufBitCnt(%d)"
+					       " should be multiple of 8!!!\n",
+					       nDataBufBitCnt);
+					dump_stack();
+					nDataBufBitCnt += 8;
+					nDataBufBitCnt &= ~7;
+				}
+
+			       if (nDataBufBitCnt > 64) {
+					printk(KERN_ERR "rtl8187se: HwThreeWire():"
+					       " nDataBufBitCnt(%d) should <= 64!!!\n",
+					       nDataBufBitCnt);
+					dump_stack();
+					nDataBufBitCnt = 64;
+				}
 
 				for(idx = 0; idx < ByteCnt; idx++)
 				{
