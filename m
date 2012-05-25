Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab2EYPL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:11:29 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42451 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab2EYPL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 11:11:26 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: David Howells <dhowells@redhat.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 00/16] vfs: atomic open v4 (part 1)
References: <6422.1337872046@redhat.com>
	<1335357857-16416-1-git-send-email-miklos@szeredi.hu>
	<7204.1337874722@redhat.com>
Date: Fri, 25 May 2012 17:12:01 +0200
In-Reply-To: <7204.1337874722@redhat.com> (David Howells's message of "Thu, 24
	May 2012 16:52:02 +0100")
Message-ID: <87fwaoi9by.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> I'd also recommend changing the "ok" and "common" labels in do_last() to
> something a bit more meaningful, perhaps:
>
> 	common -> finish_open
> 	ok -> finish_open_may_want_write

Okay.  I'll do a separate label cleanup patch.

>
> Also, does it make sense to combine:
>
> 	if (!S_ISREG(nd->inode->i_mode))
> 		will_truncate = 0;
>
> with:
>
> 	int will_truncate = open_flag & O_TRUNC;
>
> up at the top of the function.

We need to check nd->inode->i_mode *after* the lookup.  So top of the
function is not a good place.

>
> As the code stands, if ->atomic_open() opens the file but does not create it,
> handle_truncate() will be called on it even if it is not a regular file,
> whereas by the normal path, it won't.

Right, that appears to be a bug.  Thanks for spotting.

>
> I would also be tempted to move the body of:
>
> 	if (filp == ERR_PTR(-EOPENSTALE) && save_parent.dentry && !retried) {
> 		BUG_ON(save_parent.dentry != dir);
> 		path_put(&nd->path);
> 		nd->path = save_parent;
> 		nd->inode = dir->d_inode;
> 		save_parent.mnt = NULL;
> 		save_parent.dentry = NULL;
> 		if (want_write) {
> 			mnt_drop_write(nd->path.mnt);
> 			want_write = 0;
> 		}
> 		retried = true;
> 		goto retry_lookup;
> 	}
>
> before the retry_lookup label and then goto around it from the preceding
> if-else statement or place it at the bottom to make the "common:" block simpler
> to read.  Also, you could nest the if (filp == ERR_PTR(-EOPENSTALE)...) inside
> if (IS_ERR(filp)).

Yeah, moving to the bottom sounds like a good cleanup.

>
> Can I also suggest being consistent about the use of int v bool?  "created"
> and "retried" are bool, but "will_truncate", "want_write" and "symlink_ok" are
> not.  Granted some of this is likely inherited from the previous
> incarnation.

Yes, will do a cleanup patch.

Thanks,
Miklos
