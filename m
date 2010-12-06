Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab0LFXmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:42:55 -0500
Received: from ozlabs.org ([203.10.76.45]:32847 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab0LFXmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 18:42:54 -0500
Message-Id: <20101206234043.083045003@neuling.org>
User-Agent: quilt/0.48-1
Date: Tue, 07 Dec 2010 10:40:43 +1100
From: Michael Neuling <mikey@neuling.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kumar Gala <galak@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [RFC/PATCH 0/7] powerpc: Implement lazy save of FP, VMX and VSX state in SMP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements lazy save of FP, VMX and VSX state on SMP 64bit and 32
bit powerpc.

Currently we only do lazy save in UP, but this patch set extends this to
SMP.  We always do lazy restore.

For VMX, on a context switch we do the following:
 - if we are switching to a CPU that currently holds the new processes
   state, just turn on VMX in the MSR (this is the lazy/quick case)
 - if the new processes state is in the thread_struct, turn VMX off.
 - if the new processes state is in someone else's CPU, IPI that CPU to
   giveup it's state and turn VMX off in the MSR (slow IPI case).
We always start the new process at this point, irrespective of if we
have the state or not in the thread struct or current CPU.  

So in the slow case, we attempt to avoid the IPI latency by starting
the process immediately and only waiting for the state to be flushed
when the process actually needs VMX.  ie. when we take the VMX
unavailable exception after the context switch.

FP is implemented in a similar way.  VSX reuses the FP and VMX code as
it doesn't have any additional state over what FP and VMX used.

I've been benchmarking with Anton Blanchard's context_switch.c benchmark
found here: 
  http://ozlabs.org/~anton/junkcode/context_switch.c 
Using this benchmark as is gives no degradation in performance with these
patches applied.  

Inserting a simple FP instruction into one of the threads (gives the
nice save/restore lazy case), I get about a 4% improvement in context
switching rates with my patches applied.  I get similar results VMX.
With a simple VSX instruction (VSX state is 64x128bit registers) in 1
thread I get an 8% bump in performance with these patches.

With FP/VMX/VSX instructions in both threads, I get no degradation in
performance.

Running lmbench doesn't have any degradation in performance.

Most of my benchmarking and testing has been done on 64 bit systems.
I've tested 32 bit FP but I've not tested 32 bit VMX at all.

There is probably some optimisations to my asm code that can also be
made.  I've been concentrating on correctness, as opposed to speed
with the asm code, since if you get a lazy context switch, you skip
all the asm now anyway.

Whole series is bisectable to compile with various 64/32bit SMP/UP
FPU/VMX/VSX config options on and off.

I really hate the include file changes in this series.  Getting the
call_single_data in the powerpc threads_struct was a PITA :-)

Mikey

Signed-off-by: Michael Neuling <mikey@neuling.org>

