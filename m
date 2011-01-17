Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab1AQCqU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 21:46:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:5439 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab1AQCqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 21:46:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,332,1291622400"; 
   d="scan'208";a="878001634"
Subject: [PATCH]x86: make relocatable kernel work with new binutils -resend
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "Lu, Hongjiu" <hongjiu.lu@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 10:46:01 +0800
Message-ID: <1295232361.1949.675.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

last post is lost, resend it.

The CONFIG_RELOCATABLE is broken with new binutils, which will make boot
panic. According to Lu Hongjiu, the affected binutils are from
2.20.51.0.12 to 2.21.51.0.3, which are release since Oct 22 this year.
At least ubuntu 10.10 is using such binutils. see:
http://sourceware.org/bugzilla/show_bug.cgi?id=12327
The reason of boot panic is we have 'jiffies = jiffies_64;' in
vmlinux.lds.S. The jiffies isn't in any section. In kernel build, there
is warning saying jiffies is an absolute address and can't be
relocatable. At runtime, jiffies will have virtual address 0.

Signed-off-by: Shaohua Li<shaohua.li@intel.com>

---
 arch/x86/kernel/vmlinux.lds.S |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/x86/kernel/vmlinux.lds.S	2011-01-17 09:13:58.000000000 +0800
+++ linux/arch/x86/kernel/vmlinux.lds.S	2011-01-17 09:58:28.000000000 +0800
@@ -34,11 +34,9 @@ OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT, CONF
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
@@ -142,6 +140,11 @@ SECTIONS
 		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
 
 		DATA_DATA
+#ifdef CONFIG_X86_32
+		jiffies = jiffies_64;
+#else
+		jiffies_64 = jiffies;
+#endif
 		CONSTRUCTORS
 
 		/* rarely changed data like cpu maps */


