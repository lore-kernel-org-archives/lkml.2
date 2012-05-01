Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253Ab2EAEGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 00:06:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48976 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2EAEGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 00:06:13 -0400
MIME-Version: 1.0
In-Reply-To: <1335357857-16416-5-git-send-email-miklos@szeredi.hu>
References: <1335357857-16416-1-git-send-email-miklos@szeredi.hu>
	<1335357857-16416-5-git-send-email-miklos@szeredi.hu>
Date: Tue, 1 May 2012 14:06:13 +1000
Message-ID: <CAPa8GCBjDjEtJsqxVrf7T3+VxGrGFMgNcjQv=5tSb4bZLOAB9Q@mail.gmail.com>
Subject: Re: [PATCH 04/16] vfs: do_last(): use inode variable
From: Nick Piggin <npiggin@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        torvalds@linux-foundation.org, mszeredi@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 April 2012 22:44, Miklos Szeredi <miklos@szeredi.hu> wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
>
> Use helper variable instead of path->dentry->d_inode before complete_walk().
> This will allow this code to be used in RCU mode.

What do you mean, allow it to be used?

>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/namei.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/fs/namei.c b/fs/namei.c
> index 46d4bf6..f21ddb3 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2360,15 +2360,16 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
>        if (error)
>                nd->flags |= LOOKUP_JUMPED;
>
> +       inode = path->dentry->d_inode;
>        error = -ENOENT;
> -       if (!path->dentry->d_inode)
> +       if (!inode)
>                goto exit_dput;
>
> -       if (path->dentry->d_inode->i_op->follow_link)
> +       if (inode->i_op->follow_link)
>                return NULL;
>
>        path_to_nameidata(path, nd);
> -       nd->inode = path->dentry->d_inode;
> +       nd->inode = inode;
>        /* Why this, you ask?  _Now_ we might have grown LOOKUP_JUMPED... */
>        error = complete_walk(nd);
>        if (error)

In rcu-walk mode, dentry->d_inode should not be accessed at all,
outside of the core lookup code that (should) have the correct
barriers and sequence locks.

That logic should not escape into here, so I'm just not sure what
you're doing here.

This code runs in rcu-walk mode, then at the very least you need
ACCESS_ONCE to load the inode, because ->d_inode can
become NULL right after you test it for NULL (but that would likely
be a bandaid, I'm just pointing out there's raft of potential
problems).
