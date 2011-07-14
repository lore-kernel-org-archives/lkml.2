Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab1GNRCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 13:02:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52424 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab1GNRCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 13:02:13 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=MwenTAR9eMQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ZgbreupA_i01k0DUJOsA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: INFO: possible circular locking dependency detected
From: Steven Rostedt <rostedt@goodmis.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1310662707.27864.38.camel@gandalf.stny.rr.com>
References: <20110714144946.GA3354@swordfish.minsk.epam.com>
	 <1310662707.27864.38.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 14 Jul 2011 13:02:09 -0400
Message-ID: <1310662929.27864.40.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-14 at 12:58 -0400, Steven Rostedt wrote:

> void __rcu_read_unlock(void)
> {
> 	struct task_struct *t = current;
> 
> 	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
> 	--t->rcu_read_lock_nesting;
> 	barrier();  /* decrement before load of ->rcu_read_unlock_special */
> 	if (t->rcu_read_lock_nesting == 0 &&
> 	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
> 		rcu_read_unlock_special(t);
> 
> Thus the question is, how did we get rcu_read_unlock_special set here?

Looks like another process could set this with:

static int rcu_boost(struct rcu_node *rnp)
{
	[...]
	t = container_of(tb, struct task_struct, rcu_node_entry);
	rt_mutex_init_proxy_locked(&mtx, t);
	t->rcu_boost_mutex = &mtx;
	t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BOOSTED;

-- Steve


