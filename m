Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab1GWTTi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 15:19:38 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:61846 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753336Ab1GWTTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 15:19:20 -0400
X-AuditID: 12074425-b7bcaae000000a1b-c9-4e2b1e8f4392
From: Andy Lutomirski <luto@MIT.EDU>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH resend 2/2] x86-64: Work around gold bug 13023
Date: Sat, 23 Jul 2011 15:19:03 -0400
Message-Id: <7afd54689af0452954dddad0638181212f2320dd.1311448660.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1311448660.git.luto@mit.edu>
References: <201107231559.23537.a.miskiewicz@gmail.com>
 <cover.1311448660.git.luto@mit.edu>
In-Reply-To: <cover.1311448660.git.luto@mit.edu>
References: <cover.1311448660.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsUixCmqrdsvp+1ncH+zhMXSHy+ZLfquHGW3
	uLxrDpvFlkvNrBY/NjxmdWD1uNX2h9lj56y77B6bVnWyeXzeJBfAEsVlk5Kak1mWWqRvl8CV
	sXH1YtaCT3wVO+fNZ25gfMbdxcjJISFgInGkp48ZwhaTuHBvPVsXIxeHkMA+Romfx3dBORsY
	JaYv/MgO4Txjktj7bDpYC5uAikTH0gdMILaIgJ/Ez/ftYHFmgUiJC09Ws4DYwgJ2EtM3/Qar
	YRFQlTh9u5kRxOYVCJKY+/0oI8RqOYkjl5+D1XAKGEh86/sGFhcSiJVY820HO6o4B1BcX+LX
	luAJjAILGBlWMcqm5Fbp5iZm5hSnJusWJyfm5aUW6Vro5WaW6KWmlG5iBAUku4vqDsYJh5QO
	MQpwMCrx8G76ouUnxJpYVlyZe4hRkoNJSZQ3TEbbT4gvKT+lMiOxOCO+qDQntfgQowQHs5II
	7+UtQOW8KYmVValF+TApaQ4WJXHeEO//vkIC6YklqdmpqQWpRTBZGQ4OJQlebmDkCQkWpaan
	VqRl5pQgpJk4OEGG8wAN3y8LVMNbXJCYW5yZDpE/xagoJc7LD9IsAJLIKM2D64UljFeM4kCv
	CPP+AmnnASYbuO5XQIOZgAbLK2iCDC5JREhJNTAWKoZVJq0r/crAUKLU3v4x+/LB5ElG+5/5
	rv/F+CT4Vu+Gg+4l0W/bWTcUGzGt5m1allHt5KHrWbDbZkKIUbtVQe0zsanPD686zD9Dz3J2
	N7tN+UX+MOdNavxeVZGu++zs5D3eXzJ2ebUkXFWlO3PZn6YGzZo/haFRkZa6Pk+9PrBMe/SV
	T4mlOCPRUIu5qDgRAALfJJzzAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gold has trouble assigning numbers to the location counter inside of
an output section description.  The bug was triggered by
9fd67b4ed0714ab718f1f9bd14c344af336a6df7, which consolidated all of
the vsyscall sections into a single section.  The workaround is IMO
still nicer than the old way of doing it.

This produces an apparently valid kernel image and passes my vdso
tests on both GNU ld version 2.21.51.0.6-2.fc15 20110118 and GNU
gold (version 2.21.51.0.6-2.fc15 20110118) 1.10 as distributed by
Fedora 15.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/vmlinux.lds.S |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index e79fb39..8f3a265 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -158,10 +158,12 @@ SECTIONS
 	__vvar_page = .;
 
 	.vvar : AT(ADDR(.vvar) - LOAD_OFFSET) {
+		/* work around gold bug 13023 */
+		__vvar_beginning_hack = .;
 
-	      /* Place all vvars at the offsets in asm/vvar.h. */
-#define EMIT_VVAR(name, offset) 		\
-		. = offset;		\
+		/* Place all vvars at the offsets in asm/vvar.h. */
+#define EMIT_VVAR(name, offset) 			\
+		. = __vvar_beginning_hack + offset;	\
 		*(.vvar_ ## name)
 #define __VVAR_KERNEL_LDS
 #include <asm/vvar.h>
@@ -184,15 +186,17 @@ SECTIONS
 
 	. = VSYSCALL_ADDR;
 	.vsyscall : AT(VLOAD(.vsyscall)) {
+		/* work around gold bug 13023 */
+		__vsyscall_beginning_hack = .;
 		*(.vsyscall_0)
 
-		. = 1024;
+		. = __vsyscall_beginning_hack + 1024;
 		*(.vsyscall_1)
 
-		. = 2048;
+		. = __vsyscall_beginning_hack + 2048;
 		*(.vsyscall_2)
 
-		. = 4096;  /* Pad the whole page. */
+		. = __vsyscall_beginning_hack + 4096;  /* Pad the whole page. */
 	} :user =0xcc
 	. = ALIGN(__vsyscall_0 + PAGE_SIZE, PAGE_SIZE);
 
-- 
1.7.6

