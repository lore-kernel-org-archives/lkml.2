Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab2CHKhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 05:37:22 -0500
Received: from mtantr2.softathome.com ([82.138.70.70]:12694 "EHLO
	mtantr2.softathome.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab2CHKhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 05:37:20 -0500
X-Amavis-Modified: Mail body modified (using disclaimer) -
	mtantr2.softathome.com
X-Spam-Flag: NO
X-Spam-Score: -4.379
Date: Thu, 8 Mar 2012 11:37:10 +0100 (CET)
From: "Dmitry ADAMUSHKA (EXT)" <dmitry.adamushka_ext@softathome.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ralf Baechle <ralf@linux-mips.org>,
        wouter cloetens <wouter.cloetens@softathome.com>,
        linux-kernel@vger.kernel.org,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Message-ID: <1331646690.60780.1331203030720.JavaMail.root@storentr1.softathome.com>
In-Reply-To: <139779962.60750.1331202718116.JavaMail.root@storentr1.softathome.com>
Subject: Re: 'khelper' (child) is stuck in endless loop: do_signal() and
 !user_mode(regs)
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_60779_69822830.1331203030717"
X-Originating-IP: [192.168.64.166]
X-Mailer: Zimbra 6.0.6_GA_2330.UBUNTU8_64 (ZimbraWebClient - FF3.0 (Linux)/6.0.6_GA_2330.UBUNTU8_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_60779_69822830.1331203030717
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Oleg,

I'm able to reproduce this problem on x86 (32 bits) with the following patc=
hes that try to simulate the real-life situation (see the comments in the p=
atches).

It happens only when CONFIG_VM86 is disabled (I tried both). Supposedly, du=
e to the following bits of the VM86-specific code that let us break out of =
the endless-loop.

#ifdef CONFIG_VM86
#define resume_userspace_sig    check_userspace
#else
[...]

there is the specific are-we-a-kernel-task? check here

check_userspace:
        movl PT_EFLAGS(%esp), %eax      # mix EFLAGS and CS
        movb PT_CS(%esp), %al
        andl $(X86_EFLAGS_VM | SEGMENT_RPL_MASK), %eax
        cmpl $USER_RPL, %eax
        jb resume_kernel                # not returning to v8086 or userspa=
ce

ENTRY(resume_userspace)
        LOCKDEP_SYS_EXIT
[...]
        jne work_pending
        jmp restore_all

which is available neither in case of !CONFIG_VM86, nor in case of MIPS. He=
nce, the loop.

So here are the patches to simulate the problem. Is this approach not valid=
 for one or another reason?

Thanks in advance.


=3D=3D=3D copy-pasted =3D=3D=3D

--- kernel/kmod.c.orig  2012-03-08 10:26:05.504752023 +0100
+++ kernel/kmod.c       2012-03-08 11:25:05.028661835 +0100
@@ -154,6 +154,15 @@ static int ____call_usermodehelper(void
        /* We can run anywhere, unlike our parent keventd(). */
        set_cpus_allowed_ptr(current, cpu_all_mask);

+       printk(KERN_EMERG "Unleash the signal...\n");
+
+       /*
+        * (1) here we emulate receiving a signal.
+        *     In the original case, a signal should be delivered from outs=
ide,
+        *     say, by "kill(-1, SIGKILL)" in busybox.
+        */
+       send_sig(SIGUSR1, current, 0);
+
        /*
         * Our parent is keventd, which runs with elevated scheduling prior=
ity.
         * Avoid propagating that into the userspace child.
@@ -181,6 +190,19 @@ static int ____call_usermodehelper(void

        commit_creds(new);

+       /* (2) here we emulate the failure of kernel_execve().
+        *     In real life, the failure can be due to a memory shortage,
+        *     or something else.
+         *     In our case, it happens when a board reboots - same as (1) =
above.
+        */
+       retval =3D kernel_execve(NULL,
+                              (const char *const *)sub_info->argv,
+                              (const char *const *)sub_info->envp);
+
+       printk(KERN_EMERG "x86 is rock-solid!");
+       flush_signals(current);
+
+       /* If we survived the test, let's continue so the user should not n=
otice. */
        retval =3D kernel_execve(sub_info->path,
                               (const char *const *)sub_info->argv,
                               (const char *const *)sub_info->envp);

and another one

--- arch/x86/kernel/signal.c.orig       2012-03-08 11:18:19.702651943 +0100
+++ arch/x86/kernel/signal.c    2012-03-08 10:31:18.682304346 +0100
@@ -765,8 +765,11 @@ static void do_signal(struct pt_regs *re
         * X86_32: vm86 regs switched out by assembly code before reaching
         * here, so testing against kernel CS suffices.
         */
-       if (!user_mode(regs))
+       if (!user_mode(regs)) {
+               printk(KERN_EMERG "* endless loop\n");
+               dump_stack();
                return;
+       }

        signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
        if (signr > 0) {




----- Original Message -----
> From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
> To: "Oleg Nesterov" <oleg@redhat.com>
> Cc: "Dmitry ADAMUSHKA (EXT)" <dmitry.adamushka_ext@softathome.com>, "Ingo=
 Molnar" <mingo@elte.hu>, "Ralf Baechle"
> <ralf@linux-mips.org>, "wouter cloetens" <wouter.cloetens@softathome.com>=
, linux-kernel@vger.kernel.org
> Sent: Wednesday, March 7, 2012 9:05:43 PM
> Subject: Re: 'khelper' (child) is stuck in endless loop: do_signal() and =
!user_mode(regs)

> Hi Oleg,
>=20
> > On 03/07, Dmitry ADAMUSHKA (EXT) wrote:
> >>
> >> Now, the assumptions (the question is whether these are true for
> >> the recent kernels):
> >>
> >> 1) TIF_SIGPENDING can be set for 'khelper' while it's running in
> >> ____call_usermodehelper()
> >> =C2=A0 =C2=A0between (a) flush_signal_handlers() and (b) kernel_execve=
() =3D>
> >> =C2=A0 =C2=A0so TIF_SIGPENDING is set;
> >
> > Yes, but it is not khelper. It is another kernel thread. Yes, its
> > ->comm[] was copied from parent, so ps/etc can show it as khelper.
>=20
> Sure, that's why I indicated 'khelper' (child).
>=20
> >
> >> 2) kernel_execve() can fail in ____call_usermodehelper().
> >>
> >> The later one is less of an assumption; let's say, it fails due to
> >> a shortage of memory (or whatever).
> >>
> >> If (1) is true, then
> >>
> >> the pre-conditions:
> >>
> >> - a kernel space task;
> >>
> >> 'khelper' running ____call_usermodehelper() in our case.
> >>
> >> - TIF_SIGPENDING is set.
> >>
> >> A signal has been delivered, say, as a result of kill(-1, SIGKILL).
> >>
> >> The endless loop is as follows:
> >>
> >> * syscall_exit_work:
> >> =C2=A0- work_pending: // start_of_the_loop
> >
> > We shouldn't be here. This is the kernel thread.
>=20
> Note that kernel_execve() is backed up by a full fledged syscall (not
> just a function call, at least on MIPS and x86), so I assume that all
> the usual syscall-related stuff applies here as well.
>=20
> >
> > And if start_thread() was already called, then
> >
> >> =C2=A0- work_notify_sig:
> >> =C2=A0 =C2=A0- do_notify_resume()
> >> =C2=A0 =C2=A0 =C2=A0- do_signal() =3D=3D> if (!user_mode(regs)) return=
; so signals are
> >> =C2=A0 =C2=A0 =C2=A0not handled
> >
> > user_mode() is no longer true.
>=20
> !user_mode() is true. Note, the failure of kernel_execve() is one of
> the pre-conditions. So we have a kernel thread returning from a real
> syscall (hence, syscall_exit and co) with TIF_SIGPENDING.
>=20
> >
> > Once again, I can be wrong, I'll read this email tomorrow.
> >
>=20
> Great, thanks!
>=20
>=20
> -- Dmitry

This message and any attachments herein are confidential, intended solely for the addressees and are SoftAtHome's ownership. Any unauthorized use or dissemination is prohibited. If you are not the intended addressee of this message, please cancel it immediately and inform the sender.

------=_Part_60779_69822830.1331203030717
Content-Type: text/x-patch; name=kmod.c.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=kmod.c.diff

--- kernel/kmod.c.orig	2012-03-08 10:26:05.504752023 +0100
+++ kernel/kmod.c	2012-03-08 11:25:05.028661835 +0100
@@ -154,6 +154,15 @@ static int ____call_usermodehelper(void
 	/* We can run anywhere, unlike our parent keventd(). */
 	set_cpus_allowed_ptr(current, cpu_all_mask);
 
+	printk(KERN_EMERG "Unleash the signal...\n");
+
+	/*
+ 	 * (1) here we emulate receiving a signal.
+	 *     In the original case, a signal should be delivered from outside,
+	 *     say, by "kill(-1, SIGKILL)" in busybox.
+	 */
+	send_sig(SIGUSR1, current, 0);
+
 	/*
 	 * Our parent is keventd, which runs with elevated scheduling priority.
 	 * Avoid propagating that into the userspace child.
@@ -181,6 +190,19 @@ static int ____call_usermodehelper(void
 
 	commit_creds(new);
 
+	/* (2) here we emulate the failure of kernel_execve().
+	 *     In real life, the failure can be due to a memory shortage,
+	 *     or something else.
+         *     In our case, it happens when a board reboots - same as (1) above.
+	 */
+	retval = kernel_execve(NULL,
+			       (const char *const *)sub_info->argv,
+			       (const char *const *)sub_info->envp);
+
+	printk(KERN_EMERG "x86 is rock-solid!");
+	flush_signals(current);
+
+	/* If we survived the test, let's continue so the user should not notice. */
 	retval = kernel_execve(sub_info->path,
 			       (const char *const *)sub_info->argv,
 			       (const char *const *)sub_info->envp);

------=_Part_60779_69822830.1331203030717
Content-Type: text/x-patch; name=x86-signal.c.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=x86-signal.c.diff

--- arch/x86/kernel/signal.c.orig	2012-03-08 11:18:19.702651943 +0100
+++ arch/x86/kernel/signal.c	2012-03-08 10:31:18.682304346 +0100
@@ -765,8 +765,11 @@ static void do_signal(struct pt_regs *re
 	 * X86_32: vm86 regs switched out by assembly code before reaching
 	 * here, so testing against kernel CS suffices.
 	 */
-	if (!user_mode(regs))
+	if (!user_mode(regs)) {
+		printk(KERN_EMERG "* endless loop\n");
+		dump_stack();
 		return;
+	}
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 	if (signr > 0) {

------=_Part_60779_69822830.1331203030717--
