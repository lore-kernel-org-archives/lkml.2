Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab1CVRTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 13:19:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756402Ab1CVRTX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 13:19:23 -0400
MIME-Version: 1.0
In-Reply-To: <20110322153014.560003169@szeredi.hu>
References: <20110322152602.053930811@szeredi.hu> <20110322153014.560003169@szeredi.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 Mar 2011 10:18:59 -0700
Message-ID: <AANLkTikQt9JRp4jx9qcTEr6nKMppA8Gj3=E12aFUGUYs@mail.gmail.com>
Subject: Re: [PATCH 1/6 v7] vfs: add i_op->open()
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 8:26 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> Add a new inode operation i_op->open().  This is for stacked
> filesystems that want to return a struct file from a different
> filesystem.

Hmm..

> +               struct inode *inode = nd->path.dentry->d_inode;
> +
> +               if (inode->i_op->open) {
> +                       int flags = filp->f_flags;
> +                       put_filp(filp);
> +                       filp = inode->i_op->open(nd->path.dentry, flags, cred);
> +               } else {
> +                       filp = __dentry_open(&nd->path, filp, NULL, cred);
> +               }

This seems broken.

Why don't you just pass in the filp to the ->open routine, and drop
that "flags" argument. Maybe other filesystems want to use ->open, but
don't want to put_filp() on the filp we already allocated, only to
allocate a new one?

It seems like you made that unnecessarily hard on purpose, with no
advantage to the interface.

                        Linus
