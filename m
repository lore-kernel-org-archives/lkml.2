Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab2GKH1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 03:27:43 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57175 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab2GKH1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 03:27:41 -0400
X-AuditID: 9c93016f-b7cb9ae000000dfd-fd-4ffd2ae555c2
Message-ID: <4FFD2AE6.70609@kernel.org>
Date: Wed, 11 Jul 2012 16:27:34 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: devel@driverdev.osuosl.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/4] zsmalloc: remove x86 dependency
References: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com> <1341263752-10210-2-git-send-email-sjenning@linux.vnet.ibm.com> <4FFB91B8.5070009@kernel.org> <4FFC4A61.3020601@linux.vnet.ibm.com>
In-Reply-To: <4FFC4A61.3020601@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 12:29 AM, Seth Jennings wrote:
> On 07/09/2012 09:21 PM, Minchan Kim wrote:
>> On 07/03/2012 06:15 AM, Seth Jennings wrote:
> <snip>
>>> +static void zs_copy_map_object(char *buf, struct page *firstpage,
>>> +				int off, int size)
>>
>> firstpage is rather misleading.
>> As you know, we use firstpage term for real firstpage of zspage but
>> in case of zs_copy_map_object, it could be a middle page of zspage.
>> So I would like to use "page" instead of firstpage.
> 
> Accepted.
> 
>>> +{
>>> +	struct page *pages[2];
>>> +	int sizes[2];
>>> +	void *addr;
>>> +
>>> +	pages[0] = firstpage;
>>> +	pages[1] = get_next_page(firstpage);
>>> +	BUG_ON(!pages[1]);
>>> +
>>> +	sizes[0] = PAGE_SIZE - off;
>>> +	sizes[1] = size - sizes[0];
>>> +
>>> +	/* disable page faults to match kmap_atomic() return conditions */
>>> +	pagefault_disable();
>>
>> If I understand your intention correctly, you want to prevent calling
>> this function on non-atomic context. Right?
> 
> This is moved to zs_map_object() in a later patch, but the
> point is to provide uniform return conditions, regardless of
> whether the object to be mapped is contained in a single
> page or spans two pages.  kmap_atomic() disables page
> faults, so I did it here to create symmetry.  The result is

The one I want to comment out is why we should disable page fault.
ie, if we don't disable page fault, what's happen?

As I read the comment of kmap_atomic about pagefault_disable, 
it seems that for preventing reentrant bug in preemptive kernel
while it catch page fault during atomic context in non-preemptive kernel.
But I'm not sure so Ccing Peter.


> that zs_map_object always returns with preemption and page
> faults disabled.
> 
> Also, Greg already merged these patches so I'll have to
> incorporate these changes as a separate patch.
> 
> Thanks,
> Seth
> 


-- 
Kind regards,
Minchan Kim


