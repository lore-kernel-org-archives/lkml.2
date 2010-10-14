Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab0JNOmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 10:42:06 -0400
Received: from canuck.infradead.org ([134.117.69.58]:51864 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab0JNOmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 10:42:04 -0400
Date: Thu, 14 Oct 2010 10:41:59 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101014144159.GA11972@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-18-git-send-email-david@fromorbit.com>
 <20101013072058.GA3121@amd>
 <20101013112552.GB16422@infradead.org>
 <20101013123008.GA6067@amd>
 <20101013232319.GZ4681@dastard>
 <20101014090609.GB3144@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014090609.GB3144@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 08:06:09PM +1100, Nick Piggin wrote:
> Shrinker and zone reclaim is definitely needed. It is needed for NUMA
> scalability and locality of reclaim, and also for container and directed
> dentry/inode reclaim. Google have a very similar patch and they've said
> this is needed (and I already know it is needed for scalability on
> large NUMA -- SGI were complaining about this nearly 5 years ago IIRC).
> So that is _definitely_ going to be needed.

I'm sitll not sold on the per-zone shrinkers.  For one per-zone is
a really weird concept.  per-node might make a lot more sense, but
what we really need for doing things usefully is per-sb.  If that's
not scalable we might have to for sb x zone.

Either way it's not needed for a lot of workloads, and it's very
controversial.  Trying to beat it though with a take all or everthing
attitude is not helpful, and your constant insistance on it is probably
the biggest factor for delaying all this work so long.

Someone is going to do VFS scaling in pieces and if you're not willing
to help it's going to be someone else.  We'll still build ontop of your
great initial work, though.

> Store-free path walking is definitely needed, so we need to do RCU inodes.
> With RCU inodes, the optimal locking protocols change quite a bit --

I don't think anyone disagrees with that.  How we do the RCU locking
in detail is however still open.  I'd for example really like to see
inodes use slab rcu freeing from the beginning.

> It is really pretty close, and while *you* have some disagreements,
> it has had some reviews from other people (including Linus) who actually
> agree with most of it and agree that scalability is needed.

Again, I've not seen anyone arguing against the scalability.  But as
you might have noticed there's some very different opinions on how
to go there.

> It's much past a prototype. While the patches need some more cleanup
> and review still, the final end result gives a tree with almost no
> global cachelines in the entire vfs, including path walking.

It's a nice prototype, no diagreement.  But we'll need to change a lot
of the VFS things as we go to do things properly.

> Things
> like path walks are nearly 50% faster single threaded, and perfectly
> scalable. Linus actually wants the store-free path walk stuff
> _before_ any of the other things, if that gives you an idea of where
> other people are putting the priority of the patches.

Different people have different priorities.  In the end the person
doing the work of actually getting it in a mergeable shape is setting
the pace.  If you had started splitting out the RCU pathwalk bits half a
year ago there's we already have it in now.  But that's now how it
worked.
