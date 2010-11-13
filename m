Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab0KMTCB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 14:02:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39625 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab0KMTCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 14:02:00 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=b22GMZmCubYA:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=danhDmx_AAAA:8 a=yQdBAQUQAAAA:8 a=u0e5qTNkAAAA:8 a=VwQbUJbxAAAA:8 a=_q31hJi8asK4-kkfL20A:9 a=KYleiluHsioHKE_D6DgvGjEb1G4A:4 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=DwVsXEaDNqkA:10 a=LI9Vle30uBYA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Sat, 13 Nov 2010 13:01:56 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: rb-oss-3@justgohome.co.uk, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8187se: Change panic to warn when RF switch
 turned off
Message-ID: <4cdee0a4.crhk3NTeRuR61paB%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver issues a kernel panic over conditions that do not
justify such drastic action. Change these to log entries with
a stack dump.

This patch fixes the system crash reported in
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/674285.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-and-Tested-by: Robie Basik <rb-oss-3@justgohome.co.uk>
Cc: Stable <stable@kernel.org>
---

Greg,

As this fix keeps the kernel from panicking over a trivial condition,
it should be pushed as soon as possible.

Larry
---

Index: linux-2.6/drivers/staging/rtl8187se/r8185b_init.c
===================================================================
--- linux-2.6.orig/drivers/staging/rtl8187se/r8185b_init.c
+++ linux-2.6/drivers/staging/rtl8187se/r8185b_init.c
@@ -264,8 +264,12 @@ HwHSSIThreeWire(
 
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
 
 		/* RTL8187S HSSI Read/Write Function */
 		u1bTmp = read_nic_byte(dev, RF_SW_CONFIG);
@@ -298,13 +302,23 @@ HwHSSIThreeWire(
 				int idx;
 				int ByteCnt = nDataBufBitCnt / 8;
 								/* printk("%d\n",nDataBufBitCnt); */
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
 
 				for (idx = 0; idx < ByteCnt; idx++)
 					write_nic_byte(dev, (SW_3W_DB0+idx), *(pDataBuf+idx));
