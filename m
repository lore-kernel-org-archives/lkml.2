Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab1FFIen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:34:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:34398 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757009Ab1FFIek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:34:40 -0400
Date: Mon, 6 Jun 2011 08:34:02 GMT
From: tip-bot for Andy Lutomirski <luto@MIT.EDU>
Message-ID: <tip-5dfcea629a08b4684a019cd0cb59d0c9129a6c02@git.kernel.org>
Cc: mingo@redhat.com, brgerst@gmail.com, torvalds@linux-foundation.org,
        mikpe@it.uu.se, richard.weinberger@gmail.com, jj@chaosbits.net,
        JBeulich@novell.com, tglx@linutronix.de, Louis.Rilling@kerlabs.com,
        luto@MIT.EDU, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@MIT.EDU, andi@firstfloor.org, bp@alien8.de, arjan@infradead.org,
        mingo@elte.hu
Reply-To: mingo@redhat.com, torvalds@linux-foundation.org, brgerst@gmail.com,
        mikpe@it.uu.se, richard.weinberger@gmail.com, jj@chaosbits.net,
        JBeulich@novell.com, tglx@linutronix.de, luto@MIT.EDU,
        Louis.Rilling@kerlabs.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@MIT.EDU, andi@firstfloor.org, bp@alien8.de, arjan@infradead.org,
        mingo@elte.hu
In-Reply-To: <ed54bfcfbe50a9070d20ec1edbe0d149e22a4568.1307292171.git.luto@mit.edu>
References: <ed54bfcfbe50a9070d20ec1edbe0d149e22a4568.1307292171.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64: Fill unused parts of the vsyscall page with 0xcc
Git-Commit-ID: 5dfcea629a08b4684a019cd0cb59d0c9129a6c02
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Jun 2011 08:34:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5dfcea629a08b4684a019cd0cb59d0c9129a6c02
Gitweb:     http://git.kernel.org/tip/5dfcea629a08b4684a019cd0cb59d0c9129a6c02
Author:     Andy Lutomirski <luto@MIT.EDU>
AuthorDate: Sun, 5 Jun 2011 13:50:23 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 6 Jun 2011 09:43:14 +0200

x86-64: Fill unused parts of the vsyscall page with 0xcc

Jumping to 0x00 might do something depending on the following
bytes. Jumping to 0xcc is a trap.  So fill the unused parts of
the vsyscall page with 0xcc to make it useless for exploits to
jump there.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Cc: Jesper Juhl <jj@chaosbits.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: Valdis.Kletnieks@vt.edu
Cc: pageexec@freemail.hu
Link: http://lkml.kernel.org/r/ed54bfcfbe50a9070d20ec1edbe0d149e22a4568.1307292171.git.luto@mit.edu
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/vmlinux.lds.S |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 4f90082..8017471 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -166,22 +166,20 @@ SECTIONS
 	__vsyscall_0 = .;
 
 	. = VSYSCALL_ADDR;
-	.vsyscall_0 : AT(VLOAD(.vsyscall_0)) {
+	.vsyscall : AT(VLOAD(.vsyscall)) {
 		*(.vsyscall_0)
-	} :user
 
-	. = ALIGN(L1_CACHE_BYTES);
-	.vsyscall_fn : AT(VLOAD(.vsyscall_fn)) {
+		. = ALIGN(L1_CACHE_BYTES);
 		*(.vsyscall_fn)
-	}
 
-	.vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1)) {
+		. = 1024;
 		*(.vsyscall_1)
-	}
-	.vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2)) {
+
+		. = 2048;
 		*(.vsyscall_2)
-	}
 
+		. = 4096;  /* Pad the whole page. */
+	} :user =0xcc
 	. = ALIGN(__vsyscall_0 + PAGE_SIZE, PAGE_SIZE);
 
 #undef VSYSCALL_ADDR
