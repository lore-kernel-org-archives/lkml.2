Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab1JJUAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 16:00:13 -0400
Received: from claw.goop.org ([74.207.240.146]:41575 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab1JJUAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 16:00:12 -0400
Message-ID: <4E934EC9.5030909@goop.org>
Date: Mon, 10 Oct 2011 13:00:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Zhenzhong Duan <zhenzhong.duan@oracle.com>, linux-x86_64@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [PATCH] cpu idle ticks show twice in xen pvm guest
References: <ce19ea02-45e6-465a-a4c8-b5d74bf8c2ad@default> <20111010155319.GA29140@phenom.oracle.com>
In-Reply-To: <20111010155319.GA29140@phenom.oracle.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2011 08:53 AM, Konrad Rzeszutek Wilk wrote:
> On Wed, Oct 05, 2011 at 10:11:58PM -0700, Zhenzhong Duan wrote:
>> Run below test on xen pvm.
>> # x=$(cat /proc/stat | grep cpu0 | awk '{print $5}') && sleep 60  \
>> && y=$(cat /proc/stat | grep cpu0 | awk '{print $5}') \
>> && echo -e  "X:$x\nY:$y\nIDLE:" $(echo "scale=3; ($y-$x)/6000*100" | bc)
>>
>> @ X:58562301
>> @ Y:58574282
>> @ IDLE: 199.600
>>
>> Normal idle percent should be around 100%.
>> xen_timer_interrupt called account_idle_ticks to account hypervisor stolen idle ticks 
>> but these ticks will be accounted again when idle ticks restarted.
>>
>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
>> Signed-off-by: Joe Jin <joe.jin@oracle.com>
> Please in the future also CC the maintainers (you can get that using
> the scripts/get_maintainer.pl).
>
> Jeremy, any thoughts?

Does this affect the accounting of stolen ticks?  If it does, that's not
necessarily a showstopper for this patch, but we'll need to do some more
thinking about it.  Certainly, accurate accounting for idleness is
important.

    J

>> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
>> index 163b467..5dcbc91 100644
>> --- a/arch/x86/xen/time.c
>> +++ b/arch/x86/xen/time.c
>> @@ -151,7 +151,6 @@ static void do_stolen_accounting(void)
>>  
>>  	ticks = iter_div_u64_rem(blocked, NS_PER_TICK, &blocked);
>>  	__this_cpu_write(xen_residual_blocked, blocked);
>> -	account_idle_ticks(ticks);
>>  }
>>  
>>  /* Get the TSC speed from Xen */
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

