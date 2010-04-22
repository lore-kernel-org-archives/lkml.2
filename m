Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab0DVQY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 12:24:26 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45177 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab0DVQXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 12:23:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=X+T4LpXDxJfTCpM7yhyhut93zXqeXKW9mYB9nLpdgw1JJ0ZnUmL5jbsPwJZWe/pCDc
         5xHJ/JKdpdQFUnq5NUv1ulJZmZooHQ+c5tty7O5Hr6SovCb32RbQ5A52FT+rWIYXnSch
         IDLDspidFEUHVmttb3FCdJ/RzuF6d4XWvv7Js=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>,
       Haren Myneni <hbabu@us.ibm.com>, Eric Biederman <ebiederm@xmission.com>,
       Neil Horman <nhorman@tuxdriver.com>, Cong Wang <amwang@redhat.com>,
       kexec@lists.infradead.org
Subject: [PATCH 4/5] x86: use second memory region for dump-capture kernel
Date: Thu, 22 Apr 2010 18:23:11 +0200
Message-Id: <1271953392-6324-5-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1271953392-6324-1-git-send-email-v.mayatskih@gmail.com>
References: <1271953392-6324-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds second memory region support for kexec on x86
platform.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 arch/x86/kernel/setup.c |   56 +++++++++++++++++++++++++++++-----------------
 1 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c4851ef..9b395bb 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -501,19 +501,11 @@ static inline unsigned long long get_total_mem(void)
 	return total << PAGE_SHIFT;
 }
 
-static void __init reserve_crashkernel(void)
+static int __init reserve_crashkernel_region(char *region_name,
+					     struct resource *crashk,
+					     unsigned long long crash_size,
+					     unsigned long long crash_base)
 {
-	unsigned long long total_mem;
-	unsigned long long crash_size, crash_base;
-	int ret;
-
-	total_mem = get_total_mem();
-
-	ret = parse_crashkernel(boot_command_line, total_mem,
-			&crash_size, &crash_base);
-	if (ret != 0 || crash_size <= 0)
-		return;
-
 	/* 0 means: find the address automatically */
 	if (crash_base <= 0) {
 		const unsigned long long alignment = 16<<20;	/* 16M */
@@ -522,7 +514,7 @@ static void __init reserve_crashkernel(void)
 				 alignment);
 		if (crash_base == -1ULL) {
 			pr_info("crashkernel reservation failed - No suitable area found.\n");
-			return;
+			return -EINVAL;
 		}
 	} else {
 		unsigned long long start;
@@ -531,20 +523,42 @@ static void __init reserve_crashkernel(void)
 				 1<<20);
 		if (start != crash_base) {
 			pr_info("crashkernel reservation failed - memory is in use.\n");
-			return;
+			return -EINVAL;
 		}
 	}
-	reserve_early(crash_base, crash_base + crash_size, "CRASH KERNEL");
+	reserve_early(crash_base, crash_base + crash_size, region_name);
 
 	printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
-			"for crashkernel (System RAM: %ldMB)\n",
+			"for crashkernel\n",
 			(unsigned long)(crash_size >> 20),
-			(unsigned long)(crash_base >> 20),
-			(unsigned long)(total_mem >> 20));
+			(unsigned long)(crash_base >> 20));
+
+	crashk->start = crash_base;
+	crashk->end   = crash_base + crash_size - 1;
+	insert_resource(&iomem_resource, crashk);
+	return 0;
+}
+
+static void __init reserve_crashkernel(void)
+{
+	unsigned long long total_mem;
+	unsigned long long crash_size, crash_base;
+	unsigned long long crash_size_hi, crash_base_hi;
+	int ret;
+
+	total_mem = get_total_mem();
+
+	ret = parse_crashkernel_ext(boot_command_line, total_mem,
+				    &crash_size, &crash_base,
+				    &crash_size_hi, &crash_base_hi);
+	if (ret != 0 || crash_size <= 0)
+		return;
 
-	crashk_res.start = crash_base;
-	crashk_res.end   = crash_base + crash_size - 1;
-	insert_resource(&iomem_resource, &crashk_res);
+	ret = reserve_crashkernel_region("CRASH KERNEL", &crashk_res,
+					 crash_size, crash_base);
+	if (ret == 0 && crash_size_hi > 0)
+		reserve_crashkernel_region("CRASH HIMEM", &crashk_res_hi,
+					   crash_size_hi, crash_base_hi);
 }
 #else
 static void __init reserve_crashkernel(void)
-- 
1.7.0.1

