Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab2DSXvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 19:51:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab2DSXvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 19:51:02 -0400
Date: Thu, 19 Apr 2012 16:50:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland Dreier <roland@kernel.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma-debug: Fix deadlock with netconsole or other
 drivers that use the DMA API
Message-Id: <20120419165059.c4ca4e1f.akpm@linux-foundation.org>
In-Reply-To: <CAL1RGDXQ9NPKaNxBcNAYKknpSSScwXVa+gr8jXOFFU4ZjjSJ=A@mail.gmail.com>
References: <1334859173-9446-1-git-send-email-roland@kernel.org>
	<20120419114811.9e77accb.akpm@linux-foundation.org>
	<CAL1RGDXQ9NPKaNxBcNAYKknpSSScwXVa+gr8jXOFFU4ZjjSJ=A@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2012 16:36:56 -0700
Roland Dreier <roland@kernel.org> wrote:

> On Thu, Apr 19, 2012 at 11:48 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > So *any* printk can deadlock if free_entries_lock is held and
> > global_disable==false?
> 
> apparently.
> 
> > In that case we're going to need much sterner fixes. __Any list_head
> > operation can do a printk if list_head debugging is enabled.
> > dma_debug_resize_entries() does a kfree() under free_entries_lock(!).
> >
> > Methinks we need a more general fix?
> 
> sigh... no good deed goes unpunished.
> 
> OK, will look at it.  Just to make things even more fun, all the
> err_printk() stuff can potentially deadlock on the hash bucket
> lock, although that requires enough bad luck a collision to happen.

I suppose one could do something like

static DEFINE_SPINLOCK(lock);
static struct task_struct *owner;
static unsigned depth;

/*
 * Nice comments go here
 */
static unsigned long free_entries_lock(void)
{
	unsigned long flags = 0;

	if (owner == current) {
		depth++;
	} else {
		/* Permit recursive locking */
		spin_lock_irqsave(&lock, flags);
		BUG_ON(depth != 0);
		BUG_ON(owner != NULL);
		owner = current;
	}
	return flags;
}

static void free_entries_unlock(unsigned long flags)
{
	BUG_ON(owner != current);
	if (!--depth) {
		owner = NULL;
		spin_lock_irqrestore(&lock, flags);
	}
}

After removing the bugs, I think that's safe wrt interrupts?
