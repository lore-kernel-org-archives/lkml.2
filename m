Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab2GJPd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:33:57 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:41462 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab2GJPd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:33:56 -0400
Message-ID: <4FFC4A61.3020601@linux.vnet.ibm.com>
Date: Tue, 10 Jul 2012 10:29:37 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] zsmalloc: remove x86 dependency
References: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com> <1341263752-10210-2-git-send-email-sjenning@linux.vnet.ibm.com> <4FFB91B8.5070009@kernel.org>
In-Reply-To: <4FFB91B8.5070009@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071015-5518-0000-0000-000005EA43D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2012 09:21 PM, Minchan Kim wrote:
> On 07/03/2012 06:15 AM, Seth Jennings wrote:
<snip>
>> +static void zs_copy_map_object(char *buf, struct page *firstpage,
>> +				int off, int size)
> 
> firstpage is rather misleading.
> As you know, we use firstpage term for real firstpage of zspage but
> in case of zs_copy_map_object, it could be a middle page of zspage.
> So I would like to use "page" instead of firstpage.

Accepted.

>> +{
>> +	struct page *pages[2];
>> +	int sizes[2];
>> +	void *addr;
>> +
>> +	pages[0] = firstpage;
>> +	pages[1] = get_next_page(firstpage);
>> +	BUG_ON(!pages[1]);
>> +
>> +	sizes[0] = PAGE_SIZE - off;
>> +	sizes[1] = size - sizes[0];
>> +
>> +	/* disable page faults to match kmap_atomic() return conditions */
>> +	pagefault_disable();
> 
> If I understand your intention correctly, you want to prevent calling
> this function on non-atomic context. Right?

This is moved to zs_map_object() in a later patch, but the
point is to provide uniform return conditions, regardless of
whether the object to be mapped is contained in a single
page or spans two pages.  kmap_atomic() disables page
faults, so I did it here to create symmetry.  The result is
that zs_map_object always returns with preemption and page
faults disabled.

Also, Greg already merged these patches so I'll have to
incorporate these changes as a separate patch.

Thanks,
Seth

