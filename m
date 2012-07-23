Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab2GWBnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:43:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54324 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753415Ab2GWBnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:14 -0400
Message-Id: <20120723010701.453060174@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Daney <david.daney@cavium.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [ 066/108] MIPS: Properly align the .data..init_task section.
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Daney <david.daney@cavium.com>

commit 7b1c0d26a8e272787f0f9fcc5f3e8531df3b3409 upstream.

Improper alignment can lead to unbootable systems and/or random
crashes.

[ralf@linux-mips.org: This is a lond standing bug since
6eb10bc9e2deab06630261cd05c4cb1e9a60e980 (kernel.org) rsp.
c422a10917f75fd19fa7fe070aaaa23e384dae6f (lmo) [MIPS: Clean up linker script
using new linker script macros.] so dates back to 2.6.32.]

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/3881/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/mips/include/asm/thread_info.h |    4 ++--
 arch/mips/kernel/vmlinux.lds.S      |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -60,6 +60,8 @@ struct thread_info {
 register struct thread_info *__current_thread_info __asm__("$28");
 #define current_thread_info()  __current_thread_info
 
+#endif /* !__ASSEMBLY__ */
+
 /* thread information allocation */
 #if defined(CONFIG_PAGE_SIZE_4KB) && defined(CONFIG_32BIT)
 #define THREAD_SIZE_ORDER (1)
@@ -97,8 +99,6 @@ register struct thread_info *__current_t
 
 #define free_thread_info(info) kfree(info)
 
-#endif /* !__ASSEMBLY__ */
-
 #define PREEMPT_ACTIVE		0x10000000
 
 /*
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -1,5 +1,6 @@
 #include <asm/asm-offsets.h>
 #include <asm/page.h>
+#include <asm/thread_info.h>
 #include <asm-generic/vmlinux.lds.h>
 
 #undef mips
@@ -73,7 +74,7 @@ SECTIONS
 	.data : {	/* Data */
 		. = . + DATAOFFSET;		/* for CONFIG_MAPPED_KERNEL */
 
-		INIT_TASK_DATA(PAGE_SIZE)
+		INIT_TASK_DATA(THREAD_SIZE)
 		NOSAVE_DATA
 		CACHELINE_ALIGNED_DATA(1 << CONFIG_MIPS_L1_CACHE_SHIFT)
 		READ_MOSTLY_DATA(1 << CONFIG_MIPS_L1_CACHE_SHIFT)


