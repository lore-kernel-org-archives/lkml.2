Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab1GNQ6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 12:58:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38065 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab1GNQ6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 12:58:31 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=MwenTAR9eMQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=jdB_tfZz2qQyV-8WrFEA:9 a=7Gj_xNo2Qo1yh_yLbZIA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
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
In-Reply-To: <20110714144946.GA3354@swordfish.minsk.epam.com>
References: <20110714144946.GA3354@swordfish.minsk.epam.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 14 Jul 2011 12:58:27 -0400
Message-ID: <1310662707.27864.38.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-14 at 17:49 +0300, Sergey Senozhatsky wrote:
> [ 4172.371363] Chain exists of:
> [ 4172.371363]   rcu_node_level_0 --> sync_rcu_preempt_exp_wq.lock --> &p->pi_lock
> [ 4172.371370] 
> [ 4172.371371]  Possible unsafe locking scenario:
> [ 4172.371372] 
> [ 4172.371374]        CPU0                    CPU1
> [ 4172.371375]        ----                    ----
> [ 4172.371377]   lock(&p->pi_lock);
> [ 4172.371380]                                lock(sync_rcu_preempt_exp_wq.lock);
> [ 4172.371384]                                lock(&p->pi_lock);
> [ 4172.371387]   lock(rcu_node_level_0);
> [ 4172.371390] 
> [ 4172.371390]  *** DEADLOCK *** 

Here's what I found:

Note: rcu_node_level_0 == rnp->lock from rcu_init_one()

	static char *buf[] = { "rcu_node_level_0",
			       "rcu_node_level_1",
			       "rcu_node_level_2",
			       "rcu_node_level_3" };  /* Match MAX_RCU_LVLS */

	[..]
			raw_spin_lock_init(&rnp->lock);
			lockdep_set_class_and_name(&rnp->lock,
						   &rcu_node_class[i], buf[i]);


We have this call chain:

rcu_report_exp_rnp() {
	raw_spin_lock_irqsave(&rnp->lock, flags);
		wake_up(&sync_rcu_preempt_exp_wq);

		__wake_up() {
			/* q == sync_rcu_preempt_exp_wq */
			spin_lock_irqsave(&q->lock, flags);
				try_to_wake_up() {
					raw_spin_lock_irqsave(&p->pi_lock, flags);

Which gives us the noted lock chain:


rcu_node_level_0 --> sync_rcu_preempt_exp_wq.lock --> &p->pi_lock


But then we have:

try_to_wake_up() {
	raw_spin_lock_irqsave(&p->pi_lock, flags);
	select_task_rq_fair() {
		rcu_read_unlock() {
			rcu_read_unlock_special() {
				raw_spin_lock(&rnp->lock);


Now we have the call chain of &p->pi_lock -> rcu_node_level_O

But to call this we have:

void __rcu_read_unlock(void)
{
	struct task_struct *t = current;

	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
	--t->rcu_read_lock_nesting;
	barrier();  /* decrement before load of ->rcu_read_unlock_special */
	if (t->rcu_read_lock_nesting == 0 &&
	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
		rcu_read_unlock_special(t);

Thus the question is, how did we get rcu_read_unlock_special set here?

-- Steve


