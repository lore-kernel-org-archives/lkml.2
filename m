Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab1EQSbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 14:31:40 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:60509 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756077Ab1EQSbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 14:31:36 -0400
X-AuditID: 12074425-b7b78ae000007e02-de-4dd2bf09dec8
Message-ID: <4DD2BEFB.6070609@mit.edu>
Date: Tue, 17 May 2011 14:31:23 -0400
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH v4 0/6] Micro-optimize vclock_gettime
References: <20110516160943.GC25898@one.firstfloor.org> <alpine.LFD.2.02.1105161817120.3078@ionos> <20110516164939.GD25898@one.firstfloor.org> <BANLkTintkmnkN3kW06oa+TjT7W0Q1yQQGA@mail.gmail.com> <m2fwoeo0pf.fsf@firstfloor.org> <alpine.LFD.2.02.1105162345110.3078@ionos> <BANLkTinVnr1ZM2wOxuH-rHZGh+_SBWT-+g@mail.gmail.com> <alpine.LFD.2.02.1105170022430.3078@ionos> <20110517080029.GB22093@elte.hu> <BANLkTimpEfb3P9FWgrCDwSSVr6RA8nXb5w@mail.gmail.com> <20110517113634.GC13475@elte.hu>
In-Reply-To: <20110517113634.GC13475@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsUixG6nrsu5/5Kvwd/PKhYX2y6yWRy59p3d
	4mLjNhaLOedbWCz2vT/LZnF51xw2iy2XmlktNm+aymzxqO8tu8WPDY9ZHbg8uh99YvS48pTD
	Y8vKm0wet9r+MHvM3/mR0WPnrLvsHptWdbJ5vDt3jt3jxIzfLB6fN8kFcEVx2aSk5mSWpRbp
	2yVwZTx/LF1wQLHi8NaH7A2MX6W6GDk5JARMJP5veM4EYYtJXLi3nq2LkYtDSGAfo8T6pYcY
	IZwNjBL/vi+Aylxgkpi5dDsrSAuvgJrEr7nzWUBsFgFViR9zzzKD2GwCKhIdSx+AjRUVqJR4
	t2YLO0S9oMTJmU/A6kUE5CX2HPvCCjKUWeA7k8Sb01fAEsIClhKPmzYzgthCAk+ZJXadAVvG
	KaArcX3jRbChzAI6Eu/6HjBD2PIS29/OYZ7AKDgLyY5ZSMpmISlbwMi8ilE2JbdKNzcxM6c4
	NVm3ODkxLy+1SNdCLzezRC81pXQTIzi+XFR3ME44pHSIUYCDUYmHt7z3kq8Qa2JZcWXuIUZJ
	DiYlUd7UvUAhvqT8lMqMxOKM+KLSnNTiQ4wSHMxKIrwtSy/6CvGmJFZWpRblw6SkOViUxHnn
	S6r7CgmkJ5akZqemFqQWwWRlODiUJHij9gENFSxKTU+tSMvMKUFIM3FwggznARo+HWQxb3FB
	Ym5xZjpE/hSjopQ4bzBIswBIIqM0D64Xlv5eMYoDvSLMWwtSxQNMnXDdr4AGMwENXnXqAsjg
	kkSElFQDo2z3ncx1y86/eyawuvjUY+XpsirbM6pY1+1v8fswnf/nm3nXQt736iqIrFi7VfNw
	VrfgCS9+j3DukLzay21f3taEXLVh5tmwvEX7/EnH808Xa0sqTJigfr+rxE6pqT9blKmH8fJV
	vS4jg6hoF3aT3xzZeVue+OZLqywWX9D8asPjik+8M94pKbEUZyQaajEXFScCACvk+rZaAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2011 07:36 AM, Ingo Molnar wrote:
