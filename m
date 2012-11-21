Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab2KUBLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 20:11:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab2KUBLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 20:11:14 -0500
Date: Wed, 21 Nov 2012 02:11:11 +0100
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: The bug of iput() removal from flusher thread?
Message-ID: <20121121011111.GE10507@quack.suse.cz>
References: <8762541uyx.fsf@devron.myhome.or.jp>
 <873906vumh.fsf@devron.myhome.or.jp>
 <20121119145140.GA20532@quack.suse.cz>
 <20121119194102.GB20532@quack.suse.cz>
 <87a9udtiyk.fsf@devron.myhome.or.jp>
 <20121119212448.GA29498@quack.suse.cz>
 <876251tg3b.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <876251tg3b.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 20-11-12 06:53:12, OGAWA Hirofumi wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >> >  static void inode_sync_complete(struct inode *inode)
> >> >  {
> >> > +	/* If inode is clean an unused, put it into LRU now.  */
> >> > +	if (!(inode->i_state & I_DIRTY) && !atomic_read(&inode->i_count))
> >> > +		inode_lru_list_add(inode);
> >> 
> >> IMHO, open coding this would be bad idea.
> >   Do you mean creating a separate function for the above two lines?
> 
> Yes. And the intent is to consolidate "when adds inode to LRU" with
> iput_final()'s one.
> 
> >> And another one is I_REFERENCED. We really want to remove I_REFERENCED?
> >   We don't want I_REFERENCED set - noone used the inode. But looking into
> > the code with fresh eyes, the fix isn't as simple as I thought. First I
> > need to check MS_ACTIVE and second I need to check I_FREEING... So the
> > condition will be complex enough to warrant a separate function.
> 
> I can't see the issue (sync_filesystem() will wait I_DIRTY before
> MS_ACTIVE, and I_DIRTY prevents I_FREEING) though, it may be possible.
  E.g. when inode is deleted it can be both I_DIRTY (and flusher thread
can be working on it) while it is also marked as I_FREEING. In such case we
must avoid adding the inode to the LRU.

  Regarding MS_ACTIVE - you are right that sync_filesystem() should clean
all dirty inodes but some filesystems dirty their internal inodes during
umount so it's better to make flusher thread safe and not add such inodes
to the LRU during umount.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
