Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab1FGR3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 13:29:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:55047 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab1FGR3b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 13:29:31 -0400
Subject: Re: [PATCH] sched: remove rcu_read_lock from wake_affine
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110607172606.GA2286@linux.vnet.ibm.com>
References: <20110607101251.777.34547.stgit@IBM-009124035060.in.ibm.com>
	 <1307442411.2322.246.camel@twins>
	 <20110607172606.GA2286@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 07 Jun 2011 19:29:23 +0200
Message-ID: <1307467763.2322.282.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 10:26 -0700, Paul E. McKenney wrote:
> 
> Nikunj, one such approach is is "WARN_ON_ONCE(!rcu_read_lock_held())".
> 
> This will complain if this function is called without an rcu_read_lock()
> in effect, but only if CONFIG_PROVE_RCU=y.

rcu_lockdep_assert(rcu_read_lock_held()) would be nicer, however, since
the below:

> > >  static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
> > >  {
> > >     s64 this_load, load;
> > > @@ -1481,7 +1482,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
> > >      * effect of the currently running task from the load
> > >      * of the current CPU:
> > >      */
> > > -   rcu_read_lock();
> > >     if (sync) {
> > >             tg = task_group(current);
> > >             weight = current->se.load.weight; 

task_group() has an rcu_dereference_check() in, its really not needed,
the thing will yell if we get this wrong.