> 
> * Andrew Lutomirski<luto@mit.edu>  wrote:
> 
>>> Well, how does that differ from having the real syscall instruction there?
>>> How are we going to filter real (old-)glibc calls from exploits?
>>
>> Because there are only four vsyscalls: vgettimeofday, vtime, vgetcpu, and
>> venosys.  None of them have side-effects, so they only allow an attacker to
>> write something to user memory somewhere.  The implementation of
>> vgettimeofday needs a syscall instruction internally for its fallback, which
>> means that an attack could jump there instead of to the start of the vsyscall
>> implementation.
> 
> So for this to work securely the emulation code would also have to filter the
> syscall numbers, to make sure that only these benign syscalls are used.
> 
> It should perhaps also warn if it notices something weird going on.

It's even easier than that: there are no syscall numbers involved.  There are four separate entry points, one for each vsyscall.

(It turns out that one of them has been broken and just segfaults since 2008 (a4928cff), so we only have to emulate three of them.)

On KVM on Sandy Bridge, I can emulate a vsyscall that does nothing in 400ns or so.  I'll try to make this code emulate real vsyscalls over the weekend.  This was much easier than I expected.

diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsyscall.h
index d0983d2..52b4b49 100644
--- a/arch/x86/include/asm/vsyscall.h
+++ b/arch/x86/include/asm/vsyscall.h
@@ -39,6 +39,14 @@ extern struct timezone sys_tz;
 
 extern void map_vsyscall(void);
 
+/* Emulation */
+static inline bool is_vsyscall_addr(unsigned long addr)
+{
+	return (addr & ~(3*VSYSCALL_SIZE)) == VSYSCALL_START + 4096; /* intentionally incorrect for testing */
+}
+
+void emulate_vsyscall(struct pt_regs *regs);
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_VSYSCALL_H */
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index dcbb28c..83590e8 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -32,6 +32,8 @@
 #include <linux/cpu.h>
 #include <linux/smp.h>
 #include <linux/notifier.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
 
 #include <asm/vsyscall.h>
 #include <asm/pgtable.h>
@@ -233,6 +235,41 @@ static long __vsyscall(3) venosys_1(void)
 	return -ENOSYS;
 }
 
+void emulate_vsyscall(struct pt_regs *regs)
+{
+	long ret = 0;
+	unsigned long called_from;
+
+	unsigned vsyscall_no = (regs->ip >> 10) & 3;
+	BUILD_BUG_ON(VSYSCALL_SIZE != (1<<10));
+
+	/* pop called_from */
+	ret = get_user(called_from, (unsigned long __user *)regs->sp);
+	if (ret)
+		goto fault;
+	regs->sp += 8;
+
+	switch(vsyscall_no) {
+	case 0:		/* vgettimeofday */
+	case 1:		/* vtime */
+	case 2:		/* vgetcpu */
+		ret = -EINVAL;
+		goto out;
+
+	case 3:		/* venosys */
+		ret = -ENOSYS;
+		goto out;
+	}
+
+out:
+	regs->ip = called_from;
+	regs->ax = ret;
+	return;
+
+fault:
+	force_sig(SIGKILL, current);  /* XXX */
+}
+
 #ifdef CONFIG_SYSCTL
 static ctl_table kernel_table2[] = {
 	{ .procname = "vsyscall64",
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 20e3f87..c84df6f 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -16,6 +16,7 @@
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
 #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
 #include <asm/kmemcheck.h>		/* kmemcheck_*(), ...		*/
+#include <asm/vsyscall.h>		/* vsyscall emulation		*/
 
 /*
  * Page fault error code bits:
@@ -719,6 +720,16 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
 		if (is_errata100(regs, address))
 			return;
 
+		/*
+		 * Calling certain addresses has historical semantics that
+		 * we need to emulate.
+		 */
+		if (is_vsyscall_addr(regs->ip) && regs->ip == address &&
+		    (error_code & (PF_WRITE | PF_INSTR)) == PF_INSTR) {
+			emulate_vsyscall(regs);
+			return;
+		}
+
 		if (unlikely(show_unhandled_signals))
 			show_signal_msg(regs, error_code, address, tsk);
 



I don't expect to have this ready for 2.6.40.  What's the status of the RDTSC stuff -- do you want to pick it up for the 2.6.40 merge window?

--Andy
