Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab2KMRCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:02:08 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:46527 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab2KMRCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:02:05 -0500
Date: Tue, 13 Nov 2012 21:01:59 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + fs-epoll-add-procfs-fdinfo-helper.patch added to -mm tree
Message-ID: <20121113170159.GW6511@moon>
References: <20121113145050.GA13691@redhat.com>
 <20121113155313.GU6511@moon>
 <20121113162056.GK7808@moon>
 <20121113164951.GA18665@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113164951.GA18665@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 05:49:51PM +0100, Oleg Nesterov wrote:
> On 11/13, Cyrill Gorcunov wrote:
> >
> >  struct signalfd_ctx {
> > +	rwlock_t lock;
> >  	sigset_t sigmask;
> 
> Oh, I don't think.
> 
> rwlock_t is horrible in general, and what it can buy for signalfd?
> A plain spinlock would be better. Or seqlock_t.
> 
> Whatever you do, you are trying to introduce the lock which should
> serialize the access to ->sigmask correctly. In this case I think
> you should split this change into 2 patches. The first one should
> fix the locking, imo. sys_signalfd4() should not use ->siglock at
> all, and the users which take ->siglock to read ->sigmask should be
> updated.

I see

> 
> Or,
> 
> > +#ifdef CONFIG_PROC_FS
> > +static int signalfd_show_fdinfo(struct seq_file *m, struct file *f)
> > +{
> > +	struct signalfd_ctx *ctx = f->private_data;
> > +	sigset_t sigmask;
> > +
> > +	read_lock(&ctx->lock);
> > +	sigmask = ctx->sigmask;
> > +	read_unlock(&ctx->lock);
> 
> Just read ctx->sigmask lockless. Do we really care if show_fdinfo()
> reads the value "in between" ?

As from c/r patch I think we can read it lockless (since we do stop
tasks anyway before doing checkpoint). So I would prefer to provide
it without locks at all.
