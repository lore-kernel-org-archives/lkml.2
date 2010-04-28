Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab0D1ARt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 20:17:49 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47764 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab0D1ARs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 20:17:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Apr 2010 09:13:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Lameter <cl@linux.com>, Mel Gorman <mel@csn.ul.ie>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] Fix migration races in rmap_walk() V2
Message-Id: <20100428091345.496ca4c4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100427223242.GG8860@random.random>
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>
	<alpine.DEB.2.00.1004271723090.24133@router.home>
	<20100427223242.GG8860@random.random>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010 00:32:42 +0200
Andrea Arcangeli <aarcange@redhat.com> wrote:

> On Tue, Apr 27, 2010 at 05:27:36PM -0500, Christoph Lameter wrote:
> > Can we simply wait like in the fault path?
> 
> There is no bug there, no need to wait either. I already audited it
> before, and I didn't see any bug. Unless you can show a bug with CPU A
> running the rmap_walk on process1 before process2, there is no bug to
> fix there.
> 
I think there is no bug, either. But that safety is fragile.


> > 
> > > Patch 3 notes that while a VMA is moved under the anon_vma lock, the page
> > > 	tables are not similarly protected. Where migration PTEs are
> > > 	encountered, they are cleaned up.
> > 
> > This means they are copied / moved etc and "cleaned" up in a state when
> > the page was unlocked. Migration entries are not supposed to exist when
> > a page is not locked.
> 
> patch 3 is real, and the first thought I had was to lock down the page
> before running vma_adjust and unlock after move_page_tables. But these
> are virtual addresses. Maybe there's a simpler way to keep migration
> away while we run those two operations.
> 

Doing some check in move_ptes() after vma_adjust() is not safe.
IOW, when vma's information and information in page-table is incosistent...objrmap
is broken and migartion will cause panic.

Then...I think there are 2 ways.
  1. use seqcounter in "mm_struct" as previous patch and lock it at mremap.
or
  2. get_user_pages_fast() when do remap.

Thanks,
-Kame







