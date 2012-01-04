Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab2ADRRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:17:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756447Ab2ADRRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:17:16 -0500
Message-ID: <4F04898B.1080600@redhat.com>
Date: Wed, 04 Jan 2012 19:16:59 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        vatsa@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <87sjke1a53.fsf@abhimanyu.in.ibm.com> <4EF1B85F.7060105@redhat.com> <877h1o9dp7.fsf@linux.vnet.ibm.com> <20111223103620.GD4749@elte.hu> <4EF701C7.9080907@redhat.com> <20111230095147.GA10543@elte.hu> <878vlu4bgh.fsf@linux.vnet.ibm.com> <87pqf5mqg4.fsf@abhimanyu.in.ibm.com> <4F017AD2.3090504@redhat.com> <87mxa3zqm1.fsf@abhimanyu.in.ibm.com> <4F046536.5080207@redhat.com> <4F048295.1050907@redhat.com>
In-Reply-To: <4F048295.1050907@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2012 06:47 PM, Rik van Riel wrote:
>> So it looks like the default is optimal, at least wrt the cases you
>> tested and your test workload.
>
>
> It depends on the workload.
>
> I believe ebizzy synchronously bounces messages around between
> userland threads, and may benefit from lower latency preemption
> and re-scheduling.
>
> Workloads like AMQP do asynchronous messaging, and are likely
> to benefit from having a lower number of switches.
>
> I do not know which kind of workload is more prevalent.
>
> Another worry with gang scheduling is scalability.  One of
> the reasons Linux scales well to larger systems is that a
> lot of things are done CPU local, without communicating
> things with other CPUs.  Making the scheduling algorithm
> system-global has the potential to add in a lot of overhead.
>
> Likewise, removing the ability to migrate workloads to idle
> CPUs is likely to hurt a lot of real world workloads.
>
> Benchmarks don't care, because they run full-out. However,
> users do not run benchmarks nearly as much as they run
> actual workloads...
>

I think we can solve it at the guest level.  The paravirt ticketlock
stuff introduces wait/wake calls (actually wait is just a HLT
instruction); we could spin for a while, then HLT until the other side
wakes us.  We should do this for all sites that busy wait.

-- 
error compiling committee.c: too many arguments to function

