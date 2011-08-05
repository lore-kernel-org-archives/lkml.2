Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab1HEFiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 01:38:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:45395 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611Ab1HEFiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 01:38:17 -0400
Date: Fri, 5 Aug 2011 05:38:11 GMT
From: tip-bot for Andy Lutomirski <luto@mit.edu>
Message-ID: <tip-f670bb760e7d32ec9c690e748a1d5d04921363ab@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        luto@mit.edu, a.miskiewicz@gmail.com, tglx@linutronix.de,
        hpa@linux.intel.com, luto@mit.edu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@mit.edu, a.miskiewicz@gmail.com, tglx@linutronix.de,
        hpa@linux.intel.com, luto@mit.edu
In-Reply-To: <0b260cb806f1f9a25c00ce8377a5f035d57f557a.1312378163.git.luto@mit.edu>
References: <0b260cb806f1f9a25c00ce8377a5f035d57f557a.1312378163.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64: Work around gold bug 13023
Git-Commit-ID: f670bb760e7d32ec9c690e748a1d5d04921363ab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Aug 2011 05:38:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f670bb760e7d32ec9c690e748a1d5d04921363ab
Gitweb:     http://git.kernel.org/tip/f670bb760e7d32ec9c690e748a1d5d04921363ab
Author:     Andy Lutomirski <luto@MIT.EDU>
AuthorDate: Wed, 3 Aug 2011 09:31:51 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 4 Aug 2011 16:13:38 -0700

x86-64: Work around gold bug 13023

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
Link: http://lkml.kernel.org/r/0b260cb806f1f9a25c00ce8377a5f035d57f557a.1312378163.git.luto@mit.edu
Reported-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
 
