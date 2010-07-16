Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965855Ab0GPPkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 11:40:20 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57202 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965822Ab0GPPkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 11:40:17 -0400
Message-ID: <4C407D5E.7060702@austin.ibm.com>
Date: Fri, 16 Jul 2010 10:40:14 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 4/5] v2 Update sysfs node routines for new sysfs memory
 directories
References: <4C3F53D1.3090001@austin.ibm.com>	<4C3F5628.6030809@austin.ibm.com> <20100716091239.69f40e47.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100716091239.69f40e47.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2010 07:12 PM, KAMEZAWA Hiroyuki wrote:
> On Thu, 15 Jul 2010 13:40:40 -0500
> Nathan Fontenot <nfont@austin.ibm.com> wrote:
> 
>> Update the node sysfs directory routines that create
>> links to the memory sysfs directories under each node.
>> This update makes the node code aware that a memory sysfs
>> directory can cover multiple memory sections.
>>
>> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
> 
> Shouldn't "static int link_mem_sections(int nid)" be update ?
> It does
>  for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
>         register..
> 

No, although the name 'link_mem_sections' does imply that it should.  The
range of start_pfn..end_pfn examined in this routine is the range of pfn's
covered by the entire node, not a memory_block.

-Nathan

> Thanks,
> -Kame
> 
> 
>> ---
>>  drivers/base/node.c |   12 ++++++++----
>>  1 file changed, 8 insertions(+), 4 deletions(-)
>>
>> Index: linux-2.6/drivers/base/node.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/base/node.c	2010-07-15 09:54:06.000000000 -0500
>> +++ linux-2.6/drivers/base/node.c	2010-07-15 09:56:16.000000000 -0500
>> @@ -346,8 +346,10 @@
>>  		return -EFAULT;
>>  	if (!node_online(nid))
>>  		return 0;
>> -	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
>> -	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
>> +
>> +	sect_start_pfn = section_nr_to_pfn(mem_blk->start_phys_index);
>> +	sect_end_pfn = section_nr_to_pfn(mem_blk->end_phys_index);
>> +	sect_end_pfn += PAGES_PER_SECTION - 1;
>>  	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
>>  		int page_nid;
>>  
>> @@ -383,8 +385,10 @@
>>  	if (!unlinked_nodes)
>>  		return -ENOMEM;
>>  	nodes_clear(*unlinked_nodes);
>> -	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
>> -	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
>> +
>> +	sect_start_pfn = section_nr_to_pfn(mem_blk->start_phys_index);
>> +	sect_end_pfn = section_nr_to_pfn(mem_blk->end_phys_index);
>> +	sect_end_pfn += PAGES_PER_SECTION - 1;
>>  	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
>>  		int nid;
>>  
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 

