Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab1HIROd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 13:14:33 -0400
Received: from smtpout.kotinet.com ([212.50.215.76]:42710 "EHLO
	smtpout.kotinet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab1HIROc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 13:14:32 -0400
Message-ID: <4E416AF6.1050805@shade-fx.com>
Date: Tue, 09 Aug 2011 20:14:30 +0300
From: Joni Martikainen <joni@shade-fx.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110705 Thunderbird/3.1.11
MIME-Version: 1.0
To: peterz@infradead.org
CC: linux-kernel@vger.kernel.org, davej@redhat.com, arjan.van.de.ven@intel.com
Subject: Re: [PATCH] cpufreq: ondemand ignore_nice_level
References: <4e403bd4.5YAAoSWMDWtU5KOP%joni@shade-fx.com> <1312884759.22367.64.camel@twins>
In-Reply-To: <1312884759.22367.64.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi and thanks for comments

Idea and use case of this patch was to solve situation with fancy
screensavers and image rendering. Both of these takes easily all CPU
power but only rendering should be able to raise CPU speed for it's
use. There is reason to run both of those processes niced so that
computer is pleasant to use during render process. Because
ignore_nice_load does not make difference between nice levels I have
no much ways to say to my system when it should allow speed reducing
and when not.


On 08/09/2011 01:12 PM, Peter Zijlstra wrote:
> How very good of you to CC all the relevant maintainers..
>
> On Mon, 2011-08-08 at 22:41 +0300, joni@shade-fx.com wrote:
>> @@ -3755,7 +3755,7 @@ unsigned long long thread_group_sched_runtime(struct task_struct *p)
>>    * @cputime_scaled: cputime scaled by cpu frequency
>>    */
>>   void account_user_time(struct task_struct *p, cputime_t cputime,
>> -                      cputime_t cputime_scaled)
>> +               cputime_t cputime_scaled)
>>   {
>>          struct cpu_usage_stat *cpustat =&kstat_this_cpu.cpustat;
>>          cputime64_t tmp;
>
> I'm very sure the old alignment was preferred.

I agree, have to be fixed...

>
>> @@ -3769,9 +3769,11 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
>>          tmp = cputime_to_cputime64(cputime);
>>          if (TASK_NICE(p)>  0)
>>                  cpustat->nice = cputime64_add(cpustat->nice, tmp);
>> -       else
>> +       else
>>                  cpustat->user = cputime64_add(cpustat->user, tmp);
>>
>> +       cpustat->nicevalue[TASK_USER_PRIO(p)] = cputime64_add(cpustat->nicevalue[TASK_USER_PRIO(p)], tmp);
>> +
>>          cpuacct_update_stats(p, CPUACCT_STAT_USER, cputime);
>>          /* Account for user time used */
>>          acct_update_integrals(p);
>
> Yay! more senseless accounting.. we really need more of that. What's
> even better is your data array being 320 bytes spanning 5 cachelines,
> and thus the above almost guarantees a cacheline miss.
>
> All round good stuff, and as DaveJ already pointed out, all without any
> justification what so ever.
>
>

Is there some better way to account this kind of stat or is this
information probably available somewhere already? If yes let me know
then.

Cpufreq part actually needs statistic only for processes where p > 0 ,
but I think it does not make any difference to account only those.

Should nice value accounting to be configurable so that user can turn
if off when not needed?

Kind regards,
- Joni
