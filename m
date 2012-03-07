Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab2CGIK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 03:10:29 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48278 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab2CGIK2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 03:10:28 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <CACvQF52-kZze+SptSCJtsaj=d6b3vg=VgU+Wbqyz-ebYynnUwA@mail.gmail.com>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
	<1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
	<1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
	<1331034734.11248.287.camel@twins>
	<CACvQF52-kZze+SptSCJtsaj=d6b3vg=VgU+Wbqyz-ebYynnUwA@mail.gmail.com>
Date: Wed, 7 Mar 2012 10:10:27 +0200
Message-ID: <CAOtvUMfzMv4AzvaPSWuiV1YM4qh24Eyke1Dm5963Ch+EDsY8=g@mail.gmail.com>
Subject: Re: [RFC PATCH 5/6] implement per-cpu&per-domain state machine call_srcu()
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 4:44 PM, Lai Jiangshan <eag0628@gmail.com> wrote:
> On Tue, Mar 6, 2012 at 7:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Tue, 2012-03-06 at 17:57 +0800, Lai Jiangshan wrote:
>>> +void srcu_barrier(struct srcu_struct *sp)
>>> +{
>>> +       struct srcu_sync sync;
>>> +       struct srcu_head *head = &sync.head;
>>> +       unsigned long chck_seq; /* snap */
>>> +
>>> +       int idle_loop = 0;
>>> +       int cpu;
>>> +       struct srcu_cpu_struct *scp;
>>> +
>>> +       spin_lock_irq(&sp->gp_lock);
>>> +       chck_seq = sp->chck_seq;
>>> +       for_each_possible_cpu(cpu) {
>>
>> ARGH!! this is really not ok.. so we spend all this time killing
>> srcu_sync_expidited and co because they prod at all cpus for no good
>> reason, and what do you do?
>
> it is srcu_barrier(), it have to wait all callbacks complete for all
> cpus since it is per-cpu
> implementation.

I would say it only needs to wait for callbacks to complete for all
CPUs that has a callback pending.

Unless I misunderstood something, that is what your code does already
- it does not wait for completion,
or schedules a work on a CPU that does not has a callback pending, right?

>
>>
>> Also, what happens if your cpu isn't actually online?
>
> The workqueue handles it, not here, if a cpu state machine has callbacks, the
> state machine is started, if it has no callback,  srcu_barrier() does
> nothing for
> this cpu

I understand the point is that offline cpus wont have callbacks, so
nothing would be
done for them, but still, is that a reason to even check? why not use
for_each_online_cpu

I think that if a cpu that was offline went online after your check
and managed to get an
SRCU callback pending it is by definition not a callback srcu_barrier
needs to wait for
since it went pending at a later time then srcu_barrier was called. Or
have I missed something?

Thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
