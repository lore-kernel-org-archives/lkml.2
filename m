Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab0FWNVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 09:21:36 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:55115 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab0FWNVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 09:21:35 -0400
Subject: Re: [PATCH fs/ramfs] inode.c: Fix incorrect variable freeing.
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave.bueso@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20100622124101.0dbb2b3c.akpm@linux-foundation.org>
References: <1277062057.14428.0.camel@cowboy>
	 <20100622124101.0dbb2b3c.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Jun 2010 09:20:46 -0400
Message-ID: <1277299246.17913.0.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 12:41 -0700, Andrew Morton wrote:
> On Sun, 20 Jun 2010 15:27:37 -0400
> Davidlohr Bueso <dave.bueso@gmail.com> wrote:
> 
> > Hi,
> > 
> > In ramfs_fill_super(), if fsi's memory allocation fails, it will go to 'fail', 
> > which immediately tries to free the variable, potentially producing an Oops. 
> > This patch addresses this issue.
> > 
> > Thanks.
> > 
> > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> > ---
> >  fs/ramfs/inode.c |    8 +++++---
> >  1 files changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
> > index a5ebae7..40af7a2 100644
> > --- a/fs/ramfs/inode.c
> > +++ b/fs/ramfs/inode.c
> > @@ -219,7 +219,7 @@ int ramfs_fill_super(struct super_block *sb, void *data, int silent)
> >  	sb->s_fs_info = fsi;
> >  	if (!fsi) {
> >  		err = -ENOMEM;
> > -		goto fail;
> > +		goto fail2;
> >  	}
> >  
> >  	err = ramfs_parse_options(data, &fsi->mount_opts);
> > @@ -247,11 +247,13 @@ int ramfs_fill_super(struct super_block *sb, void *data, int silent)
> >  	}
> >  
> >  	return 0;
> > -fail:
> > -	kfree(fsi);
> > +fail2:
> >  	sb->s_fs_info = NULL;
> >  	iput(inode);
> >  	return err;
> > +fail:
> > +	kfree(fsi);
> > +	goto fail2;
> >  }
> >  
> >  int ramfs_get_sb(struct file_system_type *fs_type,
> 
> notabug.  kfree(NULL) is an OK thing to do.  The kernel does this
> pretty regularly in recovery paths - it usually results in slightly
> simpler and slightly smaller code.

Yeah I kind of knew that but slipped my mind. Sorry for the noise.

