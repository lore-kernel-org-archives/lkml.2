Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab1GWTTX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 15:19:23 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:64798 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753374Ab1GWTTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 15:19:15 -0400
X-AuditID: 1209190e-b7c22ae000000a2c-7e-4e2b1e561378
From: Andy Lutomirski <luto@MIT.EDU>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH resend 1/2] x86-64: Move the "user" vsyscall segment out of the data segment.
Date: Sat, 23 Jul 2011 15:19:02 -0400
Message-Id: <8821026742c2e90458a23d3e333fe67c5f049e6c.1311448660.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1311448660.git.luto@mit.edu>
References: <201107231559.23537.a.miskiewicz@gmail.com>
 <cover.1311448660.git.luto@mit.edu>
In-Reply-To: <cover.1311448660.git.luto@mit.edu>
References: <cover.1311448660.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsUixG6nohsmp+1ncPYct8XSHy+ZLfquHGW3
	uLxrDpvFlkvNrBY/NjxmdWD1uNX2h9lj56y77B6bVnWyeXzeJBfAEsVlk5Kak1mWWqRvl8CV
	sXhhSsED3ormV81MDYwfuboYOTkkBEwkGg4dYYewxSQu3FvP1sXIxSEksI9Rou/cd2YIZwOj
	ROP8c6wQzjMmiRsdrUwgLWwCKhIdSx+A2SICfhI/37czg9jMApESF56sZuli5OAQFoiVaLuQ
	BRJmEVCVODj1Ctg2XoEgiUfNj9kgNstJHLn8HGwMp4CBxLe+b4wgthBQ65pvO9hRxTmA4voS
	v7YET2AUWMDIsIpRNiW3Sjc3MTOnODVZtzg5MS8vtUjXWC83s0QvNaV0EyMoGDkl+XYwfj2o
	dIhRgINRiYd3wxctPyHWxLLiytxDjJIcTEqivGEy2n5CfEn5KZUZicUZ8UWlOanFhxglOJiV
	RHgvbwEq501JrKxKLcqHSUlzsCiJ80Z5//cVEkhPLEnNTk0tSC2CycpwcChJ8J6XBRoqWJSa
	nlqRlplTgpBm4uAEGc4DNHw/SA1vcUFibnFmOkT+FKOilDjvFZCEAEgiozQPrheWLF4xigO9
	Isz7C6SKB5ho4LpfAQ1mAhosr6AJMrgkESEl1cC4rIG3aXrTqs1a/drnRKwU/D9En3gbevll
	TdCKlk83nn4SuHf+N4OXjOjsJ4X7J6gc/K/8wLhwk9CDxXy76+QKFioFJybVrHmh8vzAofWX
	g6plnhoxG78v9L2w+kC/XdvcVXx7v9q3rfe24j556ID9bvPJTCtKv6nzTWE3+H5UJMJ5m89N
	o+uTlViKMxINtZiLihMBKpP5HfECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel's loader doesn't seem to care, but gold complains.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
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

