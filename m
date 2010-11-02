Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab0KBACJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 20:02:09 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:38763 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751069Ab0KBACI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 20:02:08 -0400
Date: Tue, 2 Nov 2010 11:01:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] fs: rcu protect inode hash lookups
Message-ID: <20101102000152.GO2715@dastard>
References: <1288589624-15251-1-git-send-email-david@fromorbit.com>
 <1288589624-15251-4-git-send-email-david@fromorbit.com>
 <1288604287.2660.94.camel@edumazet-laptop>
 <20101101134451.GN2715@dastard>
 <1288625362.2660.108.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1288625362.2660.108.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 04:29:22PM +0100, Eric Dumazet wrote:
> Le mardi 02 novembre 2010 à 00:44 +1100, Dave Chinner a écrit :
> 
> > Perhaps you should rename that file "slab_destroy_by_rcu-tips.txt",
> > because the current name seems unrelated to the contents. :/
> > 
> 
> Hmm, I dont know, this doc really is about the nulls thing.

Ok, now I understand - there's a new list type that I didn't know
about called hlist_nulls. not surprising - it's not documented
anywhere.

Maybe explicitly describing what the list_null pattern іs or a
pointer to linux/include/list_nulls.h might be appropriate, because
I managed to read that documentation and not realise that it was
refering to a specific type of list that was already implemented
rather than a simple marker technique.

> This stuff also addressed one problem I forgot to tell you about: During
> a lookup, you might find an item that is moved to another chain by
> another cpu, so your lookup is redirected to another chain. You can miss
> your target.

<groan>

So, to go to per-chain locks as per the proposed bit-lock-on-the-
low-bit-of-the-head-pointer infrastructure, we'll have to cross that
with the hlist_null code that plays low-bit pointer games for
detecting the end of the chain.

That's just messy - another hash chain specific scalability hackup.
My dislike of using hash tables for unbounded caches is not
improved by this....

> You must find a way to detect such thing to restart the lookup at
> the beginning (of the right chain).  Either you stick the chain
> number in a new inode field (that costs extra memory), or you use
> the 'nulls' value that can let you know if you ended your lookup
> in the right chain.

The chain is determined by hashing the inode number. Perhaps a
simple enough test is to hash the last inode number on a cache miss
and if that doesn't match the hash of the lookup key we redo the
search. That seems to me like it will avoid needing to play games
with termination markers - does that sound reasonable?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
