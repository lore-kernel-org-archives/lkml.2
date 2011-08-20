Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab1HTUO2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 16:14:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50477 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab1HTUOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 16:14:15 -0400
Date: Sat, 20 Aug 2011 21:14:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] weird crap with vdso on uml/i386
Message-ID: <20110820201406.GF2203@ZenIV.linux.org.uk>
References: <E1Qu7nv-0007OP-3E@ZenIV.linux.org.uk>
 <4E4D642F.3010909@nod.at>
 <20110818191946.GW2203@ZenIV.linux.org.uk>
 <20110819043120.GY2203@ZenIV.linux.org.uk>
 <4E4E2427.9080602@nod.at>
 <20110820011845.GC2203@ZenIV.linux.org.uk>
 <4E4FD12F.70508@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4FD12F.70508@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 20, 2011 at 05:22:23PM +0200, Richard Weinberger wrote:

> Hmmm, very strange.
> Sadly I cannot reproduce the issue. :(
> Everything works fine within UML.
> (Of course I've applied your vDSO/i386 patches)
> 
> My test setup:
> Host kernel: 2.6.37 and 3.0.1
> Distro: openSUSE 11.4/x86_64
> 
> UML kernel: 3.1-rc2
> Distro: openSUSE 11.1/i386
> 
> Does the problem also occur with another host kernel or a different
> guest image?

Could you check what you get in __kernel_vsyscall()?  On iAMD64 box
where that sucker contains sysenter-based variant the bug is not
present.  IOW, it's sensitive to syscall vs. systenter vs. int 0x80
differences.

I can throw the trimmed-down fs image your way, BTW (66MB of bzipped ext2 ;-/)
if you want to see if that gets reproduced on your box.  I'll drop it on
anonftp if you are interested.  FWIW, the same kernel binary/same image
result in
	* K7 box - no breakage, SYSENTER-based vdso
	* K8 box - breakage as described, SYSCALL-based vdso32
	* P4 box - no breakage, SYSENTER-based vdso32
Hell knows...  In theory that would seem to point towards ia32_cstar_target(),
so I'm going to RTFS carefully through that animal.

The thing is, whatever happens happens when victim gets resumed inside
vdso page.  I'll try to dump PTRACE_SETREGS and see the values host
kernel asked to set and work from there, but the interesting part is
bloody hard to singlestep through - the victim is back to user mode and
it is already traced by the guest kernel, so it's not as if we could
attach host gdb to it and walk through that crap.  And guest gdb is not
going to be able to set breakpoints in there - vdso page is r/o...
