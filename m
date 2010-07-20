Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761398Ab0GTQzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 12:55:38 -0400
Received: from smtp-out.google.com ([74.125.121.35]:50220 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758478Ab0GTQzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 12:55:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=PyGROcU+2CGKL2/DYat596hIelErGjLBXOsYkjDzGWFjDjbV4u7TpwlN/dDf3tviZ
	cc4xOnboA01psSq9+HJTg==
MIME-Version: 1.0
In-Reply-To: <20100720095546.2f899e04@mschwide.boeblingen.de.ibm.com>
References: <1279583835-22854-1-git-send-email-venki@google.com>
	<20100720095546.2f899e04@mschwide.boeblingen.de.ibm.com>
Date: Tue, 20 Jul 2010 09:55:29 -0700
Message-ID: <AANLkTiktBNr3pVOHwxX3piwagtkGxHpp5TepBFS3UGhb@mail.gmail.com>
Subject: Re: [PATCH 0/4] Finer granularity and task/cgroup irq time accounting
From: Venkatesh Pallipadi <venki@google.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 12:55 AM, Martin Schwidefsky
<schwidefsky@de.ibm.com> wrote:
> On Mon, 19 Jul 2010 16:57:11 -0700
> Venkatesh Pallipadi <venki@google.com> wrote:
>
>> Currently, the softirq and hardirq time reporting is only done at the
>> CPU level. There are usecases where reporting this time against task
>> or task groups or cgroups will be useful for user/administrator
>> in terms of resource planning and utilization charging. Also, as the
>> accoounting is already done at the CPU level, reporting the same at
>> the task level does not add any significant computational overhead
>> other than task level storage (patch 1).
>
> I never understood why the softirq and hardirq time gets accounted to a
> task at all. Why is it that the poor task that is running gets charged
> with the cpu time of an interrupt that has nothing to do with the task?
> I consider this to be a bug, and now this gets formalized in the
> taskstats interface? Imho not a good idea.

Agree that this is a bug. I started by looking at resolving that. But,
it was not exactly easy. Ideally we want irq times to be charged to
right task as much as possible. With things like network rcv softirq
for example, there is a task thats is going to consume the packet
eventually that should be charged. If we cant find a suitable match we
may have to charge it to some system thread. Things like threaded
interrupts will mitigate this problem a bit. But, until we have a good
enough solution, this bug will be around with us.

This change takes a small step giving hint about this to
user/administrator who can take some corrective action based on it.
Next step is to give CFQ scheduler some info about this and I am
working on a patch for that. That will help in load balancing
decisions, with irq heavy CPU not trying to get equal weight-age as
other CPU. I don't think these interfaces are binding in any way. If
and when we have tasks not being charged for irq, we can simply report
"0" in these interfaces (there is some precedent for this in
/proc/<pid>stat output already).

>> The softirq/hardirq statistics commonly done based on tick based sampling.
>> Though some archs have CONFIG_VIRT_CPU_ACCOUNTING based fine granularity
>> accounting. Having similar mechanism to get fine granularity accounting
>> on x86 will be a major challenge, given the state of TSC reliability
>> on various platforms and also the overhead it may add in common paths
>> like syscall entry exit.
>>
>> An alternative is to have a generic (sched_clock based) and configurable
>> fine-granularity accounting of si and hi time which can be reported
>> over the /proc/<pid>/stat API (patch 2).
>
> To get fine granular accounting for interrupts you need to do a
> sched_clock call on irq entry and another one on irq exit. Isn't that
> too expensive on a x86 system? (I do think this is a good idea but
> still there is the worry about the overhead).

On x86: Yes. Overhead is a potential problem. Thats the reason I had
this inside a CONFIG option. But, I have tested this with few
workloads on different systems released in past two years timeframe
and I did  not see any measurable overhead. Note that this is used
only when sched_clock is based off of TSC and not when it is based on
jiffies. The sched_clock overhead I measured on different platforms
was in 30-150 cycles range, which probably isn't going to be highly
visible in generic workloads.
Archs like s390/powerpc/ia64 already do this kind of accounting with
VIRT_CPU_ACCOUNTING. So, this patch will give them task and cgroup
level info free of charge (other than potential bugs with this code
change :-)).

Thanks,
Venki
