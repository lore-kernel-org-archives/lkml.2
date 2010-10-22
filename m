Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab0JVKhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 06:37:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39459 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab0JVKhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 06:37:08 -0400
Date: Fri, 22 Oct 2010 11:37:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/21] fs: Protect inode->i_state with the inode->i_lock
Message-ID: <20101022103705.GK19804@ZenIV.linux.org.uk>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <1287622186-1935-17-git-send-email-david@fromorbit.com>
 <20101022015622.GE19804@ZenIV.linux.org.uk>
 <20101022031431.GK12506@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022031431.GK12506@dastard>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 02:14:31PM +1100, Dave Chinner wrote:

> AFAICT, moving the inode_lru_lock inside i_lock doesn't affect the
> locking order of anything else, and I agree that putting a single
> trylock in the prune_icache loop is definitely cleaner than anything
> else I've been able to think of that retains the current locking
> order. It will also remove the wart in sync_inode().
> 
> So, I'll swallow my rhetoric and agree with you that inode_lru_lock
> inside the i_lock is the natural and easiest way to nest these
> locks. I'll rework the series to do this. 

FWIW, here's what I'd prefer:

* move the trivial parts in front of queue (including exofs fix, etc., etc.)
* make sure that _everything_ walking the lists honors I_FREEING/I_WILL_FREE
as the first step.  We are very close to that already 
* protect all accesses to ->i_state with ->i_lock
* separate lru list from wb
* protect lru list by spinlock nested inside ->i_lock, with trylock in
prune_icache()
* at that point we can rip the inode_lock off the initial part of iput
moving it down to the point after having marked the inode with I_FREEING
at that point we can take hash, etc. out of inode_lock and under locks of
their own one by one.  And that kills inode_lock completely, at which point
the hierarchy is established and we can do the rest (non-atomic refcount,
etc.)

Note that I'd rather leave *all* non-trivialities along the lines of
per-zone vs per-sb for after the hierarchy is done.  I.e. let's start
with really simple "here's the single spinlock for hash, here's the
single spinlock for all sb lists".  If we get that right, the rest will
be localized; let's deal with the skeleton first.

What I'm going to do is to put together a branch with essentially cleanups
and trivial fixes, with both patchsets forked off its tip.  Then move stuff
to common stem, rediffing the branches as we go.  Then see what's left.

One more note: IMO sb list lock is better off inside the hash one; when we
do per-chain hash locks, we'll be better off if we don't have to hold sb
one over the entire chain search.
