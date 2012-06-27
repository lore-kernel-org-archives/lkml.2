Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab2F0QIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 12:08:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40529 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976Ab2F0QIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 12:08:12 -0400
Date: Wed, 27 Jun 2012 18:08:07 +0200
From: Jan Kara <jack@suse.cz>
To: mc@linux.vnet.ibm.com
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: Go through the LRU list of inode from head
Message-ID: <20120627160807.GB5387@quack.suse.cz>
References: <1340269227-20310-1-git-send-email-mc@linux.vnet.ibm.com>
 <20120621095223.GA11645@quack.suse.cz>
 <20120626033546.Horde.D-JZIpir309P6WZSsiFCifA@imap.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120626033546.Horde.D-JZIpir309P6WZSsiFCifA@imap.linux.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 26-06-12 03:35:46, mc@linux.vnet.ibm.com wrote:
> Quoting Jan Kara <jack@suse.cz>:
> 
> >On Thu 21-06-12 17:00:27, Cong Meng wrote:
> >>Go through the LRU list of inode from head.
> >>
> >>(I'm not sure whether there is any trick here I doesn't get.  If yes,
> >>any one could explain it)
> >  Look at inode_lru_list_add(). It adds at the head of the list. So you
> >should take from the tail to get the least recently used element...
> 
> I still have a quetion about the subsequent code and comment:
> 
> inode = list_entry(sb->s_inode_lru.prev, struct inode, i_lru);
> /*
>  * we are inverting the sb->s_inode_lru_lock/inode->i_lock here,
>  * so use a trylock. If we fail to get the lock, just move the
>  * inode to the back of the list so we don't spin on it.
>  */
> if (!spin_trylock(&inode->i_lock)) {
>         list_move_tail(&inode->i_lru, &sb->s_inode_lru);
>         continue;
> }
> 
> Shouldn't the inode be moved to the head to avoid spin on it?
  Yes, it should.

> I note that list_move was replaced by list_move_tail purposely in a commit.
  Right, you are speaking about Christoph's commit 62a3ddef? I agree that
commit looks bogus and should be reverted AFAICT. Christoph?

> and below piece of code (at the bottom of prune_icache_sb()):
> 
> if (inode != list_entry(sb->s_inode_lru.next,
>                         struct inode, i_lru))
>         continue;       /* wrong inode or list_empty */
> 
> Should the inode be compared against to the tail of the list other
> than the head
> after re-get the lru lock?
  And you seem to be right here as well. Thanks for having a look!

								Honza

> >>Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
> >>---
> >> fs/inode.c |    2 +-
> >> 1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >>diff --git a/fs/inode.c b/fs/inode.c
> >>index 775cbab..aac8449 100644
> >>--- a/fs/inode.c
> >>+++ b/fs/inode.c
> >>@@ -704,7 +704,7 @@ void prune_icache_sb(struct super_block *sb,
> >>int nr_to_scan)
> >> 		if (list_empty(&sb->s_inode_lru))
> >> 			break;
> >>
> >>-		inode = list_entry(sb->s_inode_lru.prev, struct inode, i_lru);
> >>+		inode = list_entry(sb->s_inode_lru.next, struct inode, i_lru);
> >>
> >> 		/*
> >> 		 * we are inverting the sb->s_inode_lru_lock/inode->i_lock here,
> >>--
> >>1.7.5.4
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
