Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab1HWGP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 02:15:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34656 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab1HWGP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 02:15:57 -0400
Date: Tue, 23 Aug 2011 07:15:31 +0100
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
Message-ID: <20110823061531.GC2203@ZenIV.linux.org.uk>
References: <4E52B7F8.3050002@zytor.com>
 <CAObL_7GmMXPUE0Oix1CKTYzqheyJV+ua=WEBUQk5m-LGsvqihw@mail.gmail.com>
 <4E52D280.3010107@zytor.com>
 <CA+55aFw4C+ShLHF2NYZMQ-Lhjow3mJ62_eqO_iAww2nh7V_-Uw@mail.gmail.com>
 <20110823000314.GW2203@ZenIV.linux.org.uk>
 <4E52EF2A.8060608@zytor.com>
 <CA+55aFx9zRTD72jaztLvyB68ejHcqM3Z3=b+6W64opfYu3ANjA@mail.gmail.com>
 <20110823010146.GY2203@ZenIV.linux.org.uk>
 <20110823011312.GZ2203@ZenIV.linux.org.uk>
 <20110823021717.GA2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823021717.GA2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 03:17:18AM +0100, Al Viro wrote:

> I have a very strong suspicion that I know what will turn out to be involved
> into that - the page eviction done by sys_brk().  Note that dirtying this
> sucker is really necessary - without *s = 0 it won't segfault at all.  With
> it we get a segfault described above.
> 
> And page eviction on uml is nasty and convoluted as hell.  It has to do
> munmap() on process' VM.  Which is done in a rather sick way - we have a
> stub present in address space of all processes, with a function that
> does a given series of mmap/munmap/mprotect and traps itself.  Guest
> kernel puts arguments for that sucker into a shared data page and continues
> the process into that function.  Once it's done, we get the damn thing
> stopped again, nice and ready for us to continue dealing with it.
> 
> Something in that shitstorm of ptrace() calls ends up doing SETREGS
> when victim sits on the way out of (host) syscall.  Boom...

Almost, but not quite.  What happens is:
* process hits syscall insn
* it's stopped and tracer (guest kernel) does GETREGS
	+ looks at the registers (mapped to the normal layout)
	+ decides to call sys_brk()
	+ notices pages to kick out
	+ queues munmap request for stub
* tracer does SETREGS, pointing the child's eip to stub and sp to stub stack
* tracer does CONT, letting the child run
* child finishes with syscall insn, carefully preserving ebp.  It returns to
  userland, in the beginning of the stub.
* child does munmap() and hits int 3 in the end of stub.
* the damn thing is stopped again.  The tracer had been waiting for it.
* tracer finishes with sys_brk() and returns success.
* it does SETREGS, setting eax to return value, eip to original return
address of syscall insn... and ebp to what it had in regs.bp.  I.e. the
damn arg6 value.

And we are fucked.  It doesn't happen in syscall handler.  It's int3().
Having no idea that this request to set ebp should be interpreted in
a really different way - "put the value I asked to put into ecx here,
please, and ignore this one".

Sigh...  The really ugly part is that ebp can be changed by the stuff
done in stub - it's not just munmap, it can do mmap as well.  We can,
in principle, save ebp on its stack and restore it before trapping.
Then uml kernel could, in theory, replace that SETREGS with a bunch of
POKEUSER, leaving ebp alone.  Ho-hum...  In principle, that might even
be not too horrible - we need eax/eip/esp, of course, but the rest
could be dealt with by the same trick - have it pushed/popped in the
stub and to hell with wasting syscalls on setting them...

Anyway, bedtime for me.  I'll look into that again in the morning...
