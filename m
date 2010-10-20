Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab0JTNOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 09:14:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35939 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab0JTNOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 09:14:47 -0400
Date: Wed, 20 Oct 2010 14:14:46 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: npiggin@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 00/35] my inode scaling series for review
Message-ID: <20101020131446.GB24394@ZenIV.linux.org.uk>
References: <20101019034216.319085068@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019034216.319085068@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 02:42:16PM +1100, npiggin@kernel.dk wrote:

> I don't think Dave Chinner's approach is the way to go for a number of
> reasons.
> 
> * My locking design allows i_lock to lock the entire state of the icache
>   for a particular inode. Not so with Dave's, and he had to add code not
>   required with inode_lock synchronisation or my i_lock synchronisation.
>   I prefer being very conservative about making changes, especially before
>   inode_lock is lifted (which will be the end-point of bisection for any
>   locking breakage before it).

I don't think so; in particular, hash chains protection would be more
natural *outside* of i_lock.  I'm not particulary concerned about
trylock in there, or about the width of area where we are holding ->i_lock,
but I really don't think this locking hierarchy makes _sense_.

> * As far as I can tell, I have addressed all Dave and Christoph's real
>   concerns.  The disagreement about the i_lock locking model can easily be
>   solved if they post a couple of small incremental patches to the end of the
>   series, making i_lock locking less regular and no longer protecting icache
>   state of that given inode (like inode_lock was able to pre-patchset). I've
>   repeatedly disagreed with this approach, however.

IMO you are worrying about the wrong things.  Frankly, I'm a lot more
concerned about the locking being natural for the data structures we
have and easily understood.  We *are* fscking close to the complexity
cliff, hopefully still on the right side of it.  And "if you compare that
to earlier code, you can show that it doesn't break unless the old one had
been broken too" doesn't work well for analysis of the result.  Even now,
nevermind a couple of months later.

> * I have used RCU for inodes, and structured a lot of the locking around that.
>   RCU is required for store-free path walking, so it makes more sense IMO to
>   implement now rather than in a subsequent release (and reworking inode locking  to take advantage of it). I have a design sketched for using slab RCU freeing,  which is a little more complex, but it should be able to take care of any
>   real-workload regressions if we do discover them.

Separate (sub)series.

> * I implement per-zone LRU lists and locking, which are desperately required
>   for reasonable NUMA performance, and are a first step towards proper mem
>   controller control of vfs caches (Google have a similar per-zone LRU patch
>   they need for their fakenuma based memory control, I believe).

Ditto.

> * I implemented per-cpu locking for inode sb lists. The scalability and
>   single threaded performance of the full vfs-scale stack has been tested
>   quite well. Most of the vfs scales pretty linearly up to several hundreds
>   of sockets at least. I have counted cycles on various x86 and POWER
>   architectures to improve single threaded performance. It's an ongoing
>   process but there has been a lot of work done already there.
> 
>   We want all these things ASAP, so it doesn't make sense to me to stage out
>   significant locking changes in the icache code over several releases. Just
>   get them out of the way now -- the series is bisectable and reviewable, so
>   I think it will reduce churn and headache for everyone to get it out of the
>   way now.

We want all these things, but I'd prefer to have them unbundled, TYVM.  Even
if we end up merging all in one cycle.  With locking going first.

One trivial note on splitup: e.g. the patch closer to the end, introducing
inode_get() can and should be pulled all the way in front, with only the
helper to be modified when you play with i_count later.  General principle:
if you end up switching to helper anyway, better do that immediately and
do subsequent changes to that helper rather than touching every place where
it's been open-coded...
