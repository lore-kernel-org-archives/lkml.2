Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab1GZPmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:42:42 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:57343 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753085Ab1GZPmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:42:36 -0400
X-Greylist: delayed 166077 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jul 2011 11:42:32 EDT
From: Daniel Drake <dsd@laptop.org>
To: mingo@redhat.com
To: tglx@linutronix.de
To: hpa@zytor.com
To: x86@kernel.org
Cc: dilinger@queued.net
Cc: pgf@laptop.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, olpc: Wait for last byte of EC command to be accepted
Message-Id: <20110726154226.93A9F9D401C@zog.reactivated.net>
Date: Tue, 26 Jul 2011 16:42:26 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=4rr6EKLBedkA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=NKBxTcpnRpsW_ARbErMA:9 a=4Gb8eucrq0BMUHm73HoA:7 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Fox <pgf@laptop.org>

When executing EC commands, only waiting when there are still more bytes to
write is usually fine. However, if the system suspends very quickly after
a call to olpc_ec_cmd(), the last data byte may not yet be transferred to
the EC, and the command will not complete.

This solves a bug where the SCI wakeup mask was not correctly written
when going into suspend.

Signed-off-by: Paul Fox <pgf@laptop.org>
Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/platform/olpc/olpc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/olpc/olpc.c b/arch/x86/platform/olpc/olpc.c
index 8b9940e..7cce722 100644
--- a/arch/x86/platform/olpc/olpc.c
+++ b/arch/x86/platform/olpc/olpc.c
@@ -161,13 +161,13 @@ restart:
 	if (inbuf && inlen) {
 		/* write data to EC */
 		for (i = 0; i < inlen; i++) {
+			pr_devel("olpc-ec:  sending cmd arg 0x%x\n", inbuf[i]);
+			outb(inbuf[i], 0x68);
 			if (wait_on_ibf(0x6c, 0)) {
 				printk(KERN_ERR "olpc-ec:  timeout waiting for"
 						" EC accept data!\n");
 				goto err;
 			}
-			pr_devel("olpc-ec:  sending cmd arg 0x%x\n", inbuf[i]);
-			outb(inbuf[i], 0x68);
 		}
 	}
 	if (outbuf && outlen) {
-- 
1.7.6

