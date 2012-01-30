Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab2A3Pl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:41:28 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33138 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab2A3Pl0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:41:26 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Mel Gorman" <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        "Daniel Walker" <dwalker@codeaurora.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Jesse Barker" <jesse.barker@linaro.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Shariq Hasnain" <shariq.hasnain@linaro.org>,
        "Chunsang Jeong" <chunsang.jeong@linaro.org>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH 02/15] mm: page_alloc: update migrate type of pages on pcp
 when isolating
References: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
 <1327568457-27734-3-git-send-email-m.szyprowski@samsung.com>
 <20120130111522.GE25268@csn.ul.ie>
Date: Mon, 30 Jan 2012 16:41:22 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v8wlu8ws3l0zgt@mpn-glaptop>
In-Reply-To: <20120130111522.GE25268@csn.ul.ie>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012 12:15:22 +0100, Mel Gorman <mel@csn.ul.ie> wrote:

> On Thu, Jan 26, 2012 at 10:00:44AM +0100, Marek Szyprowski wrote:
>> From: Michal Nazarewicz <mina86@mina86.com>
>> @@ -139,3 +139,27 @@ int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn)
>>  	spin_unlock_irqrestore(&zone->lock, flags);
>>  	return ret ? 0 : -EBUSY;
>>  }
>> +
>> +/* must hold zone->lock */
>> +void update_pcp_isolate_block(unsigned long pfn)
>> +{
>> +	unsigned long end_pfn = pfn + pageblock_nr_pages;
>> +	struct page *page;
>> +
>> +	while (pfn < end_pfn) {
>> +		if (!pfn_valid_within(pfn)) {
>> +			++pfn;
>> +			continue;
>> +		}
>> +

On Mon, 30 Jan 2012 12:15:22 +0100, Mel Gorman <mel@csn.ul.ie> wrote:
> There is a potential problem here that you need to be aware of.
> set_pageblock_migratetype() is called from start_isolate_page_range().
> I do not think there is a guarantee that pfn + pageblock_nr_pages is
> not in a different block of MAX_ORDER_NR_PAGES. If that is right then
> your options are to add a check like this;
>
> if ((pfn & (MAX_ORDER_NR_PAGES - 1)) == 0 && !pfn_valid(pfn))
> 	break;
>
> or else ensure that end_pfn is always MAX_ORDER_NR_PAGES aligned and in
> the same block as pfn and relying on the caller to have called
> pfn_valid.

	pfn = round_down(pfn, pageblock_nr_pages);
	end_pfn = pfn + pageblock_nr_pages;

should do the trick as well, right?  move_freepages_block() seem to be
doing the same thing.

>> +		page = pfn_to_page(pfn);
>> +		if (PageBuddy(page)) {
>> +			pfn += 1 << page_order(page);
>> +		} else if (page_count(page) == 0) {
>> +			set_page_private(page, MIGRATE_ISOLATE);
>> +			++pfn;
>
> This is dangerous for two reasons. If the page_count is 0, it could
> be because the page is in the process of being freed and is not
> necessarily on the per-cpu lists yet and you cannot be sure if the
> contents of page->private are important. Second, there is nothing to
> prevent another CPU allocating this page from its per-cpu list while
> the private field is getting updated from here which might lead to
> some interesting races.
>
> I recognise that what you are trying to do is respond to Gilad's
> request that you really check if an IPI here is necessary. I think what
> you need to do is check if a page with a count of 0 is encountered
> and if it is, then a draining of the per-cpu lists is necessary. To
> address Gilad's concerns, be sure to only this this once per attempt at
> CMA rather than for every page encountered with a count of 0 to avoid a
> storm of IPIs.

It's actually more then that.

This is the same issue that I first fixed with a change to free_pcppages_bulk()
function[1].  At the time of positing, you said you'd like me to try and find
a different solution which would not involve paying the price of calling
get_pageblock_migratetype().  Later I also realised that this solution is
not enough.

[1] http://article.gmane.org/gmane.linux.kernel.mm/70314

My next attempt was to run drain PCP list while holding zone->lock[2], but that
quickly proven to be broken approach when Marek started testing it on an SMP
system.

[2] http://article.gmane.org/gmane.linux.kernel.mm/72016

This patch is yet another attempt of solving this old issue.  Even though it has
a potential race condition we came to conclusion that the actual chances of
causing any problems are slim.  Various stress tests did not, in fact, show
the race to be an issue.

The problem is that if a page is on a PCP list, and it's underlaying pageblocks'
migrate type is changed to MIGRATE_ISOLATE, the page (i) will still remain on PCP
list and thus someone can allocate it, and (ii) when removed from PCP list, the
page will be put on freelist of migrate type it had prior to change.

(i) is actually not such a big issue since the next thing that happens after
isolation is migration so all the pages will get freed.  (ii) is actual problem
and if [1] is not an acceptable solution I really don't have a good fix for that.

One things that comes to mind is calling drain_all_pages() prior to acquiring
zone->lock in set_migratetype_isolate().  This is however prone to races since
after the drain and before the zone->lock is acquired, pages might get moved
back to PCP list.

Draining PCP list after acquiring zone->lock is not possible because
smp_call_function_many() cannot be called with interrupts disabled, and changing
spin_lock_irqsave() to spin_lock() followed by local_irq_save() causes a dead
lock (that's what [2] attempted to do).

Any suggestions are welcome!

>> +		} else {
>> +			++pfn;
>> +		}
>> +	}
>> +}

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
