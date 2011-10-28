Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab1J1FBH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 01:01:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:21201 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab1J1FBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 01:01:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,416,1315206000"; 
   d="scan'208";a="83373011"
Subject: Re: [patch 4/5]thp: correct order in lru list for split huge page
From: Shaohua Li <shaohua.li@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        mel <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20111027231928.GB29407@barrios-laptop.redhat.com>
References: <1319511577.22361.140.camel@sli10-conroe>
	 <20111027231928.GB29407@barrios-laptop.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 13:08:58 +0800
Message-ID: <1319778538.22361.152.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-28 at 07:19 +0800, Minchan Kim wrote:
> On Tue, Oct 25, 2011 at 10:59:37AM +0800, Shaohua Li wrote:
> > If a huge page is split, all the subpages should live in lru list adjacently
> > because they should be taken as a whole.
> > In page split, with current code:
> > a. if huge page is in lru list, the order is: page, page+HPAGE_PMD_NR-1,
> > page + HPAGE_PMD_NR-2, ..., page + 1(in lru page reclaim order)
> > b. otherwise, the order is: page, ..other pages.., page + 1, page + 2, ...(in
> > lru page reclaim order). page + 1 ... page + HPAGE_PMD_NR - 1 are in the lru
> > reclaim tail.
> > 
> > In case a, the order is wrong. In case b, page is isolated (to be reclaimed),
> > but other tail pages will not soon.
> > 
> > With below patch:
> > in case a, the order is: page, page + 1, ... page + HPAGE_PMD_NR-1(in lru page
> > reclaim order).
> > in case b, the order is: page + 1, ... page + HPAGE_PMD_NR-1 (in lru page reclaim
> > order). The tail pages are in the lru reclaim head.
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> In case of a, it doesn't matter ordering of subpages.
> As a huge page, age of sub pages are same.
It does matter. Hugepage is split first and then reclaim. if page, page
+HPAGE_PMD_NR-1 is reclaimed, you can't get an order-1 page. but if
page, page+1 is reclaimed, you can.

> In case of b, what a page is located in tail and other subpages are located in head
> isn't critical problem.
Same way here.

