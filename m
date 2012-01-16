Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab2APOFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 09:05:07 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56674 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab2APOFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 09:05:05 -0500
Message-ID: <4F142E8D.3060808@openvz.org>
Date: Mon, 16 Jan 2012 18:05:01 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20111108 Iceape/2.0.14
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] kvm: remove dependence on delay-accounting
References: <20120114162413.15761.7341.stgit@zurg>	 <20120114163051.23946.25895.stgit@zurg> <1326720836.2442.231.camel@twins>
In-Reply-To: <1326720836.2442.231.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Sat, 2012-01-14 at 20:30 +0400, Konstantin Khlebnikov wrote:
>> KVM selects delay-accounting only to get sched-info for steal-time accounting.
>> Meanwhile delay-accounting can be disabled by boot option. This is ridiculous.
>>
>> This patch adds internal boolean option CONFIG_TASK_SCHED_INFO to enable only
>> task->sched_info and its collecting inside scheduler.
>
> Urgh, more stupid config knobs, we should be removing them, not adding
> moar.

Unfortunately, removing task-delay-accounting is not the option =)

>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 868cb83..dd5bf78 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -734,7 +734,6 @@ extern struct user_struct root_user;
>>
>>   struct backing_dev_info;
>>
>> -#if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
>>   struct sched_info {
>>   	/* cumulative counters */
>>   	unsigned long pcount;	      /* # of times run on this cpu */
>> @@ -744,7 +743,6 @@ struct sched_info {
>>   	unsigned long long last_arrival,/* when we last ran on a cpu */
>>   			   last_queued;	/* when we were last queued to run */
>>   };
>> -#endif /* defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT) */
>
> Not having that structure helps with compile errors.

I don't think so, this only helps to catch useless declarations and definitions
in code and inside other structures.

>
>>   #ifdef CONFIG_TASK_DELAY_ACCT
>>   struct task_delay_info {
>> @@ -782,7 +780,7 @@ struct task_delay_info {
>>
>>   static inline int sched_info_on(void)
>>   {
>> -#ifdef CONFIG_SCHEDSTATS
>> +#if IS_ENABLED(CONFIG_SCHEDSTATS) || IS_ENABLED(CONFIG_KVM)
>
> WTF is IS_ENABLED and why do you use it?

IS_ENABLED(smth) == (defined(smth) || defined(smth_MODULE))
but using it for CONFIG_SCHEDSTATS is overkill, indeed.

>
>
> Not much like this stuff.

