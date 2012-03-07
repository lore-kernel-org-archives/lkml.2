Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab2CGJQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 04:16:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:46846 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab2CGJQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 04:16:39 -0500
X-IronPort-AV: E=Sophos;i="4.73,545,1325433600"; 
   d="scan'208";a="4480304"
Message-ID: <4F572892.5010803@cn.fujitsu.com>
Date: Wed, 07 Mar 2012 17:21:22 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Gilad Ben-Yossef <gilad@benyossef.com>
CC: Lai Jiangshan <eag0628@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org
Subject: Re: [RFC PATCH 5/6] implement per-cpu&per-domain state machine call_srcu()
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>	<1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>	<1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>	<1331034734.11248.287.camel@twins>	<CACvQF52-kZze+SptSCJtsaj=d6b3vg=VgU+Wbqyz-ebYynnUwA@mail.gmail.com> <CAOtvUMfzMv4AzvaPSWuiV1YM4qh24Eyke1Dm5963Ch+EDsY8=g@mail.gmail.com>
In-Reply-To: <CAOtvUMfzMv4AzvaPSWuiV1YM4qh24Eyke1Dm5963Ch+EDsY8=g@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 17:14:38,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 17:14:44,
	Serialize complete at 2012-03-07 17:14:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2012 04:10 PM, Gilad Ben-Yossef wrote:
> On Tue, Mar 6, 2012 at 4:44 PM, Lai Jiangshan <eag0628@gmail.com> wrote:
>> On Tue, Mar 6, 2012 at 7:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>>> On Tue, 2012-03-06 at 17:57 +0800, Lai Jiangshan wrote:
>>>> +void srcu_barrier(struct srcu_struct *sp)
>>>> +{
>>>> +       struct srcu_sync sync;
>>>> +       struct srcu_head *head = &sync.head;
>>>> +       unsigned long chck_seq; /* snap */
>>>> +
>>>> +       int idle_loop = 0;
>>>> +       int cpu;
>>>> +       struct srcu_cpu_struct *scp;
>>>> +
>>>> +       spin_lock_irq(&sp->gp_lock);
>>>> +       chck_seq = sp->chck_seq;
>>>> +       for_each_possible_cpu(cpu) {
>>>
>>> ARGH!! this is really not ok.. so we spend all this time killing
>>> srcu_sync_expidited and co because they prod at all cpus for no good
>>> reason, and what do you do?
>>
>> it is srcu_barrier(), it have to wait all callbacks complete for all
>> cpus since it is per-cpu
>> implementation.
> 
> I would say it only needs to wait for callbacks to complete for all
> CPUs that has a callback pending.

Right.
The code above flush_workqueue() wait until all of them are delivered.
flush_workqueue() wait until all of them are completely invoked.

> 
> Unless I misunderstood something, that is what your code does already
> - it does not wait for completion,
> or schedules a work on a CPU that does not has a callback pending, right?
> 
>>
>>>
>>> Also, what happens if your cpu isn't actually online?
>>
>> The workqueue handles it, not here, if a cpu state machine has callbacks, the
>> state machine is started, if it has no callback,  srcu_barrier() does
>> nothing for
>> this cpu
> 
> I understand the point is that offline cpus wont have callbacks, so
> nothing would be
> done for them, but still, is that a reason to even check? why not use
> for_each_online_cpu

It is possible that the offline cpus have callbacks during hot-plugging.

> 
> I think that if a cpu that was offline went online after your check
> and managed to get an
> SRCU callback pending it is by definition not a callback srcu_barrier
> needs to wait for
> since it went pending at a later time then srcu_barrier was called. Or
> have I missed something?
> 
> Thanks,
> Gilad
> 

