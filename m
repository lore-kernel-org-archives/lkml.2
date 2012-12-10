Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab2LJEaN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 23:30:13 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:50559 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab2LJEaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 23:30:11 -0500
Message-ID: <50C564ED.9090803@linux.vnet.ibm.com>
Date: Mon, 10 Dec 2012 09:58:29 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/9] CPU hotplug: Provide APIs to prevent CPU offline
 from atomic context
References: <20121207173702.27305.1486.stgit@srivatsabhat.in.ibm.com> <20121207173759.27305.84316.stgit@srivatsabhat.in.ibm.com> <20121209191437.GA2816@redhat.com> <50C4EB79.5050203@linux.vnet.ibm.com> <20121209202234.GA5793@redhat.com>
In-Reply-To: <20121209202234.GA5793@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121004-3864-0000-0000-000005ED8AB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 01:52 AM, Oleg Nesterov wrote:
> On 12/10, Srivatsa S. Bhat wrote:
>>
>> On 12/10/2012 12:44 AM, Oleg Nesterov wrote:
>>
>>> But yes, it is easy to blame somebody else's code ;) And I can't suggest
>>> something better at least right now. If I understand correctly, we can not
>>> use, say, synchronize_sched() in _cpu_down() path
>>
>> We can't sleep in that code.. so that's a no-go.
> 
> But we can?
> 
> Note that I meant _cpu_down(), not get_online_cpus_atomic() or take_cpu_down().
> 

Maybe I'm missing something, but how would it help if we did a
synchronize_sched() so early (in _cpu_down())? Another bunch of preempt_disable()
sections could start immediately after our call to synchronize_sched() no?
How would we deal with that?

What we need to ensure here is that all existing preempt_disable() sections
are over and that *we* (meaning, the cpu offline writer) get to proceed immediately
after that, making all the new readers wait for us. And that is possible only if
we do our 'wait-for-readers' thing very close to our actual cpu offline operation
(which is take_cpu_down). Moreover, the writer needs to remain stable
(non-preemptible) while doing the wait-for-readers. Else (if the writer himself
keeps getting scheduled in and out of the CPU) I can't see how he can possibly
do justice to the wait.

Also, synchronize_sched() only helps us do the 'wait-for-existing-readers' logic.
What would take care of the 'prevent-new-readers-from-going-ahead' logic?

To add to it all, synchronize_sched() waits for _all_ preempt_disable() sections
to complete, whereas only a handful of them might actually care about CPU hotplug.
Which is an unnecessary burden for the writer (ie., waiting for unrelated readers
to complete).

I bet you meant something else. Sorry if I misunderstood it.

Regards,
Srivatsa S. Bhat

