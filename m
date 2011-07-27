Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab1G0DV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 23:21:57 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:54034 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753780Ab1G0DVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 23:21:02 -0400
X-AuditID: 1209190f-b7b44ae000000a24-94-4e2f8387f4b1
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jeremy@goop.org,
        keir.xen@gmail.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 3/5] x86-64: Work around gold bug 13023
Date: Tue, 26 Jul 2011 23:20:37 -0400
Message-Id: <754803d081d19d257f44c5f4eee309e353ef4d4c.1311736366.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1311736366.git.luto@mit.edu>
References: <cover.1311736366.git.luto@mit.edu>
In-Reply-To: <cover.1311736366.git.luto@mit.edu>
References: <cover.1311736366.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsUixCmqrNverO9nsG6nhEXflaPsFo/mPWK1
	mLpsLqvFssVPGS0u75rDZrH87Dw2ix8bHrNa3Jvynt2Bw2PnrLvsHpsvrmby2LSqk81j8o3l
	jB7b+3axe3x8eovF4/MmuQD2KC6blNSczLLUIn27BK6MDSsvMhWs46/o2/2MpYFxLk8XIyeH
	hICJxOnH51khbDGJC/fWs3UxcnEICexjlHi9rZkJwtnAKLH8xTFGCOcZk8SRbS0sIC1sAioS
	HUsfMIHYIgJOEq0TPoJ1MAs8Y5TYdPQMM0hCWMBc4uWVBiCbg4NFQFXi/lklEJNXIEji/z8H
	iM1yEkcuPwcbwylgILF3YytYp5CAvsS6L3eZcYlPYBRYwMiwilE2JbdKNzcxM6c4NVm3ODkx
	Ly+1SNdELzezRC81pXQTIziYJfl3MH47qHSIUYCDUYmHd1Okvp8Qa2JZcWXuIUZJDiYlUd7G
	RqAQX1J+SmVGYnFGfFFpTmrxIUYJDmYlEd4d//X8hHhTEiurUovyYVLSHCxK4rzl3v99hQTS
	E0tSs1NTC1KLYLIyHBxKErxhwKgVEixKTU+tSMvMKUFIM3FwggznARruDVLDW1yQmFucmQ6R
	P8WoKCXOqwuSEABJZJTmwfXCks0rRnGgV4R5Q0CqeICJCq77FdBgJpCrdcAGlyQipKQaGJMm
	S1p3hMT5aC/Xtm6N3JY9f1sIh8bzybUzHz7K+ng0v109//bazcf3HF/W1lI1j//zkii9+ksy
	8yf1OT6TnrOZQyLES6Ixrfx1eMNkzmtmT/7oTv2xvHTKhx0OlW8W73pmm8EZGlV6WtZ7/pne
	9PburPy5btn9k6TLdxZN9+55wvli+SfdLiWW4oxEQy3mouJEAH7x6n4RAwAA
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
Reported-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
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

