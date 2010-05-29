Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab0E2W7O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 18:59:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59464 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142Ab0E2W7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 18:59:12 -0400
Date: Sat, 29 May 2010 23:59:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Samo Pogacnik <samo_pogacnik@t-2.net>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] detour TTY driver
Message-ID: <20100529225908.GQ31073@ZenIV.linux.org.uk>
References: <1273918658.2341.17.camel@itpsd6lap>
 <1275171436.2122.29.camel@itpsd6lap>
 <20100529235402.296406d9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100529235402.296406d9@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 29, 2010 at 11:54:02PM +0100, Alan Cox wrote:
> > +	/* re-register our fops write function */
> > +	detour_fops.write = detour_write;
> > +
> > +	detour_file.f_dentry = &detour_dentry;
> > +	detour_file.f_dentry->d_inode = &detour_inode;
> > +	detour_file.f_op = &detour_fops;
> > +	detour_file.f_mode |= FMODE_WRITE;
> > +	security_file_alloc(&detour_file);
> > +	INIT_LIST_HEAD(&detour_file.f_u.fu_list);
> > +
> > +	detour_inode.i_rdev = MKDEV(TTYAUX_MAJOR, 3);
> > +	security_inode_alloc(&detour_inode);
> > +	INIT_LIST_HEAD(&detour_inode.inotify_watches);
> > +
> > +	ret = detour_fops.open(&detour_inode, &detour_file);
> > +	printk(KERN_INFO "detour_fops.open() returned %ld\n", ret);
> > +	ret = detour_fops.unlocked_ioctl(&detour_file, TIOCCONS, 0);
> > +	printk(KERN_INFO "detour_fops.ioctl() returned %ld\n", ret);

That alone is enough for a NAK.  Do Not Do That.  Fake struct file/dentry/inode
and their uses are not acceptable.  Neither is modifying file_operations,
while we are at it.
