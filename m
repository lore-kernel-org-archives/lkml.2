Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab0J2FOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 01:14:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36611 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab0J2FOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 01:14:35 -0400
Date: Fri, 29 Oct 2010 06:14:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] fs: remove inode_lock from iput_final and
 prune_icache
Message-ID: <20101029051434.GO19804@ZenIV.linux.org.uk>
References: <1288322620-8566-1-git-send-email-david@fromorbit.com>
 <1288322620-8566-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288322620-8566-5-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 02:23:36PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that inode state changes are protected by the inode->i_lock and
> the inode LRU manipulations by the inode_lru_lock, we can remove the
> inode_lock from prune_icache and the initial part of iput_final().
> 
> instead of using the inode_lock to protect the inode during
> iput_final, use the inode->i_lock instead. This protects the inode
> against new references being taken while we change the inode state
> to I_FREEING, as well as preventing prune_icache from grabbing the
> inode while we are manipulating it. Hence we no longer need the
> inode_lock in iput_final prior to setting I_FREEING on the inode.
> 
> For prune_icache, we no longer need the inode_lock to protect the
> LRU list, and the inodes themselves are protected against freeing
> races by the inode->i_lock. Hence we can lift the inode_lock from
> prune_icache as well.

	Careful.  At that point we still rely on inode_lock to protect
inode_unhashed().  Note that ->drop_inode() uses it a lot and this step
moves it from inode_lock to ->i_lock.

	What you need to do is pretty simple - make remove_inode_hash()
take both inode_lock (later - inode_hash_lock) and ->i_lock.  That's
enough for inode_unhashed() protection, but I'd also hold ->i_lock on
insertions into hash.  It's trivial (we hold ->i_lock just next to that
insertion) and would make for more consistent rules.
