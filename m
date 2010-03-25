Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab0CYPf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 11:35:29 -0400
Received: from mail.openrapids.net ([64.15.138.104]:55488 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753999Ab0CYPf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 11:35:27 -0400
Date: Thu, 25 Mar 2010 11:35:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.29.x - 2.6.31.1] module: fix __module_ref_addr()
Message-ID: <20100325153524.GB22007@Krystal>
References: <20100325153436.GA22007@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100325153436.GA22007@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:34:47 up 61 days, 18:11,  6 users,  load average: 0.26, 0.75,
	0.91
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(should really have CC'd lkml, here it is)

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
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
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
