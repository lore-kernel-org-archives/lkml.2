Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab1FFKYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 06:24:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57049 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab1FFKYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 06:24:47 -0400
Date: Mon, 6 Jun 2011 12:24:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: [PATCH] x86-64, vsyscalls: Rename UNSAFE_VSYSCALLS to
 COMPAT_VSYSCALLS
Message-ID: <20110606102419.GA837@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <4de62bfbf6974f14d0e9d9ae37cc137dbc926a30.1307292171.git.luto@mit.edu>
 <BANLkTimrhO8QfBqQsH_Q13ghRH2P+ZP7AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimrhO8QfBqQsH_Q13ghRH2P+ZP7AA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Jun 6, 2011 at 2:50 AM, Andy Lutomirski <luto@mit.edu> wrote:
> > CONFIG_UNSAFE_VSYSCALLS was added in the previous patch as a
> > temporary hack to avoid penalizing users who don't build glibc from
> > git.
> 
> I really hate that name.
> 
> Do you have *any* reason to call this "unsafe"?

No, there's no reason at all for that. That naming is borderline 
security FUD and last time i saw the series i considered renaming
it but got distracted :-)

How about the patch below? COMPAT_VSYSCALLS looks like a good logical 
extension to the COMPAT_VDSO we already have.

CONFIG_FIXED_VSYSCALLS seemed a bit awkward to me nor does it carry 
the compat nature of them.

Thanks,

	Ingo

--------------->
>From 1593843e2ada6d6832d0de4d633aacd997dc3a45 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 6 Jun 2011 12:13:40 +0200
Subject: [PATCH] x86-64, vsyscalls: Rename UNSAFE_VSYSCALLS to COMPAT_VSYSCALLS

Linus pointed out that the UNSAFE_VSYSCALL naming was inherently
bad: it suggests that there's something unsafe about enabling them,
while in reality they only have any security effect in the presence
of some *other* security hole.

So rename it to CONFIG_COMPAT_VSYSCALL and fix the documentation
and Kconfig text to correctly explain the purpose of this change.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@mit.edu>
Cc: Jesper Juhl <jj@chaosbits.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: Valdis.Kletnieks@vt.edu
Cc: pageexec@freemail.hu
Link: http://lkml.kernel.org/r/BANLkTimrhO8QfBqQsH_Q13ghRH2P%2BZP7AA@mail.gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/feature-removal-schedule.txt |    7 ++++---
 arch/x86/Kconfig                           |   17 ++++++++++-------
 arch/x86/kernel/vsyscall_64.c              |    8 ++++----
 arch/x86/kernel/vsyscall_emu_64.S          |    2 +-
 4 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 94b4470..4282ab2 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -601,10 +601,11 @@ Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 
 ----------------------------
 
-What:	CONFIG_UNSAFE_VSYSCALLS (x86_64)
+What:	CONFIG_COMPAT_VSYSCALLS (x86_64)
 When:	When glibc 2.14 or newer is ubitquitous.  Perhaps mid-2012.
-Why:	Having user-executable code at a fixed address is a security problem.
-	Turning off CONFIG_UNSAFE_VSYSCALLS mostly removes the risk but will
+Why:	Having user-executable syscall invoking code at a fixed addresses makes
+	it easier for attackers to exploit security holes.
+	Turning off CONFIG_COMPAT_VSYSCALLS mostly removes the risk but will
 	make the time() function slower on glibc versions 2.13 and below.
 Who:	Andy Lutomirski <luto@mit.edu>
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 79e5d8a..30041d8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1646,20 +1646,23 @@ config COMPAT_VDSO
 
 	  If unsure, say Y.
 
-config UNSAFE_VSYSCALLS
+config COMPAT_VSYSCALLS
 	def_bool y
-	prompt "Unsafe fast legacy vsyscalls"
+	prompt "Fixed address legacy vsyscalls"
 	depends on X86_64
 	---help---
 	  Legacy user code expects to be able to issue three syscalls
-	  by calling fixed addresses in kernel space.  If you say N,
-	  then the kernel traps and emulates these calls.  If you say
-	  Y, then there is actual executable code at a fixed address
-	  to implement time() efficiently.
+	  by calling a fixed addresses.  If you say N, then the kernel
+	  traps and emulates these calls.  If you say Y, then there is
+	  actual executable code at a fixed address to implement time()
+	  efficiently.
 
 	  On a system with recent enough glibc (probably 2.14 or
 	  newer) and no static binaries, you can say N without a
-	  performance penalty to improve security
+	  performance penalty to improve security: having no fixed
+	  address userspace-executable syscall invoking code makes
+	  it harder for both remote and local attackers to exploit
+	  security holes.
 
 	  If unsure, say Y.
 
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 285af7a..27d49b7 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -116,7 +116,7 @@ static int al_to_vsyscall_nr(u8 al)
 	return -1;
 }
 
-#ifdef CONFIG_UNSAFE_VSYSCALLS
+#ifdef CONFIG_COMPAT_VSYSCALLS
 
 /* This will break when the xtime seconds get inaccurate, but that is
  * unlikely */
@@ -138,9 +138,9 @@ vtime(time_t *t)
 	return result;
 }
 
-#endif /* CONFIG_UNSAFE_VSYSCALLS */
+#endif /* CONFIG_COMPAT_VSYSCALLS */
 
-/* If CONFIG_UNSAFE_VSYSCALLS=y, then this is incorrect for vsyscall_nr == 1. */
+/* If CONFIG_COMPAT_VSYSCALLS=y, then this is incorrect for vsyscall_nr == 1. */
 static inline unsigned long vsyscall_intcc_addr(int vsyscall_nr)
 {
 	return VSYSCALL_START + 1024*vsyscall_nr + 2;
@@ -202,7 +202,7 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 		break;
 
 	case 1:
-#ifdef CONFIG_UNSAFE_VSYSCALLS
+#ifdef CONFIG_COMPAT_VSYSCALLS
 		warn_bad_vsyscall(KERN_WARNING, regs, "bogus time() vsyscall "
 				  "emulation (exploit attempt?)");
 		goto sigsegv;
diff --git a/arch/x86/kernel/vsyscall_emu_64.S b/arch/x86/kernel/vsyscall_emu_64.S
index 7ebde61..2d53e26 100644
--- a/arch/x86/kernel/vsyscall_emu_64.S
+++ b/arch/x86/kernel/vsyscall_emu_64.S
@@ -25,7 +25,7 @@ ENTRY(vsyscall_0)
 	ret
 END(vsyscall_0)
 
-#ifndef CONFIG_UNSAFE_VSYSCALLS
+#ifndef CONFIG_COMPAT_VSYSCALLS
 .section .vsyscall_1, "a"
 ENTRY(vsyscall_1)
 	movb $0xce, %al
