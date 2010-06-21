Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629Ab0FUVUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 17:20:07 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:55801 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758624Ab0FUVUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 17:20:01 -0400
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
References: <20100618190251.GA17297@redhat.com>
	<20100618193403.GA17314@redhat.com>
	<20100618223354.GL2365@linux.vnet.ibm.com>
	<20100621170919.GA13826@redhat.com>
	<20100621174455.GA14886@redhat.com>
	<20100621190212.C8630400C5@magilla.sf.frob.com>
	<20100621200633.GA21099@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 21 Jun 2010 14:19:53 -0700
In-Reply-To: <20100621200633.GA21099@redhat.com> (Oleg Nesterov's message of "Mon\, 21 Jun 2010 22\:06\:33 +0200")
Message-ID: <m1vd9c2idi.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: oleg@redhat.com, stable@kernel.org, linux-kernel@vger.kernel.org, msb@google.com, jmarchan@redhat.com, mingo@elte.hu, fweisbec@gmail.com, dzickus@redhat.com, akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com, roland@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 0; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: ; sa06 0; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: _RELAYCOUNTRY_
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 06/21, Roland McGrath wrote:
>>
>> > Paul, Roland, do you see any problems from the correctness pov,
>> > or a better fix for now?
>> >
>> > Perhaps it also makes sense to keep the old variant renamed to
>> > while_each_thread_locked(), I dunno.
>>
>> Did we verify that only de_thread() can create the situation where a
>> while_each_thread-style loop without either lock can be confused?
>
> I think yes, this is is the only case.
>
> I mean, while_each_thread(group_leader, t). If g != group_leader, then
> the lockless while_each_thread() has problems with the plain exit(g).
>
> Afaics. The more I think about this, the more I feel confused ;)
>
> But if we start from ->group_leader, then while_each_thread() must
> stop eventually. Otherwise we should assume that the dead (unhashed)
> tasks can create the circular list, obviously this is not possible.
>
>> If
>> that's so, then just changing it to avoid the situation seems like it
>> would be less invasive overall.
>
> How? We should change ->group_leader uner write_lock_irq(tasklist),
> synchronize_rcu() is not an option. We can't do call_rcu(release_task),
> we can't take tasklist for writing in the softirq context. But even
> if we could, this can't help in fact or I missed something.

We already do: call_rcu(&p->rcu, delayed_put_task_struct); in release_task.
We don't call release_task until after we have removed it as leader and
dropped the write lock. 

At first glance it sounds like the group leader is safe as a stopping
point for a rcu while_each_thread, and I expect the fact that
de_thread takes everything down to a single thread, could have nice
properties here.  If pid_alive were only to fail on the group leader
when de_thread is called I think we could legitimately say that an event
we won't worry about.  It is close enough to a new thread being created
anyway.

Eric
