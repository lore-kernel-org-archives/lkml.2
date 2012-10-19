Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab2JSNnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:43:00 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45950 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758773Ab2JSNm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:42:59 -0400
Message-ID: <508158D6.4040806@linux.vnet.ibm.com>
Date: Fri, 19 Oct 2012 06:42:46 -0700
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: wency@cn.fujitsu.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, minchan.kim@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 2/5] memory-hotplug: update mce_bad_pages when removing
 the memory
References: <1350475735-26136-1-git-send-email-wency@cn.fujitsu.com> <1350475735-26136-3-git-send-email-wency@cn.fujitsu.com> <507ECA43.3070402@linux.vnet.ibm.com> <20121018152008.ada8fea5.akpm@linux-foundation.org>
In-Reply-To: <20121018152008.ada8fea5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101913-7182-0000-0000-000002E284CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 03:20 PM, Andrew Morton wrote:
> On Wed, 17 Oct 2012 08:09:55 -0700
> Dave Hansen <dave@linux.vnet.ibm.com> wrote:
>>> +#ifdef CONFIG_MEMORY_FAILURE
>>> +static void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
>>> +{
>>> +	int i;
>>> +
>>> +	if (!memmap)
>>> +		return;
>>
>> I guess free_section_usemap() does the same thing.
> 
> What does this observation mean?

sparse_remove_one_section() has an if(ms->section_mem_map) statement.
Inside that if() block is the only place in the function where 'memmap'
can get set.

Currently, sparse_remove_one_section() calls in to free_section_usemap()
ouside of that if() block.  With this patch new call to
clear_hwpoisoned_pages() is done in the same place, both passing 'memmap'.

However, both free_section_usemap() and clear_hwpoisoned_pages() check
'memmap' for NULL and immediately return if so.  That's a bit silly
since it could hide garbage coming back from sparse_decode_mem_map().
Seems like we should just call them both inside that if() block, or
reorganize sparse_remove_one_section(), maybe like this:

void sparse_remove_one_section(struct zone *zone, struct mem_section *ms)
{
        struct page *memmap = NULL;
        unsigned long *usemap = NULL;

        if (!ms->section_mem_map)
		return;

        usemap = ms->pageblock_flags;
        memmap = sparse_decode_mem_map(ms->section_mem_map,
                                                __section_nr(ms));
        ms->section_mem_map = 0;
        ms->pageblock_flags = NULL;

        free_section_usemap(memmap, usemap);
	clear_hwpoisoned_pages(usemap, ...);
}

