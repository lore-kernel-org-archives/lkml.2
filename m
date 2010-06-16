Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541Ab0FPT6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 15:58:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab0FPT6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 15:58:50 -0400
Date: Wed, 16 Jun 2010 15:58:35 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Jamie Lokier <jamie@shareable.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] d_ino considered harmful
Message-ID: <20100616195834.GD24382@shell>
References: <20100616185913.GA15566@shell> <20100616151556.23cc9113@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616151556.23cc9113@tlielax.poochiereds.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 03:15:56PM -0400, Jeff Layton wrote:
> On Wed, 16 Jun 2010 14:59:13 -0400
> Valerie Aurora <vaurora@redhat.com> wrote:
> 
> > Who needs d_ino anyway?  I am running a kernel with this patch -
> > Gnome, a browser, IRC, kernel compile, etc. and everything works.
> > 
> > -VAL
> > 
> > commit 184f3919d0071f3bfa40010aa6919ea89999d79b
> > Author: Valerie Aurora <vaurora@redhat.com>
> > Date:   Wed Jun 16 11:05:06 2010 -0700
> > 
> >     VFS: Always return 0 for d_ino
> >     
> >     Use of d_ino without the corresponding st_dev is always buggy in the
> >     presence of submounts, bind mounts, and union mounts.  E.g., the d_ino
> >     of a mountpoint will be the inode number of the directory under the
> >     mountpoint, not the mounted directory.  Correct code must call stat(),
> >     which returns the correct device ID and inode in st_dev and st_ino.
> >     Since no one should be using d_ino anyway, always return 0 to detect
> >     bugs.
> > 
> > diff --git a/fs/readdir.c b/fs/readdir.c
> > index dd3eae1..38ea772 100644
> > --- a/fs/readdir.c
> > +++ b/fs/readdir.c
> > @@ -91,7 +91,9 @@ static int fillonedir(void * __buf, const char * name, int namlen, loff_t offset
> >  
> >  	if (buf->result)
> >  		return -EINVAL;
> > -	d_ino = ino;
> > +	/* Use of d_ino without st_dev is always buggy. */
> > +	d_ino = 0;
> > +
> >  	if (sizeof(d_ino) < sizeof(ino) && d_ino != ino) {
> >  		buf->result = -EOVERFLOW;
> >  		return -EOVERFLOW;
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> That may run afoul of the following check (where d_ino is compared to
> ino). You can probably just remove that check though since you can be
> reasonably sure that 0 will never overflow the field.

You're right, I included that in the next version of the patch.

Thanks,

-VAL
