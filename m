Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0DSMwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 08:52:16 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:35290 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab0DSMwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 08:52:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GvT69nSHbrFdcbnsi6NWiSZ+Fznz4vZNFhh8vflczpLvEQlx/4YUfkqL717cBo11IS
         hjn5icfndQXELjL4Q0bIdsyWwyMyJNxohQGJFMgnuU8zKXwaDy1/iCBz9g51i9sDMqBk
         jW3NLZp2iNTPY5xxjvgDFCJYtEEkeoINrVnvk=
Date: Mon, 19 Apr 2010 14:52:16 +0200
From: fweisbec@gmail.com
To: Jan Blunck <jblunck@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT PULL] Preparation for BKL'ed ioctl removal
Message-ID: <20100419125212.GA5652@nowhere.home>
References: <1271390105-20355-1-git-send-regression-fweisbec@gmail.com>
 <20100419123003.GE10776@bolzano.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100419123003.GE10776@bolzano.suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 02:30:03PM +0200, Jan Blunck wrote:
> On Fri, Apr 16, Frederic Weisbecker wrote:
> 
> > Linus,
> > 
> > In order to stop the bkl contagion in ioctl and push the
> > bkl from Vfs to the drivers that don't implement a proper
> > unlock_ioctl, this patch proposes to add a new "locked_ioctl"
> > field in struct file_operation.
> > 
> > This field is never called from vfs and requires to assign a
> > new "deprecated_ioctl" helper to the unlocked_ioctl field.
> > This deprecated_ioctl() helper then calls the locked_ioctl()
> > callback with the bkl held.
> > 
> > The point of doing this is to change every users of fops::ioctl
> > to the new scheme. Once there is no more users of the ioctl field,
> > we'll then be able to remove it.
> > 
> > Also this change brings a new config BKL which is always
> > enabled for now. Every drivers that use the bkl through
> > explicit lock_kernel() calls or by using deprecated_ioctl()
> > will have to select CONFIG_BKL.
> > 
> > Once we get no more uses of the bkl from the core features but
> > only on individual drivers, config BKL can be turned off
> > by default and selected by those drivers if needed, relegating
> > the bkl as an obsolete library for poor old drivers.
> > 
> > And given the work happening currently (tty mutex, vfs pushdowns,
> > procfs bkl removal, llseek janitorials, etc...), this may happen
> > sooner than was expected.
> > 
> > Now the point of having this patch in 2.6.34 is to turn
> > the old ioctl implementations to the new scheme in a set
> > of patches that relevant maintainers can apply to their
> > tree (or apply by ourself for unmaintained areas) for .35
> > Otherwise we would need to queue everything in a single
> > tree that may bring conflicts in the next merge window.
> > 
> > This single patch has very few chances to bring any regressions.
> > 
> > Please pull the bkl/ioctl branch that can be found at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > 	bkl/ioctl
> > 
> > Thanks,
> > 	Frederic
> > ---
> > 
> > Arnd Bergmann (1):
> >       vfs: Introduce CONFIG_BKL and deprecated_ioctl
> > 
> > 
> >  fs/ioctl.c               |   22 ++++++++++++++++++++++
> >  include/linux/fs.h       |    3 +++
> >  include/linux/smp_lock.h |    4 ++++
> >  kernel/Kconfig.locks     |   10 ++++++++++
> >  4 files changed, 39 insertions(+), 0 deletions(-)
> > 
> > ---
> > commit 588a2267f7b2919ae73380e0932cc6a202787036
> > Author: Arnd Bergmann <arnd@arndb.de>
> > Date:   Thu Apr 1 14:42:38 2010 +0200
> > 
> >     vfs: Introduce CONFIG_BKL and deprecated_ioctl
> >     
> >     This is a preparation for the removal of the big kernel lock that
> >     introduces new interfaces for device drivers still using it.
> >     
> >     We can start marking those device drivers as 'depends on CONFIG_BKL'
> >     now, and make that symbol optional later, when the point has come
> >     at which we are able to build a kernel without the BKL.
> >     
> >     Similarly, device drivers that currently make use of the implicit
> >     BKL locking around the ioctl function can now get annotated by
> >     changing
> >     
> >     	.ioctl = foo_ioctl,
> >     
> >     to
> >     
> >     	.locked_ioctl = foo_ioctl,
> >     	.unlocked_ioctl = deprecated_ioctl,
> >     
> >     As soon as no driver remains using the old ioctl callback, it can
> >     get removed.
> >     
> >     [fweisbec: move config bkl from Kconfig.debug to Kconfig.locks,
> >     rename default_ioctl to deprecated_ioctl]
> >     
> >     Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >     Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > diff --git a/fs/ioctl.c b/fs/ioctl.c
> > index 6c75110..e6d6a75 100644
> > --- a/fs/ioctl.c
> > +++ b/fs/ioctl.c
> > @@ -58,6 +58,28 @@ static long vfs_ioctl(struct file *filp, unsigned int cmd,
> >  	return error;
> >  }
> >  
> > +#ifdef CONFIG_BKL
> > +/*
> > + * deprecated_ioctl - call locked_ioctl with BKL held
> > + *
> > + * Setting only the ioctl operation but not unlocked_ioctl will become
> > + * invalid in the future, all drivers that are not converted to unlocked_ioctl
> > + * should set .unlocked_ioctl = deprecated_ioctl now.
> > + */
> > +long deprecated_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> > +{
> > +	int error = -ENOTTY;
> > +	if (filp->f_op->locked_ioctl) {
> > +		lock_kernel();
> > +		error = filp->f_op->locked_ioctl(filp->f_path.dentry->d_inode,
> > +						 filp, cmd, arg);
> > +		unlock_kernel();
> > +	}
> > +	return error;
> > +}
> > +EXPORT_SYMBOL_GPL(default_ioctl);
> > +#endif
> > +
> >  static int ioctl_fibmap(struct file *filp, int __user *p)
> >  {
> >  	struct address_space *mapping = filp->f_mapping;
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 39d57bc..6b65b26 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -1492,6 +1492,9 @@ struct file_operations {
> >  	int (*readdir) (struct file *, void *, filldir_t);
> >  	unsigned int (*poll) (struct file *, struct poll_table_struct *);
> >  	int (*ioctl) (struct inode *, struct file *, unsigned int, unsigned long);
> > +#ifdef CONFIG_BKL
> > +	int (*locked_ioctl) (struct inode *, struct file *, unsigned int, unsigned long);
> > +#endif
> >  	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
> >  	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
> >  	int (*mmap) (struct file *, struct vm_area_struct *);
> > diff --git a/include/linux/smp_lock.h b/include/linux/smp_lock.h
> > index 2ea1dd1..c8693e1 100644
> > --- a/include/linux/smp_lock.h
> > +++ b/include/linux/smp_lock.h
> > @@ -62,4 +62,8 @@ static inline void cycle_kernel_lock(void)
> >  #define kernel_locked()				1
> >  
> >  #endif /* CONFIG_LOCK_KERNEL */
> > +
> > +loff_t default_llseek(struct file *file, loff_t offset, int origin);
> 
> Any specific reason why the default llseek() is in this patch?
> 
> Jan


Because this comes along the same kind of bkl preparation work
we want to do. The goal is to isolate default_llseek and deprecated_ioctl
and only enable them if CONFIG_BKL.

Hence we want their declaration in smp_lock.h

That said it is probably not needed to get the default_llseek declaration
here for this release.

I'm going to make a v2 and resend the pull request. Thanks.

