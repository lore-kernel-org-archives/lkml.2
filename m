Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab1HTUzv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 16:55:51 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:49207 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646Ab1HTUzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 16:55:49 -0400
Message-ID: <4E501F51.9060905@nod.at>
Date: Sat, 20 Aug 2011 22:55:45 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, luto@mit.edu
Subject: Re: [RFC] weird crap with vdso on uml/i386
References: <E1Qu7nv-0007OP-3E@ZenIV.linux.org.uk> <4E4D642F.3010909@nod.at> <20110818191946.GW2203@ZenIV.linux.org.uk> <20110819043120.GY2203@ZenIV.linux.org.uk> <4E4E2427.9080602@nod.at> <20110820011845.GC2203@ZenIV.linux.org.uk> <4E4FD12F.70508@nod.at> <20110820201406.GF2203@ZenIV.linux.org.uk>
In-Reply-To: <20110820201406.GF2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.08.2011 22:14, schrieb Al Viro:
> On Sat, Aug 20, 2011 at 05:22:23PM +0200, Richard Weinberger wrote:
>
>> Hmmm, very strange.
>> Sadly I cannot reproduce the issue. :(
>> Everything works fine within UML.
>> (Of course I've applied your vDSO/i386 patches)
>>
>> My test setup:
>> Host kernel: 2.6.37 and 3.0.1
>> Distro: openSUSE 11.4/x86_64
>>
>> UML kernel: 3.1-rc2
>> Distro: openSUSE 11.1/i386
>>
>> Does the problem also occur with another host kernel or a different
>> guest image?
>
> Could you check what you get in __kernel_vsyscall()?  On iAMD64 box
> where that sucker contains sysenter-based variant the bug is not
> present.  IOW, it's sensitive to syscall vs. systenter vs. int 0x80
> differences.

OK, this explains why I cannot reproduce it.
My Intel Core2 box is sysenter-based.

(gdb) disass __kernel_vsyscall
0xffffe420 <__kernel_vsyscall+0>:       push   %ecx
0xffffe421 <__kernel_vsyscall+1>:       push   %edx
0xffffe422 <__kernel_vsyscall+2>:       push   %ebp
0xffffe423 <__kernel_vsyscall+3>:       mov    %esp,%ebp
0xffffe425 <__kernel_vsyscall+5>:       sysenter
0xffffe427 <__kernel_vsyscall+7>:       nop
0xffffe428 <__kernel_vsyscall+8>:       nop
0xffffe429 <__kernel_vsyscall+9>:       nop
0xffffe42a <__kernel_vsyscall+10>:      nop
0xffffe42b <__kernel_vsyscall+11>:      nop
0xffffe42c <__kernel_vsyscall+12>:      nop
0xffffe42d <__kernel_vsyscall+13>:      nop
0xffffe42e <__kernel_vsyscall+14>:      jmp 
0xffffe423<__kernel_vsyscall+3>
0xffffe430 <__kernel_vsyscall+16>:      pop    %ebp
0xffffe431 <__kernel_vsyscall+17>:      pop    %edx
0xffffe432 <__kernel_vsyscall+18>:      pop    %ecx
0xffffe433 <__kernel_vsyscall+19>:      ret

> I can throw the trimmed-down fs image your way, BTW (66MB of bzipped ext2 ;-/)
> if you want to see if that gets reproduced on your box.  I'll drop it on
> anonftp if you are interested.  FWIW, the same kernel binary/same image
> result in
> 	* K7 box - no breakage, SYSENTER-based vdso
> 	* K8 box - breakage as described, SYSCALL-based vdso32
> 	* P4 box - no breakage, SYSENTER-based vdso32
> Hell knows...  In theory that would seem to point towards ia32_cstar_target(),
> so I'm going to RTFS carefully through that animal.

Now I'm testing with a Debian fs from: 
http://fs.devloop.org.uk/filesystems/Debian-Squeeze/

> The thing is, whatever happens happens when victim gets resumed inside
> vdso page.  I'll try to dump PTRACE_SETREGS and see the values host
> kernel asked to set and work from there, but the interesting part is
> bloody hard to singlestep through - the victim is back to user mode and
> it is already traced by the guest kernel, so it's not as if we could
> attach host gdb to it and walk through that crap.  And guest gdb is not
> going to be able to set breakpoints in there - vdso page is r/o...

[ CC'ing luto@mit.edu ]
Andy, do you have an idea?
You can find Al's original report here:
http://marc.info/?l=linux-kernel&m=131380315624244&w=2

Thanks,
//richard
