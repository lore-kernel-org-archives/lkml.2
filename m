Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab1KCEfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 00:35:07 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56589 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab1KCEfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 00:35:03 -0400
X-Originating-IP: 217.70.178.132
X-Originating-IP: 50.43.15.19
Date: Wed, 2 Nov 2011 21:34:41 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 24/28] rcu: Introduce bulk reference
 count
Message-ID: <20111103043441.GF2042@leaf>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
 <1320265849-5744-24-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320265849-5744-24-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 01:30:45PM -0700, Paul E. McKenney wrote:
> The RCU implementations, including SRCU, are designed to be used in a
> lock-like fashion, so that the read-side lock and unlock primitives must
> execute in the same context for any given read-side critical section.
> This constraint is enforced by lockdep-RCU.  However, there is a need for
> something that acts more like a reference count than a lock, in order
> to allow (for example) the reference to be acquired within the context
> of an exception, while that same reference is released in the context of
> the task that encountered the exception.  The cost of this capability is
> that the read-side operations incur the overhead of disabling interrupts.
> Some optimization is possible, and will be carried out if warranted.
> 
> Note that although the current implementation allows a given reference to
> be acquired by one task and then released by another, all known possible
> implementations that allow this have scalability problems.  Therefore,
> a given reference must be released by the same task that acquired it,
> though perhaps from an interrupt or exception handler running within
> that task's context.

This new bulkref API seems in dire need of documentation. :)

> --- a/include/linux/srcu.h
> +++ b/include/linux/srcu.h
> @@ -181,4 +181,54 @@ static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
>  	__srcu_read_unlock(sp, idx);
>  }
>  
> +/* Definitions for bulkref_t, currently defined in terms of SRCU. */
> +
> +typedef struct srcu_struct bulkref_t;
> +int init_srcu_struct_fields(struct srcu_struct *sp);
> +
> +static inline int init_bulkref(bulkref_t *brp)
> +{
> +	return init_srcu_struct_fields(brp);
> +}

Why can't this call init_srcu_struct and avoid the need to use the
previously unexported internal function?

- Josh Triplett
