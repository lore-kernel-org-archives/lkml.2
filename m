Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab0LREf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 23:35:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:53270 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab0LREfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 23:35:25 -0500
Date: Sat, 18 Dec 2010 04:34:06 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, vgoyal@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com, sgruszka@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, vgoyal@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com, sgruszka@redhat.com
In-Reply-To: <20101217195035.GE14502@redhat.com>
References: <20101217195035.GE14502@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, kexec: Limit the crashkernel address appropriately
Message-ID: <tip-7f8595bfacef279f06c82ec98d420ef54f2537e0@git.kernel.org>
Git-Commit-ID: 7f8595bfacef279f06c82ec98d420ef54f2537e0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 18 Dec 2010 04:34:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f8595bfacef279f06c82ec98d420ef54f2537e0
Gitweb:     http://git.kernel.org/tip/7f8595bfacef279f06c82ec98d420ef54f2537e0
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 16 Dec 2010 19:20:41 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 17 Dec 2010 15:04:00 -0800

x86, kexec: Limit the crashkernel address appropriately

Keep the crash kernel address below 512 MiB for 32 bits and 896 MiB
for 64 bits.  For 32 bits, this retains compatibility with earlier
kernel releases, and makes it work even if the vmalloc= setting is
adjusted.

For 64 bits, we should be able to increase this substantially once a
hard-coded limit in kexec-tools is fixed.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20101217195035.GE14502@redhat.com>
---
 arch/x86/kernel/setup.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 21c6746..c9089a1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -501,7 +501,18 @@ static inline unsigned long long get_total_mem(void)
 	return total << PAGE_SHIFT;
 }
 
-#define DEFAULT_BZIMAGE_ADDR_MAX 0x37FFFFFF
+/*
+ * Keep the crash kernel below this limit.  On 32 bits earlier kernels
+ * would limit the kernel to the low 512 MiB due to mapping restrictions.
+ * On 64 bits, kexec-tools currently limits us to 896 MiB; increase this
+ * limit once kexec-tools are fixed.
+ */
+#ifdef CONFIG_X86_32
+# define CRASH_KERNEL_ADDR_MAX	(512 << 20)
+#else
+# define CRASH_KERNEL_ADDR_MAX	(896 << 20)
+#endif
+
 static void __init reserve_crashkernel(void)
 {
 	unsigned long long total_mem;
@@ -520,10 +531,10 @@ static void __init reserve_crashkernel(void)
 		const unsigned long long alignment = 16<<20;	/* 16M */
 
 		/*
-		 *  kexec want bzImage is below DEFAULT_BZIMAGE_ADDR_MAX
+		 *  kexec want bzImage is below CRASH_KERNEL_ADDR_MAX
 		 */
 		crash_base = memblock_find_in_range(alignment,
-			       DEFAULT_BZIMAGE_ADDR_MAX, crash_size, alignment);
+			       CRASH_KERNEL_ADDR_MAX, crash_size, alignment);
 
 		if (crash_base == MEMBLOCK_ERROR) {
 			pr_info("crashkernel reservation failed - No suitable area found.\n");
