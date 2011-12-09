Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab1LISJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:09:15 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36260 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab1LISJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:09:08 -0500
From: Borislav Petkov <bp@amd64.org>
To: X86-ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/5] x86, microcode, AMD: Add a vendor-specific exit function
Date: Fri,  9 Dec 2011 19:08:51 +0100
Message-Id: <1323454135-16777-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1323454135-16777-1-git-send-email-bp@amd64.org>
References: <1323454135-16777-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This will be used to do cleanup work before the driver exits.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/microcode.h |    2 ++
 arch/x86/kernel/microcode_amd.c  |    4 ++++
 arch/x86/kernel/microcode_core.c |    5 +++++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 2421507..4ebe157 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -48,6 +48,7 @@ static inline struct microcode_ops * __init init_intel_microcode(void)
 
 #ifdef CONFIG_MICROCODE_AMD
 extern struct microcode_ops * __init init_amd_microcode(void);
+extern void __exit exit_amd_microcode(void);
 
 static inline void get_ucode_data(void *to, const u8 *from, size_t n)
 {
@@ -59,6 +60,7 @@ static inline struct microcode_ops * __init init_amd_microcode(void)
 {
 	return NULL;
 }
+static inline void __exit exit_amd_microcode(void) {}
 #endif
 
 #endif /* _ASM_X86_MICROCODE_H */
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index d494799..e8a68c2 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -353,3 +353,7 @@ struct microcode_ops * __init init_amd_microcode(void)
 {
 	return &microcode_amd_ops;
 }
+
+void __exit exit_amd_microcode(void)
+{
+}
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 9d46f5e..9302e2d 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -563,6 +563,8 @@ module_init(microcode_init);
 
 static void __exit microcode_exit(void)
 {
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
 	microcode_dev_exit();
 
 	unregister_hotcpu_notifier(&mc_cpu_notifier);
@@ -580,6 +582,9 @@ static void __exit microcode_exit(void)
 
 	microcode_ops = NULL;
 
+	if (c->x86_vendor == X86_VENDOR_AMD)
+		exit_amd_microcode();
+
 	pr_info("Microcode Update Driver: v" MICROCODE_VERSION " removed.\n");
 }
 module_exit(microcode_exit);
-- 
1.7.8.rc0

