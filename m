Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab1BOPR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 10:17:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab1BOPRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 10:17:22 -0500
Message-ID: <4D5A9909.90305@redhat.com>
Date: Tue, 15 Feb 2011 17:17:29 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH v3 3/6] KVM-GST: KVM Steal time accounting
References: <1297448364-14051-1-git-send-email-glommer@redhat.com>	 <1297448364-14051-4-git-send-email-glommer@redhat.com>	 <4D5A8F28.4090306@redhat.com> <1297781155.2413.16.camel@twins>
In-Reply-To: <1297781155.2413.16.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2011 04:45 PM, Peter Zijlstra wrote:
> On Tue, 2011-02-15 at 16:35 +0200, Avi Kivity wrote:
>> On 02/11/2011 08:19 PM, Glauber Costa wrote:
>>> This patch accounts steal time time in kernel/sched.
>>> I kept it from last proposal, because I still see advantages
>>> in it: Doing it here will give us easier access from scheduler
>>> variables such as the cpu rq. The next patch shows an example of
>>> usage for it.
>>>
>>> Since functions like account_idle_time() can be called from
>>> multiple places, not only account_process_tick(), steal time
>>> grabbing is repeated in each account function separatedely.
>>>
>> I still don't see how we export this to userspace for top(1) and friends.
>>
> The existing steal time stuff is:
>
>   kernel/sched.c:account_steal_time()
>
> 	cpustat->steal = cputime64_add(cpustat->steal, cputime64);
>
> and
>
>   fs/proc/stat.c:show_stat()
>
>
> 	steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
>
> 	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu "
> 		"%llu\n",
> 		(unsigned long long)cputime64_to_clock_t(user),
> 		(unsigned long long)cputime64_to_clock_t(nice),
> 		(unsigned long long)cputime64_to_clock_t(system),
> 		(unsigned long long)cputime64_to_clock_t(idle),
> 		(unsigned long long)cputime64_to_clock_t(iowait),
> 		(unsigned long long)cputime64_to_clock_t(irq),
> 		(unsigned long long)cputime64_to_clock_t(softirq),
> 		(unsigned long long)cputime64_to_clock_t(steal),
> 		(unsigned long long)cputime64_to_clock_t(guest),
> 		(unsigned long long)cputime64_to_clock_t(guest_nice));
>
>

Ah, so we're all set.  Do you know if any user tools process this 
information?
