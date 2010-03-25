Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab0CYBBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 21:01:24 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34796 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab0CYBBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 21:01:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 25 Mar 2010 09:57:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 10/11] Direct compact when a high-order allocation fails
Message-Id: <20100325095732.107fe878.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100324134816.529778bd.akpm@linux-foundation.org>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie>
	<1269347146-7461-11-git-send-email-mel@csn.ul.ie>
	<20100324134816.529778bd.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010 13:48:16 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 23 Mar 2010 12:25:45 +0000
> Mel Gorman <mel@csn.ul.ie> wrote:

> > +	/*
> > +	 * We will not stall if the necessary conditions are not met for
> > +	 * migration but direct reclaim seems to account stalls similarly
> > +	 */
> > +	count_vm_event(COMPACTSTALL);
> > +
> > +	/* Compact each zone in the list */
> > +	for_each_zone_zonelist_nodemask(zone, z, zonelist, high_zoneidx,
> > +								nodemask) {
> 
> Will all of this code play nicely with memory hotplug?
> 

If your concern is a race with memory hotplug, I have no concern about that
because memory hotplug makes a range of pages as "not for use" before starting.
If your concern is "code sharing", shared codes between memory hotplug and
compaction is "migrate_pages()".

Other parts are independent from each other.

IIUC.
Memory Hotremove does

	1. select a range for removal [start ....end)
	2. mark free pages as "not for use" by migrate_type
	3. move all used pages to other range.
	4. Finally, all pages in the range will be "not for use"

Compaction does
	1. select a target order
	2. move some free pages to private list
	3. move some used pages to pages in private list.
        4. free pages.

So, techniques to isolate freed pages is different. 
I think it's from their purpose.
 
"freed pages" by compaction is
	- for use
	- a chunk of page from anywhere is ok.

but "freed pages" by memory unplug is 
	- not for use
	- a chunk of page should be in specified range.

For using memory hotplug's code for compaction, we have to specify
"not for use" range. It will make low order compaction innefficient
and it seems not easy to find the best range for compaction.

For compaction, logic used in memory hotplug is too big hummer, I guess.

Thanks,
-Kame

