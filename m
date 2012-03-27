Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab2C0Wvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 18:51:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724Ab2C0Wvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 18:51:51 -0400
Date: Tue, 27 Mar 2012 15:51:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: viro@zeniv.linux.org.uk, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: suppress page allocation failure warnings from sys_listxattr
Message-Id: <20120327155149.d41a235b.akpm@linux-foundation.org>
In-Reply-To: <20120313182220.GA11500@redhat.com>
References: <20120313182220.GA11500@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012 14:22:20 -0400
Dave Jones <davej@redhat.com> wrote:

> This size is user controllable, and so it's trivial for someone to trigger a
> stream of order:4 page allocation errors.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> --- 
> There's also a similar problem in setxattr, but I'm not sure how we want
> to pass NOWARN down to memdup_user. Thoughts ?
> 
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 82f4337..544df90 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -496,7 +496,7 @@ listxattr(struct dentry *d, char __user *list, size_t size)
>  	if (size) {
>  		if (size > XATTR_LIST_MAX)
>  			size = XATTR_LIST_MAX;
> -		klist = kmalloc(size, GFP_KERNEL);
> +		klist = kmalloc(size, __GFP_NOWARN | GFP_KERNEL);
>  		if (!klist)
>  			return -ENOMEM;
>  	}

hm.  The patch is good, but one would hope that it isn't "trivial" to
trigger a page allocation failure for a kmalloc(65536, GFP_KERNEL) -
the VM is supposed to be able to handle that.

Is it really *that* easy, or is Something Unusual happening with that
machine?
