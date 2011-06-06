Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab1FFVlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:41:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:55154 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756226Ab1FFVlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:41:35 -0400
Date: Mon, 6 Jun 2011 21:41:01 GMT
From: tip-bot for Andy Lutomirski <luto@mit.edu>
Message-ID: <tip-feba7e97df8c463331071b79fba2164ead6aa14b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        luto@mit.edu, torvalds@linux-foundation.org, mikpe@it.uu.se,
        tglx@linutronix.de, mingo@elte.hu, luto@mit.edu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@mit.edu, torvalds@linux-foundation.org, mikpe@it.uu.se,
        tglx@linutronix.de, mingo@elte.hu, luto@mit.edu
In-Reply-To: <4ad5860f9c9c79ecd303f345cf9c06f8859c44d4.1307380481.git.luto@mit.edu>
References: <4ad5860f9c9c79ecd303f345cf9c06f8859c44d4.1307380481.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64: Rename COMPAT_VSYSCALLS to LEGACY_VTIME and clarify documentation
Git-Commit-ID: feba7e97df8c463331071b79fba2164ead6aa14b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Jun 2011 21:41:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  feba7e97df8c463331071b79fba2164ead6aa14b
Gitweb:     http://git.kernel.org/tip/feba7e97df8c463331071b79fba2164ead6aa14b
Author:     Andy Lutomirski <luto@MIT.EDU>
AuthorDate: Mon, 6 Jun 2011 13:27:25 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 6 Jun 2011 19:49:31 +0200

x86-64: Rename COMPAT_VSYSCALLS to LEGACY_VTIME and clarify documentation

Rename COMPAT_VSYSCALLS to LEGACY_VTIME to make sure
it's not confused with the 32-bit compat facilities we
have on x86-64.

Also, in the discussions enough people were confused about
whether LEGACY_VTIME=n breaks binary compatibility that
we should make it harder to be confused.  So make it more
clear what's going on.

[ The new text is slightly inaccurate in that LEGACY_VTIME
  could make it slightly harder to exploit *kernel* bugs once the
  kernel address layout is randomized, but me mentioning that in
  the help text might just cause more confusion. ]

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Cc: pageexec@freemail.hu
Cc: Mikael Pettersson <mikpe@it.uu.se>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/4ad5860f9c9c79ecd303f345cf9c06f8859c44d4.1307380481.git.luto@mit.edu
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/feature-removal-schedule.txt |   13 +++++++----
 arch/x86/Kconfig                           |   29 +++++++++++++++------------
 arch/x86/kernel/vsyscall_64.c              |    6 ++--
 arch/x86/kernel/vsyscall_emu_64.S          |    2 +-
 4 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 4282ab2..7a7446b 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -601,12 +601,15 @@ Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 
 ----------------------------
 
-What:	CONFIG_COMPAT_VSYSCALLS (x86_64)
-When:	When glibc 2.14 or newer is ubitquitous.  Perhaps mid-2012.
+What:	CONFIG_LEGACY_VTIME (x86_64)
+When:	When glibc 2.14 or newer is ubiquitous.  Perhaps 2013.
 Why:	Having user-executable syscall invoking code at a fixed addresses makes
-	it easier for attackers to exploit security holes.
-	Turning off CONFIG_COMPAT_VSYSCALLS mostly removes the risk but will
-	make the time() function slower on glibc versions 2.13 and below.
+	it easier for attackers to exploit security holes.  Turning off
+	CONFIG_LEGACY_VTIME reduces the risk without breaking binary
+	compatibility but will make the time() function slightly slower on
+	glibc versions 2.13 and below.
+
+	We may flip the default setting to N before 2013.
 Who:	Andy Lutomirski <luto@mit.edu>
 
 ----------------------------
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 30041d8..6746d35 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1646,26 +1646,29 @@ config COMPAT_VDSO
 
 	  If unsure, say Y.
 
-config COMPAT_VSYSCALLS
+config LEGACY_VTIME
 	def_bool y
-	prompt "Fixed address legacy vsyscalls"
+	prompt "Fast legacy sys_time() vsyscall"
 	depends on X86_64
 	---help---
-	  Legacy user code expects to be able to issue three syscalls
-	  by calling a fixed addresses.  If you say N, then the kernel
-	  traps and emulates these calls.  If you say Y, then there is
-	  actual executable code at a fixed address to implement time()
-	  efficiently.
+	  Glibc 2.13 and older, statically linked binaries, and a few
+	  other things use a legacy ABI to implement time().
 
-	  On a system with recent enough glibc (probably 2.14 or
-	  newer) and no static binaries, you can say N without a
-	  performance penalty to improve security: having no fixed
-	  address userspace-executable syscall invoking code makes
-	  it harder for both remote and local attackers to exploit
-	  security holes.
+	  If you say N here, the kernel will emulate that interface in
+	  order to make certain types of userspace bugs more difficult
+	  to exploit.  This will cause some legacy software to run
+	  slightly more slowly.
+
+	  If you say Y here, then the kernel will provide native code to
+	  allow legacy programs to run without any performance impact.
+	  This could make it easier to exploit certain types of
+	  userspace bugs.
 
 	  If unsure, say Y.
 
+	  NOTE: disabling this option will not break any ABI; the kernel
+	        will be fully compatible with all binaries either way.
+
 config CMDLINE_BOOL
 	bool "Built-in kernel command line"
 	---help---
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 04540f7..f56644e 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -102,7 +102,7 @@ static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
 	       regs->ip - 2, regs->sp, regs->ax, regs->si, regs->di);
 }
 
-#ifdef CONFIG_COMPAT_VSYSCALLS
+#ifdef CONFIG_LEGACY_VTIME
 
 /* This will break when the xtime seconds get inaccurate, but that is
  * unlikely */
@@ -124,7 +124,7 @@ vtime(time_t *t)
 	return result;
 }
 
-#endif /* CONFIG_COMPAT_VSYSCALLS */
+#endif /* CONFIG_LEGACY_VTIME */
 
 void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 {
@@ -169,7 +169,7 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 			(struct timezone __user *)regs->si);
 		break;
 
-#ifndef CONFIG_COMPAT_VSYSCALLS
+#ifndef CONFIG_LEGACY_VTIME
 	case 1:
 		vsyscall_name = "time";
 		ret = sys_time((time_t __user *)regs->di);
diff --git a/arch/x86/kernel/vsyscall_emu_64.S b/arch/x86/kernel/vsyscall_emu_64.S
index 5658d42..b192283 100644
--- a/arch/x86/kernel/vsyscall_emu_64.S
+++ b/arch/x86/kernel/vsyscall_emu_64.S
@@ -14,7 +14,7 @@ ENTRY(vsyscall_0)
 	int $VSYSCALL_EMU_VECTOR
 END(vsyscall_0)
 
-#ifndef CONFIG_COMPAT_VSYSCALLS
+#ifndef CONFIG_LEGACY_VTIME
 .section .vsyscall_1, "a"
 ENTRY(vsyscall_1)
 	int $VSYSCALL_EMU_VECTOR
