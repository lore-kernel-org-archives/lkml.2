Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab1GAOXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:23:45 -0400
Received: from mail.candelatech.com ([208.74.158.172]:53191 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670Ab1GAOXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:23:44 -0400
Message-ID: <4E0DD86D.80806@candelatech.com>
Date: Fri, 01 Jul 2011 07:23:41 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Thunderbird/3.1.9
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] slub:  Add method to verify memory is not freed.
References: <1309308462-20124-1-git-send-email-greearb@candelatech.com> <1309308462-20124-3-git-send-email-greearb@candelatech.com> <alpine.DEB.2.00.1107010909060.2458@router.home>
In-Reply-To: <alpine.DEB.2.00.1107010909060.2458@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2011 07:11 AM, Christoph Lameter wrote:
> On Tue, 28 Jun 2011, greearb@candelatech.com wrote:
>
>> diff --git a/include/linux/slab.h b/include/linux/slab.h
>> index ad4dd1c..916ce0f 100644
>> --- a/include/linux/slab.h
>> +++ b/include/linux/slab.h
>> @@ -302,6 +302,19 @@ extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, unsigned long);
>>
>>   #endif /* CONFIG_NUMA */
>>
>> +/**
>> + * Calling this on allocated memory will check that the memory
>> + * is expected to be in use, and print warnings if not.
>> + */
>> +#if defined(CONFIG_SLUB)&&  defined(CONFIG_SLUB_DEBUG)
>> +extern bool verify_mem_not_deleted(const void *x);
>> +#else
>> +static inline bool verify_mem_not_deleted(const void *x)
>> +{
>> +	return true;
>> +}
>> +#endif
>> +
>
> Why is this in slab.h and not slub_def.h?

No reason..I'll move it.

>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 3477ce5..f64caca 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2958,6 +2958,42 @@ size_t ksize(const void *object)
>>   }
>>   EXPORT_SYMBOL(ksize);
>>
>> +#ifdef CONFIG_SLUB_DEBUG
>> +bool verify_mem_not_deleted(const void *x)
>> +{
>> +	struct page *page;
>> +	void *object = (void *)x;
>> +	unsigned long flags;
>> +	bool rv;
>> +
>> +	if (unlikely(ZERO_OR_NULL_PTR(x)))
>> +		return false;
>> +
>> +	local_irq_save(flags);
>> +
>> +	page = virt_to_head_page(x);
>> +	if (unlikely(!PageSlab(page))) {
>> +		/* maybe it was from stack? */
>> +		rv = true;
>> +		goto out_unlock;
>> +	}
>
> The above check is problematic for slabs that have SLAB_DESTROY_BY_RCU
> set. PageSlab(page) may be true to the next rcu interval.

Well, any suggestions on how to do this better?

Thanks,
Ben

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
