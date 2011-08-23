Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab1HWCAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 22:00:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752888Ab1HWCAq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 22:00:46 -0400
MIME-Version: 1.0
In-Reply-To: <20110823011312.GZ2203@ZenIV.linux.org.uk>
References: <20110822151305.GV2203@ZenIV.linux.org.uk> <CA+55aFwoRO9xxnTyt_gYFdTS9LsaFoCWRuyNeXY7gvrE8CdZ0A@mail.gmail.com>
 <4E52B7F8.3050002@zytor.com> <CAObL_7GmMXPUE0Oix1CKTYzqheyJV+ua=WEBUQk5m-LGsvqihw@mail.gmail.com>
 <4E52D280.3010107@zytor.com> <CA+55aFw4C+ShLHF2NYZMQ-Lhjow3mJ62_eqO_iAww2nh7V_-Uw@mail.gmail.com>
 <20110823000314.GW2203@ZenIV.linux.org.uk> <4E52EF2A.8060608@zytor.com>
 <CA+55aFx9zRTD72jaztLvyB68ejHcqM3Z3=b+6W64opfYu3ANjA@mail.gmail.com>
 <20110823010146.GY2203@ZenIV.linux.org.uk> <20110823011312.GZ2203@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 22 Aug 2011 18:59:48 -0700
Message-ID: <CA+55aFygGyi8HRr8wNVDw5xk46D5QDOhis18u2qV-9+h0-4ReA@mail.gmail.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andrew Lutomirski <luto@mit.edu>,
        Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 6:13 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> *UGH*.  OK,
>        1) I'm an idiot; int_ret_from_sys_call does *not* usually step on
> rbp (it's callee-saved).  So normally ebp is left as is on the way out,
> which is why we don't see stuff getting buggered left, right and center.

Check.

And the system call restart should actually work fine too, because at
syscall entry we save %ebp *both* in the slot for ebp and ecx when we
enter the first time. So the second time, we'll re-load the third
argument from ebp again, but that's fine - it's still going to be the
right value. Yes? No?

However, I note that the cstar entrypont has a comment about not saving ebp:

 * %ebp Arg2    [note: not saved in the stack frame, should not be touched]

which sounds odd. Why don't we save it? If we take a signal handler
there, don't we want %ebp on the kernel stack in pt_regs, in order to
do everything right?

Now I'm *really* confused.

                       Linus
