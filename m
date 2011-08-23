Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab1HWO01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 10:26:27 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:32801 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab1HWO0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 10:26:21 -0400
Date: Tue, 23 Aug 2011 16:26:08 +0200
From: Borislav Petkov <bp@amd64.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Andrew Lutomirski <luto@mit.edu>,
        Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
Message-ID: <20110823142608.GB12669@aftab>
References: <CAObL_7GmMXPUE0Oix1CKTYzqheyJV+ua=WEBUQk5m-LGsvqihw@mail.gmail.com>
 <4E52D280.3010107@zytor.com>
 <CA+55aFw4C+ShLHF2NYZMQ-Lhjow3mJ62_eqO_iAww2nh7V_-Uw@mail.gmail.com>
 <20110823000314.GW2203@ZenIV.linux.org.uk>
 <4E52EF2A.8060608@zytor.com>
 <CA+55aFx9zRTD72jaztLvyB68ejHcqM3Z3=b+6W64opfYu3ANjA@mail.gmail.com>
 <20110823010146.GY2203@ZenIV.linux.org.uk>
 <20110823011312.GZ2203@ZenIV.linux.org.uk>
 <20110823021717.GA2203@ZenIV.linux.org.uk>
 <20110823061531.GC2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823061531.GC2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 02:15:31AM -0400, Al Viro wrote:
> Almost, but not quite.  What happens is:
> * process hits syscall insn
> * it's stopped and tracer (guest kernel) does GETREGS
> 	+ looks at the registers (mapped to the normal layout)
> 	+ decides to call sys_brk()
> 	+ notices pages to kick out
> 	+ queues munmap request for stub
> * tracer does SETREGS, pointing the child's eip to stub and sp to stub stack
> * tracer does CONT, letting the child run
> * child finishes with syscall insn, carefully preserving ebp.  It returns to
>   userland, in the beginning of the stub.
> * child does munmap() and hits int 3 in the end of stub.
> * the damn thing is stopped again.  The tracer had been waiting for it.
> * tracer finishes with sys_brk() and returns success.
> * it does SETREGS, setting eax to return value, eip to original return
> address of syscall insn... and ebp to what it had in regs.bp.  I.e. the
> damn arg6 value.

Ok, stupid question: can a convoluted ptracing case like this be created
in "normal" userspace, i.e. irrespective of UML and only by using gdb,
for example?

I.e., from what I understand from above, you need to stop the tracee at
syscall and "redirect" it to the stub after it finishes the syscall so
that in another syscall it gets a debug exception... sounds complicated.

> And we are fucked.  It doesn't happen in syscall handler.  It's int3().
> Having no idea that this request to set ebp should be interpreted in
> a really different way - "put the value I asked to put into ecx here,
> please, and ignore this one".
> 
> Sigh...  The really ugly part is that ebp can be changed by the stuff
> done in stub - it's not just munmap, it can do mmap as well.  We can,
> in principle, save ebp on its stack and restore it before trapping.
> Then uml kernel could, in theory, replace that SETREGS with a bunch of
> POKEUSER, leaving ebp alone.  Ho-hum...  In principle, that might even
> be not too horrible - we need eax/eip/esp, of course, but the rest
> could be dealt with by the same trick - have it pushed/popped in the
> stub and to hell with wasting syscalls on setting them...

which could mean that we could get away by not replacing SYSCALL32?

Hmm.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
