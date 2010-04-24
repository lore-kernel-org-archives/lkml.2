Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab0DXCHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 22:07:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48546 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab0DXCGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 22:06:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Sat, 24 Apr 2010 11:02:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       Christoph Lameter <cl@linux.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX][mm][PATCH] fix migration race in rmap_walk
Message-Id: <20100424110200.b491ec5f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100423155801.GA14351@csn.ul.ie>
References: <20100423120148.9ffa5881.kamezawa.hiroyu@jp.fujitsu.com>
	<20100423095922.GJ30306@csn.ul.ie>
	<20100423155801.GA14351@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 16:58:01 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> > I had considered this idea as well as it is vaguely similar to how zones get
> > resized with a seqlock. I was hoping that the existing locking on anon_vma
> > would be usable by backing off until uncontended but maybe not so lets
> > check out this approach.
> > 
> 
> A possible combination of the two approaches is as follows. It uses the
> anon_vma lock mostly except where the anon_vma differs between the page
> and the VMAs being walked in which case it uses the seq counter. I've
> had it running a few hours now without problems but I'll leave it
> running at least 24 hours.
> 
ok, I'll try this, too.


> ==== CUT HERE ====
>  mm,migration: Prevent rmap_walk_[anon|ksm] seeing the wrong VMA information by protecting against vma_adjust with a combination of locks and seq counter
> 
> vma_adjust() is updating anon VMA information without any locks taken.
> In constract, file-backed mappings use the i_mmap_lock. This lack of
> locking can result in races with page migration. During rmap_walk(),
> vma_address() can return -EFAULT for an address that will soon be valid.
> This leaves a dangling migration PTE behind which can later cause a
> BUG_ON to trigger when the page is faulted in.
> 
> With the recent anon_vma changes, there is no single anon_vma->lock that
> can be taken that is safe for rmap_walk() to guard against changes by
> vma_adjust(). Instead, a lock can be taken on one VMA while changes
> happen to another.
> 
> What this patch does is protect against updates with a combination of
> locks and seq counters. First, the vma->anon_vma lock is taken by
> vma_adjust() and the sequence counter starts. The lock is released and
> the sequence ended when the VMA updates are complete.
> 
> The lock serialses rmap_walk_anon when the page and VMA share the same
> anon_vma. Where the anon_vmas do not match, the seq counter is checked.
> If a change is noticed, rmap_walk_anon drops its locks and starts again
> from scratch as the VMA list may have changed. The dangling migration
> PTE bug was not triggered after several hours of stress testing with
> this patch applied.
> 
> [kamezawa.hiroyu@jp.fujitsu.com: Use of a seq counter]
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

I think this patch is nice!

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



