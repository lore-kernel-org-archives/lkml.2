Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab2ASQQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:16:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932436Ab2ASQQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:16:48 -0500
Date: Thu, 19 Jan 2012 11:16:42 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/12] blkcg: use q and plid instead of opaque void * for
 blkio_group association
Message-ID: <20120119161642.GC10908@redhat.com>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
 <1326935490-11827-7-git-send-email-tj@kernel.org>
 <20120119140442.GA9582@redhat.com>
 <20120119155545.GD5198@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119155545.GD5198@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 07:55:45AM -0800, Tejun Heo wrote:

[..]
> > > +static void cfq_unlink_blkio_group(struct request_queue *q,
> > > +				   struct blkio_group *blkg)
> > >  {
> > > -	unsigned long  flags;
> > > -	struct cfq_data *cfqd = key;
> > > +	struct cfq_data *cfqd = q->elevator->elevator_data;
> > > +	unsigned long flags;
> > >  
> > > -	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
> > > +	spin_lock_irqsave(q->queue_lock, flags);
> > >  	cfq_destroy_cfqg(cfqd, cfqg_of_blkg(blkg));
> > > -	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
> > > +	spin_unlock_irqrestore(q->queue_lock, flags);
> > 
> > I think this code will create problem where both old elevator group and
> > new elevator group is on blkcg list and upon cgroup removal one can not
> > rely that q->elevator->elevator_data will give us old elevator's cfqd.
> 
> Again, if I didn't botch up earlier elevator switch code, it shouldn't.

I think I am missing something. IIUC, following is new elevator switch
sequence.

1. elv_quiesce_start
2. unregister old elevator
3. ioc_clear_queue
4. allocate new elevator
5. init new elevator
6. exit old elevator

So any groups on old elevator, will be cleaned up in step 6. So till step
5 these groups are still present on blkcg list. Now assume between step 5
and step 6, if a cgroup removal takes place and blkcg tries to call into
elevator to remove that group, will it not be accessing the wrong cfqd
in cfq_destroy_cfqg() (cfqd of new elevator instead of old elevator).

What am I missing?

Thanks
Vivek
