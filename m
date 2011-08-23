Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab1HWCRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 22:17:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33494 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1HWCRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 22:17:44 -0400
Date: Tue, 23 Aug 2011 03:17:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andrew Lutomirski <luto@mit.edu>,
        Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
Message-ID: <20110823021717.GA2203@ZenIV.linux.org.uk>
References: <CA+55aFwoRO9xxnTyt_gYFdTS9LsaFoCWRuyNeXY7gvrE8CdZ0A@mail.gmail.com>
 <4E52B7F8.3050002@zytor.com>
 <CAObL_7GmMXPUE0Oix1CKTYzqheyJV+ua=WEBUQk5m-LGsvqihw@mail.gmail.com>
 <4E52D280.3010107@zytor.com>
 <CA+55aFw4C+ShLHF2NYZMQ-Lhjow3mJ62_eqO_iAww2nh7V_-Uw@mail.gmail.com>
 <20110823000314.GW2203@ZenIV.linux.org.uk>
 <4E52EF2A.8060608@zytor.com>
 <CA+55aFx9zRTD72jaztLvyB68ejHcqM3Z3=b+6W64opfYu3ANjA@mail.gmail.com>
 <20110823010146.GY2203@ZenIV.linux.org.uk>
 <20110823011312.GZ2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823011312.GZ2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 02:13:12AM +0100, Al Viro wrote:
> *UGH*.  OK,
> 	1) I'm an idiot; int_ret_from_sys_call does *not* usually step on
> rbp (it's callee-saved).  So normally ebp is left as is on the way out,
> which is why we don't see stuff getting buggered left, right and center.
> 	2) Sometimes it apparently does somehow happen.  I don't see where
> it happens yet, but uml breakage that started all of that looks *exactly*
> like that.  %ebp getting arg6 in it when we return into __kernel_vsyscall()
> from the kernel fits the observed pattern precisely.
> 	3) modulo that the situation is nowhere near as bad as I thought.
> Brown paperbag time for me - for missing that if my analysis had been correct
> we'd've seen breakage _much_ earlier.  Mea culpa.
> 	4) we still have a problem, apparently, but it's more narrow now -
> the question is when would %rbp be shat into?
> 
> Al, off to apply a serious self-LART...

So it smells like a nasty effect of PTRACE_SETREGS/PTRACE_POKEUSER on the
way *out* of syscall (the same on the way in wouldn't have such effect -
modified EBP value would be simply lost after the syscall; passed to it
as arg6, but that's it).

All right, now I have a nice shiny reproducer for uml folks:
main()
{
	char *s = sbrk(8192);
	*s = 0;
	brk(s);
}
will do it on the affected boxen.  It gets fucked in the second call of
brk().  What happens is this:
brk(3) in libc:
	about to call brk(2), will have to stomp on %ebx
	save ebx into ecx for the duration of call
	the new brk level into ebx, syscall number into eax
	hit __kernel_vsyscall()
		push ebp
		mov ecx, ebp
ecx is going to get stomped on, save it (i.e. original ebx) into ebp
		syscall
and at that point ebp has changed - it became equal to arg6, aka what we'd
put on stack, aka the value of ebp prior to all of that, aka the frame
pointer of caller.
		use ecx to set ss back to sanity
		mov ebp, ecx
and now ecx is buggered.
		pop ebp
the value of ebp has actually not been changed by that.
		ret
	put the value of ecx back into ebx
only it's not the value we used to have there.  Not anymore.  Now we are about
to store the return value of brk(2) into static variable.  And that's where
it really hits the fan, since we are in a PIC code and ebx is not what it
used to be.  So instead of that variable we access hell knows what address
and promptly segfault.

I have a very strong suspicion that I know what will turn out to be involved
into that - the page eviction done by sys_brk().  Note that dirtying this
sucker is really necessary - without *s = 0 it won't segfault at all.  With
it we get a segfault described above.

And page eviction on uml is nasty and convoluted as hell.  It has to do
munmap() on process' VM.  Which is done in a rather sick way - we have a
stub present in address space of all processes, with a function that
does a given series of mmap/munmap/mprotect and traps itself.  Guest
kernel puts arguments for that sucker into a shared data page and continues
the process into that function.  Once it's done, we get the damn thing
stopped again, nice and ready for us to continue dealing with it.

Something in that shitstorm of ptrace() calls ends up doing SETREGS
when victim sits on the way out of (host) syscall.  Boom...
