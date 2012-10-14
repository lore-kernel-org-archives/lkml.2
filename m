Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab2JNWZE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 18:25:04 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52216 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2JNWZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 18:25:01 -0400
Date: Sun, 14 Oct 2012 23:24:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Mack <zonque@gmail.com>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] signals pile 3
Message-ID: <20121014222449.GN21164@n2100.arm.linux.org.uk>
References: <20121013005334.GM2616@ZenIV.linux.org.uk> <507ADBBB.9090209@gmail.com> <20121014202431.GL21164@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121014202431.GL21164@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, here's the post-mortem diagnosis.

What's happening is as follows (I'm very certain of this.)

We come through the usual init, and issue (see init/main.c):

	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);

This creates a new thread, which falls through to the ret_from_fork
assembly, with r4 set NULL and r5 set to kernel_init.  You can see
this in your oops dump register set - r5 is 0xc0344555, which is the
address of kernel_init plus 1 which marks the function as Thumb code.

Now, let's look at this code a little closer - this is what the
disassembly looks like:

c000d180 <ret_from_fork>:
c000d180:       f03a fe08       bl      c0047d94 <schedule_tail>
c000d184:       2d00            cmp     r5, #0
c000d186:       bf1e            ittt    ne
c000d188:       4620            movne   r0, r4
c000d18a:       46fe            movne   lr, pc <-- XXXXXXX
c000d18c:       46af            movne   pc, r5
c000d18e:       46e9            mov     r9, sp
c000d190:       ea4f 3959       mov.w   r9, r9, lsr #13
c000d194:       ea4f 3949       mov.w   r9, r9, lsl #13
c000d198:       e7c8            b.n     c000d12c <ret_to_user>
c000d19a:       bf00            nop
c000d19c:       f3af 8000       nop.w

I have marked one instruction, and it's the significant one.

Eventually, having had a successful call to kernel_execve(), kernel_init()
returns zero.

In returning, it uses the value in 'lr' which was set by the instruction
I marked above.  Unfortunately, this causes lr to contain 0xc000d18e -
an even address.  This switches the ISA to ARM on return but with a non
word aligned PC value.

So, what do we end up executing?  Well, not the instructions above - yes
the opcodes, but they don't mean the same thing in ARM mode.  In ARM mode,
it looks like this instead:

c000d18c:       46e946af        strbtmi r4, [r9], pc, lsr #13
c000d190:       3959ea4f        ldmdbcc r9, {r0, r1, r2, r3, r6, r9, fp, sp, lr, pc}^
c000d194:       3949ea4f        stmdbcc r9, {r0, r1, r2, r3, r6, r9, fp, sp, lr, pc}^
c000d198:       bf00e7c8        svclt   0x0000e7c8
c000d19c:       8000f3af        andhi   pc, r0, pc, lsr #7
c000d1a0:       e88db092        stm     sp, {r1, r4, r7, ip, sp, pc}
c000d1a4:       46e81fff                        ; <UNDEFINED> instruction: 0x46e81fff
c000d1a8:       8a00f3ef        bhi     0xc004a16c
c000d1ac:       0a0cf08a        beq     0xc03493dc

I have included more above, because it's relevant.  The PSR flags which we
can see in the oops dump are nZCv, so Z and C are set.

All the above ARM instructions are not executed, except for two.  c000d1a0,
which has no writeback, and writes below the current stack pointer (and
that data is lost when we take the next exception.)  The other instruction
which is executed is c000d1ac, which takes us to... 0xc03493dc.  However,
remember that bit 1 of the PC got set.  So that makes it 0xc03493de.

And that value is the value we find in the oops dump for PC.  What is the
instruction here when interpreted in ARM mode?

       0:       f71e150c                ; <UNDEFINED> instruction: 0xf71e150c

and there we have our undefined instruction (remember that the 'never'
condition code, 0xf, has been deprecated and is now always executed.)

So, what we have above is a consistent and sane story for how we ended up
at such a strange place in the kernel with such an odd register dump - with
no unanswered questions about what happened to get us there.

In light of this, I'm 100% certain that the patch below will fix the issue
you're seeing - please test this and get back to me ASAP, thanks.

 arch/arm/kernel/entry-common.S |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 417bac1..3471175 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -88,9 +88,9 @@ ENTRY(ret_from_fork)
 	bl	schedule_tail
 	cmp	r5, #0
 	movne	r0, r4
-	movne	lr, pc
+	adrne	lr, BSYM(1f)
 	movne	pc, r5
-	get_thread_info tsk
+1:	get_thread_info tsk
 	b	ret_slow_syscall
 ENDPROC(ret_from_fork)
 

