Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab0D0Wdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 18:33:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358Ab0D0Wdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 18:33:49 -0400
Date: Wed, 28 Apr 2010 00:32:42 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] Fix migration races in rmap_walk() V2
Message-ID: <20100427223242.GG8860@random.random>
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>
 <alpine.DEB.2.00.1004271723090.24133@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1004271723090.24133@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 05:27:36PM -0500, Christoph Lameter wrote:
> Can we simply wait like in the fault path?

There is no bug there, no need to wait either. I already audited it
before, and I didn't see any bug. Unless you can show a bug with CPU A
running the rmap_walk on process1 before process2, there is no bug to
fix there.

> 
> > Patch 3 notes that while a VMA is moved under the anon_vma lock, the page
> > 	tables are not similarly protected. Where migration PTEs are
> > 	encountered, they are cleaned up.
> 
> This means they are copied / moved etc and "cleaned" up in a state when
> the page was unlocked. Migration entries are not supposed to exist when
> a page is not locked.

patch 3 is real, and the first thought I had was to lock down the page
before running vma_adjust and unlock after move_page_tables. But these
are virtual addresses. Maybe there's a simpler way to keep migration
away while we run those two operations.
