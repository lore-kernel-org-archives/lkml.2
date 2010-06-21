Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab0FUVXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 17:23:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42059 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758484Ab0FUVXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 17:23:09 -0400
To: paulmck@linux.vnet.ibm.com
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
References: <20100618190251.GA17297@redhat.com>
	<20100618193403.GA17314@redhat.com>
	<20100618223354.GL2365@linux.vnet.ibm.com>
	<20100621170919.GA13826@redhat.com>
	<20100621205128.GI2354@linux.vnet.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 21 Jun 2010 14:22:59 -0700
In-Reply-To: <20100621205128.GI2354@linux.vnet.ibm.com> (Paul E. McKenney's message of "Mon\, 21 Jun 2010 13\:51\:28 -0700")
Message-ID: <m1mxuo2i8c.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: paulmck@linux.vnet.ibm.com, stable@kernel.org, linux-kernel@vger.kernel.org, roland@redhat.com, msb@google.com, jmarchan@redhat.com, mingo@elte.hu, fweisbec@gmail.com, dzickus@redhat.com, akpm@linux-foundation.org, oleg@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;paulmck@linux.vnet.ibm.com
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:

> On Mon, Jun 21, 2010 at 07:09:19PM +0200, Oleg Nesterov wrote:
>> On 06/18, Paul E. McKenney wrote:
>> >
>> > On Fri, Jun 18, 2010 at 09:34:03PM +0200, Oleg Nesterov wrote:
>> > >
>> > > 	#define XXX(t)	({
>> > > 		struct task_struct *__prev = t;
>> > > 		t = next_thread(t);
>> > > 		t != g && t != __prev;
>> > > 	})
>> > >
>> > > 	#define while_each_thread(g, t) \
>> > > 		while (XXX(t))
>> >
>> > Isn't the above vulnerable to a pthread_create() immediately following
>> > the offending exec()?  Especially if the task doing the traversal is
>> > preempted?
>> 
>> Yes, thanks!
>> 
>> > here are some techniques that might (or might not) help:
>> 
>> To simplify, let's consider the concrete example,
>
> Sounds very good!
>
>> 	rcu_read_lock();
>> 
>> 	g = t = returns_the_rcu_safe_task_struct_ptr();
>
> This returns a pointer to the task struct of the current thread?
> Or might this return a pointer some other thread's task struct?
>
>> 	do {
>> 		printk("%d\n", t->pid);
>> 	} while_each_thread(g, t);
>> 
>> 	rcu_read_unlock();
>> 
>> Whatever we do, without tasklist/siglock this can obviously race
>> with fork/exit/exec. It is OK to miss a thread, or print the pid
>> of the already exited/released task.
>> 
>> But it should not loop forever (the subject), and it should not
>> print the same pid twice (ignoring pid reuse, of course).
>> 
>> And, afaics, there are no problems with rcu magic per se, next_thread()
>> always returns the task_struct we can safely dereference. The only
>> problem is that while_each_thread() assumes that sooner or later
>> next_thread() must reach the starting point, g.
>> 
>> (zap_threads() is different, it must not miss a thread with ->mm
>>  we are going to dump, but it holds mmap_sem).
>
> Indeed, the tough part is figuring out when you are done given that things
> can come and go at will.  Some additional tricks, in no particular order:
>
> 1.	Always start at the group leader.  Of course, the group leader
> 	is probably permitted to leave any time it wants to, so this
> 	is not sufficient in and of itself.

No.  The group leader must exist as long as the group exists.
Modulo de_thread weirdness.  The group_leader can be a zombie but
it can not go away completely.

> 2.	Maintain a separate task structure that flags the head of the
> 	list.  This separate structure is freed one RCU grace period
> 	following the disappearance of the current group leader.  This
> 	should be quite robust, but "holy overhead, Batman!!!"  (Apologies
> 	for the American pop culture reference, but nothing else seemed
> 	appropriate.)

That is roughly what we have in the group leader right now.

Eric
