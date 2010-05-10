Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0EJBw7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 21:52:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754774Ab0EJBw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 21:52:56 -0400
Date: Sun, 9 May 2010 18:49:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] mm,migration: Fix race between shift_arg_pages and
 rmap_walk by guaranteeing rmap_walk finds PTEs created within the temporary
 stack
In-Reply-To: <20100510104039.98332e67.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.LFD.2.00.1005091847260.3711@i5.linux-foundation.org>
References: <1273188053-26029-1-git-send-email-mel@csn.ul.ie> <1273188053-26029-3-git-send-email-mel@csn.ul.ie> <alpine.LFD.2.00.1005061836110.901@i5.linux-foundation.org> <20100507105712.18fc90c4.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.LFD.2.00.1005061905230.901@i5.linux-foundation.org> <20100509192145.GI4859@csn.ul.ie> <alpine.LFD.2.00.1005091245000.3711@i5.linux-foundation.org> <20100510094050.8cb79143.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1005091827500.3711@i5.linux-foundation.org>
 <alpine.LFD.2.00.1005091831140.3711@i5.linux-foundation.org> <20100510104039.98332e67.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 10 May 2010, KAMEZAWA Hiroyuki wrote:
>
> Hmm. vm_flags is still 32bit..(I think it should be long long)
> 
> Using combination of existing flags...
> 
> #define VM_STACK_INCOMPLETE_SETUP (VM_RAND_READ | VM_SEC_READ)
> 
> Can be used instead of checking mapcount, I think.

Ahh, yes. We can also do things like not having VM_MAY_READ/WRITE set. 
That's impossible on a real mapping - even if it's not readable, it is 
always something you could mprotect to _be_ readable.

The point being, we can make the tests more explicit, and less "magic that 
happens to work". As long as it's ok to just say "don't migrate pages in 
this mapping yet, because we're still setting it up".

			Linus
