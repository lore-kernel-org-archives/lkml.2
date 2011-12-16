Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760345Ab1LPR57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 12:57:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39411 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab1LPR5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 12:57:52 -0500
Date: Fri, 16 Dec 2011 09:57:35 -0800
From: Greg KH <gregkh@suse.de>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tty idle time and hooking inode_ops from a chardev
Message-ID: <20111216175735.GA5404@suse.de>
References: <4EEB774D.1070407@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEB774D.1070407@cfl.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 11:52:29AM -0500, Phillip Susi wrote:
> I finally have spent some time figuring out an ancient bug that has
> bothered me on and off over the years: why the terminal idle time
> that who reports is sometimes very wrong.  It seems that this
> feature relies on the atime of the tty dev node being updated by the
> kernel whenever input is entered ( or more specifically, when it is
> read ).  Some programs, notably emacs and less, open /dev/tty rather
> than use stdin, and as a result, the atime of that inode is updated
> instead of the specific tty emacs is attached to.  This also means
> that if you mknod another inode to reach that tty ( say, for a
> chroot ), the times won't be updated correctly either.
> 
> To solve this, I think that a timestamp needs to be added to the
> struct tty_struct, and this should be updated whenever there is
> input, rather than updating the inode when the input is actually
> read.  In order to maintain compatibility with user space however, I
> would like to hook the stat calls and update the inode's atime from
> tty_struct whenever user space checks it.
> 
> To do this, I think that tty_open would need to replace the
> inode_operations pointer to point to its own version that has a set
> of functions that forward to the original inode_operations, but the
> iop->getattr would update the inode's atime from the tty_struct.
> This means it needs to be able to locate both the tty_struct and the
> original inode_operations given the inode.  Is the i_private member
> of struct inode available for the tty code to use for this?

No, I do not think it is.

> Alternatively, does anyone have a better idea to accomplish this?

Don't worry about it, as it's not really an important issue at all? :)

It seems that your userspace programs aren't properly measuring the
correct thing here, it's not that the kernel is doing something wrong,
right?

And atime on a character node is pretty undefined, isn't it?

> Perhaps instead, struct cdev could gain a function pointer to allow
> it to hook vfs_stat?  I'm pretty sure there is a way to find the
> tty_struct given the cdev ( through dev_t? ), but I'm not sure what
> it is.

No, I don't want to touch cdev in this way, sorry.

greg k-h
