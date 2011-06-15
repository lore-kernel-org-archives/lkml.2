Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab1FOHGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 03:06:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34442 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab1FOHGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 03:06:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LfgEuQJxzrcp1ja0M2VEjU0h5g0vg0Bi0uifXRIXFdnNIsT5TOP7/43WY5jbTAD8gs
         bI68Cc4+V3wk6fa59N/WfnrGIgD5wL5LU+4dZy2kLLNlWvjXTIhjLz/rZORjk2C5PTc4
         9xLBZJfGEcf9Fo73uBwl6ANub2qpDepnJCmVE=
Date: Wed, 15 Jun 2011 09:06:38 +0200
From: Tejun Heo <tj@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mark Wu <dwu@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/1] [virt] virtio-blk: Use ida to allocate disk index
Message-ID: <20110615070638.GI8141@htj.dyndns.org>
References: <1306913069-23637-1-git-send-email-dwu@redhat.com>
 <87mxi1xfz0.fsf@rustcorp.com.au>
 <4DEF744D.9040702@redhat.com>
 <87mxhrgba6.fsf@rustcorp.com.au>
 <20110609091433.GB11773@htj.dyndns.org>
 <4DF0A374.6090504@redhat.com>
 <87mxhjzogo.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mxhjzogo.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 15, 2011 at 02:21:51PM +0930, Rusty Russell wrote:
> > +	if (index_to_minor(index) >= 1 << MINORBITS) {
> > +		err =  -ENOSPC;
> > +		goto out_free_index;
> > +	}
> 
> Is this *really* how this is supposed to be used?
> 
> Tejun, this is your code.  What do you think of something like this?
> (untested)

It's inherited from idr which was designed to have separate
prepare/allocation stages so that allocation can happen inside an
outer spinlock.  It doesn't have too much to do with optimization.
It's mostly to be able to use sleepable context for memory allocation
while allowing atomic id[ra] allocation.

>  /**
> + * ida_simple_get - get a new id.
> + * @ida: the (initialized) ida.
> + * @min_id: the minimum id (inclusive)
> + * @max_id: the maximum id (inclusive)
> + *
> + * Allocates an id in the range min_id <= id <= max_id, or returns -ENOSPC.
> + * On allocation failure, returns -ENOMEM.  This function can sleep.
> + *
> + * Use ida_simple_remove() to get rid of an id.
> + */
> +int ida_simple_get(struct ida *ida, int min_id, int max_id)

Hmmm... new interface different from existing id[ra] style, but yeah
something like the above would have made more sense from the
beginning.  The only thing is that isn't (begin <= range < end) more
conventional form to express ranges?

Thanks.

-- 
tejun
