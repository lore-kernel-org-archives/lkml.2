Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab2KURIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 12:08:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38856 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab2KURIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 12:08:54 -0500
Date: Wed, 21 Nov 2012 18:08:50 +0100
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: The bug of iput() removal from flusher thread?
Message-ID: <20121121170850.GD30250@quack.suse.cz>
References: <8762541uyx.fsf@devron.myhome.or.jp>
 <873906vumh.fsf@devron.myhome.or.jp>
 <20121119145140.GA20532@quack.suse.cz>
 <20121119194102.GB20532@quack.suse.cz>
 <87a9udtiyk.fsf@devron.myhome.or.jp>
 <20121119212448.GA29498@quack.suse.cz>
 <876251tg3b.fsf@devron.myhome.or.jp>
 <20121121011111.GE10507@quack.suse.cz>
 <20121121014851.GH10507@quack.suse.cz>
 <20121121024405.GN2591@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121121024405.GN2591@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 21-11-12 13:44:05, Dave Chinner wrote:
> On Wed, Nov 21, 2012 at 02:48:51AM +0100, Jan Kara wrote:
> > 
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 51ea267..3e3422f 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -228,6 +228,8 @@ static void requeue_io(struct inode *inode, struct bdi_writeback *wb)
> >  static void inode_sync_complete(struct inode *inode)
> >  {
> >  	inode->i_state &= ~I_SYNC;
> > +	/* If inode is clean an unused, put it into LRU now... */
> > +	inode_add_lru(inode);
> >  	/* Waiters must see I_SYNC cleared before being woken up */
> >  	smp_mb();
> >  	wake_up_bit(&inode->i_state, __I_SYNC);
> > diff --git a/fs/inode.c b/fs/inode.c
> > index b03c719..8f6396f 100644
> > --- a/fs/inode.c
> > +++ b/fs/inode.c
> > @@ -408,6 +408,19 @@ static void inode_lru_list_add(struct inode *inode)
> >  	spin_unlock(&inode->i_sb->s_inode_lru_lock);
> >  }
> >  
> > +/*
> > + * Add inode to LRU if needed (inode is unused and clean).
> > + *
> > + * Needs inode->i_lock held.
> > + */
> > +void inode_add_lru(struct inode *inode)
> > +{
> > +	if (!(inode->i_state & (I_DIRTY | I_FREEING | I_SYNC)) &&
> > +	    !atomic_read(&inode->i_count) && inode->i_sb->s_flags & MS_ACTIVE)
> > +		inode_lru_list_add(inode);
> 
> Needs to avoid I_WILL_FREE as well. There's no point putting it on
> the LRU if we are writing from iput_final()....
  Yeah, it won't cause any real problems but you are right it's not useful
to put such inodes into the LRU. I'll send v3 in a moment, now as a proper
patch submission since we seem to agree...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
