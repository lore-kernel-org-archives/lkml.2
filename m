Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030324Ab2HPSr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:47:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933145Ab2HPSrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:47:18 -0400
Message-ID: <502D3FB2.7000008@redhat.com>
Date: Thu, 16 Aug 2012 14:45:06 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: preeti <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins> <502C98E8.20800@linux.vnet.ibm.com> <502CFD35.5000801@linux.intel.com>
In-Reply-To: <502CFD35.5000801@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 10:01 AM, Arjan van de Ven wrote:
>> *Power policy*:
>>
>> So how is power policy different? As Peter says,'pack more than spread
>> more'.
>
> this is ... a dubiously general statement.
>
> for good power, at least on Intel cpus, you want to spread. Parallelism is efficient.
>
> the only thing you do not want to do, is wake cpus up for
> tasks that only run extremely briefly (think "100 usec" or less).
>
> so maybe the balance interval is slightly different, or more, you don't balance tasks that
> historically ran only for brief periods

This makes me think that maybe, in addition to tracking
the idle residency time in the c-state governor, we may
also want to track the average run times in the scheduler.

The c-state governor can call the scheduler code before
putting a CPU to sleep, to indicate (1) the wakeup latency
of the CPU, and (2) whether TLB and/or cache get invalidated.

At wakeup time, the scheduler can check whether the CPU
the to-be-woken process ran on is in a deeper sleep state,
and whether the typical run time for the process significantly
exceeds the wakeup latency of the CPU it last ran on.

If the process typically runs for a short interval, and/or
the process's CPU lost its cached state, it may be better
to run the just-woken task on the CPU that is doing the
waking up, instead of on the CPU where it used to run.

Does that make sense?

Am I overlooking any factors?

