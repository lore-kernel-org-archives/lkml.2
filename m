Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab0HQN1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 09:27:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52287 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab0HQN1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 09:27:22 -0400
X-Authority-Analysis: v=1.1 cv=nbWoJD01ruQLYOYE44JZbYtzz81AmFDL3LnuPvZDHs8= c=1 sm=0 a=ApKsrK4jzPIA:10 a=Q9fys5e9bTEA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=PrqykDpG06oujDh4OCEA:9 a=AuIVs7ItiKjp6KBH9U9FhuP_zrEA:4 a=PUjeQqilurYA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Subject: Re: [PATCH tip/core/rcu 08/10] rcu: Add a TINY_PREEMPT_RCU
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com
In-Reply-To: <20100816220705.GA18650@Krystal>
References: <20100809221447.GA24358@linux.vnet.ibm.com>
	 <1281392111-25060-8-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20100816150737.GB8320@Krystal> <20100816183355.GH2388@linux.vnet.ibm.com>
	 <20100816191947.GA970@Krystal> <20100816213200.GK2388@linux.vnet.ibm.com>
	 <20100816214123.GA15663@Krystal> <20100816215555.GL2388@linux.vnet.ibm.com>
	 <20100816220705.GA18650@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 17 Aug 2010 09:27:19 -0400
Message-ID: <1282051639.3268.1335.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 18:07 -0400, Mathieu Desnoyers wrote:

> > Moving this down past the check of t->rcu_read_lock_special (which is
> > now covered by ACCESS_ONCE()) would violate the C standard, as it would
> > be equivalent to moving a volatile up past a sequence point.
> 
> Hrm, I'm not quite convinced yet. I am not concerned about gcc moving
> the volatile access prior to the sequence point (as you say, this is
> forbidden by the C standard), but rather that:
> 
> --(t->rcu_read_lock_nesting)
> 
> could be split in two distinct operations:
> 
> read t->rcu_read_lock_nesting
> decrement t->rcu_read_lock_nesting
> 
> Note that in order to know the result required to pass the sequence
> point "&&" (the test), we only need to perform the read, not the
> decrement. AFAIU, gcc would be in its rights to move the
> t->rcu_read_lock_nesting update after the volatile access.
> 

If we are this concerned, what about just doing:

	--t->rcu_read_lock_nesting;
        if (ACCESS_ONCE(t->rcu_read_lock_nesting) == 0 &&
             unlikely((ACCESS_ONCE(t->rcu_read_unlock_special)))

-- Steve


