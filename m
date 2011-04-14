Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451Ab1DNRrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:47:22 -0400
Received: from mail.windriver.com ([147.11.1.11]:38544 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933419Ab1DNRrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:18 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 100/209] staging: rtl8187se: Change panic to warn when RF switch turned off
Date: Thu, 14 Apr 2011 13:42:10 -0400
Message-Id: <1302803039-9400-101-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit f36d83a8cb7224f45fdfa1129a616dff56479a09 upstream.

This driver issues a kernel panic over conditions that do not
justify such drastic action. Change these to log entries with
a stack dump.

This patch fixes the system crash reported in
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/674285.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-and-Tested-by: Robie Basik <rb-oss-3@justgohome.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/rtl8187se/r8185b_init.c |   30 ++++++++++++++++++++++--------
 1 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index a0ece1f..e7e8745 100644
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
+				if ((nDataBufBitCnt % 8) != 0) {
+					printk(KERN_ERR "rtl8187se: "
+					       "HwThreeWire(): nDataBufBitCnt(%d)"
+					       " should be multiple of 8!!!\n",
+					       nDataBufBitCnt);
+					dump_stack();
+					nDataBufBitCnt += 8;
+					nDataBufBitCnt &= ~7;
+				}
 
-			       if (nDataBufBitCnt > 64)
-				panic("HwThreeWire(): nDataBufBitCnt(%d) should <= 64!!!\n",
-				nDataBufBitCnt);
+			       if (nDataBufBitCnt > 64) {
+					printk(KERN_ERR "rtl8187se: HwThreeWire():"
+					       " nDataBufBitCnt(%d) should <= 64!!!\n",
+					       nDataBufBitCnt);
+					dump_stack();
+					nDataBufBitCnt = 64;
+				}
 
 				for(idx = 0; idx < ByteCnt; idx++)
 				{
-- 
1.7.4.4

