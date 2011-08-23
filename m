Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab1HWQMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:12:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54436 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1HWQME convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:12:04 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzUAuPEwcvVvuXooWMT6XpDuOjEHi-Ab+SOhZVjfbVYpA@mail.gmail.com>
References: <4E52B7F8.3050002@zytor.com> <CAObL_7GmMXPUE0Oix1CKTYzqheyJV+ua=WEBUQk5m-LGsvqihw@mail.gmail.com>
 <4E52D280.3010107@zytor.com> <CA+55aFw4C+ShLHF2NYZMQ-Lhjow3mJ62_eqO_iAww2nh7V_-Uw@mail.gmail.com>
 <20110823000314.GW2203@ZenIV.linux.org.uk> <4E52EF2A.8060608@zytor.com>
 <CA+55aFx9zRTD72jaztLvyB68ejHcqM3Z3=b+6W64opfYu3ANjA@mail.gmail.com>
 <20110823010146.GY2203@ZenIV.linux.org.uk> <20110823011312.GZ2203@ZenIV.linux.org.uk>
 <20110823021717.GA2203@ZenIV.linux.org.uk> <20110823061531.GC2203@ZenIV.linux.org.uk>
 <CA+55aFzUAuPEwcvVvuXooWMT6XpDuOjEHi-Ab+SOhZVjfbVYpA@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 23 Aug 2011 12:11:43 -0400
X-Google-Sender-Auth: 3ki2YoZAth_Hck4CJ_FvagNfae4
Message-ID: <CAObL_7F-E2y_cd1MK4ayBx_CqszrewSrBt6V7=ndVuBQrrmTKQ@mail.gmail.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
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

On Tue, Aug 23, 2011 at 12:03 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Aug 22, 2011 at 11:15 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> * it does SETREGS, setting eax to return value, eip to original return
>> address of syscall insn... and ebp to what it had in regs.bp.  I.e. the
>> damn arg6 value.
>
> Ok, I think that exhaustively explains that
>
>  (a) our system call restart has always worked correctly, and we're good.
>
>  (b) it's simply just UML that is buggy, and doesn't understand the
> subtleties about doing GETREGS at a system call.
>
> and I think that the correct and simple solution is to just teach UML
> to understand the proper logic of pt_regs during a system call (and a
> 'syscall' instruction in particular).
>
> The thing is, UML emulates 'syscall' the way the *CPU* does it, not
> the way *we* do it. That may make sense, but it's simply not correct.
>
> So I would vote very strongly against actually changing anything in
> arch/x86. This is very much an UML issue.
>
> Suggested fixes:
>
>  - instead of blindly doing SETREGS, just write the result registers
> individually like you suggested
>
> OR (and perhaps preferably):
>
>  - teach UML that when you do 'GETREGS' after a system call trapped,
> we have switched things around to match the "official system call
> order", and UML should just undo our swizzling, and do a "regs.ebp =
> regs.ecx" to make it be what the actual original registers were (or
> whatever the actual correct swizzle is - I didn't think that through
> very much).
>
> IOW, I think the core kernel does the right thing. Our argument
> register swizzling is odd, yes, but it's an implementation detail that
> something like uml should just have to take into account. No?
>
> Hmm?

Egads.  Does this mean that doing GETREGS and then doing SETREGS later
on with the *exact same values* is considered incorrect?  IMO, this
way lies madness.

In any case, this seems insanely overcomplicated.  I'd be less afraid
of something like my approach (which, I think, makes all of the
SYSCALL weirdness pretty much transparent to ptrace users) or of just
removing SYSCALL entirely from 32-bit code.

--Andy
