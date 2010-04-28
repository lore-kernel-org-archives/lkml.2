Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab0D1Rq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 13:46:56 -0400
Received: from mail.openrapids.net ([64.15.138.104]:53505 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754850Ab0D1Rqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 13:46:55 -0400
Date: Wed, 28 Apr 2010 13:46:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Greg KH <gregkh@suse.de>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [170/197] lockdep: fix incorrect percpu usage
Message-ID: <20100428174653.GB4205@Krystal>
References: <20100422191857.GA13268@kroah.com> <20100422190922.618832798@kvm.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100422190922.618832798@kvm.kroah.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:46:05 up 95 days, 20:23,  7 users,  load average: 0.02, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (gregkh@suse.de) wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> 
> The mainline kernel as of 2.6.34-rc5 is not affected by this problem because
> commit 10fad5e46f6c7bdfb01b1a012380a38e3c6ab346 fixed it by refactoring.
> 
> lockdep fix incorrect percpu usage
> 
> Should use per_cpu_ptr() to obfuscate the per cpu pointers (RELOC_HIDE is needed
> for per cpu pointers).
> 
> git blame points to commit:
> 
> lockdep.c: commit 8e18257d29238311e82085152741f0c3aa18b74d
> 
> But it's really just moving the code around. But it's enough to say that the
> problems appeared before Jul 19 01:48:54 2007, which brings us back to 2.6.23.
> 
> It should be applied to stable 2.6.23.x to 2.6.33.x (or whichever of these
> stable branches are still maintained).

Tejun, (same as module.c patch) should this patch be applied to 2.6.32.x, or
will it cause problems on ia64 ?

Thanks,

Mathieu

> 
> (tested on 2.6.33.1 x86_64)
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Randy Dunlap <randy.dunlap@oracle.com>
> CC: Eric Dumazet <dada1@cosmosbay.com>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Tejun Heo <tj@kernel.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Greg Kroah-Hartman <gregkh@suse.de>
> CC: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  kernel/lockdep.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -591,9 +591,9 @@ static int static_obj(void *obj)
>  	 * percpu var?
>  	 */
>  	for_each_possible_cpu(i) {
> -		start = (unsigned long) &__per_cpu_start + per_cpu_offset(i);
> -		end   = (unsigned long) &__per_cpu_start + PERCPU_ENOUGH_ROOM
> -					+ per_cpu_offset(i);
> +		start = (unsigned long) per_cpu_ptr(&__per_cpu_start, i);
> +		end   = (unsigned long) per_cpu_ptr(&__per_cpu_start
> +						    + PERCPU_ENOUGH_ROOM, i);
>  
>  		if ((addr >= start) && (addr < end))
>  			return 1;
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
