Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680Ab2AKRqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:46:21 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:40590 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab2AKRqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:46:18 -0500
Message-ID: <4F0DCAA7.4000601@linux.vnet.ibm.com>
Date: Wed, 11 Jan 2012 11:45:11 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Nitin Gupta <ngupta@vflare.org>,
        Brian King <brking@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] staging: zsmalloc: zsmalloc memory allocation library
References: <<1326149520-31720-1-git-send-email-sjenning@linux.vnet.ibm.com>> <<1326149520-31720-2-git-send-email-sjenning@linux.vnet.ibm.com>> <b5b5a961-85e5-4ce1-8280-7ca382cb0e0f@default>
In-Reply-To: <b5b5a961-85e5-4ce1-8280-7ca382cb0e0f@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12011117-3352-0000-0000-000001DA8C28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2012 11:19 AM, Dan Magenheimer wrote:
>> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
>> Subject: [PATCH 1/5] staging: zsmalloc: zsmalloc memory allocation library
>>
>> From: Nitin Gupta <ngupta@vflare.org>
>>
>> This patch creates a new memory allocation library named
>> zsmalloc.
>>
>> +/*
>> + * Allocate a zspage for the given size class
>> + */
>> +static struct page *alloc_zspage(struct size_class *class, gfp_t flags)
>> +{
>> +	int i, error;
>> +	struct page *first_page = NULL;
>> +
>> +	/*
>> +	 * Allocate individual pages and link them together as:
>> +	 * 1. first page->private = first sub-page
>> +	 * 2. all sub-pages are linked together using page->lru
>> +	 * 3. each sub-page is linked to the first page using page->first_page
>> +	 *
>> +	 * For each size class, First/Head pages are linked together using
>> +	 * page->lru. Also, we set PG_private to identify the first page
>> +	 * (i.e. no other sub-page has this flag set) and PG_private_2 to
>> +	 * identify the last page.
>> +	 */
>> +	error = -ENOMEM;
>> +	for (i = 0; i < class->zspage_order; i++) {
>> +		struct page *page, *prev_page;
>> +
>> +		page = alloc_page(flags);
> 
> Hmmm... I thought we agreed offlist that the new allocator API would
> provide for either preloads or callbacks (which may differ per pool)
> instead of directly allocating raw pages from the kernel.  The caller
> (zcache or ramster or ???) needs to be able to somehow manage maximum
> memory capacity to avoid OOMs.
> 
> Or am I missing the code that handles that?

No, you aren't missing it; it's not there.  And I agree that we
should add that.

However, the existing allocator, xvmalloc, doesn't support callback
functionality either.  Would it be simpler to add the that as 
a separate patch, that way we can keep the changes to zcache/zram
in this patchset isolated to just changing the xvmalloc calls to 
zsmalloc calls?

--
Seth

