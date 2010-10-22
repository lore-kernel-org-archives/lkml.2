Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab0JVC07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 22:26:59 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:47478 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907Ab0JVC06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 22:26:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAL+QwEx5Ldx0/2dsb2JhbAChXnK+SIVKBI9O
Date: Fri, 22 Oct 2010 13:26:54 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/21] fs: Protect inode->i_state with the inode->i_lock
Message-ID: <20101022022654.GA6535@amd>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <1287622186-1935-17-git-send-email-david@fromorbit.com>
 <20101022015622.GE19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022015622.GE19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 02:56:22AM +0100, Al Viro wrote:
> On Thu, Oct 21, 2010 at 11:49:41AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> For the path that leaves the inode alive and hashed - sorry, can't do.
> AFAICS, unlike hash, wb and sb locks, lru lock should nest *inside*
> ->i_lock.  And yes, it means trylock in prune_icache(), with "put it in
> the end of the list for one more spin" if we fail.  In that case it's
> really cleaner that way.

I still have found that nesting them all inside i_lock is much more
natural a way to protect the inode's icache state.

Typically, we either have an icache data structure that we want to
look up one inode from, or we have an inode that we need to do one
*or more* icache state manipulations on.

When it involves putting the inode on or off different data structures,
holding i_lock over the sequence allows us to lift inode_lock without
much further thought.

One downside is the trylocks -- most can be subsequently removed quite
easily by doing data structure lookups without locks. I prefer this
approach, and be easily able to hold i_lock over the entirety of
something like iput_final. At least for the initial lock break work.

