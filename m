Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0JARRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 13:17:32 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:11626 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753188Ab0JARRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 13:17:31 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de
To: mingo@redhat.com
To: hpa@zytor.com
To: x86@kernel.org
Cc: dilinger@queued.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] OLPC: Don't retry EC commands forever
Message-Id: <20101001171719.4448E9D401B@zog.reactivated.net>
Date: Fri,  1 Oct 2010 18:17:19 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=3ENABmdyEd/Fm7fR7+mZIuMDn6+IErAeEhlfWBImZFk= c=1 sm=0 a=5IHxzvmIYLwA:10 a=Op-mwl0xAAAA:8 a=IrZA8GXdiRcN18Tbs1YA:9 a=rPeD18x46FYIwxMp5gUA:7 a=7zMtkCGgRmDGjY22kJU4zBYYFK0A:4 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Fox <pgf@laptop.org>

Avoids a potential infinite loop

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/kernel/olpc.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
index 37c49934..7472613 100644
--- a/arch/x86/kernel/olpc.c
+++ b/arch/x86/kernel/olpc.c
@@ -114,6 +114,7 @@ int olpc_ec_cmd(unsigned char cmd, unsigned char *inbuf, size_t inlen,
 	unsigned long flags;
 	int ret = -EIO;
 	int i;
+	int restarts = 0;
 
 	spin_lock_irqsave(&ec_lock, flags);
 
@@ -169,7 +170,9 @@ restart:
 			if (wait_on_obf(0x6c, 1)) {
 				printk(KERN_ERR "olpc-ec:  timeout waiting for"
 						" EC to provide data!\n");
-				goto restart;
+				if (restarts++ < 10)
+					goto restart;
+				goto err;
 			}
 			outbuf[i] = inb(0x68);
 			pr_devel("olpc-ec:  received 0x%x\n", outbuf[i]);
-- 
1.7.2.3

