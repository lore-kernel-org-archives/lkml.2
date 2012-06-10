Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab2FJAuC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 20:50:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36340 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab2FJAuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 20:50:00 -0400
Message-ID: <4FD3EF26.7040108@vflare.org>
Date: Sat, 09 Jun 2012 17:49:42 -0700
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
CC: Greg KH <greg@kroah.com>, Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] zsmalloc documentation
References: <1339288874-2743-1-git-send-email-ngupta@vflare.org> <20120610004434.GA24894@localhost.localdomain>
In-Reply-To: <20120610004434.GA24894@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2012 05:44 PM, Konrad Rzeszutek Wilk wrote:

> On Sat, Jun 09, 2012 at 05:41:14PM -0700, Nitin Gupta wrote:
>> Documentation of various struct page fields
>> used by zsmalloc.
>>
>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
>>
>> Changes for v2:
>> 	- Regroup descriptions as suggested by Seth
>                                                ^^ - Konrad
> 
> Otherwise: Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 


Sorry about that, Konrad!
Greg: Please let me know if I should resend the patch with corrected
name in the changelog.

Thanks,
Nitin

>> ---
>>  drivers/staging/zsmalloc/zsmalloc-main.c |   48 ++++++++++++++++++++++++++++++
>>  1 file changed, 48 insertions(+)
>>
>> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
>> index 4496737..1db76ec 100644
>> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
>> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
>> @@ -10,6 +10,54 @@
>>   * Released under the terms of GNU General Public License Version 2.0
>>   */
>>  
>> +
>> +/*
>> + * This allocator is designed for use with zcache and zram. Thus, the
>> + * allocator is supposed to work well under low memory conditions. In
>> + * particular, it never attempts higher order page allocation which is
>> + * very likely to fail under memory pressure. On the other hand, if we
>> + * just use single (0-order) pages, it would suffer from very high
>> + * fragmentation -- any object of size PAGE_SIZE/2 or larger would occupy
>> + * an entire page. This was one of the major issues with its predecessor
>> + * (xvmalloc).
>> + *
>> + * To overcome these issues, zsmalloc allocates a bunch of 0-order pages
>> + * and links them together using various 'struct page' fields. These linked
>> + * pages act as a single higher-order page i.e. an object can span 0-order
>> + * page boundaries. The code refers to these linked pages as a single entity
>> + * called zspage.
>> + *
>> + * Following is how we use various fields and flags of underlying
>> + * struct page(s) to form a zspage.
>> + *
>> + * Usage of struct page fields:
>> + *	page->first_page: points to the first component (0-order) page
>> + *	page->index (union with page->freelist): offset of the first object
>> + *		starting in this page. For the first page, this is
>> + *		always 0, so we use this field (aka freelist) to point
>> + *		to the first free object in zspage.
>> + *	page->lru: links together all component pages (except the first page)
>> + *		of a zspage
>> + *
>> + *	For _first_ page only:
>> + *
>> + *	page->private (union with page->first_page): refers to the
>> + *		component page after the first page
>> + *	page->freelist: points to the first free object in zspage.
>> + *		Free objects are linked together using in-place
>> + *		metadata.
>> + *	page->objects: maximum number of objects we can store in this
>> + *		zspage (class->zspage_order * PAGE_SIZE / class->size)
>> + *	page->lru: links together first pages of various zspages.
>> + *		Basically forming list of zspages in a fullness group.
>> + *	page->mapping: class index and fullness group of the zspage
>> + *
>> + * Usage of struct page flags:
>> + *	PG_private: identifies the first component page
>> + *	PG_private2: identifies the last component page
>> + *
>> + */
>> +
>>  #ifdef CONFIG_ZSMALLOC_DEBUG
>>  #define DEBUG
>>  #endif
>> -- 
>> 1.7.10.2
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>>


