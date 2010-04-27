Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab0D0Dyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 23:54:49 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46791 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab0D0Dyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 23:54:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 27 Apr 2010 12:50:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] mm,migration: Prevent rmap_walk_[anon|ksm] seeing
 the wrong VMA information
Message-Id: <20100427125040.634f56b3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100427090706.7ca68e12.kamezawa.hiroyu@jp.fujitsu.com>
References: <1272321478-28481-1-git-send-email-mel@csn.ul.ie>
	<1272321478-28481-3-git-send-email-mel@csn.ul.ie>
	<20100427090706.7ca68e12.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010 09:07:06 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Mon, 26 Apr 2010 23:37:58 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > vma_adjust() is updating anon VMA information without any locks taken.
> > In contrast, file-backed mappings use the i_mmap_lock and this lack of
> > locking can result in races with page migration. During rmap_walk(),
> > vma_address() can return -EFAULT for an address that will soon be valid.
> > This leaves a dangling migration PTE behind which can later cause a BUG_ON
> > to trigger when the page is faulted in.
> > 
> > With the recent anon_vma changes, there can be more than one anon_vma->lock
> > that can be taken in a anon_vma_chain but a second lock cannot be spinned
> > upon in case of deadlock. Instead, the rmap walker tries to take locks of
> > different anon_vma's. If the attempt fails, the operation is restarted.
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> 
> Ok, acquiring vma->anon_vma->spin_lock always sounds very safe.
> (but slow.)
> 
> I'll test this, too.
> 
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 

Sorry. reproduced. It seems the same bug before patch. 
mapcount 1 -> unmap -> remap -> mapcount 0. And it was SwapCache.


Thanks,
-Kame

