Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab0HKBAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 21:00:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752370Ab0HKBAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 21:00:01 -0400
Date: Tue, 10 Aug 2010 17:59:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Sripathi Kodi <sripathik@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: remove inode_setattr
Message-Id: <20100810175944.5919319e.akpm@linux-foundation.org>
In-Reply-To: <20100811005216.GB31363@ZenIV.linux.org.uk>
References: <201008101859.o7AIx9BM026915@hera.kernel.org>
	<20100810155011.b9657102.akpm@linux-foundation.org>
	<20100811101751.1afdded8.sfr@canb.auug.org.au>
	<20100811104503.4082f68f.sfr@canb.auug.org.au>
	<20100811005216.GB31363@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Aug 2010 01:52:16 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> Whiskey Tango Fotrot, Over
> 
> In Linus' tree we have
> commit 1025774ce411f2bd4b059ad7b53f0003569b74fa
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Fri Jun 4 11:30:02 2010 +0200
> ...
> diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
> index 4331b3b..4b3ad6a 100644
> --- a/fs/9p/vfs_inode.c
> +++ b/fs/9p/vfs_inode.c
> @@ -896,10 +896,19 @@ static int v9fs_vfs_setattr(struct dentry *dentry, struct 
>         }
>  
>         retval = p9_client_wstat(fid, &wstat);
> -       if (retval >= 0)
> -               retval = inode_setattr(dentry->d_inode, iattr);
> +       if (retval < 0)
> +               return retval;
> +
> +       if ((iattr->ia_valid & ATTR_SIZE) &&
> +           iattr->ia_size != i_size_read(dentry->d_inode)) {
> +               retval = vmtruncate(dentry->d_inode, iattr->ia_size);
> +               if (retval)
> +                       return retval;
> +       }
> 
> So what the hell is going on?

That's v9fs_vfs_setattr().  The problem is in the new
v9fs_vfs_setattr_dotl().

