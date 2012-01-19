Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab2ASPzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 10:55:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58022 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171Ab2ASPzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 10:55:50 -0500
Date: Thu, 19 Jan 2012 07:55:45 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/12] blkcg: use q and plid instead of opaque void *
 for blkio_group association
Message-ID: <20120119155545.GD5198@google.com>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
 <1326935490-11827-7-git-send-email-tj@kernel.org>
 <20120119140442.GA9582@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119140442.GA9582@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 19, 2012 at 09:04:42AM -0500, Vivek Goyal wrote:
> On Wed, Jan 18, 2012 at 05:11:24PM -0800, Tejun Heo wrote:
> > blkgio_group is association between a block cgroup and a queue for a
> > given policy.  Using opaque void * for association makes things
> > confusing and hinders factoring of common code.  Use request_queue *
> > and, if necessary, policy id instead.
> > 
> > This will help block cgroup API cleanup.
> 
> Using void* allowed one to pass any type of data pointer as key by the
> client.
>
> I think passing cfq_data or throtl_data as key is better than passing
> request queue as key.
> 
> - During elevator exit, it looks like there will be a small window where
>   groups from both old elevator and new elevator will be present in blkcg
>   list. Given the fact that there can be only one active elevator at a
>   time, during cgroup removal call there is no way to reach a group's
>   cfqd. One can only retrieve request queue reliably and can't rely
>   on q->elevator->elevator_data.
> 
>   So passing cfq_data as key provides more flexibility and allows
>   co-existence of two elevators more naturally without information loss.

Yeah, sure, at the cost of making everything opaque to blkcg core and
duplicating a lot of stuff in policies.  The sad part is that the
'flexibility' bought that way isn't even necessary if layering is done
right.  You're asking completely wrong questions and then coming up
with convoluted solutions somehow working around those silly problem
definitions.  Block cgroup core layer should do all blkg management
and policy implementations shouldn't be worrying about dereferencing
some stupid pointer while elevator is being switched.

> [..]
> > -static void cfq_unlink_blkio_group(void *key, struct blkio_group *blkg)
> > +static void cfq_unlink_blkio_group(struct request_queue *q,
> > +				   struct blkio_group *blkg)
> >  {
> > -	unsigned long  flags;
> > -	struct cfq_data *cfqd = key;
> > +	struct cfq_data *cfqd = q->elevator->elevator_data;
> > +	unsigned long flags;
> >  
> > -	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
> > +	spin_lock_irqsave(q->queue_lock, flags);
> >  	cfq_destroy_cfqg(cfqd, cfqg_of_blkg(blkg));
> > -	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
> > +	spin_unlock_irqrestore(q->queue_lock, flags);
> 
> I think this code will create problem where both old elevator group and
> new elevator group is on blkcg list and upon cgroup removal one can not
> rely that q->elevator->elevator_data will give us old elevator's cfqd.

Again, if I didn't botch up earlier elevator switch code, it shouldn't.

> But I think it is confusing so it is probably better to register cfq_data
> or throtl_data as key instead of request queue.

I'm not gonna repeat.  I really don't have any nice thing left to say
about it.

Thanks.

-- 
tejun
