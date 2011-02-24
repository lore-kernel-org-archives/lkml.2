Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab1BXXFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 18:05:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755658Ab1BXXFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 18:05:17 -0500
Date: Thu, 24 Feb 2011 15:04:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mtosatti@redhat.com, xiaoguangrong@cn.fujitsu.com
Subject: Re: [RFC PATCH 1/3] Weight-balanced tree
Message-Id: <20110224150430.6daa9e52.akpm@linux-foundation.org>
In-Reply-To: <20110222185456.22026.28200.stgit@s20.home>
References: <20110222183822.22026.62832.stgit@s20.home>
	<20110222185456.22026.28200.stgit@s20.home>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011 11:55:05 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
>  include/linux/wbtree.h |   55 ++++++++++++++++
>  lib/Makefile           |    3 +
>  lib/wbtree.c           |  170 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 227 insertions(+), 1 deletions(-)
>  create mode 100644 include/linux/wbtree.h
>  create mode 100644 lib/wbtree.c
> 
> diff --git a/include/linux/wbtree.h b/include/linux/wbtree.h
> new file mode 100644
> index 0000000..ef70f6f
> --- /dev/null
> +++ b/include/linux/wbtree.h
> @@ -0,0 +1,55 @@
> +/*
> + * Weight-balanced binary tree
> + *
> + * The balance of this tree is based on search probability.  The
> + * heaviest weighted nodes (the ones we're most likely to hit), are
> + * at the top of each subtree.
> + *
> + * Copywrite (C) 2011 Red Hat, Inc.
> + *
> + * Authors:
> + *   Alex Williamson <alex.williamson@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2.  See
> + * the COPYING file in the top-level directory.
> + */
> +#ifndef _LINUX_WBTREE_H
> +#define _LINUX_WBTREE_H
> +
> +#include <linux/kernel.h>
> +#include <linux/stddef.h>
> +
> +struct wb_node {
> +	struct wb_node *wb_parent;
> +	struct wb_node *wb_left;
> +	struct wb_node *wb_right;
> +	unsigned long wb_weight;
> +};
> +
> +struct wb_root {
> +	struct wb_node *wb_node;
> +};
> +
> +#define WB_ROOT (struct wb_root) { NULL, }
> +#define wb_entry(ptr, type, member) container_of(ptr, type, member)

Please implement this as a C function.  That way we get typechecking
which container_of() is unable to provide.

Otherwise the code looks OK to me, apart from the total lack of
documentation.  Please document at least all the exported interfaces. 
The documentation should be designed to tell people how to maintain
this code, and how to use this code reliably and well from other subsystems.
Don't fall into the trap of just dumbly filling out templates.

The documentation should also carefully explain the locking
requirements which these functions place upon callers.  (rwlocks used
how?  rcu?)

Once that is all squared away, please merge the code via the KVM tree.

