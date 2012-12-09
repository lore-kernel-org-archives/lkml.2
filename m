Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918Ab2LIT73 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 14:59:29 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:54699 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758871Ab2LIT71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 14:59:27 -0500
Message-ID: <50C4ED46.3070100@linux.vnet.ibm.com>
Date: Mon, 10 Dec 2012 01:27:58 +0530
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
Subject: Re: [RFC PATCH v3 7/9] yield_to(), cpu-hotplug: Prevent offlining
 of other CPUs properly
References: <20121207173702.27305.1486.stgit@srivatsabhat.in.ibm.com> <20121207173950.27305.39499.stgit@srivatsabhat.in.ibm.com> <20121209194826.GB2816@redhat.com>
In-Reply-To: <20121209194826.GB2816@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120919-2674-0000-0000-0000070CE6C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 01:18 AM, Oleg Nesterov wrote:
> On 12/07, Srivatsa S. Bhat wrote:
>>
>> Once stop_machine() is gone from the CPU offline path, we won't be able to
>> depend on local_irq_save() to prevent CPUs from going offline from under us.
> 
> OK, I guess we need to avoid resched_task()->smp_send_reschedule()
> after __cpu_disable() and before migrate_tasks().
> 

Yes.

> But, whatever problem we have,
> 
>> Use the get/put_online_cpus_atomic() APIs to prevent CPUs from going offline,
>> while invoking from atomic context.
> 
> it should be solved, so...
> 
>> -		if (preempt && rq != p_rq)
>> +		if (preempt && rq != p_rq && cpu_online(task_cpu(p)))
> 
> Why do we need this change?
> 
> Afaics, you could add BUG_ON(!cpu_online(...)) instead?
> 
> I am just curious.
>

Oh, I think that's a remnant of v1 (which needed readers to use
cpu_online_stable()). You're right, we don't need it. Or we could put a
BUG_ON instead, like you suggested.

Regards,
Srivatsa S. Bhat

