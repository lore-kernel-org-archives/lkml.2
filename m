Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab0JMVWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 17:22:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:38292 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab0JMVWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 17:22:53 -0400
Date: Wed, 13 Oct 2010 21:22:34 GMT
From: tip-bot for Daniel Drake <dsd@laptop.org>
Cc: mjg@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, dsd@laptop.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mjg@redhat.com, dsd@laptop.org, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20101013181042.90C8F9D401B@zog.reactivated.net>
References: <20101013181042.90C8F9D401B@zog.reactivated.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/olpc] x86, olpc: Register XO-1 platform devices
Message-ID: <tip-447b1d43ded08c11f4f3d344b4e07e6dcddbef95@git.kernel.org>
Git-Commit-ID: 447b1d43ded08c11f4f3d344b4e07e6dcddbef95
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Oct 2010 21:22:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  447b1d43ded08c11f4f3d344b4e07e6dcddbef95
Gitweb:     http://git.kernel.org/tip/447b1d43ded08c11f4f3d344b4e07e6dcddbef95
Author:     Daniel Drake <dsd@laptop.org>
AuthorDate: Wed, 13 Oct 2010 19:10:42 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 13 Oct 2010 11:51:25 -0700

x86, olpc: Register XO-1 platform devices

The upcoming XO-1 rfkill driver (for drivers/platform/x86) will register
itself with the name "xo1-rfkill", and the already-merged XO-1 poweroff
code uses name "olpc-xo1"

Add the necessary mechanics so that these devices are properly
initialized on XO-1 laptops.

Signed-off-by: Daniel Drake <dsd@laptop.org>
LKML-Reference: <20101013181042.90C8F9D401B@zog.reactivated.net>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/olpc.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
index 7472613..edaf3fe 100644
--- a/arch/x86/kernel/olpc.c
+++ b/arch/x86/kernel/olpc.c
@@ -17,6 +17,7 @@
 #include <linux/spinlock.h>
 #include <linux/io.h>
 #include <linux/string.h>
+#include <linux/platform_device.h>
 
 #include <asm/geode.h>
 #include <asm/setup.h>
@@ -223,8 +224,25 @@ static bool __init platform_detect(void)
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
 
@@ -251,6 +269,12 @@ static int __init olpc_init(void)
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
 
