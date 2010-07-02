Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab0GBOeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 10:34:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51772 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab0GBOeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 10:34:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tlk7+qLeARx8dsubwQYh+YYhzbUZJO54IgEYUOlM3p0b6urNXB0HynsfbIC+pU+SgO
         BtsuNjh/MngRCRkQcXJiLjRVvfLh6gU1ZlxZDvFqt4KS4w0t/u+K0qZaDgvJjL4fFvde
         eYY3luancflXBwzF2fSEahaBlwUTOV8e0mkQk=
Date: Fri, 2 Jul 2010 16:34:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>,
       Jeff Mahoney <jeffm@jeffreymahoney.com>
Subject: Re: reiserfs locking (v2)
Message-ID: <20100702143419.GC5324@nowhere>
References: <20100702093451.GA3973@swordfish.minsk.epam.com> <20100702131248.GA5324@nowhere> <1278078267.1917.254.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278078267.1917.254.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 03:44:27PM +0200, Peter Zijlstra wrote:
> On Fri, 2010-07-02 at 15:12 +0200, Frederic Weisbecker wrote:
> > 
> > I don't think the deadlock can really happen, as we can't release the directory while
> > we are reading it. Plus I guess we can't mmap a directory (someone correct me if
> > I'm wrong).
> > 
> 
> > Is there someone who could give me a hint here?
> 
> If its purely directories you can try and give directory inode locks a
> different class.


We have a static layout in include/linux/fs.h:

enum inode_i_mutex_lock_class
{
	I_MUTEX_NORMAL,
	I_MUTEX_PARENT,
	I_MUTEX_CHILD,
	I_MUTEX_XATTR,
	I_MUTEX_QUOTA
};


I fear none of them fits in our scheme, except the normal one.

And playing with a supplementary set of classes only used in
a single place would make the lockdep checks useless there,
even worse it would make us missing a lot of right checks.

vfs_readdir() locks the directory before calling the fs, and none
of the nested classes would be in its good right there, as the
directory is the current inode to work on, not a parent nor a
child or so.

And unfortunately it's the same in reiserfs_file_release() that
can close about whatever inode, we are locking the current inode,
not a parent, child, xattr, or so.


So changing the nesting class here would not be a good thing to do
I fear.

