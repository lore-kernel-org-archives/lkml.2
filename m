Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab0KJHvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 02:51:14 -0500
Received: from smtp-out.google.com ([74.125.121.35]:1100 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab0KJHvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 02:51:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=EueJgahA4wUzMNdpRLJkfRQeHhaCux/9UvcjEByJnLvoGrDpkhioABfeF67sRQzwGM
         PIQKoGDtk7zvNK1ByUbA==
Date: Tue, 9 Nov 2010 23:49:30 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrea Arcangeli <aarcange@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 43 of 66] don't leave orhpaned swap cache after ksm
 merging
In-Reply-To: <20101109214036.GE6809@random.random>
Message-ID: <alpine.LSU.2.00.1011092312360.6873@sister.anvils>
References: <patchbomb.1288798055@v2.random> <d5aefe85d1dab1bb7e99.1288798098@v2.random> <20101109120747.BC4B.A69D9226@jp.fujitsu.com> <20101109214036.GE6809@random.random>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010, Andrea Arcangeli wrote:
> On Tue, Nov 09, 2010 at 12:08:25PM +0900, KOSAKI Motohiro wrote:
> > > From: Andrea Arcangeli <aarcange@redhat.com>
> > > 
> > > When swapcache is replaced by a ksm page don't leave orhpaned swap cache.
> > > 
> > > Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> > > Reviewed-by: Rik van Riel <riel@redhat.com>
> > 
> > This explanation seems to tell this is bugfix. If so, please separate
> > this one from THP and will send mainline and -stable soon.
> 
> Right. I'm uncertain if this is so bad to require -stable I think, if
> it was more urgent I would have submitted already separately but it's
> true it's not THP specific.

Yes, we discussed this a few months ago: it's a welcome catch, but not
very serious, since it's normal for some pages to evade swap freeing,
then eventually memory pressure sorts it all out in __remove_mapping().

We did ask you back then to send in a fix separate from THP, but both
sides then forgot about it until recently.

We didn't agree on what the fix should look like.  You're keen to change
the page locking there, I didn't make a persuasive case for keeping it
as is, yet I can see no point whatever in changing it for this swap fix.
Could I persuade you to approve this simpler alternative?


[PATCH] ksm: free swap when swapcache page is replaced

When a swapcache page is replaced by a ksm page, it's best to free that
swap immediately.

Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/ksm.c |    2 ++
 1 file changed, 2 insertions(+)

--- 2.6.37-rc1/mm/ksm.c	2010-10-20 13:30:22.000000000 -0700
+++ linux/mm/ksm.c	2010-11-09 23:01:24.000000000 -0800
@@ -800,6 +800,8 @@ static int replace_page(struct vm_area_s
 	set_pte_at_notify(mm, addr, ptep, mk_pte(kpage, vma->vm_page_prot));
 
 	page_remove_rmap(page);
+	if (!page_mapped(page))
+		try_to_free_swap(page);
 	put_page(page);
 
 	pte_unmap_unlock(ptep, ptl);
