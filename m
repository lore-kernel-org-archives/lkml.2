Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306Ab0ELW3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 18:29:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754165Ab0ELW3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 18:29:21 -0400
Date: Wed, 12 May 2010 15:26:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Linux-MM <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] always lock the root (oldest) anon_vma
In-Reply-To: <4BEB2923.8030200@redhat.com>
Message-ID: <alpine.LFD.2.00.1005121520500.3711@i5.linux-foundation.org>
References: <20100512133815.0d048a86@annuminas.surriel.com> <20100512134029.36c286c4@annuminas.surriel.com> <alpine.LFD.2.00.1005121441350.3711@i5.linux-foundation.org> <4BEB2923.8030200@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 12 May 2010, Rik van Riel wrote:
> 
> I suspect the atomic_dec_and_lock in the KVM code is being used
> to prevent the following race:
> 
> 1) KSM code reduces the refcount to 0
> 
> 2)     munmap on other CPU frees the anon_vma
> 
> 3) KSM code takes the anon_vma lock,
>    which now lives in freed memory

Hmm. Well, if it were just about the lock, then that would be fine. That's 
why we do the whole anon_vma RCU freeing dance, after all.

But I guess you're right - although not because of the lock. You're right 
because it would be a double-free - both parties would decide that they 
can free the damn thing, because it's not a pure atomic refcount, it's a 
"refcount or list_empty()" thing.

If _everybody_ was using the refcount, we could just do the 
atomic_dec_and_test(). But they aren't. So yeah, I guess we do want that 
nasty dec-and-lock version.

			Linus
