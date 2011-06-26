Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab1FZAmh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 20:42:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40862 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab1FZAmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 20:42:36 -0400
Date: Sun, 26 Jun 2011 01:42:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: WTF is ceph_lookup_open() doing with nd->intent.open.file?
Message-ID: <20110626004234.GB11013@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ceph_lookup_open() does the following:

        struct file *file = nd->intent.open.file;
        struct inode *parent_inode = get_dentry_parent_inode(file->f_dentry);

Note that at this point nd->intent.open.file is going to have NULL ->f_dentry.
What's more, we end up calling ceph_init_file() on that struct file.  If
open(2) fails *after* the call of that sucker, we'll end up leaking
from ceph_file_cachep, since ->release() will *not* be called - VFS will
have no damn indication that it needs to.  Not that calling ->i_fop->open()
on something without ->f_op (and ->f_dentry, and...) would be a good idea...

What is that code supposed to do, anyway?  Looks like a bastardized
variant of the atomic open tricks NFS is pulling off, without the
proper use of lookup_instantiate_filp()...  The thing is,
lookup_instantiate_filp() takes care to set ->f_path.dentry, which is
what distinguishes struct file that had been through ->open() from
ones that had not.  So no ->release() for you...

Moreover, what would you expect to set ->f_dentry by the time you call
->lookup()?  Looks like you expect that parent_inode to be the directory
you are doing lookup in, so why not use the dir argument of ceph_lookup_open()?
While we are at it, what's "locked_dir" and what is it for?  AFAICS,
nothing has ever looked at it - not since the mainline merge...

Either I'm seriously confused, or that code is...
