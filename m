Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab0I1SGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 14:06:49 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49193 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab0I1SGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 14:06:49 -0400
Message-ID: <4CA22EA2.8060307@austin.ibm.com>
Date: Tue, 28 Sep 2010 13:06:26 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        Greg KH <greg@kroah.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 4/8] v2 Allow memory block to span multiple memory sections
References: <4CA0EBEB.1030204@austin.ibm.com>	 <4CA0EFAA.8050000@austin.ibm.com> <1285631707.19976.3385.camel@nimitz>
In-Reply-To: <1285631707.19976.3385.camel@nimitz>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2010 06:55 PM, Dave Hansen wrote:
> On Mon, 2010-09-27 at 14:25 -0500, Nathan Fontenot wrote:
>> +static inline int base_memory_block_id(int section_nr)
>> +{
>> +       return section_nr / sections_per_block;
>> +}
> ...
>> -       mutex_lock(&mem_sysfs_mutex);
>> -
>> -       mem->phys_index = __section_nr(section);
>> +       scn_nr = __section_nr(section);
>> +       mem->phys_index = base_memory_block_id(scn_nr) * sections_per_block; 
> 
> I'm really regretting giving this variable such a horrid name.  I suck.
> 
> I think this is correct now:
> 
> 	mem->phys_index = base_memory_block_id(scn_nr) * sections_per_block;
> 	mem->phys_index = section_nr / sections_per_block * sections_per_block;
> 	mem->phys_index = section_nr
> 
> Since it gets exported to userspace this way:
> 
>> +static ssize_t show_mem_start_phys_index(struct sys_device *dev,
>>                         struct sysdev_attribute *attr, char *buf)
>>  {
>>         struct memory_block *mem =
>>                 container_of(dev, struct memory_block, sysdev);
>> -       return sprintf(buf, "%08lx\n", mem->phys_index / sections_per_block);
>> +       unsigned long phys_index;
>> +
>> +       phys_index = mem->start_phys_index / sections_per_block;
>> +       return sprintf(buf, "%08lx\n", phys_index);
>> +}
> 
> The only other thing I'd say is that we need to put phys_index out of
> its misery and call it what it is now: a section number.  I think it's
> OK to call them "start/end_section_nr", at least inside the kernel.  I
> intentionally used "phys_index" terminology in sysfs so that we _could_
> eventually do this stuff and break the relationship between sections and
> the sysfs dirs, but I think keeping the terminology around inside the
> kernel is confusing now.

Yes, it took me a couple o looks to get the phys_index <-> section number
correlation.  I think changing the kernel names to start/end_section_number
is a good idea.

-Nathan

> 
> -- Dave
> 

