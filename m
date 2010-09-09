Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab0IIGHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 02:07:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50649 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab0IIGHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 02:07:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=k2D6nmkWw9OGXJ/gYPh9CTMafSgYFNlc44quunU+aeIZs/ulQj6xgV6TB2jxcw9Dsd
         YYP3UJ8Ugh8KGy48hmM8PNCFK0DryGUOYseoNgsIZsjjiODfp+BTnydzM35u3s+gb6HD
         IJ1TpgRrzVZU3pIDNR119AzYjsGj2+NAgQrgI=
Date: Thu, 9 Sep 2010 06:07:26 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        reiserfs-devel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [Bug] possible circular locking in reiserfs_unpack
Message-ID: <20100909060726.GA6171@ff.dom.local>
References: <20100905113121.GA1876@del.dom.local> <20100908153730.5ad13f71.akpm@linux-foundation.org> <20100909015346.GA5999@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100909015346.GA5999@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 03:53:52AM +0200, Frederic Weisbecker wrote:
> On Wed, Sep 08, 2010 at 03:37:30PM -0700, Andrew Morton wrote:
> > On Sun, 5 Sep 2010 13:31:21 +0200
> > Jarek Poplawski <jarkao2@gmail.com> wrote:
> > 
> > > Hi,
> > > I get this warning on every lilo write with 2.6.35.4 and a bit/git
> > > later too.
> > > 
> > 
> > Can you tell us the latest kernel version which did *not* have this
> > bug?  That way we can narrow the problem down a bit.

I'll try if Frederic's patch doesn't help. But, generally, it seems
with this kind of (not too long) lockdep info it should be much faster
to have a look of somebody with a basic reiserfs locking knowledge.;-)

> > 
> > Thanks.
> 
> 
> 
> Ah, when you see &REISERFS_SB(s)->lock in a bug report, don't hesitate to blame me :-)
> 
> This is a problem resulting from the bkl conversion to a mutex that introduced
> a lot of new locking dependencies. Most of them have been fixed, but for less
> tested paths like ioctl, we hear about it later.
> 
> Does the following patch fixes the issue?
> If so, I'll make a proper changelog and put the appropriate 2.6.33-35 stable
> tags for the backport.

I should be able to test it when back home (within 9 hours).

Thanks,
Jarek P.

> 
> Thnaks!
> 
> 
> diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
> index f53505d..679d502 100644
> --- a/fs/reiserfs/ioctl.c
> +++ b/fs/reiserfs/ioctl.c
> @@ -188,7 +188,7 @@ int reiserfs_unpack(struct inode *inode, struct file *filp)
>  	/* we need to make sure nobody is changing the file size beneath
>  	 ** us
>  	 */
> -	mutex_lock(&inode->i_mutex);
> +	reiserfs_mutex_lock_safe(&inode->i_mutex, inode->i_sb);
>  	reiserfs_write_lock(inode->i_sb);
>  
>  	write_from = inode->i_size & (blocksize - 1);
> 
