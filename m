Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab0JWVh4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 17:37:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33249 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab0JWVhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 17:37:54 -0400
Date: Sat, 23 Oct 2010 22:37:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/21] fs: Protect inode->i_state with the inode->i_lock
Message-ID: <20101023213752.GR19804@ZenIV.linux.org.uk>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <1287622186-1935-17-git-send-email-david@fromorbit.com>
 <20101022015622.GE19804@ZenIV.linux.org.uk>
 <20101022031431.GK12506@dastard>
 <20101022103705.GK19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022103705.GK19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 11:37:05AM +0100, Al Viro wrote:

> What I'm going to do is to put together a branch with essentially cleanups
> and trivial fixes, with both patchsets forked off its tip.  Then move stuff
> to common stem, rediffing the branches as we go.  Then see what's left.

OK, the current (partial) set is in

git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ #merge-stem

What remains to be done (I'm about to fall down right now, so that'll have
to wait until tomorrow):

	* writeback_sb_inode() told to ignore I_FREEING ones in addition to
I_NEW and I_WILL_FREE ones it ignores now.  Currently I_FREEING can't be
found there at all, so that'll change nothing.
	* invalidate_inodes() - collect I_FREEING/I_WILL_FREE on a separate
list, then (after we'd evicted the stuff we'd decided to evict) wait until
they get freed by whatever's freeing them already.
	* remove_dquot_ref() - looks like we might be OK with that one being
as it is - it walks sb list of inodes and for things like prune_icache()
the inodes stay on said list all the way through evict(), so it either
doesn't care or it's already broken.  And no, I'm not discounting either
possibility - it needs further analysis.

That's it - after that we'll be OK with dropping and regaining inode_lock
between the moment when we set I_FREEING and removals from the lists.
