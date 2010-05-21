Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab0EUHDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 03:03:19 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:55505 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab0EUHDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 03:03:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vxlF9jZcmGXAQAJcyOA+q3JPJxTz+K6juO7+3SPw0kIik3+ZVO2v/r3bBQiqM0O+pU
         5oNG9UXSP/BxwWBLzNT2fiNGIP3iE4X8mxQMJs6teYHcB/cuxDI/JaDjmbo0+aKwqLn1
         36wo8xkwMpqkoFYmR6Uj8QoCZkKcYBOn5fQsU=
Date: Fri, 21 May 2010 09:03:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Dustin Kirkland <kirkland@canonical.com>,
       Ecryptfs <ecryptfs-devel@lists.launchpad.net>,
       Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] vfs/eCryptfs: Handle ioctl calls with unlocked and
	compat functions
Message-ID: <20100521070322.GA5327@nowhere>
References: <1274289855-10001-1-git-send-regression-fweisbec@gmail.com> <20100520233942.GA1086@ecryptfs> <20100520234223.GA1133@ecryptfs> <201005210825.32819.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005210825.32819.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 08:25:32AM +0200, Arnd Bergmann wrote:
> On Friday 21 May 2010, Tyler Hicks wrote:
> > Lower filesystems that only implement unlocked_ioctl aren't being
> > passed ioctl calls because eCryptfs only checked for
> > lower_file->f_op->ioctl and returned -ENOTTY if it was NULL.
> > 
> > eCryptfs shouldn't implement ioctl(), since it doesn't require the BKL.
> > Instead, unlocked_ioctl() should be used and vfs_ioctl() can be called
> > on the lower file since it handles locking, if necessary.  This requires
> > vfs_ioctl() to be exported.
> 
> Calling vfs_ioctl doesn't help you at all here, you could simply call
> the ->unlocked_ioctl function of the lower fs directly to do the same,
> because ->ioctl will be gone soon.



Yeah. Nothing is left pending in the fs tree wrt ioctl pushdown so this
is safe.



> You are howevers still missing a few calls that are done through do_vfs_ioctl
> or file_ioctl.  To implement these, you need to add the file and super operations
> that these call and forward the functions to the lower fs.
> 
> > +#ifdef CONFIG_COMPAT
> > +static long
> > +ecryptfs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> > +{
> > +	long rc = -ENOTTY;
> > +	struct file *lower_file = NULL;
> > +
> > +	if (ecryptfs_file_to_private(file))
> > +		lower_file = ecryptfs_file_to_lower(file);
> > +	if (lower_file && lower_file->f_op && lower_file->f_op->compat_ioctl)
> > +		rc = lower_file->f_op->compat_ioctl(lower_file, cmd, arg);
> > +	return rc;
> > +}
> > +#endif
> 
> You need to return -ENOIOCTLCMD here, not ENOTTY to cover the case where
> the lower file system does not have a ->compat_ioctl function but has its
> calls listed in fs/compat_ioctl.c.
> 
> 	Arnd



Right.

So I'll drop the pushdown from my tree and let Tyler handle that.

Thanks.

