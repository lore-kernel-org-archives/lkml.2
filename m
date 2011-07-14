Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab1GNVeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:34:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:34052 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932280Ab1GNVd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:33:59 -0400
Date: Thu, 14 Jul 2011 21:33:51 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-ab5d140b9eafae402aa3e673a63c5ef6164a9dd2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        benh@kernel.crashing.org, yinghai@kernel.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, benh@kernel.crashing.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1310462166-31469-6-git-send-email-tj@kernel.org>
References: <1310462166-31469-6-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/memblock] x86: Use __memblock_alloc_base() in early_reserve_e820()
Git-Commit-ID: ab5d140b9eafae402aa3e673a63c5ef6164a9dd2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Jul 2011 21:33:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ab5d140b9eafae402aa3e673a63c5ef6164a9dd2
Gitweb:     http://git.kernel.org/tip/ab5d140b9eafae402aa3e673a63c5ef6164a9dd2
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 12 Jul 2011 11:15:58 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Jul 2011 11:47:47 -0700

x86: Use __memblock_alloc_base() in early_reserve_e820()

early_reserve_e820() implements its own ad-hoc early allocator using
memblock_x86_find_in_range_size().  Use __memblock_alloc_base()
instead and remove the unnecessary @startt parameter (it's top-down
allocation anyway).

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1310462166-31469-6-git-send-email-tj@kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/e820.h |    2 +-
 arch/x86/kernel/e820.c      |   30 ++++++------------------------
 arch/x86/kernel/mpparse.c   |    6 ++----
 3 files changed, 9 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 908b969..3778256 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -117,7 +117,7 @@ static inline void early_memtest(unsigned long start, unsigned long end)
 
 extern unsigned long e820_end_of_ram_pfn(void);
 extern unsigned long e820_end_of_low_ram_pfn(void);
-extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
+extern u64 early_reserve_e820(u64 sizet, u64 align);
 
 void memblock_x86_fill(void);
 void memblock_find_dma_reserve(void);
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 0f9ff58..b99d940 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -737,35 +737,17 @@ core_initcall(e820_mark_nvs_memory);
 /*
  * pre allocated 4k and reserved it in memblock and e820_saved
  */
-u64 __init early_reserve_e820(u64 startt, u64 sizet, u64 align)
+u64 __init early_reserve_e820(u64 size, u64 align)
 {
-	u64 size = 0;
 	u64 addr;
-	u64 start;
 
-	for (start = startt; ; start += size) {
-		start = memblock_x86_find_in_range_size(start, &size, align);
-		if (!start)
-			return 0;
-		if (size >= sizet)
-			break;
+	addr = __memblock_alloc_base(size, align, MEMBLOCK_ALLOC_ACCESSIBLE);
+	if (addr) {
+		e820_update_range_saved(addr, size, E820_RAM, E820_RESERVED);
+		printk(KERN_INFO "update e820_saved for early_reserve_e820\n");
+		update_e820_saved();
 	}
 
-#ifdef CONFIG_X86_32
-	if (start >= MAXMEM)
-		return 0;
-	if (start + size > MAXMEM)
-		size = MAXMEM - start;
-#endif
-
-	addr = round_down(start + size - sizet, align);
-	if (addr < start)
-		return 0;
-	memblock_x86_reserve_range(addr, addr + sizet, "new next");
-	e820_update_range_saved(addr, sizet, E820_RAM, E820_RESERVED);
-	printk(KERN_INFO "update e820_saved for early_reserve_e820\n");
-	update_e820_saved();
-
 	return addr;
 }
 
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 9103b89..8faeaa0 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -836,10 +836,8 @@ early_param("alloc_mptable", parse_alloc_mptable_opt);
 
 void __init early_reserve_e820_mpc_new(void)
 {
-	if (enable_update_mptable && alloc_mptable) {
-		u64 startt = 0;
-		mpc_new_phys = early_reserve_e820(startt, mpc_new_length, 4);
-	}
+	if (enable_update_mptable && alloc_mptable)
+		mpc_new_phys = early_reserve_e820(mpc_new_length, 4);
 }
 
 static int __init update_mp_table(void)
