Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405Ab0EFNmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 09:42:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758311Ab0EFNmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 09:42:15 -0400
Message-ID: <4BE2C6E8.2030609@redhat.com>
Date: Thu, 06 May 2010 09:40:56 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 1/2] mm,migration: Prevent rmap_walk_[anon|ksm] seeing
 the wrong VMA information
References: <1273065281-13334-1-git-send-email-mel@csn.ul.ie> <1273065281-13334-2-git-send-email-mel@csn.ul.ie> <alpine.LFD.2.00.1005050729000.5478@i5.linux-foundation.org> <20100505145620.GP20979@csn.ul.ie> <alpine.LFD.2.00.1005050815060.5478@i5.linux-foundation.org> <20100505155454.GT20979@csn.ul.ie> <alpine.LFD.2.00.1005051007140.27218@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005051007140.27218@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2010 01:34 PM, Linus Torvalds wrote:

>   - you always lock the _deepest_ anon_vma you can find.

The emphasis should be on "always" :)

> That means just a single lock. And the "deepest" anon_vma is well-defined
> for all anon_vma's, because each same_anon_vma chain is always rooted in
> the original anon_vma that caused it.

It should work, but only if we always take the deepest
anon_vma lock.

Not just in the migration code, but also in mmap, munmap,
mprotect (for split_vma), expand_stack, etc...

Otherwise we will still not provide exclusion of migrate
vs. those events.

I'm guessing that means changing both anon_vma_lock and
page_lock_anon_vma to always take the deepest anon_vma
lock - not introducing a new function that is only called
by the migration code.

-- 
All rights reversed
