Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702Ab2CVL6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 07:58:37 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:48735 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859Ab2CVL6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 07:58:35 -0400
Message-ID: <4F6B13BC.7090102@linux.vnet.ibm.com>
Date: Thu, 22 Mar 2012 17:27:48 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, mce: Add persistent MCE event
References: <1332340496-21658-1-git-send-email-bp@amd64.org> <1332340496-21658-3-git-send-email-bp@amd64.org> <4F6AE48D.4070508@linux.vnet.ibm.com> <20120322114051.GB30026@aftab>
In-Reply-To: <20120322114051.GB30026@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12032211-2674-0000-0000-000003CCA34E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 05:10 PM, Borislav Petkov wrote:

> On Thu, Mar 22, 2012 at 02:06:29PM +0530, Srivatsa S. Bhat wrote:
>>> +err_unwind:
>>> +	err = -EINVAL;
>>> +	for (--cpu; cpu >= 0; cpu--)
>>> +		perf_rm_persistent_on_cpu(cpu, &per_cpu(mce_ev, cpu));
>>> +
>>
>>
>> *Totally* theoretical question: How do you know that the cpu_online_mask isn't
>> sparse? In other words, what if some CPUs weren't booted? Then this for-loop
>> wouldn't be very good..
>>
>> Oh, now I see that perf_rm_persistent_on_cpu() probably handles that case well..
>> So no issues I guess.. ?
> 
> Right, this could theoretically come around to bite us in some obscure
> cases, so we probably fix it from the get-go.
> 
>> (Moreover, we will probably have bigger issues at hand if some CPU didn't
>> boot..)
>>
>> (The code looked funny, so I thought of pointing it out, whether or not it
>> actually is worrisome. Sorry for the noise, if any).
> 
> Right, no, thanks for pointing it out.
> 
> I'll probably do something like the following:
> 
> 	for (--cpu; cpu >= 0; cpu--)
> 		if (cpu_online(cpu))
> 			perf_rm_persistent_on_cpu(cpu, &per_cpu(mce_ev, cpu));
> 
> to be on the safe side from that perspective.
> 


You can do that or something like the following, to make it more readable:

int cpunum;

for_each_online_cpu(cpunum) {
	if (cpunum == cpu)
		break;
	perf_rm_persistent_on_cpu(cpunum, &per_cpu(mce_ev, cpunum));
}

It is of course, up to you.. whichever form you prefer..

Regards,
Srivatsa S. Bhat

