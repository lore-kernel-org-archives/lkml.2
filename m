Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab1G0DVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 23:21:04 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:61005 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753682Ab1G0DU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 23:20:58 -0400
X-AuditID: 12074423-b7cb3ae000000a19-5b-4e2f84156232
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jeremy@goop.org,
        keir.xen@gmail.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 2/5] x86-64: Move the "user" vsyscall segment out of the data segment.
Date: Tue, 26 Jul 2011 23:20:36 -0400
Message-Id: <af5cec39502c43e22e1c150de05125231510db55.1311736366.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1311736366.git.luto@mit.edu>
References: <cover.1311736366.git.luto@mit.edu>
In-Reply-To: <cover.1311736366.git.luto@mit.edu>
References: <cover.1311736366.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsUixG6nrivaou9ncPGLgkXflaPsFo/mPWK1
	mLpsLqvFssVPGS0u75rDZrH87Dw2ix8bHrNa3Jvynt2Bw2PnrLvsHpsvrmby2LSqk81j8o3l
	jB7b+3axe3x8eovF4/MmuQD2KC6blNSczLLUIn27BK6MHbNWshfM4auYv2AncwPjCu4uRg4O
	CQETiYb3tl2MnECmmMSFe+vZQGwhgX2MEjeeiHcxcgHZGxglbi3sYYRIPGOSmPBNC8RmE1CR
	6Fj6gAnEFhFwkmid8JEJpIFZ4BmjxKajZ5hBEsICYRLX53xmAlnGIqAqceukHIjJKxAkcfxH
	AMReOYkjl5+DjeEUMJDYu7GVGWKVvsS6L3eZcYlPYBRYwMiwilE2JbdKNzcxM6c4NVm3ODkx
	Ly+1SNdMLzezRC81pXQTIziMXZR3MP45qHSIUYCDUYmHd2Okvp8Qa2JZcWXuIUZJDiYlUd6M
	ZqAQX1J+SmVGYnFGfFFpTmrxIUYJDmYlEd4d//X8hHhTEiurUovyYVLSHCxK4ry53v99hQTS
	E0tSs1NTC1KLYLIyHBxKErxhIEMFi1LTUyvSMnNKENJMHJwgw3mAhnuD1PAWFyTmFmemQ+RP
	MSpKifNmgyQEQBIZpXlwvbA084pRHOgVYd4QkCoeYIqC634FNJgJ5GodsMEliQgpqQbG67vj
	a2I23doVrPF71eIbq+JYVx13e9jNUBkiHW7jvL/ncoK5+aN9Bi2RnEkta2JjnV5K57Cfburz
	c9VINombZGNqWs6+37Fsynqt8rj/rz5nGQR6fbpUnOW8MYFZba2Wr9buL97Mk2fHy7t81O4p
	nzlHJiRftllKWERxIUvd1r9LwqzNWZVYijMSDbWYi4oTAYRTAAMOAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel's loader doesn't seem to care, but gold complains.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Reported-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
---
 arch/x86/kernel/vmlinux.lds.S |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 4aa9c54..e79fb39 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -154,6 +154,24 @@ SECTIONS
 
 #ifdef CONFIG_X86_64
 
+	. = ALIGN(PAGE_SIZE);
+	__vvar_page = .;
+
+	.vvar : AT(ADDR(.vvar) - LOAD_OFFSET) {
+
+	      /* Place all vvars at the offsets in asm/vvar.h. */
+#define EMIT_VVAR(name, offset) 		\
+		. = offset;		\
+		*(.vvar_ ## name)
+#define __VVAR_KERNEL_LDS
+#include <asm/vvar.h>
+#undef __VVAR_KERNEL_LDS
+#undef EMIT_VVAR
+
+	} :data
+
+       . = ALIGN(__vvar_page + PAGE_SIZE, PAGE_SIZE);
+
 #define VSYSCALL_ADDR (-10*1024*1024)
 
 #define VLOAD_OFFSET (VSYSCALL_ADDR - __vsyscall_0 + LOAD_OFFSET)
@@ -162,7 +180,6 @@ SECTIONS
 #define VVIRT_OFFSET (VSYSCALL_ADDR - __vsyscall_0)
 #define VVIRT(x) (ADDR(x) - VVIRT_OFFSET)
 
-	. = ALIGN(4096);
 	__vsyscall_0 = .;
 
 	. = VSYSCALL_ADDR;
@@ -185,23 +202,6 @@ SECTIONS
 #undef VVIRT_OFFSET
 #undef VVIRT
 
-	__vvar_page = .;
-
-	.vvar : AT(ADDR(.vvar) - LOAD_OFFSET) {
-
-	      /* Place all vvars at the offsets in asm/vvar.h. */
-#define EMIT_VVAR(name, offset) 		\
-		. = offset;		\
-		*(.vvar_ ## name)
-#define __VVAR_KERNEL_LDS
-#include <asm/vvar.h>
-#undef __VVAR_KERNEL_LDS
-#undef EMIT_VVAR
-
-	} :data
-
-       . = ALIGN(__vvar_page + PAGE_SIZE, PAGE_SIZE);
-
 #endif /* CONFIG_X86_64 */
 
 	/* Init code and data - will be freed after init */
-- 
1.7.6

