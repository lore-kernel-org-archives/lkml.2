Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab1FPBro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 21:47:44 -0400
Received: from ozlabs.org ([203.10.76.45]:60047 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab1FPBrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 21:47:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Cc: Mark Wu <dwu@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/1] [virt] virtio-blk: Use ida to allocate disk index
In-Reply-To: <20110615070638.GI8141@htj.dyndns.org>
References: <1306913069-23637-1-git-send-email-dwu@redhat.com> <87mxi1xfz0.fsf@rustcorp.com.au> <4DEF744D.9040702@redhat.com> <87mxhrgba6.fsf@rustcorp.com.au> <20110609091433.GB11773@htj.dyndns.org> <4DF0A374.6090504@redhat.com> <87mxhjzogo.fsf@rustcorp.com.au> <20110615070638.GI8141@htj.dyndns.org>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 16 Jun 2011 09:35:34 +0930
Message-ID: <87hb7qzlm9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011 09:06:38 +0200, Tejun Heo <tj@kernel.org> wrote:
> It's inherited from idr which was designed to have separate
> prepare/allocation stages so that allocation can happen inside an
> outer spinlock.  It doesn't have too much to do with optimization.
> It's mostly to be able to use sleepable context for memory allocation
> while allowing atomic id[ra] allocation.

It might have made sense for a few callers, but as a general mechanism
it stinks.  It's a lot of dancing to avoid GFP_ATOMIC allocations; we'd
be better making idr_get_new() take a gfp_t, and have an idr_pre_alloc()
for those who care.

*Sure* there's a chance of racing and we will need to do an atomic
allocation.  But can anyone justify the current complexity for all
callers?

> > + * ida_simple_get - get a new id.
> > + * @ida: the (initialized) ida.
> > + * @min_id: the minimum id (inclusive)
> > + * @max_id: the maximum id (inclusive)
> > + *
> > + * Allocates an id in the range min_id <= id <= max_id, or returns -ENOSPC.
> > + * On allocation failure, returns -ENOMEM.  This function can sleep.
> > + *
> > + * Use ida_simple_remove() to get rid of an id.
> > + */
> > +int ida_simple_get(struct ida *ida, int min_id, int max_id)
> 
> Hmmm... new interface different from existing id[ra] style, but yeah
> something like the above would have made more sense from the
> beginning.  The only thing is that isn't (begin <= range < end) more
> conventional form to express ranges?

Yes, but how to express an unlimited range then?  I could used unsigned
and 0x80000000, but that seemed crude.

Cheers,
Rusty.
