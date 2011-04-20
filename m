Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab1DTX73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 19:59:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752863Ab1DTX72 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 19:59:28 -0400
MIME-Version: 1.0
In-Reply-To: <1303324240-26672-1-git-send-email-jack@suse.cz>
References: <1303324240-26672-1-git-send-email-jack@suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 20 Apr 2011 16:59:06 -0700
Message-ID: <BANLkTi=muyG3iVnTp6YCY1-dFuBa6SQGZQ@mail.gmail.com>
Subject: Re: [PATCH] vfs: Pass setxattr(2) flags properly
To: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm. This patch looks very sane, but it's been that way - ignoring the
'flags' value - since 2009. Does anybody actually _use_ the flags
field?

Judging by commit 431547b3c453 (that introduced the thing), it looks
like a plain mistake, and the previous "flags" was replaced by a "0"
in the call when it added the "hander->flags" argument at the end. But
the fact that it's been two years, and nobody noticed, makes me go
"hmm.."

Christoph added to participants, since he's the cause of that change.

On Wed, Apr 20, 2011 at 11:30 AM, Jan Kara <jack@suse.cz> wrote:
> For some reason generic_setxattr() did not pass flags (XATTR_CREATE,
> XATTR_REPLACE) to the filesystem specific helper. This caused that
> setxattr(2) syscall just ignored these flags.
>
> Fix the bug by passing flags correctly.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/xattr.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
>  Who's handling VFS changes when Al is away? Andrew?

I guess it's mostly me for at least the path handling, but for
something like this I'd like Christoph to take a look too. Even if it
_looks_ like a really obvious fix.

>
> diff --git a/fs/xattr.c b/fs/xattr.c
> index a19acdb..f1ef949 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -666,7 +666,7 @@ generic_setxattr(struct dentry *dentry, const char *name, const void *value, siz
>        handler = xattr_resolve_name(dentry->d_sb->s_xattr, &name);
>        if (!handler)
>                return -EOPNOTSUPP;
> -       return handler->set(dentry, name, value, size, 0, handler->flags);
> +       return handler->set(dentry, name, value, size, flags, handler->flags);
>  }
>
>  /*
> --
> 1.7.1
>
>
