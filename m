Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab2CLQfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:35:50 -0400
Received: from mtantr2.softathome.com ([82.138.70.70]:20854 "EHLO
	mtantr2.softathome.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab2CLQfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:35:44 -0400
X-Amavis-Modified: Mail body modified (using disclaimer) -
	mtantr2.softathome.com
X-Spam-Flag: NO
X-Spam-Score: -4.379
Date: Mon, 12 Mar 2012 17:35:38 +0100 (CET)
From: "Dmitry ADAMUSHKA (EXT)" <dmitry.adamushka_ext@softathome.com>
To: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>
Message-ID: <1486047996.69314.1331570138102.JavaMail.root@storentr1.softathome.com>
In-Reply-To: <522171377.62242.1331225909662.JavaMail.root@storentr1.softathome.com>
Subject: Re: 'khelper' (child) is stuck in endless loop: do_signal() and
	!user_mode(regs)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.64.166]
X-Mailer: Zimbra 6.0.6_GA_2330.UBUNTU8_64 (ZimbraWebClient - FF3.0 (Linux)/6.0.6_GA_2330.UBUNTU8_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


just wondering, whether this problem/scenario considered to be completely unrealistic or I just should resend the x86 patch alone to get more attention? :-)

--Dmitry

----- Original Message -----
> From: "Dmitry ADAMUSHKA (EXT)" <dmitry.adamushka_ext@softathome.com>
> To: "Oleg Nesterov" <oleg@redhat.com>
> Cc: "Ingo Molnar" <mingo@elte.hu>, "Ralf Baechle" <ralf@linux-mips.org>, "wouter cloetens"
> <wouter.cloetens@softathome.com>, linux-kernel@vger.kernel.org, "Dmitry Adamushko" <dmitry.adamushko@gmail.com>, "H.
> Peter Anvin" <hpa@zytor.com>
> Sent: Thursday, March 8, 2012 5:58:29 PM
> Subject: Re: 'khelper' (child) is stuck in endless loop: do_signal() and !user_mode(regs)

> > On 03/08, Dmitry ADAMUSHKA (EXT) wrote:
> > >
> > > The following quick hack "fixes" it for x86.
> >
> > First of all let me repeat, I do not understand this asm ;)
> > Fortunately Ingo and Peter do.
> >
> > But,
> >
> > > --- arch/x86/kernel/entry_32.S.orig 2012-03-08 15:42:25.041296595
> > > +0100 +++ arch/x86/kernel/entry_32.S 2012-03-08 15:58:29.926081131
> > > +0100 @@ -98,12 +98,6 @@
> > >  #endif .endm
> > >
> > > -#ifdef CONFIG_VM86
> > > -#define resume_userspace_sig check_userspace
> > > -#else -#define resume_userspace_sig resume_userspace
> > > -#endif -
> > >  /*
> > >   * User gs save/restore
> > >   *
> > > @@ -327,10 +321,19 @@ ret_from_exception:
> > >         preempt_stop(CLBR_ANY)
> > >  ret_from_intr:
> > >         GET_THREAD_INFO(%ebp)
> > > -check_userspace: +resume_userspace_sig: +#ifdef CONFIG_VM86
> > >         movl PT_EFLAGS(%esp), %eax # mix EFLAGS and CS
> > >         movb PT_CS(%esp), %al
> > >         andl $(X86_EFLAGS_VM | SEGMENT_RPL_MASK), %eax
> > > +#else +/*
> > > + * We can be coming here from a syscall done in the kernel space,
> > > + * e.g. a failed kernel_execve().
> > > + */
> > > + movl PT_CS(%esp), %eax
> > > + andl $SEGMENT_RPL_MASK, %eax
> > > +#endif
> > >         cmpl $USER_RPL, %eax
> > >         jb resume_kernel # not returning to v8086 or userspace
> >
> > IIUC (I can be easily wrong) this breaks the endless loop, but
> > only after do_notify_resume() was already called.
> 
> yeah, basically I'm simulating the approach of CONFIG_VM86 here, i.e.
> doing the check at the same place in the call chain. Well, and giving
> a possibility for that "if (!user_mode(regs))" code in do_signal() to
> execute :-))
> 
> btw., what are the legitimate cases/code-paths for this part of
> do_signal()? I see that other archs just copy-past this approach. My
> initial thought was that it has something to do with handling (or
> rather preserving) some sort of signals that get delivered to
> not-yet-fully-created user-space tasks.. so that they get handled when
> these new tasks are up-and-running.
> 
> >
> > _perhaps_ it would be better to avoid do_notify_resume() in this
> > case altogether. Say, fire_user_return_notifiers() doesn't look
> > right in this case, we are not going to return to the usermode.
> >
> 
> yeah, there are some other corner cases I'm not sure about (like with
> syscall tracing). Also, there can be other scenarios of entering this
> loop... so one way or another, the loop should be broken.
> 
> --Dmitry
This message and any attachments herein are confidential, intended solely for the addressees and are SoftAtHome's ownership. Any unauthorized use or dissemination is prohibited. If you are not the intended addressee of this message, please cancel it immediately and inform the sender.
