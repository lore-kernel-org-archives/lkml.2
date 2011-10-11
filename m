Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1JKDP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 23:15:59 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:42002 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab1JKDP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 23:15:56 -0400
Message-ID: <4E93B51A.4020204@oracle.com>
Date: Tue, 11 Oct 2011 11:16:42 +0800
From: DuanZhenzhong <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
User-Agent: Thunderbird 2.0.0.24 (X11/20101209)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-x86_64@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, Joe Jin <joe.jin@oracle.com>
Subject: Re: [PATCH] cpu idle ticks show twice in xen pvm guest
References: <ce19ea02-45e6-465a-a4c8-b5d74bf8c2ad@default> <20111010155319.GA29140@phenom.oracle.com> <4E934EC9.5030909@goop.org>
In-Reply-To: <4E934EC9.5030909@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet23.oracle.com [156.151.31.71]
X-CT-RefId: str=0001.0A090204.4E93B4E9.0024,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> On 10/10/2011 08:53 AM, Konrad Rzeszutek Wilk wrote:
>   
>> On Wed, Oct 05, 2011 at 10:11:58PM -0700, Zhenzhong Duan wrote:
>>     
>>> Run below test on xen pvm.
>>> # x=$(cat /proc/stat | grep cpu0 | awk '{print $5}') && sleep 60  \
>>> && y=$(cat /proc/stat | grep cpu0 | awk '{print $5}') \
>>> && echo -e  "X:$x\nY:$y\nIDLE:" $(echo "scale=3; ($y-$x)/6000*100" | bc)
>>>
>>> @ X:58562301
>>> @ Y:58574282
>>> @ IDLE: 199.600
>>>
>>> Normal idle percent should be around 100%.
>>> xen_timer_interrupt called account_idle_ticks to account hypervisor stolen idle ticks 
>>> but these ticks will be accounted again when idle ticks restarted.
>>>
>>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
>>> Signed-off-by: Joe Jin <joe.jin@oracle.com>
>>>       
>> Please in the future also CC the maintainers (you can get that using
>> the scripts/get_maintainer.pl).
>>
>> Jeremy, any thoughts?
>>     
>
> Does this affect the accounting of stolen ticks?  If it does, that's not
> necessarily a showstopper for this patch, but we'll need to do some more
> thinking about it.  Certainly, accurate accounting for idleness is
> important.
>
>     J
>
>   
Thanks Konrad for point out that.
In Original kernel, tick_nohz_restart_sched_tick and 
do_stolen_accounting both called account_idle_ticks.
For a idle pvm, idle/iowait maybe doubled apparently.
Normally Y-X should get close to 6000 in idle system, but in my test 
it's 11981.
But I am still not sure if patch has any impact to other part. Thanks
>>> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
>>> index 163b467..5dcbc91 100644
>>> --- a/arch/x86/xen/time.c
>>> +++ b/arch/x86/xen/time.c
>>> @@ -151,7 +151,6 @@ static void do_stolen_accounting(void)
>>>  
>>>  	ticks = iter_div_u64_rem(blocked, NS_PER_TICK, &blocked);
>>>  	__this_cpu_write(xen_residual_blocked, blocked);
>>> -	account_idle_ticks(ticks);
>>>  }
>>>  
>>>  /* Get the TSC speed from Xen */
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>       
>
>   


-- 
Regards
zhenzhong
--
Oracle Building, No.24 Building, Zhongguancun Software Park
Haidian District, Beijing 100193, China

