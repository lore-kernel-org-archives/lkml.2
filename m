Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab1HCNce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:32:34 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:61147 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754726Ab1HCNcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:32:16 -0400
X-AuditID: 1209190f-b7b44ae000000a24-80-4e394d482a0b
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jeremy@goop.org,
        keir.xen@gmail.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2 3/6] x86-64: Work around gold bug 13023
Date: Wed,  3 Aug 2011 09:31:51 -0400
Message-Id: <0b260cb806f1f9a25c00ce8377a5f035d57f557a.1312378163.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1312378163.git.luto@mit.edu>
References: <cover.1312378163.git.luto@mit.edu>
In-Reply-To: <cover.1312378163.git.luto@mit.edu>
References: <cover.1312378163.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsUixCmqrevha+lnsPuemEXflaPsFo/mPWK1
	mLpsLqvFssVPGS0u75rDZrH87Dw2ix8bHrNa3Jvynt2Bw2PnrLvsHpsvrmby2LSqk81j8o3l
	jB7b+3axe3x8eovF4/MmuQD2KC6blNSczLLUIn27BK6MDSsvMhWs46/o2/2MpYFxLk8XIyeH
	hICJxNxNb1khbDGJC/fWs3UxcnEICexjlPg1bQJYQkhgPaPE5H/xEImnTBK/X/xiBkmwCahI
	dCx9wARiiwg4SbRO+MgEUsQs8IxRYtPRM0BFHBzCAlYSc16HgtSwCKhKfHx+mAXE5hUIkmh/
	1Q+1WU7iyOXnYHM4BQwkVi14zgLSKiSgL/FgTT4O4QmMAgsYGVYxyqbkVunmJmbmFKcm6xYn
	J+blpRbpmujlZpbopaaUbmIEB7Ik/w7GbweVDjEKcDAq8fAyylv4CbEmlhVX5h5ilORgUhLl
	Xe5l6SfEl5SfUpmRWJwRX1Sak1p8iFGCg1lJhLedFyjHm5JYWZValA+TkuZgURLnLff+7ysk
	kJ5YkpqdmlqQWgSTleHgUJLg9QJGrJBgUWp6akVaZk4JQpqJgxNkOA/Q8HKQGt7igsTc4sx0
	iPwpRkUpcV5DkIQASCKjNA+uF5ZoXjGKA70izGsLUsUDTFJw3a+ABjMBDf7/3gJkcEkiQkqq
	gTEwP+PSYouwB3JyieeYuN8dyZMSTo9bxvbm3aVZi9ckX8nPZVvu3lGTftD4Q06QYS+Dt2D8
	Yq5VAfZ3bpslBq+1mrHp6YwpG4WK9HvOXsycyvl6Y9jhHzfZpzzwetPMfONjiKK6xgG2TjHW
	SWdi1X5P8Ivr/M/rn7nulNmSt+89/Xpbcq3lmZVYijMSDbWYi4oTAYz/ky8PAwAA
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

