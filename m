Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab0GGQQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 12:16:26 -0400
Received: from [202.81.31.143] ([202.81.31.143]:51807 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab0GGQQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 12:16:25 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de, hooanon05@yahoo.co.jp,
       bfields@fieldses.org, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V14 03/11] vfs: Add open by file handle support
In-Reply-To: <20100707151738.GR11732@laptop>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1276621981-2774-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100707151738.GR11732@laptop>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Wed, 07 Jul 2010 21:46:08 +0530
Message-ID: <87fwzvfet3.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jul 2010 01:17:38 +1000, Nick Piggin <npiggin@suse.de> wrote:
> On Tue, Jun 15, 2010 at 10:42:53PM +0530, Aneesh Kumar K.V wrote:
> > diff --git a/fs/open.c b/fs/open.c
> > index 43ac798..1c5daa3 100644
> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -1168,3 +1168,201 @@ SYSCALL_DEFINE4(name_to_handle_at, int, dfd, const char __user *, name,
> >  	return -ENOSYS;
> >  }
> >  #endif
> > +
> > +#ifdef CONFIG_EXPORTFS
> > +static struct vfsmount *get_vfsmount_from_fd(int fd)
> > +{
> > +	int fput_needed;
> > +	struct path *path;
> > +	struct file *filep;
> > +
> > +	if (fd == AT_FDCWD) {
> > +		struct fs_struct *fs = current->fs;
> > +		read_lock(&fs->lock);
> > +		path = &fs->pwd;
> > +		mntget(path->mnt);
> > +		read_unlock(&fs->lock);
> > +	} else {
> > +		filep = fget_light(fd, &fput_needed);
> > +		if (!filep)
> > +			return ERR_PTR(-EBADF);
> > +		path = &filep->f_path;
> > +		mntget(path->mnt);
> > +		fput_light(filep, fput_needed);
> > +	}
> > +	return path->mnt;
> > +}
> 
> The bulk of this this should probably be in fs/namei.c, factored with
> path_init stuff if possible please.
> 

Will move this to fs/namei.c. I guess we can also remove #ifdef
CONFIG_EXPORTFS around the code ?

-aneesh
