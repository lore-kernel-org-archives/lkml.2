Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487Ab2LJFDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 00:03:33 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:39006 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab2LJFDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 00:03:31 -0500
Message-ID: <50C56CC0.4000200@linux.vnet.ibm.com>
Date: Mon, 10 Dec 2012 10:31:52 +0530
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
References: <20121207173702.27305.1486.stgit@srivatsabhat.in.ibm.com> <20121207173759.27305.84316.stgit@srivatsabhat.in.ibm.com> <20121209191437.GA2816@redhat.com> <50C4EB79.5050203@linux.vnet.ibm.com> <20121209211338.GA8090@redhat.com>
In-Reply-To: <20121209211338.GA8090@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121005-1396-0000-0000-00000245E24A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 02:43 AM, Oleg Nesterov wrote:
> Damn, sorry for noise. I missed this part...
> 
> On 12/10, Srivatsa S. Bhat wrote:
>>
>> On 12/10/2012 12:44 AM, Oleg Nesterov wrote:
>>> the latency. And I guess something like kick_all_cpus_sync() is "too heavy".
>>
>> I hadn't considered that. Thinking of it, I don't think it would help us..
>> It won't get rid of the currently running preempt_disable() sections no?
> 
> Sure. But (again, this is only my feeling so far) given that get_online_cpus_atomic()
> does cli/sti,

Ah, that one! Actually, the only reason I do that cli/sti is because, potentially
interrupt handlers can be hotplug readers too. So we need to protect the portion
of the code of get_online_cpus_atomic() which is not re-entrant.
(Which reminds me to try and reduce the length of cli/sti in that code, if possible).

> this can help to implement ensure-the-readers-must-see-the-pending-writer.
> IOW this might help to implement sync-with-readers.
> 

2 problems:

1. It won't help with cases like this:

   preempt_disable()
	...
	preempt_disable()
		...
			<------- Here
		...
	preempt_enable()
	...
   preempt_enable()

If the IPI hits at the point marked above, the IPI is useless, because, at
that point, since we are already in a nested read-side critical section, we can't
switch the synchronization protocol. We need to wait till we start a fresh
non-nested read-side critical section, in order to switch to global rwlock.
The reason is that preempt_enable() or put_online_cpus_atomic() can only undo
what its predecessor (preempt_disable()/get_online_cpus_atomic()) did.

2. Part of the reason we want to get rid of stop_machine() is to avoid the
latency it induces on _all_ CPUs just to take *one* CPU offline. If we use
kick_all_cpus_sync(), we get into that territory again : we unfairly interrupt
every CPU, _even when_ that CPU's existing preempt_disabled() sections might
not actually be hotplug readers! (ie., not bothered about CPU Hotplug).

So, I think whatever synchronization scheme we develop, must not induce the very
same problems that stop_machine() had. Otherwise, we can end up going a full-circle
and coming back to the same stop_machine() scenario that we intended to get rid of.

(That's part of the reason why I initially tried to provide that _light() variant
of the reader APIs in the previous version of the patchset, so that light readers
can remain as undisturbed from cpu hotplug as possible, thereby avoiding indirectly
inducing the "stop_machine effect", like I mentioned here:
https://lkml.org/lkml/2012/12/5/369)

Regards,
Srivatsa S. Bhat

