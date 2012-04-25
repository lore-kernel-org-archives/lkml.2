Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355Ab2DYT6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 15:58:24 -0400
Received: from fieldses.org ([174.143.236.118]:34363 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758135Ab2DYT6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 15:58:23 -0400
Date: Wed, 25 Apr 2012 15:58:15 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>, switeho@redhat.com
Subject: Re: [PATCH 5/5] vfs: change nondirectory i_mutex ordering to fix
 quota deadlock
Message-ID: <20120425195815.GG751@fieldses.org>
References: <20120418215238.GA11959@fieldses.org>
 <1335367329-929-5-git-send-email-bfields@fieldses.org>
 <20120425152858.GB751@fieldses.org>
 <20120425195343.GC27193@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425195343.GC27193@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 09:53:43PM +0200, Jan Kara wrote:
> On Wed 25-04-12 11:28:58, J. Bruce Fields wrote:
> > On Wed, Apr 25, 2012 at 11:22:09AM -0400, bfields@fieldses.org wrote:
> > > diff --git a/fs/inode.c b/fs/inode.c
> > > index 487c924..13d23b6 100644
> > > --- a/fs/inode.c
> > > +++ b/fs/inode.c
> > > @@ -961,6 +961,17 @@ void unlock_new_inode(struct inode *inode)
> > >  }
> > >  EXPORT_SYMBOL(unlock_new_inode);
> > >  
> > > +/*
> > > + * We order !IS_NOQUOTA files before ISNOQUOTA files, and by pointer
> > > + * within each category.
> > > + */
> > > +static bool nondir_mutex_ordered(struct inode *inode1, struct inode *inode2)
> > > +{
> > > +	if (IS_NOQUOTA(inode1) == IS_NOQUOTA(inode2))
> > > +		return inode1 < inode2;
> > > +	return IS_NOQUOTA(inode2);
> > > +}
> > 
> > This seems kind of awful.  Is it what you were thinking of originally,
> > Al, and could we live with it?
>   Yeah, it's pretty ugly and also racy. I'm just now testing patches that
> would get rid of I_MUTEX_QUOTA usage for filesystems (except GFS2) and
> quota code. GFS2 could be certainly dealt with as well (at least by
> introducing a new GFS2 internal lock) so this ugly code can go away.

That would be great, thanks!

--b.
