Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab0INAGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 20:06:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751848Ab0INAGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 20:06:04 -0400
Date: Mon, 13 Sep 2010 17:05:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Eric Paris <eparis@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: audit_tree: sleep inside atomic
Message-Id: <20100913170522.f0b8b1e8.akpm@linux-foundation.org>
In-Reply-To: <4C80FD9E.5040408@gmail.com>
References: <4C1F8217.5020909@gmail.com>
	<4C80FD9E.5040408@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Sep 2010 15:52:30 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> Ideas, comments?

Apparently not.

The question is: why is nobody reporting this bug?  Obviously nobody's
running that code path.  Why not?

> On 06/21/2010 05:15 PM, Jiri Slaby wrote:
> > Hi,
> > 
> > stanse found a sleep inside atomic added by the following commit:
> > commit fb36de479642bc9bdd3af251ae48b882d8a1ad5d
> > Author: Eric Paris <eparis@redhat.com>
> > Date:   Thu Dec 17 20:12:05 2009 -0500
> > 
> >     audit: reimplement audit_trees using fsnotify rather than inotify
> > 
> >     Simply switch audit_trees from using inotify to using fsnotify for it's
> >     inode pinning and disappearing act information.
> > 
> >     Signed-off-by: Eric Paris <eparis@redhat.com>
> > 
> > 
> > In untag_chunk, there is
> >   spin_lock(&entry->lock);
> >   ...
> >   new = alloc_chunk(size);
> >   ...
> >   spin_unlock(&entry->lock);
> > 
> > with
> > static struct audit_chunk *alloc_chunk(int count)
> > {
> >   struct audit_chunk *chunk;
> >   ...
> >   chunk = kzalloc(size, GFP_KERNEL);
> > 
> > But this can sleep. How big the allocations are? Could it be ATOMIC or
> > moved outside the spinlock?

Yes, we could make it GFP_ATOMIC - the code tries to handle allocation
failures.

But if we did that we'd be adding a rarely-executed codepath to an
apparently-never-executed code path.  We'd end up shipping stuff which
nobody had tested, ever.

Plus GFP_ATOMIC is unreliable and using it because we screwed up the
locking is lame.

untag_chunk() could be converted to use GFP_KERNEL outside hash_lock
and ->entry_lock.  The usual way is to take a peek, see if it looks
like we'll probably need to do an allocation and if so, do it outside
the locks then free it again if it turned out that we didn't need it
after all.  Or to maintain a one-deep static-local cache and preload
that cache if it's empty.  Neither are particularly pretty.
