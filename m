Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab2FFJwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:52:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:5480 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755622Ab2FFJwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:52:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="148807391"
Message-ID: <4FCF284B.7050902@linux.intel.com>
Date: Wed, 06 Jun 2012 17:52:11 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Luck, Tony" <tony.luck@intel.com>, "bp@amd64.org" <bp@amd64.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86/mce: Fix the MCE poll timer logic
References: <1338863702-9245-1-git-send-email-gong.chen@linux.intel.com> <tip-958fb3c51295764599d6abce87e1a01ace897a3e@git.kernel.org> <4FCF0C03.9010400@linux.intel.com> <alpine.LFD.2.02.1206061120270.3086@ionos>
In-Reply-To: <alpine.LFD.2.02.1206061120270.3086@ionos>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012/6/6 17:27, Thomas Gleixner 写道:
> On Wed, 6 Jun 2012, Chen Gong wrote:
>> In fact, there still exists another potential issue:
>>
>> static void __mcheck_cpu_init_timer(void)
>> {
>>         struct timer_list *t = &__get_cpu_var(mce_timer);
>>         unsigned long iv = __this_cpu_read(mce_next_interval);
>>
>>         setup_timer(t, mce_timer_fn, smp_processor_id());
>>
>>         if (mce_ignore_ce)
>>                 return;
>>
>>         __this_cpu_write(mce_next_interval, iv);
>>         if (!iv)
>>                 return;
>> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>
>> Because the 2nd patch is not merged yet, so here iv is zero when this
>> function is called, which means at the beginning, the poll timers are
>> not registered until some other conditions trigger *add_timer_on*.
> Dammit. I dropped the 
>
> 	iv = check_interval * HZ;
>
> line before __this_cpu_write() and nobody noticed. :(
>  
>>         t->expires = round_jiffies(jiffies + iv);
>>         add_timer_on(t, smp_processor_id());
>> }
>>
>> Another potential issue is in this function two smp_processor_id()
>> are called. If conext changes during this procedure (I'm not sure
>> if it can hapen, besides secondary_cpu kickoff, online/offline will
> No. This code is always called with preemption disabled.
>
>> call these functions, even in virtualization envrionment, etc.).
> What has virtualization to do with that ?
>
>> So I think it will be better saving the value in the beginning of
>> this function. Make sense?
> No. Otherwise all the __this_cpu_read/write accesses are bogus as
> well.
>
>
Oh, yes, since __this_cpu_read/write can be used here, there no context
issue.
Please ignore my over-thinking.
