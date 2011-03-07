Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab1CGIyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:54:55 -0500
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:48090 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab1CGIyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:54:50 -0500
Date: Mon, 7 Mar 2011 09:54:38 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Michel Lespinasse <walken@google.com>
Cc: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] futex: cmpxchg_futex_value_locked API change
Message-ID: <20110307095438.7d963d0f@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20110307021127.GB31188@google.com>
References: <20110307021127.GB31188@google.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Mar 2011 18:11:27 -0800
Michel Lespinasse <walken@google.com> wrote:

> Aplogies for the long CC list - as this proposal involves asm changes
> in many architectures, and I have only been able to test on x86,
> I have tried to include one maintainer from every arch so they can
> hopefully double check me. I do think I got all architectures right,
> but you can never be 100% sure...
> 
> -static int __futex_atomic_cmpxchg_pt(int __user *uaddr, int oldval, int newval)
> +static int __futex_atomic_cmpxchg_pt(int *uval, int __user *uaddr,
> +				     int oldval, int newval)
>  {
>  	int ret;
> 
>  	asm volatile("0: cs   %1,%4,0(%5)\n"
> -		     "1: lr   %0,%1\n"
> +		     "1: l    %0,0\n"
>  		     "2:\n"
>  		     EX_TABLE(0b,2b) EX_TABLE(1b,2b)
>  		     : "=d" (ret), "+d" (oldval), "=m" (*uaddr)
>  		     : "0" (-EFAULT), "d" (newval), "a" (uaddr), "m" (*uaddr)
>  		     : "cc", "memory" );
> +	*uval = oldval;
>  	return ret;
>  }

That "l %0,0" is incorrect; if you want to load a zero into %0 you can use "la %0,0".

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

