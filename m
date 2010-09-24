Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab0IWXa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 19:30:58 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:46036 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904Ab0IWXa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 19:30:56 -0400
Date: Thu, 23 Sep 2010 17:31:05 -0700
From: Andres Salomon <dilinger@queued.net>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, dsd@laptop.org, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org
Subject: [PATCH] x86: OLPC: some olpc-detection cleanups
Message-ID: <20100923173105.10fb92d1@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following up on dsd's cleanups (3e3c4860), address some minor nits:

 - rename check_ofw_arch to olpc_check_arch (as we're checking for OLPC)
 - add a comment describing why we're checking..
 - use sizeof(array) rather than hardcoding the size
 - sprinkle some parens around

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/kernel/olpc.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
index 37c4993..361c2e0 100644
--- a/arch/x86/kernel/olpc.c
+++ b/arch/x86/kernel/olpc.c
@@ -183,18 +183,25 @@ err:
 }
 EXPORT_SYMBOL_GPL(olpc_ec_cmd);
 
-static bool __init check_ofw_architecture(void)
+/*
+ * Simply because OFW has been detected does not mean that the machine is
+ * an OLPC device; this ensures that OFW's "/architecture" property is set
+ * to "OLPC".
+ */
+static bool __init olpc_check_architecture(void)
 {
 	size_t propsize;
 	char olpc_arch[5];
-	const void *args[] = { NULL, "architecture", olpc_arch, (void *)5 };
+	const void *args[] = { NULL, "architecture", olpc_arch,
+			(void *)sizeof(olpc_arch) };
 	void *res[] = { &propsize };
 
 	if (olpc_ofw("getprop", args, res)) {
 		printk(KERN_ERR "ofw: getprop call failed!\n");
 		return false;
 	}
-	return propsize == 5 && strncmp("OLPC", olpc_arch, 5) == 0;
+	return (propsize == sizeof(olpc_arch)) &&
+			(strncmp("OLPC", olpc_arch, sizeof(olpc_arch)) == 0);
 }
 
 static u32 __init get_board_revision(void)
@@ -213,7 +220,7 @@ static u32 __init get_board_revision(void)
 
 static bool __init platform_detect(void)
 {
-	if (!check_ofw_architecture())
+	if (!olpc_check_architecture())
 		return false;
 	olpc_platform_info.flags |= OLPC_F_PRESENT;
 	olpc_platform_info.boardrev = get_board_revision();
-- 
1.5.6.5

