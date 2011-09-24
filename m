Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab1IXBVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 21:21:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:40869 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab1IXBVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 21:21:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="55406114"
From: Andi Kleen <andi@firstfloor.org>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BFS cpu scheduler and skip list implementation
References: <201109240945.58879.kernel@kolivas.org>
Date: Fri, 23 Sep 2011 18:21:06 -0700
In-Reply-To: <201109240945.58879.kernel@kolivas.org> (Con Kolivas's message of
	"Sat, 24 Sep 2011 09:45:58 +1000")
Message-ID: <m28vpeka65.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas <kernel@kolivas.org> writes:

> Many of you may know about Skip lists as an alternative to balanced binary 
> search trees. They feature O(log n) insertion, lookup and removal of table 
> entries. Anyway I've been looking for some time at the O(n) lookup of BFS 
> (which is O(1) insertion and removal) to try and find a solution that didn't 
> cost us at the desktop level since O(n) of small numbers of n is very fast. 
> The problem is of course at higher numbers of n (or server type loads), where 
> it gets linearly slower, and the cache trashing aspect of scanning linked 
> lists becomes expensive.

The big problem with skiplists is that it is hard to resize the pointer
arrays: so you either waste a lot of memory/cache or you have a highest
limit after which they start performing poorly.

I investigated them some time ago to replace the non scalable rbtrees
we have currently, but got discouraged by these problems.

> +struct nodeStructure {
> +	int level;	/* Levels in this structure */
> +	keyType key;
> +	valueType value;
> +	skiplist_node *next[16];
> +	skiplist_node *prev[16];
> +};

That's 128 byte / 2 cache lines, not too bad, but it limits
the maximum number of tasks that can be efficiently handled
(my guess to around 64k with maxlevel == 16, but someone may
correct me on that)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
