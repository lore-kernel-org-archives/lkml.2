Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab0JSXjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 19:39:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751414Ab0JSXjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 19:39:06 -0400
Date: Tue, 19 Oct 2010 16:38:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] support polling of /proc/swaps
Message-Id: <20101019163837.c2a67d0b.akpm@linux-foundation.org>
In-Reply-To: <1287530747.1171.9.camel@yio.site>
References: <1287479956.1729.1.camel@yio.site>
	<20101019153136.b2543f7b.akpm@linux-foundation.org>
	<1287530747.1171.9.camel@yio.site>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Oct 2010 01:25:47 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Tue, 2010-10-19 at 15:31 -0700, Andrew Morton wrote:
> > On Tue, 19 Oct 2010 11:19:16 +0200
> > Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> > It's a bit sad that we have to add quite a pile of infrastructure to
> > make a procfs file pollable.  I wonder if it's possible to provide some
> > core support for this, and reduce the amount of code at each particular
> > handler site.
> 
> You mean something like adding the event counter to the seq_file? There
> is /proc/self/mounts,mountinfo and /proc/swaps so far, I think.

Don't know - I was just waving hands about wondering if we really need
to add 48 new lines of code each time we want to make a procfs file
pollable.

> > Also, I wonder how we are to communicate the existence of this feature
> > to our users.  Nobody will look in Documentation/filesystems/.  Is
> > there a manpage?  Seems not...
> 
> Hmm, 'man 5 proc'?

yes, that mentions /proc/swaps.

> > > +static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
> > > +static int proc_poll_event;
> > 
> > Please pick a lock to protect proc_poll_event.
> 
> An atomic_t should do it too, right?

It does.

> > Then document that
> > locking here, when you also document proc_poll_event ;)
> 
> The actual value has no meaning at all, it just tells that something
> happened if it has changed.
> 

bah.

--- a/mm/swapfile.c~proc-swaps-support-polling-fix
+++ a/mm/swapfile.c
@@ -60,6 +60,7 @@ static struct swap_info_struct *swap_inf
 static DEFINE_MUTEX(swapon_mutex);
 
 static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
+/* Activity counter to indicate that a swapon or swapoff has occurred */
 static atomic_t proc_poll_event = ATOMIC_INIT(0);
 
 static inline unsigned char swap_count(unsigned char ent)
_

