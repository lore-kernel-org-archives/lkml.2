Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab0EKAOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 20:14:31 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36358 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953Ab0EKAO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 20:14:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 11 May 2010 09:10:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Lameter <cl@linux.com>, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] mm,migration: Avoid race between shift_arg_pages()
 and rmap_walk() during migration by not migrating temporary stacks
Message-Id: <20100511091022.347785db.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100510190559.GD22632@random.random>
References: <1272529930-29505-1-git-send-email-mel@csn.ul.ie>
	<1272529930-29505-3-git-send-email-mel@csn.ul.ie>
	<alpine.DEB.2.00.1005012055010.2663@router.home>
	<20100504094522.GA20979@csn.ul.ie>
	<alpine.DEB.2.00.1005101239400.13652@router.home>
	<20100510190559.GD22632@random.random>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010 21:05:59 +0200
Andrea Arcangeli <aarcange@redhat.com> wrote:

> On Mon, May 10, 2010 at 12:41:07PM -0500, Christoph Lameter wrote:
> > A simple way to disallow migration of pages is to increment the refcount
> > of a page.
> 
> Ok for migrate but it won't prevent to crash in split_huge_page rmap
> walk, nor the PG_lock. Why for a rmap bug have a migrate specific fix?
> The fix that makes execve the only special place to handle in every
> rmap walk, is at least more maintainable than a fix that makes one of
> the rmap walk users special and won't fix the others, as there will be
> more than just 1 user that requires this. My fix didn't make execve
> special and it didn't require execve knowledge into the every rmap
> walk like migrate (split_huge_page etc...) but as long as the kernel
> doesn't crash I'm fine ;).
> 

At first, I like step-by-step approach even if it makes our cost double
because it's easy to understand and makes chasing change-log easy.

Ok, your split_huge_page() has some problems with current rmap+migration.
But I don't like a patch for never-happen-now bug in change-log.

I believe it can be fixed by the same approach for execs.
Renaming 
#define VM_STACK_INCOMPLETE_SETUP
to be
#define VM_TEMPORARY_INCONSITENT_RMAP
in _your_ patch series and add some check in rmap_walk() seems enough.

Of course, I may misunderstand your problem. Could you show your patch
which meets the problem with rmap+migration ?

Thanks,
-Kame




