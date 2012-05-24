Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab2EXPwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:52:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771Ab2EXPwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:52:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <6422.1337872046@redhat.com>
References: <6422.1337872046@redhat.com> <1335357857-16416-1-git-send-email-miklos@szeredi.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, mszeredi@suse.cz
Subject: Re: [PATCH 00/16] vfs: atomic open v4 (part 1)
Date: Thu, 24 May 2012 16:52:02 +0100
Message-ID: <7204.1337874722@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'd also recommend changing the "ok" and "common" labels in do_last() to
something a bit more meaningful, perhaps:

	common -> finish_open
	ok -> finish_open_may_want_write

Also, does it make sense to combine:

	if (!S_ISREG(nd->inode->i_mode))
		will_truncate = 0;

with:

	int will_truncate = open_flag & O_TRUNC;

up at the top of the function.

As the code stands, if ->atomic_open() opens the file but does not create it,
handle_truncate() will be called on it even if it is not a regular file,
whereas by the normal path, it won't.

I would also be tempted to move the body of:

	if (filp == ERR_PTR(-EOPENSTALE) && save_parent.dentry && !retried) {
		BUG_ON(save_parent.dentry != dir);
		path_put(&nd->path);
		nd->path = save_parent;
		nd->inode = dir->d_inode;
		save_parent.mnt = NULL;
		save_parent.dentry = NULL;
		if (want_write) {
			mnt_drop_write(nd->path.mnt);
			want_write = 0;
		}
		retried = true;
		goto retry_lookup;
	}

before the retry_lookup label and then goto around it from the preceding
if-else statement or place it at the bottom to make the "common:" block simpler
to read.  Also, you could nest the if (filp == ERR_PTR(-EOPENSTALE)...) inside
if (IS_ERR(filp)).

Can I also suggest being consistent about the use of int v bool?  "created"
and "retried" are bool, but "will_truncate", "want_write" and "symlink_ok" are
not.  Granted some of this is likely inherited from the previous incarnation.

David
