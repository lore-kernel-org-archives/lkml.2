Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130Ab0EYVpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 17:45:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3688 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759096Ab0EYVpJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 17:45:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=BVRfLUU2gP7LWm5HnphK+bm4c27AqRPnMoQ/q0CUxmXrTISLRpLVExpwa0NidYupm
	58TQ1+hiVvxJLVWkOWzWw==
MIME-Version: 1.0
In-Reply-To: <20100525091300.GN3519@balbir.in.ibm.com>
References: <1274746282-21533-1-git-send-email-venki@google.com>
	<1274746282-21533-2-git-send-email-venki@google.com>
	<20100525091300.GN3519@balbir.in.ibm.com>
Date: Tue, 25 May 2010 14:45:03 -0700
Message-ID: <AANLkTinFyHV1HdX1TcOX_-sqf_5-Xdqo0q-z9HZo4qqz@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] sched: Track and export per task [hard|soft]irq 
	time
From: Venkatesh Pallipadi <venki@google.com>
To: balbir@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 2:13 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * Venkatesh Pallipadi <venki@google.com> [2010-05-24 17:11:19]:
>
>> Currently, kernel does not have accounting mechanism for softirq and hardirq
>> times at the task level. There is irq time info in kstat_cpu which is
>> accumulated at the cpu level.
>>
>> Without the task level information, the non irq run time of task(s) would
>> have to be guessed based on their exec time and CPU on which they were
>> running recently and assuming that the CPU irq time reported are spread
>> across all the tasks running there. And this guess can be widely off the mark.
>>
>> Sample case, considering just the softirq:
>>
>> If there are varied workloads running on a CPU, say a CPU bound task (loop)
>> and a network IO bound task (nc) along with the network softirq load,
>> there is no way for the administrator/user to know the non-irq runtime of each
>> of these tasks. Only information available is the total runtime for each of the
>> tasks and kstat_cpu softirq time for the CPU.
>>
>> In this example, considering a 10 second sample, both loop and nc would have
>> total run time of ~5s. And kstat_cpu softirq on this cpu increase was
>> 355 (~3.5s).
>>
>> So, all the information the user gets is that both the tasks are running for
>> roughly the same amount of time and softirq is around 35%. As a result user
>> may conclude that irq overhead for both tasks are equal (1.75s) and the
>> non-irq runtime of both the tasks are around ~3.25s. Yes. There is another
>> factor of system and user time reported for these tasks that I am ignoring
>> as that is tough to correlate with irq time, in cases where the tasks have
>> significant non-irq system time.
>>
>> This change adds tracking of softirq time on each task and task group.
>> This information is exported in /proc/<pid>/stat.
>>
>> So, the user can get info like below, looking at exec_time and si_time in
>> appropriate /proc/<pid>/stat.
>> (Taken for a 10s interval)
>> task exec_time softirqtime (in USER_HZ)
>> (loop)  (nc)
>> 505 0   500 359
>> 502 1   501 363
>> 503 0   502 354
>> 504 0   499 359
>> 503 3   500 360
>>
>> with this, user can get the non-irq run time as 5s and ~1.45s for
>> loop and nc, respectively.
>
> Have you noticed any overheads after these changes? Otherwise, the
> changes look correct to me.
>

Haven't noticed any significant overhead yet. But, I am yet to run this on wide
array of systems. Will post the data once I have them.

Thanks,
Venki
