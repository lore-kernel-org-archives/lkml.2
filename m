Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab0D0JOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:14:05 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60716 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab0D0JOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:14:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 27 Apr 2010 18:09:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] mm,migration: Prevent rmap_walk_[anon|ksm] seeing
 the wrong VMA information
Message-Id: <20100427180949.673350f2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100427085951.GB4895@csn.ul.ie>
References: <1272321478-28481-1-git-send-email-mel@csn.ul.ie>
	<1272321478-28481-3-git-send-email-mel@csn.ul.ie>
	<20100427090706.7ca68e12.kamezawa.hiroyu@jp.fujitsu.com>
	<20100427125040.634f56b3.kamezawa.hiroyu@jp.fujitsu.com>
	<20100427085951.GB4895@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010 09:59:51 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> On Tue, Apr 27, 2010 at 12:50:40PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Tue, 27 Apr 2010 09:07:06 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > On Mon, 26 Apr 2010 23:37:58 +0100
> > > Mel Gorman <mel@csn.ul.ie> wrote:
> > > 
> > > > vma_adjust() is updating anon VMA information without any locks taken.
> > > > In contrast, file-backed mappings use the i_mmap_lock and this lack of
> > > > locking can result in races with page migration. During rmap_walk(),
> > > > vma_address() can return -EFAULT for an address that will soon be valid.
> > > > This leaves a dangling migration PTE behind which can later cause a BUG_ON
> > > > to trigger when the page is faulted in.
> > > > 
> > > > With the recent anon_vma changes, there can be more than one anon_vma->lock
> > > > that can be taken in a anon_vma_chain but a second lock cannot be spinned
> > > > upon in case of deadlock. Instead, the rmap walker tries to take locks of
> > > > different anon_vma's. If the attempt fails, the operation is restarted.
> > > > 
> > > > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > > 
> > > Ok, acquiring vma->anon_vma->spin_lock always sounds very safe.
> > > (but slow.)
> > > 
> > > I'll test this, too.
> > > 
> > > Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > 
> > 
> > Sorry. reproduced. It seems the same bug before patch. 
> > mapcount 1 -> unmap -> remap -> mapcount 0. And it was SwapCache.
> > 
> 
> Same here, reproduced after 18 hours.
> 
Hmm. It seems rmap_one() is called and the race is not in vma_address()
but in remap_migration_pte().
So, I added more hooks for debug..but not reproduced yet.
(But I doubt my debug code, too ;)

But it seems strange to have a race in remap_migration_pte(), so, I doubt
my debug code, too.

Thanks,
-Kame

