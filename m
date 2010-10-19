Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933814Ab0JSEEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 00:04:31 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28444 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757890Ab0JSD4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaFSQSKSg
Message-Id: <20101019034216.319085068@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:16 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 00/35] my inode scaling series for review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is my famously tardy inode scaling patch set, for review for merging.
Yes it is a lot of patches, but it is very well broken out. It is not
rocket science -- if you don't understand something please get me to add
comments.

Patches 1-13 incrementally take over inode_lock in small, conservative,
obvious (as possible) steps. Subsequent patches improve code and
performance.

The only significant changes made from the inode scaling work in the
vfs-scale tree are merging to mainline, taking review suggestions, changing
the patch set to be better split up and improving comments and changelogs.

This is compatible with the rest of the dcache scaling improvements in my
tree, including the store-free path walking (rcu-walk).

I don't think Dave Chinner's approach is the way to go for a number of
reasons.

* My locking design allows i_lock to lock the entire state of the icache
  for a particular inode. Not so with Dave's, and he had to add code not
  required with inode_lock synchronisation or my i_lock synchronisation.
  I prefer being very conservative about making changes, especially before
  inode_lock is lifted (which will be the end-point of bisection for any
  locking breakage before it).

* As far as I can tell, I have addressed all Dave and Christoph's real
  concerns.  The disagreement about the i_lock locking model can easily be
  solved if they post a couple of small incremental patches to the end of the
  series, making i_lock locking less regular and no longer protecting icache
  state of that given inode (like inode_lock was able to pre-patchset). I've
  repeatedly disagreed with this approach, however.

* I have used RCU for inodes, and structured a lot of the locking around that.
  RCU is required for store-free path walking, so it makes more sense IMO to
  implement now rather than in a subsequent release (and reworking inode locking  to take advantage of it). I have a design sketched for using slab RCU freeing,  which is a little more complex, but it should be able to take care of any
  real-workload regressions if we do discover them.

* I implement per-zone LRU lists and locking, which are desperately required
  for reasonable NUMA performance, and are a first step towards proper mem
  controller control of vfs caches (Google have a similar per-zone LRU patch
  they need for their fakenuma based memory control, I believe).

* I implemented per-cpu locking for inode sb lists. The scalability and
  single threaded performance of the full vfs-scale stack has been tested
  quite well. Most of the vfs scales pretty linearly up to several hundreds
  of sockets at least. I have counted cycles on various x86 and POWER
  architectures to improve single threaded performance. It's an ongoing
  process but there has been a lot of work done already there.

  We want all these things ASAP, so it doesn't make sense to me to stage out
  significant locking changes in the icache code over several releases. Just
  get them out of the way now -- the series is bisectable and reviewable, so
  I think it will reduce churn and headache for everyone to get it out of the
  way now.


