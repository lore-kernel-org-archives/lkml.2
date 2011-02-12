Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab1BLRMA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 12:12:00 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65372 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab1BLRLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 12:11:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=h8k3c9we5W7L0j1deUelJWHfe38D1LZfyAqAMZcH8QPkHT6+kTTaGGjVdXmMtvIwwx
         DNwTTL8QZB1n6gd09IxABIBqesVkPwNXSr+ktDGeaih2twNqDpgb0ovc8wZw4ZdEEPlY
         ac3cRrqLry4HWgHukBblS27mWXvMcZU5mzOSk=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/26] x86-64, NUMA: Wrap acpi_numa_init() so that failure can be indicated by return value
Date: Sat, 12 Feb 2011 18:10:42 +0100
Message-Id: <1297530663-26234-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297530663-26234-1-git-send-email-tj@kernel.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of the way ACPI tables are parsed, the generic
acpi_numa_init() couldn't return failure when error was detected by
arch hooks.  Instead, the failure state was recorded and later arch
dependent init hook - acpi_scan_nodes() - would fail.

Wrap acpi_numa_init() with x86_acpi_numa_init() so that failure can be
indicated as return value immediately.  This is in preparation for
further NUMA init cleanups.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/acpi.h |    1 +
 arch/x86/kernel/setup.c     |    2 +-
 arch/x86/mm/srat_64.c       |   10 ++++++++++
 3 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 4e5dff9..06fb786 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -187,6 +187,7 @@ struct bootnode;
 extern int acpi_numa;
 extern void acpi_get_nodes(struct bootnode *physnodes, unsigned long start,
 				unsigned long end);
+extern int x86_acpi_numa_init(void);
 extern int acpi_scan_nodes(void);
 #define NR_NODE_MEMBLKS (MAX_NUMNODES*2)
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1870a59..f69d838 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -988,7 +988,7 @@ void __init setup_arch(char **cmdline_p)
 	/*
 	 * Parse SRAT to discover nodes.
 	 */
-	acpi = !acpi_numa_init();
+	acpi = !x86_acpi_numa_init();
 #endif
 
 #ifdef CONFIG_AMD_NUMA
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 19652dd..8d145ae 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -358,6 +358,16 @@ void __init acpi_get_nodes(struct bootnode *physnodes, unsigned long start,
 }
 #endif /* CONFIG_NUMA_EMU */
 
+int __init x86_acpi_numa_init(void)
+{
+	int ret;
+
+	ret = acpi_numa_init();
+	if (ret < 0)
+		return ret;
+	return srat_disabled() ? -EINVAL : 0;
+}
+
 /* Use the information discovered above to actually set up the nodes. */
 int __init acpi_scan_nodes(void)
 {
-- 
1.7.1

