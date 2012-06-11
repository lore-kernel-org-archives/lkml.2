Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab2FKWtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 18:49:35 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:46039 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab2FKWte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 18:49:34 -0400
X-AuditID: 9c930197-b7b5dae000004b23-8d-4fd675fc297b
Message-ID: <4FD675FE.1060202@kernel.org>
Date: Tue, 12 Jun 2012 07:49:34 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] mm: do not use page_count without a page pin
References: <1339373872-31969-1-git-send-email-minchan@kernel.org> <4FD59C31.6000606@jp.fujitsu.com> <20120611074440.GI3094@redhat.com> <20120611133043.GA2340@barrios> <20120611144132.GT3094@redhat.com>
In-Reply-To: <20120611144132.GT3094@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2012 11:41 PM, Andrea Arcangeli wrote:

> Hi Minchan,
> 
> On Mon, Jun 11, 2012 at 10:30:43PM +0900, Minchan Kim wrote:
>> AFAIUC, you mean we have to increase reference count of head page?
>> If so, it's not in __count_immobile_pages because it is already race-likely function
>> so it shouldn't be critical although race happens.
> 
> I meant, shouldn't we take into account the full size? If it's in the
> lru the whole thing can be moved away.
> 
>   if (!PageLRU(page)) {
>      nr_pages = hpage_nr_pages(page);
>      barrier();


Could you explain why we need barrier?

>      found += nr_pages;
>      iter += nr_pages-1;
>   }
> 


Thanks for the explain.

For the normal pages, the logic accounts it as "non-movable pages" so for the consistency,
it seems you're right. But let's think about a bit.

If THP page isn't LRU and it's still PageTransHuge, I think it's rather rare and
although it happens, it means migration/reclaimer is about to split or isolate/putback
so it ends up making THP page movable pages.

IMHO, it would be better to account it by movable pages.
What do you think about it?

Thanks.
-- 
Kind regards,
Minchan Kim
