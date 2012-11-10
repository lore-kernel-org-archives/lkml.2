Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab2KJHdn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 02:33:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36506 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab2KJHdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 02:33:41 -0500
Date: Sat, 10 Nov 2012 07:33:39 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Michel Lespinasse <walken@google.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: Issues with "x86, um: switch to generic fork/vfork/clone" commit
Message-ID: <20121110073338.GP2616@ZenIV.linux.org.uk>
References: <CANN689FmsFBjfiD8V-nQyDh+GtTF5B3SDUcuXc=3OeeN6JW0kw@mail.gmail.com>
 <20121110045104.GN2616@ZenIV.linux.org.uk>
 <CANN689GetguA+1bqKXC=Cq0SLcLqaqLsn5XGBZYVbWeBogX+zA@mail.gmail.com>
 <20121110053334.GO2616@ZenIV.linux.org.uk>
 <CANN689G+j0VS5JcFDx08XexZmqZ95YUPMVRd+3ji=8Fr3Q2R=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANN689G+j0VS5JcFDx08XexZmqZ95YUPMVRd+3ji=8Fr3Q2R=Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 09:47:54PM -0800, Michel Lespinasse wrote:
> On Fri, Nov 9, 2012 at 9:33 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Fri, Nov 09, 2012 at 08:57:58PM -0800, Michel Lespinasse wrote:
> >> On Fri, Nov 9, 2012 at 8:51 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >> > On Fri, Nov 09, 2012 at 08:36:53PM -0800, Michel Lespinasse wrote:
> >> >> Hi,
> >> >>
> >> >> I'm having an issue booting current linux-next kernels on my test
> >> >> machines. Userspace crashes when it's supposed to pivot to the rootfs.
> >> >> With the loglevel=8 kernel parameter, the last messages I see are:
> >> >>
> >> >> Checking root filesystem in pivot_root init.
> >> >> [    6.252717] usb 2-1: link qh256-0001/ffff880853ec9ab8 start 1 [1/0 us]
> >> >> [    6.259419] hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0000
> >> >> [    6.292302] traps: hotplug[1633] general protection ip:f767c06b
> >> >> sp:ffbb2d1c error:0 in libc-2.3.6.so[f7652000+126000]
> >> >>
> >> >> I ran a bisection and it turns out that
> >> >> e52d03a3775841cc68d0ea9d86f2f09b603c41e6 (x86, um: switch to generic
> >> >> fork/vfork/clone) is the commit breaking my setup. When reverting
> >> >> that, I am able to boot linux-next (or mmotm, which is what I was
> >> >> trying to do in the first place) without issues.
> >> >>
> >> >> Sorry for not having a more complete root cause at the moment - I'm
> >> >> lacking some context as to what the change is trying to do.
> >> >
> >> > Hmm...  32bit native, presumably?
> >>
> >> This is running on a x86_64 system; I believe the userspace binaries
> >> should be 64-bit as well.
> >
> > Curious...  After the second look at that sucker, it seems that you have
> > 32bit hotplug(8) in there, and yes, it's clearly a 64bit kernel...  Could
> > you check which binary it is and whether it's really 32bit or not?
> 
> Looks like /sbin/hotplug is a script on this system, using /bin/bash
> as the interpreter, and /bin/bash is ELF 32-bit LSB executable.
> (wow, I had no idea, I thought more of that system was 64-bits :)

I think I see what's going on there.  It's PTREGSCALL blindly used for
clone wrapper in ia32entry.S.  FWIW, it's wrong for all of those
suckers, anyway:
	* fork/clone/vfork need to save extra registers, but don't need
to restore them; after unification we don't need pt_regs argument for any
of those - for fork/vfork it's useless, for clone it breaks things.
	* execve doesn't need pt_regs argument; harmless, but useless.
	* for sigaltstack() we simply need to get rid of stupid pt_regs
argument, along with the wrapper; current_pt_regs()->sp is all it needs.
	* for sigreturn/rt_sigreturn we need to restore extra registers,
but we do *not* need to save them; just leave the space on stack.  And
no need to pass pt_regs either - it'll be current_pt_regs() anyway.
	* iopl() doesn't need to save/restore extras and it doesn't need
pt_regs argument - it's going to be current_pt_regs().

On top of all that, there's an extra piece of crap - different order of
arguments for native and compat clone.

Could you verify that this on top of for-next gets the things working again?
It's a very lazy way to deal with that (we don't want to bother with
restoring extras, at the very least), but the rest can go separately (and
is shared with mainline, unlike that one).  It seems to be working here,
but I'd like to see your ACK as well.  If everything works, it'll get
folded into the offending commit...

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 633649e..32e6f05 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -467,11 +467,16 @@ GLOBAL(\label)
 	PTREGSCALL stub32_sigaltstack, sys32_sigaltstack, %rdx
 	PTREGSCALL stub32_execve, compat_sys_execve, %rcx
 	PTREGSCALL stub32_fork, sys_fork, %rdi
-	PTREGSCALL stub32_clone, sys_clone, %rdx
 	PTREGSCALL stub32_vfork, sys_vfork, %rdi
 	PTREGSCALL stub32_iopl, sys_iopl, %rsi
 
 	ALIGN
+GLOBAL(stub32_clone)
+	leaq sys_clone(%rip),%rax
+	mov	%r8, %rcx
+	jmp  ia32_ptregs_common	
+
+	ALIGN
 ia32_ptregs_common:
 	popq %r11
 	CFI_ENDPROC

Anyway, below is the minimal fix on top of for-next; I'll fold it
