Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab0GXDKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 23:10:04 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:34676 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab0GXDKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 23:10:01 -0400
Message-ID: <4C4A5985.6000206@austin.ibm.com>
Date: Fri, 23 Jul 2010 22:09:57 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, greg@kroah.com
Subject: Re: [PATCH 4/8] v3 Allow memory_block to span multiple memory sections
References: <4C451BF5.50304@austin.ibm.com>	 <4C451E1C.8070907@austin.ibm.com> <1279653481.9785.4.camel@nimitz>
In-Reply-To: <1279653481.9785.4.camel@nimitz>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2010 02:18 PM, Dave Hansen wrote:
> On Mon, 2010-07-19 at 22:55 -0500, Nathan Fontenot wrote:
>> +static int add_memory_section(int nid, struct mem_section *section,
>> +                       unsigned long state, enum mem_add_context context)
>> +{
>> +       struct memory_block *mem;
>> +       int ret = 0;
>> +
>> +       mem = find_memory_block(section);
>> +       if (mem) {
>> +               atomic_inc(&mem->section_count);
>> +               kobject_put(&mem->sysdev.kobj);
>> +       } else
>> +               ret = init_memory_block(&mem, section, state);
>> +
>>         if (!ret) {
>> -               if (context == HOTPLUG)
>> +               if (context == HOTPLUG &&
>> +                   atomic_read(&mem->section_count) == sections_per_block)
>>                         ret = register_mem_sect_under_node(mem, nid);
>>         } 
> 
> I think the atomic_inc() can race with the atomic_dec_and_test() in
> remove_memory_block().
> 
> Thread 1 does:
> 
> 	mem = find_memory_block(section);
> 
> Thread 2 does 
> 
> 	atomic_dec_and_test(&mem->section_count);
> 
> and destroys the memory block,  Thread 1 runs again:
> 	
>        if (mem) {
>                atomic_inc(&mem->section_count);
>                kobject_put(&mem->sysdev.kobj);
>        } else
> 
> but now mem got destroyed by Thread 2.  You probably need to change
> find_memory_block() to itself take a reference, and to use
> atomic_inc_unless().
> 

You're right but I think the fix you suggested will narrow the window for the
race condition, not eliminate it.  We could still take a time splice in
find_memory_block prior to the container_of() calls to get the memory
block pointer and end up de-referencing a invalid kobject o sysdev pointer.

I think if we want to eliminate this we may need to have lock that protects
access to any of the memory_block structures.  This would need to be taken
any time find_memory_block is called and released when use of the memory_block
returned is finished.  If we're going to fix this we should eliminate the
window completely instead of just closing it further.

If we add a lock should I submit it as part of this patchset? or submit it
as a follow-on?

-Nathan 
