Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab2KMQtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:49:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923Ab2KMQtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:49:18 -0500
Date: Tue, 13 Nov 2012 17:49:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + fs-epoll-add-procfs-fdinfo-helper.patch added to -mm tree
Message-ID: <20121113164951.GA18665@redhat.com>
References: <20121113145050.GA13691@redhat.com> <20121113155313.GU6511@moon> <20121113162056.GK7808@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113162056.GK7808@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13, Cyrill Gorcunov wrote:
>
>  struct signalfd_ctx {
> +	rwlock_t lock;
>  	sigset_t sigmask;

Oh, I don't think.

rwlock_t is horrible in general, and what it can buy for signalfd?
A plain spinlock would be better. Or seqlock_t.

Whatever you do, you are trying to introduce the lock which should
serialize the access to ->sigmask correctly. In this case I think
you should split this change into 2 patches. The first one should
fix the locking, imo. sys_signalfd4() should not use ->siglock at
all, and the users which take ->siglock to read ->sigmask should be
updated.

Or,

> +#ifdef CONFIG_PROC_FS
> +static int signalfd_show_fdinfo(struct seq_file *m, struct file *f)
> +{
> +	struct signalfd_ctx *ctx = f->private_data;
> +	sigset_t sigmask;
> +
> +	read_lock(&ctx->lock);
> +	sigmask = ctx->sigmask;
> +	read_unlock(&ctx->lock);

Just read ctx->sigmask lockless. Do we really care if show_fdinfo()
reads the value "in between" ?

Oleg.

