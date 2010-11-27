Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab0K0PU3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 10:20:29 -0500
Received: from mail.openrapids.net ([64.15.138.104]:53757 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752547Ab0K0PU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 10:20:28 -0500
Date: Sat, 27 Nov 2010 10:20:26 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thisops uV2 09/10] x86: this_cpu_cmpxchg and
	this_cpu_cmpxchg_double operations
Message-ID: <20101127152026.GA15758@Krystal>
References: <20101126210937.383047168@linux.com> <20101126210954.166783984@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101126210954.166783984@linux.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:07:52 up 3 days, 20:10,  3 users,  load average: 0.04, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> Provide support as far as the hardware capabilities of the x86 cpus
> allow.
> 
> V1->V2:
> 	- Mark %rdx clobbering during cmpxchg16b
> 	- Provide emulation of cmpxchg16b for early AMD processors
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

[...]
> +/*
> + * Something is screwed up with alternate instruction creation. This one
> + * fails with a mysterious asm error about a byte val > 255.

Hrm, "interesting" ;) Does each of these work if expressed directly in inline
assembly without the alternatives ? Can you give us more information about the
failure ?

> + */
> +#define percpu_cmpxchg16b(pcp, o1, o2, n1, n2)			\
> +({									\
> +	char __ret;							\
> +	typeof(o1) __o1 = o1;						\
> +	typeof(o1) __n1 = n1;						\
> +	typeof(o2) __o2 = o2;						\
> +	typeof(o2) __n2 = n2;						\
> +	typeof(o2) __dummy;						\
> +	VM_BUG_ON(((unsigned long)pcp) % 16);				\

Restricting typing on "pcp" at build time might be more appropriate. E.g.
creating a "struct doublecas" that would be forcefully aligned on 16 bytes. We
could check that with __builtin_types_compatible_p and generate a build failure
if necessary.

Thanks,

Mathieu

> +	alternative_io("call cmpxchg16b_local\n\t" P6_NOP4,		\
> +			"cmpxchg16b %%gs:(%%rsi)\n\tsetz %0\n\t",	\
> +			X86_FEATURE_CX16,				\
> +		    	ASM_OUTPUT2("=a"(__ret), "=d"(__dummy)),	\
> +		        "S" (pcp), "b"(__n1), "c"(__n2),		\
> +			 "a"(__o1), "d"(__o2));				\
> +	__ret;								\
> +})

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
