Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab1ARIuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 03:50:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:54290 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997Ab1ARIuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 03:50:01 -0500
Date: Tue, 18 Jan 2011 08:49:38 GMT
From: tip-bot for Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        sam@ravnborg.org, hongjiu.lu@intel.com, shaohua.li@intel.com,
        ying.huang@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sam@ravnborg.org, hongjiu.lu@intel.com, shaohua.li@intel.com,
        ying.huang@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1295312269.1949.725.camel@sli10-conroe>
References: <1295312269.1949.725.camel@sli10-conroe>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Make relocatable kernel work with new binutils
Message-ID: <tip-86b1e8dd83cbb0fcbf3d61d2b461df8be1f528cf@git.kernel.org>
Git-Commit-ID: 86b1e8dd83cbb0fcbf3d61d2b461df8be1f528cf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 Jan 2011 08:49:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  86b1e8dd83cbb0fcbf3d61d2b461df8be1f528cf
Gitweb:     http://git.kernel.org/tip/86b1e8dd83cbb0fcbf3d61d2b461df8be1f528cf
Author:     Shaohua Li <shaohua.li@intel.com>
AuthorDate: Tue, 18 Jan 2011 08:57:49 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Jan 2011 09:05:33 +0100

x86: Make relocatable kernel work with new binutils

The CONFIG_RELOCATABLE=y option is broken with new binutils, which will make
boot panic.

According to Lu Hongjiu, the affected binutils are from 2.20.51.0.12 to
2.21.51.0.3, which are release since Oct 22 this year. At least ubuntu 10.10 is
using such binutils. See:

    http://sourceware.org/bugzilla/show_bug.cgi?id=12327

The reason of the boot panic is that we have 'jiffies = jiffies_64;' in
vmlinux.lds.S. The jiffies isn't in any section. In kernel build, there is
warning saying jiffies is an absolute address and can't be relocatable. At
runtime, jiffies will have virtual address 0.

Signed-off-by: Shaohua Li<shaohua.li@intel.com>
Cc: Lu Hongjiu<hongjiu.lu@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
LKML-Reference: <1295312269.1949.725.camel@sli10-conroe>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/vmlinux.lds.S |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index bf47007..b34ab80 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -34,11 +34,9 @@ OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT)
 #ifdef CONFIG_X86_32
 OUTPUT_ARCH(i386)
 ENTRY(phys_startup_32)
-jiffies = jiffies_64;
 #else
 OUTPUT_ARCH(i386:x86-64)
 ENTRY(phys_startup_64)
-jiffies_64 = jiffies;
 #endif
 
 #if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
@@ -142,6 +140,15 @@ SECTIONS
 		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
 
 		DATA_DATA
+		/*
+		 * Workaround a binutils (2.20.51.0.12 to 2.21.51.0.3) bug.
+		 * This makes jiffies relocatable in such binutils
+		 */
+#ifdef CONFIG_X86_32
+		jiffies = jiffies_64;
+#else
+		jiffies_64 = jiffies;
+#endif
 		CONSTRUCTORS
 
 		/* rarely changed data like cpu maps */
