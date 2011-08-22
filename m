Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab1HVC0W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 22:26:22 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38845 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab1HVC0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 22:26:20 -0400
MIME-Version: 1.0
In-Reply-To: <20110822020737.GP2203@ZenIV.linux.org.uk>
References: <20110821063443.GH2203@ZenIV.linux.org.uk> <20110821084230.GI2203@ZenIV.linux.org.uk>
 <CAObL_7GXyzAzNjBtgye9BwXLyHm337oBTdjRDjbSPqoKZGWyyA@mail.gmail.com>
 <20110821144352.GJ2203@ZenIV.linux.org.uk> <20110821164124.GL2203@ZenIV.linux.org.uk>
 <CAObL_7E1vU8+0UQST6Smf9j40TckTzB=QdY0AuAWo4AX6cs2xg@mail.gmail.com>
 <20110822011645.GM2203@ZenIV.linux.org.uk> <CA+55aFz1jCZGcQ-c6uGN=k8nKDuGoz5g8e+pxpYAg4X_p7=5Mw@mail.gmail.com>
 <4E51B56F.3080301@zytor.com> <CAObL_7HLDD=FVSN58W7a0g0R--8x7OVrQVCBxWD1DirVZxRn2w@mail.gmail.com>
 <20110822020737.GP2203@ZenIV.linux.org.uk>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 21 Aug 2011 22:26:00 -0400
X-Google-Sender-Auth: lp9BR3qBtCqcyUWlbZf6hSbjKZg
Message-ID: <CAObL_7HY7qFUoqtNju42=BHTR8WuuW-cL_cQh_uUfx_7gFfHRg@mail.gmail.com>
Subject: Re: SYSCALL, ptrace and syscall restart breakages (Re: [RFC] weird
 crap with vdso on uml/i386)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 10:07 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Aug 21, 2011 at 10:01:40PM -0400, Andrew Lutomirski wrote:
>
>>  3. We're worried that pt_regs-using compat syscalls might want the
>> regs to appear to match the actual arguments (why?)
>
> run strace and you'll see why.
>

I'm talking about the implementations of stub32_rt_sigreturn,
sys32_rt_sigreturn, stub32_sigreturn, stub32_sigaltstack,
stub32_execve, stub32_fork, stub32_clone, stub32_vfork, and stub32_iopl.
I don't know what this has to do with strace or user ABI at all.

>>  4. ptrace expects the "registers" when SYSCALL happens to match the
>> int 0x80 convention.  (This is, IMO, sick.)
>
> That's what ptrace is *for*.  It's there to let debuggers play with
> the program being debugged, including taking a look at the syscall
> arguments and modifying them.  In a predictable way, please.
>

It may be necessary, but I still think it's sick.  Especially in the
case of inlined SYSCALL, where the registers reported to ptrace do not
match any register values that ever actually existed in CPU registers.
 Too late to fix it, though.

Which still leaves the question of how to fix it.  Restarting via an
int 0x80-based helper might be the only option that leaves everything
fully functional.

--Andy
