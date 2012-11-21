Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab2KUBa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 20:30:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55534 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab2KUBa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 20:30:57 -0500
Date: Wed, 21 Nov 2012 02:30:55 +0100
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: The bug of iput() removal from flusher thread?
Message-ID: <20121121013055.GF10507@quack.suse.cz>
References: <8762541uyx.fsf@devron.myhome.or.jp>
 <873906vumh.fsf@devron.myhome.or.jp>
 <20121119145140.GA20532@quack.suse.cz>
 <20121119194102.GB20532@quack.suse.cz>
 <20121120223741.GI2591@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120223741.GI2591@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 21-11-12 09:37:41, Dave Chinner wrote:
> On Mon, Nov 19, 2012 at 08:41:02PM +0100, Jan Kara wrote:
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 51ea267..ed7613b 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -227,6 +227,9 @@ static void requeue_io(struct inode *inode, struct bdi_writeback *wb)
> >  
> >  static void inode_sync_complete(struct inode *inode)
> >  {
> > +	/* If inode is clean an unused, put it into LRU now.  */
> > +	if (!(inode->i_state & I_DIRTY) && !atomic_read(&inode->i_count))
> > +		inode_lru_list_add(inode);
> 
> Unsafe. Has to avoid I_FREEING|I_WILL_FREE (see warnings at start of
> writeback_single_inode()).
> 
> Also, if you do this after clearing the I_SYNC flag, you can use
> exactly the same logic as iput_final(). A helper function could be
> used for both cases at that point, and....
  Agreed. That's what I do in the current version of the patch (not posted
yet).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
