Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab2APNnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 08:43:05 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55076 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab2APNnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 08:43:03 -0500
Message-ID: <4F142962.2050606@openvz.org>
Date: Mon, 16 Jan 2012 17:42:58 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20111108 Iceape/2.0.14
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] kvm: remove dependence on delay-accounting
References: <20120114162413.15761.7341.stgit@zurg> <20120114163051.23946.25895.stgit@zurg> <20120116111446.GF7937@amt.cnet>
In-Reply-To: <20120116111446.GF7937@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcelo Tosatti wrote:
> On Sat, Jan 14, 2012 at 08:30:51PM +0400, Konstantin Khlebnikov wrote:
>> KVM selects delay-accounting only to get sched-info for steal-time accounting.
>> Meanwhile delay-accounting can be disabled by boot option. This is ridiculous.
>>
>> This patch adds internal boolean option CONFIG_TASK_SCHED_INFO to enable only
>> task->sched_info and its collecting inside scheduler.
>>

<cut>

>>   static inline int sched_info_on(void)
>>   {
>> -#ifdef CONFIG_SCHEDSTATS
>> +#if IS_ENABLED(CONFIG_SCHEDSTATS) || IS_ENABLED(CONFIG_KVM)
>>   	return 1;
>
> CONFIG_TASK_SCHED_INFO?
>

It makes it equal to constant 1, because all its callers are
under #ifdef CONFIG_TASK_SCHED_INFO =)

its current code:

static inline int sched_info_on(void)
{
#ifdef CONFIG_SCHEDSTATS
	return 1;
#elif defined(CONFIG_TASK_DELAY_ACCT)
	extern int delayacct_on;
	return delayacct_on;
#else
	return 0;
#endif
}

CONFIG_SCHEDSTATS == debug option in lib/Kconfig.debug for /proc/schedstat
CONFIG_TASK_DELAY_ACCT == wierd net-link based statistics collecting tool

Thus, may be better to remove this function, because it can return 0
only if delay-accounting is compiled but disabled by boot option
(delayacct_on =1 by default since 2.6.18)

patch follows...

