Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964890Ab2EaUgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:36:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8380 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab2EaUf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:35:58 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=6I2XFdsDAPIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=xDSAQ_2pYmEkZUIePVQA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338496555.13348.429.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 4/5] x86: Allow nesting of the debug stack IDT setting
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Dave Jones <davej@redhat.com>, Andi Kleen <ak@linux.intel.com>
Date: Thu, 31 May 2012 16:35:55 -0400
In-Reply-To: <4FC7D1F7.8090405@zytor.com>
References: <20120531012829.160060586@goodmis.org>
	   <20120531020441.500105258@goodmis.org> <4FC7BF59.3070906@zytor.com>
	  <1338492300.13348.384.camel@gandalf.stny.rr.com>
	  <4FC7C62C.1020807@zytor.com>
	 <1338494431.13348.410.camel@gandalf.stny.rr.com>
	 <4FC7D1F7.8090405@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 13:17 -0700, H. Peter Anvin wrote:

> Ouch.  This is really way more complex than it has any excuse for being,
> and it's the complexity that concerns me, not the performance.

Complexity is my Sun, and I am the planet that orbits around it.

> 
> I'd like a chart, or list, of the alternate stack environments we can be
> in and what can transfer to what.  I think there might be an easier
> solution that is more robust.

Well, it's not as bad as one might think:

#define STACKFAULT_STACK 1
#define DOUBLEFAULT_STACK 2
#define NMI_STACK 3
#define DEBUG_STACK 4
#define MCE_STACK 5
#define N_EXCEPTION_STACKS 5  /* hw limit: 7 */

These are the exceptions that have their own stacks.

arch/x86/kernel/traps.c:        set_intr_gate_ist(X86_TRAP_DB, &debug, DEBUG_STACK);
arch/x86/kernel/traps.c:        set_system_intr_gate_ist(X86_TRAP_BP, &int3, DEBUG_STACK);
arch/x86/kernel/traps.c:        set_intr_gate_ist(X86_TRAP_NMI, &nmi, NMI_STACK);
arch/x86/kernel/traps.c:        set_intr_gate_ist(X86_TRAP_DF, &double_fault, DOUBLEFAULT_STACK);
arch/x86/kernel/traps.c:        set_intr_gate_ist(X86_TRAP_SS, &stack_segment, STACKFAULT_STACK);
arch/x86/kernel/traps.c:        set_intr_gate_ist(X86_TRAP_MC, &machine_check, MCE_STACK);

We only have two IDT tables that are fixed and are switched via the NMI
handler (debug_stack_set_zero), as well as this patch set.

head_64.S:

ENTRY(idt_table)
	.skip IDT_ENTRIES * 16

	.align L1_CACHE_BYTES
ENTRY(nmi_idt_table)
	.skip IDT_ENTRIES * 16


Only the DEBUG stack has a double size:

arch/x89/kernel/cpu/common.c:

static const unsigned int exception_stack_sizes[N_EXCEPTION_STACKS] = {
	  [0 ... N_EXCEPTION_STACKS - 1]	= EXCEPTION_STKSZ,
	  [DEBUG_STACK - 1]			= DEBUG_STKSZ
};


Thus only the debug stack does the stack TSS trick.

Is this what you were looking for? (God, it just shows how much time
I've been spending on this crap, as I was able to find all this by
memory and not grepping for it :-p )

-- Steve


