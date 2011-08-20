Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab1HTPWg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 11:22:36 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:43421 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab1HTPWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 11:22:34 -0400
Message-ID: <4E4FD12F.70508@nod.at>
Date: Sat, 20 Aug 2011 17:22:23 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] weird crap with vdso on uml/i386
References: <E1Qu7nv-0007OP-3E@ZenIV.linux.org.uk> <4E4D642F.3010909@nod.at> <20110818191946.GW2203@ZenIV.linux.org.uk> <20110819043120.GY2203@ZenIV.linux.org.uk> <4E4E2427.9080602@nod.at> <20110820011845.GC2203@ZenIV.linux.org.uk>
In-Reply-To: <20110820011845.GC2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.08.2011 03:18, schrieb Al Viro:
> 3) with the previous two issues dealt with, we get the following magical
> mistery shite when running 32bit uml kernel + userland on 64bit host:
> 	* the system boots all the way to getty/login and sshd (i.e. gets
> through the debian /etc/init.d (squeeze/i386))
> 	* one can log into it, both on terminals and over ssh.  shell and
> a bunch of other stuff works.  Mostly.
> 	* /bin/bash -c "echo *" reliably segfaults.  Always.  So does tab
> completion in bash, for that matter.
> 	* said segfault is reproducible both from shell and under gdb.
> For /bin/bash -c "echo *" under gdb it's always the 10th call of brk(3).
> What happens there apparently boils down to __kernel_vsyscall() getting
> called (and yes, sys_brk() is called, succeeds and results in expected
> value in %eax) and corrupting the living hell out of %ecx.  Namely, on
> return from what presumably is __kernel_vsyscall() I'm seeing %ecx equal
> to (original value of) %ebp.  All registers except %eax and %ecx (including
> %esp and %ebp) remain unchanged.
> 	Again, that happens only on the same call of brk(3) - all previous
> calls succeed as expected.  I don't believe that it's a race.  I also
> very much doubt that we are calling the wrong location - it's hard to tell
> with the call being call *%gs:0x10 (is there any way to find what that
> is equal to in gdb, BTW?  Short of hot-patching movl *%gs:0x10,%eax in place
> of that call and single-stepping it, that is...) but it *does* end up
> making the system call that ought to have been made, so I suspect that it
> does hit __kernel_vsyscall(), after all...
>
> The text of __kernel_vsyscall() is
> 	0xffffe420<__kernel_vsyscall+0>:       push   %ebp
> 	0xffffe421<__kernel_vsyscall+1>:       mov    %ecx,%ebp
> 	0xffffe423<__kernel_vsyscall+3>:       syscall
> 	0xffffe425<__kernel_vsyscall+5>:       mov    $0x2b,%ecx
> 	0xffffe42a<__kernel_vsyscall+10>:      mov    %ecx,%ss
> 	0xffffe42c<__kernel_vsyscall+12>:      mov    %ebp,%ecx
> 	0xffffe42e<__kernel_vsyscall+14>:      pop    %ebp
> 	0xffffe42f<__kernel_vsyscall+15>:      ret
> so %ecx on the way out becoming equal to original %ebp is bloody curious -
> it would smell like entering that sucker 3 bytes too late and skipping
> mov %ecx, %ebp, but... we would also skip push %ebp, so we'd get trashed
> on the way out - wrong return address, wrong value in %ebp, changed %esp.
> None of that happens.  And we are executing that code in userland - i.e.
> to get corrupt it would have to get corrupt in *HOST* 32bit VDSO.  Which
> would have much more visible effects, starting with the next attempt to
> run the testcase blowing up immediately instead of waiting (as it actually
> does) for the same 10th call of brk()...
>
> I'm at loss, to be honest.  The sucker is nicely reproducible, but bisecting
> doesn't help at all - it seems to be present all the way back at least to
> 2.6.33.  I hadn't tried to go back further and I hadn't tried to go for
> older host kernels, but I wouldn't put too much faith into that...  The
> reason it hadn't been noticed much earlier is that it works fine on i386
> host - aforementioned shit happens only when the entire thing (identical
> binary, identical fs image, identical options) is run on amd64.  However,
> on i386 I have a different __kernel_vsyscall, which might easily be the
> reason it doesn't happen there.  It's a K7 box with sysenter-based
> variant ending up as __kernel_vsyscall().  Hell knows what's going on...
> Behaviour is really weird and I'd appreciate any pointers re debugging
> that crap.  Suggestions?

Hmmm, very strange.
Sadly I cannot reproduce the issue. :(
Everything works fine within UML.
(Of course I've applied your vDSO/i386 patches)

My test setup:
Host kernel: 2.6.37 and 3.0.1
Distro: openSUSE 11.4/x86_64

UML kernel: 3.1-rc2
Distro: openSUSE 11.1/i386

Does the problem also occur with another host kernel or a different 
guest image?

Thanks,
//richard
