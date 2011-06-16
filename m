Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab1FPHqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:46:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37320 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab1FPHqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:46:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CJvF9MczzAQbKlK9JZj7KaS+xjWZ99DIVz1cujKDj8MEQdMfQAJ+/WzOKuuqbgqhWi
         nzRxf0jrSSw4oRd4YxLKArXe9psBYZ+ZzkFgVRGR5+/Ro4pCadHAFw04th5hkOCV9pd4
         3X9B6cAeGtFRLvnjuhev68ApfalFEyv8dYsBA=
Date: Thu, 16 Jun 2011 09:46:48 +0200
From: Tejun Heo <tj@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mark Wu <dwu@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/1] [virt] virtio-blk: Use ida to allocate disk index
Message-ID: <20110616074648.GF8141@htj.dyndns.org>
References: <1306913069-23637-1-git-send-email-dwu@redhat.com>
 <87mxi1xfz0.fsf@rustcorp.com.au>
 <4DEF744D.9040702@redhat.com>
 <87mxhrgba6.fsf@rustcorp.com.au>
 <20110609091433.GB11773@htj.dyndns.org>
 <4DF0A374.6090504@redhat.com>
 <87mxhjzogo.fsf@rustcorp.com.au>
 <20110615070638.GI8141@htj.dyndns.org>
 <87hb7qzlm9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hb7qzlm9.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 16, 2011 at 09:35:34AM +0930, Rusty Russell wrote:
> On Wed, 15 Jun 2011 09:06:38 +0200, Tejun Heo <tj@kernel.org> wrote:
> > It's inherited from idr which was designed to have separate
> > prepare/allocation stages so that allocation can happen inside an
> > outer spinlock.  It doesn't have too much to do with optimization.
> > It's mostly to be able to use sleepable context for memory allocation
> > while allowing atomic id[ra] allocation.
> 
> It might have made sense for a few callers, but as a general mechanism
> it stinks.  It's a lot of dancing to avoid GFP_ATOMIC allocations; we'd
> be better making idr_get_new() take a gfp_t, and have an idr_pre_alloc()
> for those who care.
> 
> *Sure* there's a chance of racing and we will need to do an atomic
> allocation.  But can anyone justify the current complexity for all
> callers?

Sure, I'm not arguing for the current interface.

> > > + * ida_simple_get - get a new id.
> > > + * @ida: the (initialized) ida.
> > > + * @min_id: the minimum id (inclusive)
> > > + * @max_id: the maximum id (inclusive)
> > > + *
> > > + * Allocates an id in the range min_id <= id <= max_id, or returns -ENOSPC.
> > > + * On allocation failure, returns -ENOMEM.  This function can sleep.
> > > + *
> > > + * Use ida_simple_remove() to get rid of an id.
> > > + */
> > > +int ida_simple_get(struct ida *ida, int min_id, int max_id)
> > 
> > Hmmm... new interface different from existing id[ra] style, but yeah
> > something like the above would have made more sense from the
> > beginning.  The only thing is that isn't (begin <= range < end) more
> > conventional form to express ranges?
> 
> Yes, but how to express an unlimited range then?  I could used unsigned
> and 0x80000000, but that seemed crude.

So, why not do this properly then?  ie. ida_get(ida, begin, end, gfp).

As for the end of range, shouldn't 0 mean the default max range?  Only
some users care about the upper limit anyway.  We can also make it
unsigned just in case and cap the value.

Thanks.

-- 
tejun
