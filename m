Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab2CHPNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 10:13:10 -0500
Received: from mtantr2.softathome.com ([82.138.70.70]:13515 "EHLO
	mtantr2.softathome.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab2CHPNH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 10:13:07 -0500
X-Amavis-Modified: Mail body modified (using disclaimer) -
	mtantr2.softathome.com
X-Spam-Flag: NO
X-Spam-Score: -4.379
Date: Thu, 8 Mar 2012 16:12:46 +0100 (CET)
From: "Dmitry ADAMUSHKA (EXT)" <dmitry.adamushka_ext@softathome.com>
To: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        wouter cloetens <wouter.cloetens@softathome.com>,
        linux-kernel@vger.kernel.org,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Message-ID: <1587824623.61690.1331219566458.JavaMail.root@storentr1.softathome.com>
In-Reply-To: <CAO6Zf6C+SDZ-TV12wr9oiO6HB-itQ6fLPHFugXk0osEiAxW22w@mail.gmail.com>
Subject: Re: 'khelper' (child) is stuck in endless loop: do_signal() and
 !user_mode(regs)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.64.166]
X-Mailer: Zimbra 6.0.6_GA_2330.UBUNTU8_64 (ZimbraWebClient - FF3.0 (Linux)/6.0.6_GA_2330.UBUNTU8_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following quick hack "fixes" it for x86. The output is below (contrary to the endless "* endless loop" messages seen before) [1].

--- arch/x86/kernel/entry_32.S.orig     2012-03-08 15:42:25.041296595 +0100
+++ arch/x86/kernel/entry_32.S  2012-03-08 15:58:29.926081131 +0100
@@ -98,12 +98,6 @@
 #endif
 .endm

-#ifdef CONFIG_VM86
-#define resume_userspace_sig   check_userspace
-#else
-#define resume_userspace_sig   resume_userspace
-#endif
-
 /*
  * User gs save/restore
  *
@@ -327,10 +321,19 @@ ret_from_exception:
        preempt_stop(CLBR_ANY)
 ret_from_intr:
        GET_THREAD_INFO(%ebp)
-check_userspace:
+resume_userspace_sig:
+#ifdef CONFIG_VM86
        movl PT_EFLAGS(%esp), %eax      # mix EFLAGS and CS
        movb PT_CS(%esp), %al
        andl $(X86_EFLAGS_VM | SEGMENT_RPL_MASK), %eax
+#else
+/*
+ * We can be coming here from a syscall done in the kernel space,
+ * e.g. a failed kernel_execve().
+ */
+       movl PT_CS(%esp), %eax
+       andl $SEGMENT_RPL_MASK, %eax
+#endif
        cmpl $USER_RPL, %eax
        jb resume_kernel                # not returning to v8086 or userspace

[1]

[...]
[   10.220496] input: HDA Intel Line-Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   10.448021] Unleash the signal...
[   10.448028] * endless loop
[   10.448030] Pid: 906, comm: kworker/u:6 Not tainted 3.3.0-rc4-crush-custom #4
[   10.448032] Call Trace:
[   10.448038]  [<c151cfe4>] ? printk+0x30/0x34
[   10.448042]  [<c1002abf>] do_signal+0x7ff/0x890
[   10.448045]  [<c151f6ed>] ? _raw_spin_trylock+0xd/0x20
[   10.448048]  [<c1324da8>] ? vt_console_print+0x288/0x360
[   10.448052]  [<c10264c8>] ? default_spin_lock_flags+0x8/0x10
[   10.448054]  [<c1522a90>] ? spurious_fault+0xd0/0xd0
[   10.448057]  [<c1520183>] ? error_code+0x67/0x6c
[   10.448060]  [<c111007b>] ? read_swap_cache_async+0x7b/0xf0
[   10.448063]  [<c1133c3d>] ? getname_flags+0x5d/0x160
[   10.448065]  [<c1133c3d>] ? getname_flags+0x5d/0x160
[   10.448067]  [<c1133d51>] ? getname+0x11/0x20
[   10.448069]  [<c1002dc5>] do_notify_resume+0x65/0x80
[   10.448071]  [<c151fbb7>] work_notifysig+0x16/0x1b
[   10.448074]  [<c10b00d8>] ? unmask_irq+0x8/0x30
[   10.448076]  [<c1006661>] ? kernel_execve+0x21/0x30
[   10.448080]  [<c1048f20>] ? ____call_usermodehelper+0x100/0x130
[   10.448082]  [<c1048e20>] ? proc_cap_handler+0x180/0x180
[   10.448085]  [<c1526b3e>] ? kernel_thread_helper+0x6/0x10
[   10.448086] x86 is rock-solid!
[   10.448842] ppdev: user-space parallel port driver
[...]


