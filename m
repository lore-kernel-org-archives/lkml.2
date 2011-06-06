Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab1FFVst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:48:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55705 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757297Ab1FFVsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:48:47 -0400
Date: Mon, 6 Jun 2011 23:48:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: pageexec@freemail.hu, Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH v5 9/9] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to
 feature-removal-schedule
Message-ID: <20110606214823.GA11489@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <4DECAE68.16683.1203EBBB@pageexec.freemail.hu>
 <BANLkTin5jEmUUxWUUkYn9pKzGRwcA-zRLw@mail.gmail.com>
 <4DED206E.20356.13C155EA@pageexec.freemail.hu>
 <BANLkTi=choqfXPYmnivznYBbEFeg2UfbuA@mail.gmail.com>
 <20110606214545.GA6492@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606214545.GA6492@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> I was unsure how big of a problem the time() slowdown was and the 
> config option was easy enough to provide. My preference would be to 
> just remove the config option and simplify the code - complexity is 
> the #1 enemy of security.

The patch below is what the config removal brings us.

Thanks,

	Ingo

--
 Documentation/feature-removal-schedule.txt |   13 -------------
 arch/x86/Kconfig                           |   23 -----------------------
 arch/x86/kernel/vsyscall_64.c              |   26 --------------------------
 arch/x86/kernel/vsyscall_emu_64.S          |    2 --
 4 files changed, 0 insertions(+), 64 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 7a7446b..1a9446b 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -600,16 +600,3 @@ Why:	Superseded by the UVCIOC_CTRL_QUERY ioctl.
 Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 
 ----------------------------
-
-What:	CONFIG_LEGACY_VTIME (x86_64)
-When:	When glibc 2.14 or newer is ubiquitous.  Perhaps 2013.
-Why:	Having user-executable syscall invoking code at a fixed addresses makes
-	it easier for attackers to exploit security holes.  Turning off
-	CONFIG_LEGACY_VTIME reduces the risk without breaking binary
-	compatibility but will make the time() function slightly slower on
-	glibc versions 2.13 and below.
-
-	We may flip the default setting to N before 2013.
-Who:	Andy Lutomirski <luto@mit.edu>
-
-----------------------------
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6746d35..da34972 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1646,29 +1646,6 @@ config COMPAT_VDSO
 
 	  If unsure, say Y.
 
-config LEGACY_VTIME
-	def_bool y
-	prompt "Fast legacy sys_time() vsyscall"
-	depends on X86_64
-	---help---
-	  Glibc 2.13 and older, statically linked binaries, and a few
-	  other things use a legacy ABI to implement time().
-
-	  If you say N here, the kernel will emulate that interface in
-	  order to make certain types of userspace bugs more difficult
-	  to exploit.  This will cause some legacy software to run
-	  slightly more slowly.
-
-	  If you say Y here, then the kernel will provide native code to
-	  allow legacy programs to run without any performance impact.
-	  This could make it easier to exploit certain types of
-	  userspace bugs.
-
-	  If unsure, say Y.
-
-	  NOTE: disabling this option will not break any ABI; the kernel
-	        will be fully compatible with all binaries either way.
-
 config CMDLINE_BOOL
 	bool "Built-in kernel command line"
 	---help---
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index f56644e..41f6a98 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -102,30 +102,6 @@ static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
 	       regs->ip - 2, regs->sp, regs->ax, regs->si, regs->di);
 }
 
-#ifdef CONFIG_LEGACY_VTIME
-
-/* This will break when the xtime seconds get inaccurate, but that is
- * unlikely */
-time_t __attribute__ ((unused, __section__(".vsyscall_1"))) notrace
-vtime(time_t *t)
-{
-	unsigned seq;
-	time_t result;
-
-	do {
-		seq = read_seqbegin(&VVAR(vsyscall_gtod_data).lock);
-
-		result = VVAR(vsyscall_gtod_data).wall_time_sec;
-
-	} while (read_seqretry(&VVAR(vsyscall_gtod_data).lock, seq));
-
-	if (t)
-		*t = result;
-	return result;
-}
-
-#endif /* CONFIG_LEGACY_VTIME */
-
 void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 {
 	static DEFINE_RATELIMIT_STATE(rs, 3600 * HZ, 3);
@@ -169,12 +145,10 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 			(struct timezone __user *)regs->si);
 		break;
 
-#ifndef CONFIG_LEGACY_VTIME
 	case 1:
 		vsyscall_name = "time";
 		ret = sys_time((time_t __user *)regs->di);
 		break;
-#endif
 
 	case 2:
 		vsyscall_name = "getcpu";
diff --git a/arch/x86/kernel/vsyscall_emu_64.S b/arch/x86/kernel/vsyscall_emu_64.S
index b192283..bc10dba 100644
--- a/arch/x86/kernel/vsyscall_emu_64.S
+++ b/arch/x86/kernel/vsyscall_emu_64.S
@@ -14,12 +14,10 @@ ENTRY(vsyscall_0)
 	int $VSYSCALL_EMU_VECTOR
 END(vsyscall_0)
 
-#ifndef CONFIG_LEGACY_VTIME
 .section .vsyscall_1, "a"
 ENTRY(vsyscall_1)
 	int $VSYSCALL_EMU_VECTOR
 END(vsyscall_1)
-#endif
 
 .section .vsyscall_2, "a"
 ENTRY(vsyscall_2)
