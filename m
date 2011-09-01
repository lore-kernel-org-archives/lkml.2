Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab1IAF2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 01:28:44 -0400
Received: from ozlabs.org ([203.10.76.45]:45303 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab1IAF2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 01:28:43 -0400
Date: Thu, 1 Sep 2011 15:28:39 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Barry <abarry@cray.com>, linux-mm <linux-mm@kvack.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Hastings <abh@cray.com>
Subject: Re: [PATCH v2 1/1] hugepages: Fix race between hugetlbfs umount and
 quota update.
Message-ID: <20110901052839.GK11906@yookeroo.fritz.box>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrew Barry <abarry@cray.com>, linux-mm <linux-mm@kvack.org>,
	Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andrew Hastings <abh@cray.com>
References: <4E4EB603.8090305@cray.com>
 <20110819145109.dcd5dac6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110819145109.dcd5dac6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 02:51:09PM -0700, Andrew Morton wrote:
> On Fri, 19 Aug 2011 14:14:11 -0500
> Andrew Barry <abarry@cray.com> wrote:
> 
> > This patch fixes a use-after-free problem in free_huge_page, with a quota update
> > happening after hugetlbfs umount. The problem results when a device driver,
> > which has mapped a hugepage, does a put_page. Put_page, calls free_huge_page,
> > which does a hugetlb_put_quota. As written, hugetlb_put_quota takes an
> > address_space struct pointer "mapping" as an argument. If the put_page occurs
> > after the hugetlbfs filesystem is unmounted, mapping points to freed memory.
> 
> OK.  This sounds screwed up.  If a device driver is currently using a
> page from a hugetlbfs file then the unmount shouldn't have succeeded in
> the first place!
> 
> Or is it the case that the device driver got a reference to the page by
> other means, bypassing hugetlbfs?  And there's undesirable/incorrect
> interaction between the non-hugetlbfs operation and hugetlbfs?
> 
> Or something else?
> 
> <starts reading the mailing list>
> 
> OK, important missing information from the above is that the driver got
> at this page via get_user_pages() and happened to stumble across a
> hugetlbfs page.  So it's indeed an incorrect interaction between a
> non-hugetlbfs operation and hugetlbfs.
> 
> What's different about hugetlbfs?  Why don't other filesystems hit this?
> 
> <investigates further>
> 
> OK so the incorrect interaction happened in free_huge_page(), which is
> called via the compound page destructor (this dtor is "what's different
> about hugetlbfs").   What is incorrect about this is
> 
> a) that we're doing fs operations in response to a
>    get_user_pages()/put_page() operation which has *nothing* to do with
>    filesystems!
> 
> b) that we continue to try to do that fs operation against an fs
>    which was unmounted and freed three days ago. duh.
> 
> 
> So I hereby pronounce that
> 
> a) It was wrong to manipulate hugetlbfs quotas within
>    free_huge_page().  Because free_huge_page() is a low-level
>    page-management function which shouldn't know about one of its
>    specific clients (in this case, hugetlbfs).
> 
>    In fact it's wrong for there to be *any* mention of hugetlbfs
>    within hugetlb.c.
> 
> b) I shouldn't have merged that hugetlbfs quota code.  whodidthat. 
>    Mel, Adam, Dave, at least...
> 
> c) The proper fix here is to get that hugetlbfs quota code out of
>    free_huge_page() and do it all where it belongs: within hugetlbfs
>    code.
> 
> Regular filesystems don't need to diddle quota counts within
> page_cache_release().  Why should hugetlbfs need to?

Regular filesystems can assume there's a few spare pages that can
buffer quota transitions.  Hugepages on the other hand are scarce, and
it's common practice to want to actively use every single one of the
system.

I really can't see how to avoid poking the counts from
free_huge_page(), whether or not it's directly or via some sort of
callback.

Andrew (Morton) or Hugh, if you can suggest a more correct way to fix
this, I'm all ears, but at present we have a real bug and Andrew
Barry's patch is the best fix we have.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
