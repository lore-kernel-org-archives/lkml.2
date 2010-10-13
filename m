Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab0JMSKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 14:10:47 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:31474 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751843Ab0JMSKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 14:10:46 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de
To: mingo@redhat.com
To: x86@kernel.org
To: hpa@zytor.com
Cc: dilinger@queued.net
Cc: mjg@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] OLPC: register XO-1 platform devices
Message-Id: <20101013181042.90C8F9D401B@zog.reactivated.net>
Date: Wed, 13 Oct 2010 19:10:42 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=DhNl2YeytwJssBBGe49HJX82LNDFEEVkpVB34RXKaPo= c=1 sm=0 a=8ehnox9J--sA:10 a=Op-mwl0xAAAA:8 a=u87za_w-RV7SNqKzJE8A:9 a=QKosQRD-9YGyfCyNoxLGe_j8UQgA:4 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The upcoming XO-1 rfkill driver (for drivers/platform/x86) will register
itself with the name "xo1-rfkill", and the already-merged XO-1 poweroff
code uses name "olpc-xo1"

Add the necessary mechanics so that these devices are properly
initialized on XO-1 laptops.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/kernel/olpc.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

Needed for the just-merged XO-1 poweroff support to be useful.
Replaces earlier patch titled "OLPC: register XO-1 RF kill device"
The rfkill driver got an ack from the drivers/platform/x86 maintainer,
I presume he's just waiting for the merge of this one before applying it.

diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
index 37c49934..cb34ecf 100644
--- a/arch/x86/kernel/olpc.c
+++ b/arch/x86/kernel/olpc.c
@@ -17,6 +17,7 @@
 #include <linux/spinlock.h>
 #include <linux/io.h>
 #include <linux/string.h>
+#include <linux/platform_device.h>
 
 #include <asm/geode.h>
 #include <asm/setup.h>
@@ -220,8 +221,25 @@ static bool __init platform_detect(void)
 	return true;
 }
 
+static int __init add_xo1_platform_devices(void)
+{
+	struct platform_device *pdev;
+
+	pdev = platform_device_register_simple("xo1-rfkill", -1, NULL, 0);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
+	pdev = platform_device_register_simple("olpc-xo1", -1, NULL, 0);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
+	return 0;
+}
+
 static int __init olpc_init(void)
 {
+	int r = 0;
+
 	if (!olpc_ofw_present() || !platform_detect())
 		return 0;
 
@@ -248,6 +266,12 @@ static int __init olpc_init(void)
 			olpc_platform_info.boardrev >> 4,
 			olpc_platform_info.ecver);
 
+	if (olpc_platform_info.boardrev < olpc_board_pre(0xd0)) { /* XO-1 */
+		r = add_xo1_platform_devices();
+		if (r)
+			return r;
+	}
+
 	return 0;
 }
 
-- 
1.7.2.3

