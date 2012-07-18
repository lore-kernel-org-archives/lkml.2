Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab2GRMWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 08:22:46 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:57606 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab2GRMWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 08:22:43 -0400
Message-ID: <5006AA40.1090408@linux.vnet.ibm.com>
Date: Wed, 18 Jul 2012 17:51:20 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Michal Hocko <mhocko@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] fix idle ticks in cpu summary line of /proc/stat
References: <20120311182621.41674b39@de.ibm.com> <20120312121726.GA23608@tiehlicka.suse.cz> <20120312101739.26eb373e@de.ibm.com>	<4F5E0CC1.6010102@linux.vnet.ibm.com> <20120312153906.GE3994@tiehlicka.suse.cz> <20120312164145.5110ed5c@de.ibm.com> <20120313080748.GA7754@tiehlicka.suse.cz> <4F5F0623.6080702@linux.vnet.ibm.com> <20120718135255.1eafb680@de.ibm.com>
In-Reply-To: <20120718135255.1eafb680@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12071812-2000-0000-0000-0000084FDF19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 05:22 PM, Martin Schwidefsky wrote:
> On Tue, 13 Mar 2012 14:02:35 +0530
> "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> 
>> On 03/13/2012 01:37 PM, Michal Hocko wrote:
>>
>>> OK, so the updated version of the patch looks like this. I am sorry but
>>> I had time to only compile test this...
>>> ---
>>> From d12247f14c5f8b00ae97a87442f62e49227a759b Mon Sep 17 00:00:00 2001
>>> From: Michal Hocko <mhocko@suse.cz>
>>> Date: Mon, 12 Mar 2012 13:11:38 +0100
>>> Subject: [PATCH] nohz: fix idle ticks in cpu summary line of /proc/stat
>>>
>>> Git commit 09a1d34f8535ecf9 "nohz: Make idle/iowait counter update
>>> conditional" introduced a bug in regard to cpu hotplug. The effect is
>>> that the number of idle ticks in the cpu summary line in /proc/stat is
>>> still counting ticks for offline cpus.
>>>
>>> Reproduction is easy, just start a workload that keeps all cpus busy,
>>> switch off one or more cpus and then watch the idle field in top.
>>> On a dual-core with one cpu 100% busy and one offline cpu you will get
>>> something like this:
>>>
>>> %Cpu(s): 48.7 us,  1.3 sy,  0.0 ni, 50.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
>>>
>>> The problem is that an offline cpu still has ts->idle_active == 1.
>>> To fix this we should make sure that the cpu is online when calling
>>> get_cpu_idle_time_us and get_cpu_iowait_time_us.
>>>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>> Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
>>> Reported-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
>>> Signed-off-by: Michal Hocko <mhocko@suse.cz>
>>> ---
>>>  fs/proc/stat.c |   14 ++++++++++----
>>>  1 files changed, 10 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/proc/stat.c b/fs/proc/stat.c
>>> index 121f77c..62bda24 100644
>>> --- a/fs/proc/stat.c
>>> +++ b/fs/proc/stat.c
>>> @@ -24,10 +24,13 @@
>>>
>>>  static u64 get_idle_time(int cpu)
>>>  {
>>> -	u64 idle, idle_time = get_cpu_idle_time_us(cpu, NULL);
>>> +	u64 idle, idle_time = -1ULL;
>>> +
>>> +	if (cpu_online(cpu))
>>> +		idle_time = get_cpu_idle_time_us(cpu, NULL);
>>>
>>>  	if (idle_time == -1ULL) {
>>> -		/* !NO_HZ so we can rely on cpustat.idle */
>>> +		/* !NO_HZ or cpu offline so we can rely on cpustat.idle */
>>>  		idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
>>>  		idle += arch_idle_time(cpu);
>>>  	} else
>>> @@ -38,10 +41,13 @@ static u64 get_idle_time(int cpu)
>>>
>>>  static u64 get_iowait_time(int cpu)
>>>  {
>>> -	u64 iowait, iowait_time = get_cpu_iowait_time_us(cpu, NULL);
>>> +	u64 iowait, iowait_time = -1ULL;
>>> +
>>> +	if (cpu_online(cpu))
>>> +		iowait_time = get_cpu_iowait_time_us(cpu, NULL);
>>>
>>>  	if (iowait_time == -1ULL)
>>> -		/* !NO_HZ so we can rely on cpustat.iowait */
>>> +		/* !NO_HZ or cpu offline so we can rely on cpustat.iowait */
>>>  		iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
>>>  	else
>>>  		iowait = usecs_to_cputime64(iowait_time);
>>
>>
>>
>> Yeah, this looks much better..
>>
>> Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> 
> What happened to this patch? The fix for s390 (git commit cb85a6ed67e979c59
> "proc: stats: Use arch_idle_time for idle and iowait times if available"
> is upstream but the fix for non-s390 systems is missing, no?
> 

Oh, right! Thomas, could you kindly pick up Michal's patch please?

Martin had outlined the relationship between the 2 patches here:
http://thread.gmane.org/gmane.linux.kernel/1265374/focus=1276336

Regards,
Srivatsa S. Bhat