----- Original Message -----
> From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
> To: "Oleg Nesterov" <oleg@redhat.com>
> Cc: "Ingo Molnar" <mingo@elte.hu>, "Ralf Baechle" <ralf@linux-mips.org>, "wouter cloetens"
> <wouter.cloetens@softathome.com>, linux-kernel@vger.kernel.org, "Dmitry ADAMUSHKA (EXT)"
> <dmitry.adamushka_ext@softathome.com>
> Sent: Thursday, March 8, 2012 11:46:41 AM
> Subject: Re: 'khelper' (child) is stuck in endless loop: do_signal() and !user_mode(regs)

> See the enclosed picture.
> 
> For some reason, I can only see the "* endless loop" messages
> (KERN_EMERG) on my terminal. Perhaps, it's due to the setting of
> syslog (or whatever is used here) for this terminal (the primary
> graphical one is just stuck).
> 
> 
> On 8 March 2012 11:37, Dmitry ADAMUSHKA (EXT)
> <dmitry.adamushka_ext@softathome.com> wrote:
> >
> > Oleg,
> >
> > I'm able to reproduce this problem on x86 (32 bits) with the
> > following patches that try to simulate the real-life situation (see
> > the comments in the patches).
> >
> > It happens only when CONFIG_VM86 is disabled (I tried both).
> > Supposedly, due to the following bits of the VM86-specific code that
> > let us break out of the endless-loop.
> >
> > #ifdef CONFIG_VM86
> > #define resume_userspace_sig check_userspace
> > #else [...]
> >
> > there is the specific are-we-a-kernel-task? check here
> >
> > check_userspace:
> >        movl PT_EFLAGS(%esp), %eax # mix EFLAGS and CS
> >        movb PT_CS(%esp), %al
> >        andl $(X86_EFLAGS_VM | SEGMENT_RPL_MASK), %eax
> >        cmpl $USER_RPL, %eax
> >        jb resume_kernel # not returning to v8086 or userspace
> >
> > ENTRY(resume_userspace)
> >        LOCKDEP_SYS_EXIT
> > [...]
> >        jne work_pending
> >        jmp restore_all
> >
> > which is available neither in case of !CONFIG_VM86, nor in case of
> > MIPS. Hence, the loop.
> >
> > So here are the patches to simulate the problem. Is this approach
> > not valid for one or another reason?
> >
> > Thanks in advance.
> >
> >
> > === copy-pasted ===
> >
> > --- kernel/kmod.c.orig 2012-03-08 10:26:05.504752023 +0100
> > +++ kernel/kmod.c 2012-03-08 11:25:05.028661835 +0100
> > @@ -154,6 +154,15 @@ static int ____call_usermodehelper(void
> >        /* We can run anywhere, unlike our parent keventd(). */
> >        set_cpus_allowed_ptr(current, cpu_all_mask);
> >
> > + printk(KERN_EMERG "Unleash the signal...\n");
> > + + /*
> > + * (1) here we emulate receiving a signal.
> > + * In the original case, a signal should be delivered from outside,
> > + * say, by "kill(-1, SIGKILL)" in busybox.
> > + */
> > + send_sig(SIGUSR1, current, 0);
> > +
> >        /*
> >         * Our parent is keventd, which runs with elevated scheduling
> >         priority. * Avoid propagating that into the userspace child.
> > @@ -181,6 +190,19 @@ static int ____call_usermodehelper(void
> >
> >        commit_creds(new);
> >
> > + /* (2) here we emulate the failure of kernel_execve().
> > + * In real life, the failure can be due to a memory shortage,
> > + * or something else.
> > + * In our case, it happens when a board reboots - same as (1)
> > above. + */
> > + retval = kernel_execve(NULL,
> > + (const char *const *)sub_info->argv,
> > + (const char *const *)sub_info->envp);
> > + + printk(KERN_EMERG "x86 is rock-solid!");
> > + flush_signals(current);
> > + + /* If we survived the test, let's continue so the user should
> > not notice. */
> >        retval = kernel_execve(sub_info->path,
> >                               (const char *const *)sub_info->argv,
> >                               (const char *const *)sub_info->envp);
> >
> > and another one
> >
> > --- arch/x86/kernel/signal.c.orig 2012-03-08 11:18:19.702651943
> > +0100 +++ arch/x86/kernel/signal.c 2012-03-08 10:31:18.682304346
> > +0100 @@ -765,8 +765,11 @@ static void do_signal(struct pt_regs *re
> >         * X86_32: vm86 regs switched out by assembly code before
> >         reaching * here, so testing against kernel CS suffices.
> >         */
> > - if (!user_mode(regs))
> > + if (!user_mode(regs)) {
> > + printk(KERN_EMERG "* endless loop\n");
> > + dump_stack();
> >                return;
> > + }
> >
> >        signr = get_signal_to_deliver(&info, &ka, regs, NULL);
> >        if (signr > 0) {
> >
> >
> >
> >
> > ----- Original Message -----
> >> From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
> >> To: "Oleg Nesterov" <oleg@redhat.com>
> >> Cc: "Dmitry ADAMUSHKA (EXT)" <dmitry.adamushka_ext@softathome.com>,
> >> "Ingo Molnar" <mingo@elte.hu>, "Ralf Baechle"
> >> <ralf@linux-mips.org>, "wouter cloetens"
> >> <wouter.cloetens@softathome.com>, linux-kernel@vger.kernel.org
> >> Sent: Wednesday, March 7, 2012 9:05:43 PM
> >> Subject: Re: 'khelper' (child) is stuck in endless loop:
> >> do_signal() and !user_mode(regs)
> >
> >> Hi Oleg,
> >>
> >> > On 03/07, Dmitry ADAMUSHKA (EXT) wrote:
> >> >>
> >> >> Now, the assumptions (the question is whether these are true for
> >> >> the recent kernels):
> >> >>
> >> >> 1) TIF_SIGPENDING can be set for 'khelper' while it's running in
> >> >> ____call_usermodehelper()
> >> >>    between (a) flush_signal_handlers() and (b) kernel_execve()
> >> >>    => so TIF_SIGPENDING is set;
> >> >
> >> > Yes, but it is not khelper. It is another kernel thread. Yes, its
> >> > ->comm[] was copied from parent, so ps/etc can show it as
> >> > khelper.
> >>
> >> Sure, that's why I indicated 'khelper' (child).
> >>
> >> >
> >> >> 2) kernel_execve() can fail in ____call_usermodehelper().
> >> >>
> >> >> The later one is less of an assumption; let's say, it fails due
> >> >> to a shortage of memory (or whatever).
> >> >>
> >> >> If (1) is true, then
> >> >>
> >> >> the pre-conditions:
> >> >>
> >> >> - a kernel space task;
> >> >>
> >> >> 'khelper' running ____call_usermodehelper() in our case.
> >> >>
> >> >> - TIF_SIGPENDING is set.
> >> >>
> >> >> A signal has been delivered, say, as a result of kill(-1,
> >> >> SIGKILL).
> >> >>
> >> >> The endless loop is as follows:
> >> >>
> >> >> * syscall_exit_work:
> >> >>  - work_pending: // start_of_the_loop
> >> >
> >> > We shouldn't be here. This is the kernel thread.
> >>
> >> Note that kernel_execve() is backed up by a full fledged syscall
> >> (not just a function call, at least on MIPS and x86), so I assume
> >> that all
> >> the usual syscall-related stuff applies here as well.
> >>
> >> >
> >> > And if start_thread() was already called, then
> >> >
> >> >>  - work_notify_sig:
> >> >>    - do_notify_resume()
> >> >>      - do_signal() ==> if (!user_mode(regs)) return; so signals
> >> >>      are not handled
> >> >
> >> > user_mode() is no longer true.
> >>
> >> !user_mode() is true. Note, the failure of kernel_execve() is one
> >> of the pre-conditions. So we have a kernel thread returning from a
> >> real syscall (hence, syscall_exit and co) with TIF_SIGPENDING.
> >>
> >> >
> >> > Once again, I can be wrong, I'll read this email tomorrow.
> >> >
> >>
> >> Great, thanks!
> >>
> >>
> >> -- Dmitry
> >
> > This message and any attachments herein are confidential, intended
> > solely for the addressees and are SoftAtHome's ownership. Any
> > unauthorized use or dissemination is prohibited. If you are not the
> > intended addressee of this message, please cancel it immediately and
> > inform the sender.
> 
> 
> 
> --
> 
> -- Dmitry
This message and any attachments herein are confidential, intended solely for the addressees and are SoftAtHome's ownership. Any unauthorized use or dissemination is prohibited. If you are not the intended addressee of this message, please cancel it immediately and inform the sender.
