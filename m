Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab1I1HmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:42:24 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:54713 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab1I1HmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:42:22 -0400
Date: Wed, 28 Sep 2011 17:42:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110928174214.17a58be15d84d67c185930e1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) failed like this:

arch/x86/kernel/sys_x86_64.c:28:10: warning: 'enum align_flags' declared inside parameter list
arch/x86/kernel/sys_x86_64.c:28:10: warning: its scope is only this definition or declaration, which is probably not what you want
arch/x86/kernel/sys_x86_64.c:28:22: error: parameter 3 ('flags') has incomplete type
arch/x86/kernel/sys_x86_64.c:27:15: warning: function declaration isn't a prototype
arch/x86/kernel/sys_x86_64.c: In function 'align_addr':
arch/x86/kernel/sys_x86_64.c:33:6: error: 'va_align' undeclared (first use in this function)
arch/x86/kernel/sys_x86_64.c:33:6: note: each undeclared identifier is reported only once for each function it appears in
arch/x86/kernel/sys_x86_64.c:33:2: error: implicit declaration of function 'mmap_is_ia32'
arch/x86/kernel/sys_x86_64.c:39:17: error: 'ALIGN_VDSO' undeclared (first use in this function)
arch/x86/kernel/sys_x86_64.c:48:16: error: 'ALIGN_TOPDOWN' undeclared (first use in this function)
arch/x86/kernel/sys_x86_64.c: In function 'control_va_addr_alignment':
arch/x86/kernel/sys_x86_64.c:59:6: error: 'va_align' undeclared (first use in this function)
arch/x86/kernel/sys_x86_64.c:69:20: error: 'ALIGN_VA_32' undeclared (first use in this function)
arch/x86/kernel/sys_x86_64.c:71:20: error: 'ALIGN_VA_64' undeclared (first use in this function)
arch/x86/kernel/sys_x86_64.c: In function 'arch_get_unmapped_area_topdown':
arch/x86/kernel/sys_x86_64.c:231:11: error: 'ALIGN_TOPDOWN' undeclared (first use in this function)

Presumably caused by commit dfb09f9b7ab0 ("x86, amd: Avoid cache aliasing
penalties on AMD family 15h") from the tip tree interacting with the
module.h split up.

I applied the following patch (which could be applied to the tip
tree ...).

>From 6b1212311c0728a7e3054e1f187e7c3b9f464bd5 Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 28 Sep 2011 17:28:50 +1000
Subject: [PATCH] x86, amd: include linux/elf.h since we use stuff from
 asm/elf.h

The lack of this inclusion causes build erros after the module.h split up:

arch/x86/kernel/sys_x86_64.c:28:10: warning: 'enum align_flags' declared inside parameter list
arch/x86/kernel/sys_x86_64.c:28:10: warning: its scope is only this definition or declaration, which is probably not what you want
arch/x86/kernel/sys_x86_64.c:28:22: error: parameter 3 ('flags') has incomplete type
arch/x86/kernel/sys_x86_64.c:27:15: warning: function declaration isn't a prototype
arch/x86/kernel/sys_x86_64.c: In function 'align_addr':
arch/x86/kernel/sys_x86_64.c:33:6: error: 'va_align' undeclared (first use in this function)
arch/x86/kernel/sys_x86_64.c:33:6: note: each undeclared identifier is reported only once for each function it appears in
arch/x86/kernel/sys_x86_64.c:33:2: error: implicit declaration of function 'mmap_is_ia32'
arch/x86/kernel/sys_x86_64.c:39:17: error: 'ALIGN_VDSO' undeclared (first use in this function)
arch/x86/kernel/sys_x86_64.c:48:16: error: 'ALIGN_TOPDOWN' undeclared (first use in this function)
arch/x86/kernel/sys_x86_64.c: In function 'control_va_addr_alignment':
arch/x86/kernel/sys_x86_64.c:59:6: error: 'va_align' undeclared (first use in this function)
arch/x86/kernel/sys_x86_64.c:69:20: error: 'ALIGN_VA_32' undeclared (first use in this function)
arch/x86/kernel/sys_x86_64.c:71:20: error: 'ALIGN_VA_64' undeclared (first use in this function)
arch/x86/kernel/sys_x86_64.c: In function 'arch_get_unmapped_area_topdown':
arch/x86/kernel/sys_x86_64.c:231:11: error: 'ALIGN_TOPDOWN' undeclared (first use in this function)

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/kernel/sys_x86_64.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index fe7d2da..0514890 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -14,6 +14,7 @@
 #include <linux/personality.h>
 #include <linux/random.h>
 #include <linux/uaccess.h>
+#include <linux/elf.h>
 
 #include <asm/ia32.h>
 #include <asm/syscalls.h>
-- 
1.7.6.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
