Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab1ETWeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 18:34:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35199 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab1ETWeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 18:34:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to:x-pgp-key
         :user-agent;
        b=bnw6XtkGm1EBdALlowue1OT8EUUKGmcoDPgca41pHKliav6AizDSbi0ZC6tJXg5ylf
         eaUkU6uGtQcZCCdWwd9jJ2TzVg7nluw90bmvLDEmCwdI/wu/2oMc/rByOk6J8WM0HQUT
         UxAiJRuBcwyYtK9MAYJIKv6WLJi9Jk2A4oOIg=
Date: Fri, 20 May 2011 19:30:34 -0300
From: Rafael Aquini <aquini@linux.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russ Anderson <rja@sgi.com>, Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] [BUGFIX] mm: hugepages can cause negative commitlimit
Message-ID: <20110520223032.GA15192@x61.tchesoft.com>
Reply-To: aquini@linux.com
References: <20110518153445.GA18127@sgi.com>
 <BANLkTinbHnrf2isuLzUFZN8ypaT476G1zw@mail.gmail.com>
 <20110519045630.GA22533@sgi.com>
 <BANLkTinyYP-je9Nf8X-xWEdpgvn8a631Mw@mail.gmail.com>
 <20110519221101.GC19648@sgi.com>
 <20110520130411.d1e0baef.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110520130411.d1e0baef.akpm@linux-foundation.org>
X-PGP-Key: http://aquini.fedorapeople.org/AQUINI-GPG-KEY
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 01:04:11PM -0700, Andrew Morton wrote:
> On Thu, 19 May 2011 17:11:01 -0500
> Russ Anderson <rja@sgi.com> wrote:
> 
> > OK, I see your point.  The root problem is hugepages allocated at boot are
> > subtracted from totalram_pages but hugepages allocated at run time are not.
> > Correct me if I've mistate it or are other conditions.
> > 
> > By "allocated at run time" I mean "echo 1 > /proc/sys/vm/nr_hugepages".
> > That allocation will not change totalram_pages but will change
> > hugetlb_total_pages().
> > 
> > How best to fix this inconsistency?  Should totalram_pages include or exclude
> > hugepages?  What are the implications?
> 
> The problem is that hugetlb_total_pages() is trying to account for two
> different things, while totalram_pages accounts for only one of those
> things, yes?
> 
> One fix would be to stop accounting for huge pages in totalram_pages
> altogether.  That might break other things so careful checking would be
> needed.
> 
> Or we stop accounting for the boot-time allocated huge pages in
> hugetlb_total_pages().  Split the two things apart altogether and
> account for boot-time allocated and runtime-allocated pages separately.  This
> souds saner to me - it reflects what's actually happening in the kernel.

Perhaps we can just reinstate the # of pages "stealed" at early boot allocation
later, when hugetlb_init() calls gather_bootmem_prealloc()

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8ee3bd8..d606c9c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1111,6 +1111,7 @@ static void __init gather_bootmem_prealloc(void)
                WARN_ON(page_count(page) != 1);
                prep_compound_huge_page(page, h->order);
                prep_new_huge_page(h, page, page_to_nid(page));
+               totalram_pages += 1 << h->order;
        }
 }

-- 
Rafael Aquini <aquini@linux.com>
