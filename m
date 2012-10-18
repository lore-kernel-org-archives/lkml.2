Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab2JRDnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 23:43:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16623 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab2JRDnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 23:43:47 -0400
X-IronPort-AV: E=Sophos;i="4.80,605,1344182400"; 
   d="scan'208";a="6020035"
Message-ID: <507F7AAF.3070400@cn.fujitsu.com>
Date: Thu, 18 Oct 2012 11:42:39 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: tony.luck@intel.com, bp@amd64.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] Do not change worker's running cpu in cmci_rediscover().
References: <1348737586-7018-1-git-send-email-tangchen@cn.fujitsu.com> <20121016230824.GG16166@google.com>
In-Reply-To: <20121016230824.GG16166@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/18 11:43:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/18 11:43:24,
	Serialize complete at 2012/10/18 11:43:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 07:08 AM, Tejun Heo wrote:
> On Thu, Sep 27, 2012 at 05:19:46PM +0800, Tang Chen wrote:
>> 1. cmci_rediscover() is only called by the CPU_POST_DEAD event handler, which
>> means the corresponding cpu has already dead. As a result, it won't be accessed
>> in the for_each_online_cpu loop.
>> So, we could change the if(cpu == dying) statement into a BUG_ON().
>
> Let's please move this to a separate patch and use WARN_ON_ONCE()
> instead.

OK, no problem. :)

>
>> 2. cmci_rediscover() used set_cpus_allowed_ptr() to change the current process's
>> running cpu, and migrate itself to the dest cpu. But worker processes are not
>> allowed to be migrated. If current is a worker, the worker will be migrated to
>> another cpu, but the corresponding  worker_pool is still on the original cpu.
>>
>> In this case, the following BUG_ON in try_to_wake_up_local() will be triggered:
>> BUG_ON(rq != this_rq());
>>
>> This will cause the kernel panic.
>>
>> This patch removes the set_cpus_allowed_ptr() call, and put the cmci rediscover
>> jobs onto all the other cpus using system_wq. This could bring some delay for
>> the jobs.

> After separating out the fix part into a separate patch, please add
> Cc: stable@vger.kernel.org.

OK, I will.

>
> The change looks correct to me but fails to apply to the current
> mainline.

I'll update it and resend it soon. :)
Thanks.

>
> Thanks!
>

