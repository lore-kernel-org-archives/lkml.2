Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab1HCNc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:32:27 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:59062 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754626Ab1HCNcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:32:14 -0400
X-AuditID: 12074423-b7b31ae000000a3c-c6-4e394de1dcfb
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jeremy@goop.org,
        keir.xen@gmail.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2 2/6] x86-64: Move the "user" vsyscall segment out of the data segment.
Date: Wed,  3 Aug 2011 09:31:50 -0400
Message-Id: <f0716870c297242a841b949953d80c0d87bf3d3f.1312378163.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1312378163.git.luto@mit.edu>
References: <cover.1312378163.git.luto@mit.edu>
In-Reply-To: <cover.1312378163.git.luto@mit.edu>
References: <cover.1312378163.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsUixG6novvQ19LPYN9pfYu+K0fZLR7Ne8Rq
	MXXZXFaLZYufMlpc3jWHzWL52XlsFj82PGa1uDflPbsDh8fOWXfZPTZfXM3ksWlVJ5vH5BvL
	GT229+1i9/j49BaLx+dNcgHsUVw2Kak5mWWpRfp2CVwZO2atZC+Yw1cxf8FO5gbGFdxdjJwc
	EgImEjvWXmOBsMUkLtxbzwZiCwnsY5S4/Uu0i5ELyF7PKPHr90pWCOcpk8S+/U/BqtgEVCQ6
	lj5gArFFBJwkWid8ZAIpYhZ4xiix6egZZpCEsECkxK+F79hBbBYBVYmJh5oYQWxegSCJF1cO
	Q62Wkzhy+TnYIE4BA4lVC54DxTmAtulLPFiTj0N4AqPAAkaGVYyyKblVurmJmTnFqcm6xcmJ
	eXmpRbpmermZJXqpKaWbGMGh7KK8g/HPQaVDjAIcjEo8vIzyFn5CrIllxZW5hxglOZiURHmX
	e1n6CfEl5adUZiQWZ8QXleakFh9ilOBgVhLhbecFyvGmJFZWpRblw6SkOViUxHlzvf/7Cgmk
	J5akZqemFqQWwWRlODiUJHj5gTErJFiUmp5akZaZU4KQZuLgBBnOAzTcBqSGt7ggMbc4Mx0i
	f4pRUUqc1xAkIQCSyCjNg+uFpZpXjOJArwjzMoBU8QDTFFz3K6DBTECD/7+3ABlckoiQkmpg
	VHgVMNvx+qX42yv0ZtbJnuLX3f1OtDM/aUOsV2TPtOg7wawyKydpmE1ecbFTfpWr9iU78R03
	EysuTAhfZdt+llFfoOy+ub1XGWPT8a1Hbgnk77Tr5vveMqeNl91rynzhU6t4LW8XaItp3JLV
	kO+ZVXQj5yb3r2Y9XXvhPX8UTz+Pc1qy+4S4EktxRqKhFnNRcSIASxVuXBADAAA=
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

