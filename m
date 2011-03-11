Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab1CKCRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 21:17:08 -0500
Received: from smtp-out.google.com ([74.125.121.67]:12971 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab1CKCRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 21:17:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W7k5a6HRBMfHPncs1paGPZ/oO52g2ONfECgAvA+Q95Bd5EC/h/FYIPqQTOXv4JbFba
         SPEMw+FwdLRuAcvEAtlg==
Date: Thu, 10 Mar 2011 18:16:54 -0800
From: Michel Lespinasse <walken@google.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <darren@dvhart.com>, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20110311021654.GA26122@google.com>
References: <20110307021127.GB31188@google.com>
 <alpine.LFD.2.00.1103082114270.2787@localhost6.localdomain6>
 <20110309112550.GA3050@google.com>
 <alpine.LFD.2.00.1103101948540.2787@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103101948540.2787@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 07:55:05PM +0100, Thomas Gleixner wrote:
> On Wed, 9 Mar 2011, Michel Lespinasse wrote:
> > On Tue, Mar 08, 2011 at 09:17:11PM +0100, Thomas Gleixner wrote:
> 
> Just looked at it again in detail before picking it up. Can we please
> separate the s/int/u32/ changes from the real API change ?
> 
> > -	pagefault_disable();	/* implies preempt_disable() */
> > +	/* Note that preemption is disabled by futex_atomic_cmpxchg_inatomic
> > +	 * call sites. */
> 
> That wants to be a separate patch as well.

No problems. That makes it 3 patches, will send as replies to this.

> > -int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
> > +int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
> >  {
> >  	int op = (encoded_op >> 28) & 7;
> >  	int cmp = (encoded_op >> 24) & 15;
> > @@ -197,7 +197,7 @@ int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
> >  	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
> >  		oparg = 1 << oparg;
> >  
> > -	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
> > +	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
> >  		return -EFAULT;
> >  
> >  	pagefault_disable();
> 
> So following the reasoning above, shouldn't that be the same for
> futex_atomic_op_inuser() ?

futex_atomic_op_inuser() is currently called by core futex code with
page faults enabled. I think that's OK - for futex_atomic_cmpxchg_inatomic
I fixed the arm implementation because it was inconsistent with the
other ones, but for futex_atomic_op_inuser() every arch does it
that way.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
