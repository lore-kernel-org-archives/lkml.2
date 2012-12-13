Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab2LMQeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:34:07 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:52198 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2LMQeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:34:04 -0500
Message-ID: <50CA0317.90501@linux.vnet.ibm.com>
Date: Thu, 13 Dec 2012 22:02:23 +0530
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
Subject: Re: [RFC PATCH v4 1/9] CPU hotplug: Provide APIs to prevent CPU offline
 from atomic context
References: <20121211140314.23621.64088.stgit@srivatsabhat.in.ibm.com> <20121211140358.23621.97011.stgit@srivatsabhat.in.ibm.com> <20121212171720.GA22289@redhat.com> <50C8C4A5.4080104@linux.vnet.ibm.com> <20121212180248.GA24882@redhat.com> <50C8CD52.8040808@linux.vnet.ibm.com> <20121212184849.GA26784@redhat.com> <50C8D739.6030903@linux.vnet.ibm.com> <50C9F38F.3020005@linux.vnet.ibm.com> <20121213161709.GA19125@redhat.com>
In-Reply-To: <20121213161709.GA19125@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121316-0260-0000-0000-0000024A3FC4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 09:47 PM, Oleg Nesterov wrote:
> On 12/13, Srivatsa S. Bhat wrote:
>>
>> On 12/13/2012 12:42 AM, Srivatsa S. Bhat wrote:
>>>
>>> Even I don't spot anything wrong with it. But I'll give it some more
>>> thought..
>>
>> Since an interrupt handler can also run get_online_cpus_atomic(), we
>> cannot use the __this_cpu_* versions for modifying reader_percpu_refcnt,
>> right?
> 
> Hmm. I thought that __this_cpu_* must be safe under preempt_disable().
> IOW, I thought that, say, this_cpu_inc() is "equal" to preempt_disable +
> __this_cpu_inc() correctness-wise.
>
> And. I thought that this_cpu_inc() is safe wrt interrupt, like local_t.
> 
> But when I try to read the comments percpu.h, I am starting to think that
> even this_cpu_inc() is not safe if irq handler can do the same?
> 

The comment seems to say that its not safe wrt interrupts. But looking at
the code in include/linux/percpu.h, IIUC, that is true only about
this_cpu_read() because it only disables preemption.

However, this_cpu_inc() looks safe wrt interrupts because it wraps the
increment within raw_local_irqsave()/restore().

> Confused...
> 
> I am shy to ask... will, say, DEFINE_PER_CPU(local_t) and
> local_inc(__this_cpu_ptr(...)) work??
> 
>> But still, this scheme is better, because the reader doesn't have to spin
>> on the read_lock() with interrupts disabled.
> 
> Yes, but my main concern is that irq_disable/enable itself is not that cheap.
> 

Regards,
Srivatsa S. Bhat

