Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab0GMP74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 11:59:56 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47233 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756565Ab0GMP7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 11:59:54 -0400
Message-ID: <4C3C8D75.5000409@austin.ibm.com>
Date: Tue, 13 Jul 2010 10:59:49 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Brian King <brking@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/7] Split the memory_block structure
References: <4C3B3446.5090302@austin.ibm.com> <4C3B37CE.50802@austin.ibm.com> <4C3C718C.6080402@linux.vnet.ibm.com>
In-Reply-To: <4C3C718C.6080402@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 09:00 AM, Brian King wrote:
> On 07/12/2010 10:42 AM, Nathan Fontenot wrote:
>> @@ -123,13 +130,20 @@
>>  static ssize_t show_mem_removable(struct sys_device *dev,
>>  			struct sysdev_attribute *attr, char *buf)
>>  {
>> -	unsigned long start_pfn;
>> -	int ret;
>> -	struct memory_block *mem =
>> -		container_of(dev, struct memory_block, sysdev);
>> +	struct list_head *pos, *tmp;
>> +	struct memory_block *mem;
>> +	int ret = 1;
>> +
>> +	mem = container_of(dev, struct memory_block, sysdev);
>> +	list_for_each_safe(pos, tmp, &mem->sections) {
>> +		struct memory_block_section *mbs;
>> +		unsigned long start_pfn;
>> +
>> +		mbs = list_entry(pos, struct memory_block_section, next);
>> +		start_pfn = section_nr_to_pfn(mbs->phys_index);
>> +		ret &= is_mem_section_removable(start_pfn, PAGES_PER_SECTION);
>> +	}
> 
> I don't see you deleting anyting from the list in this loop. Why do you need
> to use list_for_each_safe? That won't protect you if someone else is messing
> with the list.

Yes, Kame pointed this out too.  I think I'll need to update the patches to
always take the mutex when walking the list and use list_for_each_entry

> 
>>
>> -	start_pfn = section_nr_to_pfn(mem->phys_index);
>> -	ret = is_mem_section_removable(start_pfn, PAGES_PER_SECTION);
>>  	return sprintf(buf, "%d\n", ret);
>>  }
>>
> 
> 
>> @@ -238,19 +252,40 @@
>>  static int memory_block_change_state(struct memory_block *mem,
>>  		unsigned long to_state, unsigned long from_state_req)
>>  {
>> +	struct memory_block_section *mbs;
>> +	struct list_head *pos;
>>  	int ret = 0;
>> +
>>  	mutex_lock(&mem->state_mutex);
>>
>> -	if (mem->state != from_state_req) {
>> -		ret = -EINVAL;
>> -		goto out;
>> +	list_for_each(pos, &mem->sections) {
>> +		mbs = list_entry(pos, struct memory_block_section, next);
>> +
>> +		if (mbs->state != from_state_req)
>> +			continue;
>> +
>> +		ret = memory_block_action(mbs, to_state);
>> +		if (ret)
>> +			break;
>> +	}
> 
> Would it be better here to loop through all the sections and ensure they
> are in the proper state first before starting to change the state of any
> of them? Then you could easily return -EINVAL if one or more is in
> the incorrect state and wouldn't need to the code below.

The code below is needed in cases where the add/remove of one of the
memory_block_sections fails.  The code can then return all of the
memory_block_sections in the memory_block to the original state.

> 
>> +	if (ret) {
>> +		list_for_each(pos, &mem->sections) {
>> +			mbs = list_entry(pos, struct memory_block_section,
>> +					 next);
>> +
>> +			if (mbs->state == from_state_req)
>> +				continue;
>> +
>> +			if (memory_block_action(mbs, to_state))
>> +				printk(KERN_ERR "Could not re-enable memory "
>> +				       "section %lx\n", mbs->phys_index);
>> +		}
>>  	}
>>
>> -	ret = memory_block_action(mem, to_state);
>>  	if (!ret)
>>  		mem->state = to_state;
>>
>> -out:
>>  	mutex_unlock(&mem->state_mutex);
>>  	return ret;
>>  }
> 
> 
>> @@ -498,19 +496,97 @@
>>
>>  	return mem;
>>  }
>> +static int add_mem_block_section(struct memory_block *mem,
>> +				 int section_nr, unsigned long state)
>> +{
>> +	struct memory_block_section *mbs;
>> +
>> +	mbs = kzalloc(sizeof(*mbs), GFP_KERNEL);
>> +	if (!mbs)
>> +		return -ENOMEM;
>> +
>> +	mbs->phys_index = section_nr;
>> +	mbs->state = state;
>> +
>> +	list_add(&mbs->next, &mem->sections);
> 
> I don't think there is sufficient protection for this list. Don't we
> need to be holding a lock of some sort when adding/deleting/iterating
> through this list? 

You're right.  we should be holding the mutex.

I think there are a couple other places that I missed with this.  I'll fix
it for a v2 of the patches.

> 
>> +	return 0;
>> +}
> 

