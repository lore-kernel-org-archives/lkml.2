Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1CJS4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 13:56:19 -0500
Received: from www.tglx.de ([62.245.132.106]:46066 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230Ab1CJS4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 13:56:17 -0500
Date: Thu, 10 Mar 2011 19:55:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michel Lespinasse <walken@google.com>
cc: Darren Hart <darren@dvhart.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] futex: cmpxchg_futex_value_locked API change
In-Reply-To: <20110309112550.GA3050@google.com>
Message-ID: <alpine.LFD.2.00.1103101948540.2787@localhost6.localdomain6>
References: <20110307021127.GB31188@google.com> <alpine.LFD.2.00.1103082114270.2787@localhost6.localdomain6> <20110309112550.GA3050@google.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Mar 2011, Michel Lespinasse wrote:
> On Tue, Mar 08, 2011 at 09:17:11PM +0100, Thomas Gleixner wrote:

Just looked at it again in detail before picking it up. Can we please
separate the s/int/u32/ changes from the real API change ?

>  
> -	pagefault_disable();	/* implies preempt_disable() */
> +	/* Note that preemption is disabled by futex_atomic_cmpxchg_inatomic
> +	 * call sites. */

That wants to be a separate patch as well.
  
> -int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
> +int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
>  {
>  	int op = (encoded_op >> 28) & 7;
>  	int cmp = (encoded_op >> 24) & 15;
> @@ -197,7 +197,7 @@ int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
>  	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
>  		oparg = 1 << oparg;
>  
> -	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
> +	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
>  		return -EFAULT;
>  
>  	pagefault_disable();

So following the reasoning above, shouldn't that be the same for
futex_atomic_op_inuser() ?

Thanks,

	tglx
