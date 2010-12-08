Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab0LHBLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:11:51 -0500
Received: from kroah.org ([198.145.64.141]:33798 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750Ab0LHBDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:46 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:46 2010
Message-Id: <20101208005746.688112751@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [253/289] staging: rtl8187se: Change panic to warn when RF switch turned off
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit f36d83a8cb7224f45fdfa1129a616dff56479a09 upstream.

This driver issues a kernel panic over conditions that do not
justify such drastic action. Change these to log entries with
a stack dump.

This patch fixes the system crash reported in
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/674285.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-and-Tested-by: Robie Basik <rb-oss-3@justgohome.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rtl8187se/r8185b_init.c |   32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
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


