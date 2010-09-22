Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab0IVNtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 09:49:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61145 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab0IVNtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 09:49:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nV0HycE/e60Cq3oHtbahK2vr0R8bChjI8TkmoebABmTJaSxL83NEhooNY3C86WH2Et
         3jf/v+XKfve8yx3SAi7tjlSEC1i+77+XALDVmPpB2hDoFFnmKtJ33BRH7sGWLlAZGLGi
         EAxfp3IfxL46++38BpkcXqxAMadYtbUOe5Ba8=
Date: Wed, 22 Sep 2010 15:49:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        reiserfs-devel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Re: [Bug] possible circular locking in reiserfs_unpack
Message-ID: <20100922134944.GA6549@nowhere>
References: <20100905113121.GA1876@del.dom.local> <20100908153730.5ad13f71.akpm@linux-foundation.org> <20100909015346.GA5999@nowhere> <4C88F566.7080600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C88F566.7080600@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 04:55:34PM +0200, Jarek Poplawski wrote:
> Frederic Weisbecker wrote, On 12/23/-28158 08:59 PM:
> 
> > On Wed, Sep 08, 2010 at 03:37:30PM -0700, Andrew Morton wrote:
> >> On Sun, 5 Sep 2010 13:31:21 +0200
> >> Jarek Poplawski <jarkao2@gmail.com> wrote:
> >>
> >>> Hi,
> >>> I get this warning on every lilo write with 2.6.35.4 and a bit/git
> >>> later too.
> >>>
> >> Can you tell us the latest kernel version which did *not* have this
> >> bug?  That way we can narrow the problem down a bit.
> >>
> >> Thanks.
> > 
> > 
> > 
> > Ah, when you see &REISERFS_SB(s)->lock in a bug report, don't hesitate to blame me :-)
> > 
> > This is a problem resulting from the bkl conversion to a mutex that introduced
> > a lot of new locking dependencies. Most of them have been fixed, but for less
> > tested paths like ioctl, we hear about it later.
> > 
> > Does the following patch fixes the issue?
> > If so, I'll make a proper changelog and put the appropriate 2.6.33-35 stable
> > tags for the backport.
> > 
> > Thnaks!
> > 
> > 
> > diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
> > index f53505d..679d502 100644
> > --- a/fs/reiserfs/ioctl.c
> > +++ b/fs/reiserfs/ioctl.c
> > @@ -188,7 +188,7 @@ int reiserfs_unpack(struct inode *inode, struct file *filp)
> >  	/* we need to make sure nobody is changing the file size beneath
> >  	 ** us
> >  	 */
> > -	mutex_lock(&inode->i_mutex);
> > +	reiserfs_mutex_lock_safe(&inode->i_mutex, inode->i_sb);
> >  	reiserfs_write_lock(inode->i_sb);
> >  
> >  	write_from = inode->i_size & (blocksize - 1);
> > 
> 
> 
> So, there is still a warning but a bit different now.
> 
> Jarek P.


I can reproduce your first case, but not this one.

So, I hope you can give a try to the following fix,

Thanks!


diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
index f53505d..90a757b 100644
--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -170,7 +170,7 @@ int reiserfs_prepare_write(struct file *f, struct page *page,
 int reiserfs_unpack(struct inode *inode, struct file *filp)
 {
 	int retval = 0;
-	int index;
+	int index, depth;
 	struct page *page;
 	struct address_space *mapping;
 	unsigned long write_from;
@@ -185,11 +185,12 @@ int reiserfs_unpack(struct inode *inode, struct file *filp)
 		return 0;
 	}
 
+	depth = reiserfs_write_lock_once(inode->i_sb);
+
 	/* we need to make sure nobody is changing the file size beneath
 	 ** us
 	 */
-	mutex_lock(&inode->i_mutex);
-	reiserfs_write_lock(inode->i_sb);
+	reiserfs_mutex_lock_safe(&inode->i_mutex, inode->i_sb);
 
 	write_from = inode->i_size & (blocksize - 1);
 	/* if we are on a block boundary, we are already unpacked.  */
@@ -224,6 +225,6 @@ int reiserfs_unpack(struct inode *inode, struct file *filp)
 
       out:
 	mutex_unlock(&inode->i_mutex);
-	reiserfs_write_unlock(inode->i_sb);
+	reiserfs_write_unlock_once(inode->i_sb, depth);
 	return retval;
 }

