Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab1GAOU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:20:27 -0400
Received: from mail.candelatech.com ([208.74.158.172]:53424 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689Ab1GAOUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:20:24 -0400
Message-ID: <4E0DD7A5.7020106@candelatech.com>
Date: Fri, 01 Jul 2011 07:20:21 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Thunderbird/3.1.9
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] slub: Enable backtrace for create/delete points.
References: <1309308462-20124-1-git-send-email-greearb@candelatech.com> <1309308462-20124-2-git-send-email-greearb@candelatech.com> <alpine.DEB.2.00.1107010905350.2458@router.home>
In-Reply-To: <alpine.DEB.2.00.1107010905350.2458@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2011 07:08 AM, Christoph Lameter wrote:
> On Tue, 28 Jun 2011, greearb@candelatech.com wrote:
>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 35f351f..3477ce5 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -191,8 +191,12 @@ static LIST_HEAD(slab_caches);
>>   /*
>>    * Tracking user of a slab.
>>    */
>> +#define TRACK_ADDRS_COUNT 16
>>   struct track {
>> -	unsigned long addr;	/* Called from address */
>> +	unsigned long caddr;
>
> Keep the name the same since its role does not change. That makes the
> patch touch less code.
>
>> +#ifdef CONFIG_STACKTRACE
>> +	unsigned long addrs[TRACK_ADDRS_COUNT];	/* Called from address */
>> +#endif
>>   	int cpu;		/* Was running on cpu */
>>   	int pid;		/* Pid context */
>>   	unsigned long when;	/* When did the operation occur */
>> @@ -420,7 +424,25 @@ static void set_track(struct kmem_cache *s, void *object,
>>   	struct track *p = get_track(s, object, alloc);
>>
>>   	if (addr) {
>> -		p->addr = addr;
>> +#ifdef CONFIG_STACKTRACE
>> +		struct stack_trace trace;
>> +		int i;
>> +
>> +		trace.nr_entries = 0;
>> +		trace.max_entries = TRACK_ADDRS_COUNT;
>> +		trace.entries = p->addrs;
>> +		trace.skip = 3;
>> +		save_stack_trace(&trace);
>> +
>> +		/* See rant in lockdep.c */
>> +		if (trace.nr_entries != 0&&
>> +		    trace.entries[trace.nr_entries - 1] == ULONG_MAX)
>> +			trace.nr_entries--;
>> +
>> +		for (i = trace.nr_entries; i<  TRACK_ADDRS_COUNT; i++)
>> +			p->addrs[i] = 0;
>> +#endif
>
> Hmmm... Is this really working on all architectures? I remember from years
> past that we had issues with adding the same functionality to slab.

The lockdep code seems to use the same basic logic, and I didn't notice
any arch checks in it.  I think recently someone must have fixed the backtrace
logic to be more easily used...this API didn't exist a few kernels
ago.

>
> Otherwise the patch is quite straightforward (and it will be much cleaner
> if you do not change the name of "addr").

Ok, will change that.

Thanks,
Ben

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
