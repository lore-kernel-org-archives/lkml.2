Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab0GTPjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:39:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31854 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab0GTPjN (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 20 Jul 2010 11:39:13 -0400
Date: Tue, 20 Jul 2010 11:38:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Xen-devel <xen-devel@lists.xensource.com>, Avi Kivity <avi@redhat.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [Xen-devel] [PATCH RFC 03/12] x86/ticketlock: Use C for
 __ticket_spin_unlock
Message-ID: <20100720153845.GA9122@phenom.dumpdata.com>
References: <cover.1279328276.git.jeremy.fitzhardinge@citrix.com>
 <f3622d39ae72573c586405ea6f1597eb39fc28d4.1279328276.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3622d39ae72573c586405ea6f1597eb39fc28d4.1279328276.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C45C30D.00BE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/arch/x86/include/asm/spinlock.h
> +++ b/arch/x86/include/asm/spinlock.h
> @@ -33,9 +33,23 @@
>   * On PPro SMP or if we are using OOSTORE, we use a locked operation to unlock
>   * (PPro errata 66, 92)
>   */
> -# define UNLOCK_LOCK_PREFIX LOCK_PREFIX
> +static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
> +{
> +	if (sizeof(lock->tickets.head) == sizeof(u8))
> +		asm (LOCK_PREFIX "incb %0"
> +		     : "+m" (lock->tickets.head) : : "memory");
> +	else
> +		asm (LOCK_PREFIX "incw %0"
> +		     : "+m" (lock->tickets.head) : : "memory");

Should those be 'asm volatile' to make them barriers as well? Or do we
not have to worry about that on a Pentium Pro SMP?

> +
> +}
>  #else
> -# define UNLOCK_LOCK_PREFIX
> +static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
> +{
> +	barrier();
> +	lock->tickets.head++;
> +	barrier();
> +}

Got a question:
This extra barrier() (which I see gets removed in git tree) was
done b/c the function is inlined and hence the second barrier() inhibits
gcc from re-ordering __ticket_spin_unlock instructions? Which is a big
pre-requisite in patch 7 where this function expands to:


 static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 {
       __ticket_t next = lock->tickets.head + 1; // This code
is executed before the lock->tickets.head++ b/c of the 1st barrier?
Or would it be done irregardless b/c gcc sees the data dependency here?

        __ticket_unlock_release(lock); <- expands to
"barrier();lock->tickets.head++;barrier()" 

+       __ticket_unlock_kick(lock, next);   <- so now the second barrier()
affects this code, so it won't re-order the lock->tickets.head++ to be called
after this function?


This barrier ("asm volatile("" : : : "memory")); from what I've been reading
says : "Don't re-order the instructions within this scope and starting
right below me." ? Or is it is just within the full scope of the
function/code logic irregardless of the 'inline' defined in one of them?
