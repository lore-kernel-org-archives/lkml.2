Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab0GMPwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 11:52:10 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:53887 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab0GMPwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 11:52:08 -0400
Message-ID: <4C3C8B9E.7000208@austin.ibm.com>
Date: Tue, 13 Jul 2010 10:51:58 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 4/7] Allow sysfs memory directories to be split
References: <4C3B3446.5090302@austin.ibm.com>	<4C3B3895.3040209@austin.ibm.com> <20100713152854.ec1f4d6a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100713152854.ec1f4d6a.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 01:28 AM, KAMEZAWA Hiroyuki wrote:
> On Mon, 12 Jul 2010 10:45:25 -0500
> Nathan Fontenot <nfont@austin.ibm.com> wrote:
> 
>> This patch introduces the new 'split' file in each memory sysfs
>> directory and the associated routines needed to handle splitting
>> a directory.
>>
>> Signed-off-by; Nathan Fontenot <nfont@austin.ibm.com>
>> ---
> 
> pleae check diff option...
> 
> 
>>  drivers/base/memory.c |   99 +++++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 98 insertions(+), 1 deletion(-)
>>
>> Index: linux-2.6/drivers/base/memory.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/base/memory.c	2010-07-09 14:23:20.000000000 -0500
>> +++ linux-2.6/drivers/base/memory.c	2010-07-09 14:38:09.000000000 -0500
>> @@ -32,6 +32,9 @@
>>  
>>  static int sections_per_block;
>>  
>> +static int register_memory(struct memory_block *, struct mem_section *,
>> +			   int, enum mem_add_context);
>> +
>>  static inline int base_memory_block_id(int section_nr)
>>  {
>>  	return (section_nr / sections_per_block) * sections_per_block;
>> @@ -309,11 +312,100 @@
>>  	return sprintf(buf, "%d\n", mem->phys_device);
>>  }
>>  
>> +static void update_memory_block_phys_indexes(struct memory_block *mem)
>> +{
>> +	struct list_head *pos;
>> +	struct memory_block_section *mbs;
>> +	unsigned long min_index = 0xffffffff;
>> +	unsigned long max_index = 0;
>> +
>> +	list_for_each(pos, &mem->sections) {
>> +		mbs = list_entry(pos, struct memory_block_section, next);
>> +
>> +		if (mbs->phys_index < min_index)
>> +			min_index = mbs->phys_index;
>> +
>> +		if (mbs->phys_index > max_index)
>> +			max_index = mbs->phys_index;
>> +	}
>> +
>> +	mem->start_phys_index = min_index;
>> +	mem->end_phys_index = max_index;
>> +}
>> +
>> +static ssize_t
>> +store_mem_split_block(struct sys_device *dev, struct sysdev_attribute *attr,
>> +		      const char *buf, size_t count)
>> +{
>> +	struct memory_block *mem, *new_mem_blk;
>> +	struct memory_block_section *mbs;
>> +	struct list_head *pos, *tmp;
>> +	struct mem_section *section;
>> +	int min_scn_nr = 0;
>> +	int max_scn_nr = 0;
>> +	int total_scns = 0;
>> +	int new_blk_min, new_blk_total;
>> +	int ret = -EINVAL;
>> +
>> +	mem = container_of(dev, struct memory_block, sysdev);
>> +
>> +	if (list_is_singular(&mem->sections))
>> +		return -EINVAL;
> 
> What this means ?

list_is_singular() will return true if there is only one item
on the list.  In this case we cannot split a memory_block with
only one memory_block_section.

> 
> 
>> +
>> +	mutex_lock(&mem->state_mutex);
>> +
>> +	list_for_each(pos, &mem->sections) {
>> +		mbs = list_entry(pos, struct memory_block_section, next);
>> +
>> +		total_scns++;
>> +
>> +		if (min_scn_nr > mbs->phys_index)
>> +			min_scn_nr = mbs->phys_index;
>> +
>> +		if (max_scn_nr < mbs->phys_index)
>> +			max_scn_nr = mbs->phys_index;
>> +	}
>> +
>> +	new_mem_blk = kzalloc(sizeof(*new_mem_blk), GFP_KERNEL);
>> +	if (!new_mem_blk)
>> +		return -ENOMEM;
>> +
>> +	mutex_init(&new_mem_blk->state_mutex);
>> +	INIT_LIST_HEAD(&new_mem_blk->sections);
>> +	new_mem_blk->state = mem->state;
>> +
>> +	mutex_lock(&new_mem_blk->state_mutex);
>> +
>> +	new_blk_total = total_scns / 2;
>> +	new_blk_min = max_scn_nr - new_blk_total + 1;
>> +
>> +	section = __nr_to_section(new_blk_min);
>> +	ret = register_memory(new_mem_blk, section, 0, HOTPLUG);
>> +
> 'nid' is always 0 ?

Ahh.. good catch.  it may not be.  I'll look into finding the correct nid.

> 
> And for what purpose this interface is ? Does this split memory block into 2 pieces
> of the same size ?? sounds __very__ strange interface to me.

Yes, this splits the memory_block into two blocks of the same size.  This was
suggested as something we may want to do.  From ppc perspective I am not sure we
would use this.

The split functionality is not required.  The main goal of the patch set is to
reduce the number of memory sysfs directories created.  From a ppc perspective
the split functionality is not really needed.

> 
> If this is necessary, I hope move the whole things to configfs rather than
> something tricky.
> 
> Bye.
> -Kame
> 

