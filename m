Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab0HKAwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 20:52:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52079 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab0HKAw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 20:52:29 -0400
Date: Wed, 11 Aug 2010 01:52:16 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Sripathi Kodi <sripathik@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: remove inode_setattr
Message-ID: <20100811005216.GB31363@ZenIV.linux.org.uk>
References: <201008101859.o7AIx9BM026915@hera.kernel.org>
 <20100810155011.b9657102.akpm@linux-foundation.org>
 <20100811101751.1afdded8.sfr@canb.auug.org.au>
 <20100811104503.4082f68f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100811104503.4082f68f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 10:45:03AM +1000, Stephen Rothwell wrote:
> Hi All,
> 
> On Wed, 11 Aug 2010 10:17:51 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Reported by me June 22 with a fixup, reminded Aug 4 and yesterday ... it
> > needed to be fixed up by Linus when he merged Al's tree ...
> 
> I will apply this fix patch to linux-next today ... Al, Christoph, this
> is the fix I sent out earlier.  Is it correct enough for Linus to apply
> it?
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 22 Jun 2010 11:15:01 +1000
> Subject: [PATCH] v9fs: fixup for inode_setattr being removed
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  fs/9p/vfs_inode.c |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
> index f027a42..2ec7bfa 100644
> --- a/fs/9p/vfs_inode.c
> +++ b/fs/9p/vfs_inode.c
> @@ -1052,10 +1052,19 @@ static int v9fs_vfs_setattr_dotl(struct dentry *dentry, struct iattr *iattr)
>  		return PTR_ERR(fid);
>  
>  	retval = p9_client_setattr(fid, &p9attr);
> -	if (retval >= 0)
> -		retval = inode_setattr(dentry->d_inode, iattr);
> +	if (retval < 0)
> +		return retval;
>  
> -	return retval;
> +	if ((iattr->ia_valid & ATTR_SIZE) &&
> +	    iattr->ia_size != i_size_read(dentry->d_inode)) {
> +		retval = vmtruncate(dentry->d_inode, iattr->ia_size);
> +		if (retval)
> +			return retval;
> +	}
> +
> +	setattr_copy(dentry->d_inode, iattr);
> +	mark_inode_dirty(dentry->d_inode);
> +	return 0;
>  }

Whiskey Tango Fotrot, Over

In Linus' tree we have
commit 1025774ce411f2bd4b059ad7b53f0003569b74fa
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Jun 4 11:30:02 2010 +0200
...
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 4331b3b..4b3ad6a 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -896,10 +896,19 @@ static int v9fs_vfs_setattr(struct dentry *dentry, struct 
        }
 
        retval = p9_client_wstat(fid, &wstat);
-       if (retval >= 0)
-               retval = inode_setattr(dentry->d_inode, iattr);
+       if (retval < 0)
+               return retval;
+
+       if ((iattr->ia_valid & ATTR_SIZE) &&
+           iattr->ia_size != i_size_read(dentry->d_inode)) {
+               retval = vmtruncate(dentry->d_inode, iattr->ia_size);
+               if (retval)
+                       return retval;
+       }

So what the hell is going on?
