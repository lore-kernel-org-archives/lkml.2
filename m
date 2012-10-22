Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821Ab2JVCLk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 22:11:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:30850 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932742Ab2JVCLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 22:11:39 -0400
X-IronPort-AV: E=Sophos;i="4.80,627,1344182400"; 
   d="scan'208";a="6039188"
Message-ID: <5084AB10.7010807@cn.fujitsu.com>
Date: Mon, 22 Oct 2012 10:10:24 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: tony.luck@intel.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        miaox@cn.fujitsu.com, laijs@cn.fujitsu.com, wency@cn.fujitsu.com,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 1/2] Replace if statement with WARN_ON_ONCE() in cmci_rediscover().
References: <1350625528-1385-1-git-send-email-tangchen@cn.fujitsu.com> <1350625528-1385-2-git-send-email-tangchen@cn.fujitsu.com> <20121019164045.GE11958@aftab.osrc.amd.com>
In-Reply-To: <20121019164045.GE11958@aftab.osrc.amd.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/22 10:10:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/22 10:11:02,
	Serialize complete at 2012/10/22 10:11:02
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2012 12:40 AM, Borislav Petkov wrote:
> On Fri, Oct 19, 2012 at 01:45:27PM +0800, Tang Chen wrote:
>> cmci_rediscover() is only called by the CPU_POST_DEAD event handler,
>> which means the corresponding cpu has already dead. As a result, it
>> won't be accessed in the for_each_online_cpu loop.
>> So, we could change the if(cpu == dying) statement into a WARN_ON_ONCE().
>>
>> Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
>> ---
>>   arch/x86/kernel/cpu/mcheck/mce_intel.c |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
>> index 38e49bc..481d152 100644
>> --- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
>> +++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
>> @@ -180,8 +180,8 @@ void cmci_rediscover(int dying)
>>   	cpumask_copy(old,&current->cpus_allowed);
>>
>>   	for_each_online_cpu(cpu) {
>> -		if (cpu == dying)
>> -			continue;
>> +		WARN_ON_ONCE(cpu == dying);
>
> Ok, I don't understand that:
>
> we want to warn that the rediscovering is happening on a dying cpu?? And
> before that, we simply jumped over it and didn't do the rediscovering
> there? Why should we warn at all?

Hi Borislav,

As far as I know, cmci_rediscover() is only called in
mce_cpu_callback() to handle CPU_POST_DEAD event.

2362         if (action == CPU_POST_DEAD) {
2363                 /* intentionally ignoring frozen here */
2364                 cmci_rediscover(cpu);
2365         }

I didn't find anywhere else using this function. So I think the cpu
should be dead already when this function is called.

I don't why before we just jumped over it. But I think if we have an
online cpu == dying here, it must be wrong. So I think we should warn
it, not just jump over it.

Thanks. :)


>
> Huh?
>

