Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab0JTNDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 09:03:52 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:60377 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751128Ab0JTNDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 09:03:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOqEvkx5LdoF/2dsb2JhbAChWHK+EIVKBI9M
Date: Thu, 21 Oct 2010 00:03:45 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: npiggin@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch 19/35] fs: icache remove redundant i_sb_list umount
 locking
Message-ID: <20101020130345.GA6663@amd>
References: <20101019034216.319085068@kernel.dk>
 <20101019034657.476923711@kernel.dk>
 <20101020124631.GA24394@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101020124631.GA24394@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 01:46:31PM +0100, Al Viro wrote:
> On Tue, Oct 19, 2010 at 02:42:35PM +1100, npiggin@kernel.dk wrote:
> > +	/*
> > +	 * We can walk the per-sb list of inodes here without worrying about
> > +	 * its consistency, because the list must not change during umount
> > +	 * anymore, and because iprune_sem keeps shrink_icache_memory() away.
> > +	 */
> >  	fsnotify_unmount_inodes(&sb->s_inodes);
> 
> OK, explain to me why is that safe.  Note that fsnotify_destroy_mark()
> _can_ race with umount, dropping the last reference to inode before
> fsnotify_unmount_inodes() would get to it and kill it (along with the mark).
> With the current code it's just fine - we walk the list under lock and
> iput() won't mess with that list until it acquires the damn lock.  And
> no matter who gets there first, the mark will be destroyed and reference
> to inode will be dropped.
> 
> With your change, AFAICS, removal from the list can happen while we walk
> it.  With obvious results.

Ah, tricky. So after fsnotify_unmount_inodes runs, the invalidate_list
is now safe because no more marks can put the inode at that point? OK I
can concede that point and drop the patch, thanks.

Where can fsnotify_destroy_mark run concurrently at umount time, can you
explain? I haven't spotted it yet.

