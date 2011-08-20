Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1HTBS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 21:18:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55122 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab1HTBS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 21:18:56 -0400
Date: Sat, 20 Aug 2011 02:18:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC] weird crap with vdso on uml/i386
Message-ID: <20110820011845.GC2203@ZenIV.linux.org.uk>
References: <E1Qu7nv-0007OP-3E@ZenIV.linux.org.uk>
 <4E4D642F.3010909@nod.at>
 <20110818191946.GW2203@ZenIV.linux.org.uk>
 <20110819043120.GY2203@ZenIV.linux.org.uk>
 <4E4E2427.9080602@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4E2427.9080602@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 10:51:51AM +0200, Richard Weinberger wrote:

> Please slow down a bit. :-)
> All these branches are just for testing purposes.
> That's why I have not announced them nor sent a pull request to Linus.
> 
> Anyway, thanks for the hints!

np...  FWIW, there's a really ugly bug present in mainline as well as
in mainline + these patches and I'd welcome any help in figuring out
what's going on.

1) USER_OBJS do not see CONFIG_..., so os-Linux/main.c doesn't see
CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA.  As the result, uml/i386 doesn't
notice that host vdso is there.  That one is easy to fix:
-obj-$(CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA) += elf_aux.o
+ifeq ($(CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA),y)
+obj-y += elf_aux.o
+CFLAGS_main.o += -DCONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA
+endif
in arch/um/os-Linux/Makefile takes care of that.  Unfortunately, it also
exposes a bug in fixrange_init():

2) fixrange_init() gets called with start (and end) not multiple of
PMD_SIZE; moreover, end is very close to the ~0UL - closer than by PMD_SIZE.
Bad things start happening to the loops in there.  Again, easy to fix:

diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 8137ccc..39ee674 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -119,19 +119,22 @@ static void __init fixrange_init(unsigned long start, unsigned long end,
 	int i, j;
 	unsigned long vaddr;
 
-	vaddr = start;
+	vaddr = start & PMD_MASK;
 	i = pgd_index(vaddr);
 	j = pmd_index(vaddr);
 	pgd = pgd_base + i;
+	start >>= PMD_SHIFT;
+	end = (end - 1) >> PMD_SHIFT;
 
-	for ( ; (i < PTRS_PER_PGD) && (vaddr < end); pgd++, i++) {
+	for ( ; (i < PTRS_PER_PGD) && start <= end; pgd++, i++) {
 		pud = pud_offset(pgd, vaddr);
 		if (pud_none(*pud))
 			one_md_table_init(pud);
 		pmd = pmd_offset(pud, vaddr);
-		for (; (j < PTRS_PER_PMD) && (vaddr < end); pmd++, j++) {
+		for (; (j < PTRS_PER_PMD) && start <= end; pmd++, j++) {
 			one_page_table_init(pmd);
 			vaddr += PMD_SIZE;
+			start++;
 		}
 		j = 0;
 	}

That populates the page tables in the right places and fixrange_user_init()
manages to call it, avoid death-by-oom from runaway allocations and then
install references to all pages it wants.  Alas, at that point the things
become really interesting.

3) with the previous two issues dealt with, we get the following magical
mistery shite when running 32bit uml kernel + userland on 64bit host:
	* the system boots all the way to getty/login and sshd (i.e. gets
through the debian /etc/init.d (squeeze/i386))
	* one can log into it, both on terminals and over ssh.  shell and
a bunch of other stuff works.  Mostly.
	* /bin/bash -c "echo *" reliably segfaults.  Always.  So does tab
completion in bash, for that matter.
	* said segfault is reproducible both from shell and under gdb.
For /bin/bash -c "echo *" under gdb it's always the 10th call of brk(3).
What happens there apparently boils down to __kernel_vsyscall() getting
called (and yes, sys_brk() is called, succeeds and results in expected
value in %eax) and corrupting the living hell out of %ecx.  Namely, on
return from what presumably is __kernel_vsyscall() I'm seeing %ecx equal
to (original value of) %ebp.  All registers except %eax and %ecx (including
%esp and %ebp) remain unchanged.
	Again, that happens only on the same call of brk(3) - all previous
calls succeed as expected.  I don't believe that it's a race.  I also
very much doubt that we are calling the wrong location - it's hard to tell
with the call being call *%gs:0x10 (is there any way to find what that
is equal to in gdb, BTW?  Short of hot-patching movl *%gs:0x10,%eax in place
of that call and single-stepping it, that is...) but it *does* end up
making the system call that ought to have been made, so I suspect that it
does hit __kernel_vsyscall(), after all...

The text of __kernel_vsyscall() is
	0xffffe420 <__kernel_vsyscall+0>:       push   %ebp
	0xffffe421 <__kernel_vsyscall+1>:       mov    %ecx,%ebp
	0xffffe423 <__kernel_vsyscall+3>:       syscall 
	0xffffe425 <__kernel_vsyscall+5>:       mov    $0x2b,%ecx
	0xffffe42a <__kernel_vsyscall+10>:      mov    %ecx,%ss
	0xffffe42c <__kernel_vsyscall+12>:      mov    %ebp,%ecx
	0xffffe42e <__kernel_vsyscall+14>:      pop    %ebp
	0xffffe42f <__kernel_vsyscall+15>:      ret    
so %ecx on the way out becoming equal to original %ebp is bloody curious -
it would smell like entering that sucker 3 bytes too late and skipping
mov %ecx, %ebp, but... we would also skip push %ebp, so we'd get trashed
on the way out - wrong return address, wrong value in %ebp, changed %esp.
None of that happens.  And we are executing that code in userland - i.e.
to get corrupt it would have to get corrupt in *HOST* 32bit VDSO.  Which
would have much more visible effects, starting with the next attempt to
run the testcase blowing up immediately instead of waiting (as it actually
does) for the same 10th call of brk()...

I'm at loss, to be honest.  The sucker is nicely reproducible, but bisecting
doesn't help at all - it seems to be present all the way back at least to
2.6.33.  I hadn't tried to go back further and I hadn't tried to go for
older host kernels, but I wouldn't put too much faith into that...  The
reason it hadn't been noticed much earlier is that it works fine on i386
host - aforementioned shit happens only when the entire thing (identical
binary, identical fs image, identical options) is run on amd64.  However,
on i386 I have a different __kernel_vsyscall, which might easily be the
reason it doesn't happen there.  It's a K7 box with sysenter-based
variant ending up as __kernel_vsyscall().  Hell knows what's going on...
Behaviour is really weird and I'd appreciate any pointers re debugging
that crap.  Suggestions?
