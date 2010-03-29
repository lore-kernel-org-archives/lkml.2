Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab0C2TVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 15:21:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63874 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab0C2TVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 15:21:38 -0400
X-Authority-Analysis: v=1.0 c=1 a=yqlkXEV8x04A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=7d_E57ReAAAA:8 a=yPCof4ZbAAAA:8 a=FsJUqAuNAAAA:8 a=Tty9oNO6AAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=meVymXHHAAAA:8 a=hOcEJDhqPqEo0Qbn3ScA:9 a=jm9RBlBu-nELeFWZbLvI9ZjtHScA:4 a=PUjeQqilurYA:10 a=D6-X0JM3zdQA:10 a=7DSvI1NPTFQA:10 a=pzSI60jIEQsA:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2.6.29.x - 2.6.31.1] module: fix __module_ref_addr()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable <stable@kernel.org>
In-Reply-To: <20100327143126.GA25615@Krystal>
References: <20100327143126.GA25615@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 29 Mar 2010 15:21:32 -0400
Message-ID: <1269890492.19685.4767.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does not apply to 2.6.34-rc, and the code in upstream looks
to have been fixed. Should this go to stable?

-- Steve


On Sat, 2010-03-27 at 10:31 -0400, Mathieu Desnoyers wrote:
> __module_ref_addr() should use per_cpu_ptr() to obfuscate the pointer
> (RELOC_HIDE is needed for per cpu pointers).
> 
> This non-standard per-cpu pointer use has been introduced by commit
> 720eba31f47aeade8ec130ca7f4353223c49170f
> 
> It causes a NULL pointer exception on some configurations when CONFIG_TRACING is
> enabled on 2.6.33. This patch fixes the problem (acknowledged by Randy who
> reported the bug).
> 
> It did not appear to hurt previously because most of the accesses were done
> through local_inc, which probably obfuscated the access enough that no compiler
> optimizations were done. But with local_read() done when CONFIG_TRACING is
> active, this becomes a problem. Non-CONFIG_TRACING is probably affected as well
> (module.c contains local_set and local_read that use __module_ref_addr()), but I
> guess nobody noticed because we've been lucky enough that the compiler did not
> generate the inappropriate optimization pattern there.
> 
> This patch should be queued for the 2.6.29.x through 2.6.33.x stable branches.
> (tested on 2.6.33.1 x86_64)
> 
> The __module_ref_addr() problem disappears in 2.6.34-rc kernels because these
> percpu accesses were re-factored.
> 
> It makes me wonder about other non-standard uses of per_cpu_offset: there is one
> in module.c and two in lockdep.c, which are still in 2.6.34-rc. This should
> probably be fixed by the code authors in separate patches.
> 
> lockdep.c: commit 8e18257d29238311e82085152741f0c3aa18b74d
> module.c: commit 6b588c18f8dacfa6d7957c33c5ff832096e752d3
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Tested-by: Randy Dunlap <randy.dunlap@oracle.com>
> CC: Eric Dumazet <dada1@cosmosbay.com>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Tejun Heo <tj@kernel.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Greg Kroah-Hartman <gregkh@suse.de>
> CC: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/module.h |    2 +-
>  kernel/module.c        |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6-lttng/include/linux/module.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/linux/module.h	2010-03-25 11:01:53.000000000 -0400
> +++ linux-2.6-lttng/include/linux/module.h	2010-03-25 11:01:59.000000000 -0400
> @@ -467,7 +467,7 @@ void symbol_put_addr(void *addr);
>  static inline local_t *__module_ref_addr(struct module *mod, int cpu)
>  {
>  #ifdef CONFIG_SMP
> -	return (local_t *) (mod->refptr + per_cpu_offset(cpu));
> +	return (local_t *) per_cpu_ptr(mod->refptr, cpu);
>  #else
>  	return &mod->ref;
>  #endif
> 


