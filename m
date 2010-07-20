Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab0GTNUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 09:20:20 -0400
Received: from smtp.nokia.com ([192.100.122.230]:19459 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab0GTNUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 09:20:19 -0400
Subject: Re: [RFC][PATCH 16/16] writeback: prevent unnecessary bdi threads
 wakeups
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100718074536.GA1191@infradead.org>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
	 <1279284312-2411-17-git-send-email-dedekind1@gmail.com>
	 <20100718074536.GA1191@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Jul 2010 16:13:14 +0300
Message-ID: <1279631594.16462.139.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 20 Jul 2010 13:19:36.0746 (UTC) FILETIME=[336A78A0:01CB280E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-18 at 03:45 -0400, Christoph Hellwig wrote:
> > +		if (wb_has_dirty_io(wb) && dirty_writeback_interval) {
> > +			unsigned long wait;
> >  
> > -			wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
> > -			schedule_timeout(wait_jiffies);
> > +			wait = msecs_to_jiffies(dirty_writeback_interval * 10);
> > +			schedule_timeout(wait);
> 
> No need for a local variable.  If you want to shorten things a bit a
> schedule_timeout_msecs helper in generic code would be nice, as there
> are lots of patterns like this in various kernel threads.

OK, do you want me to ignore the 80-lines limitation or you want me
to add schedule_timeout_msecs() as a part of this patch series?

> >  void __mark_inode_dirty(struct inode *inode, int flags)
> >  {
> > +	bool wakeup_bdi;
> >  	struct super_block *sb = inode->i_sb;
> > +	struct backing_dev_info *uninitialized_var(bdi);
> 
> Just initialize wakeup_bdi and bdi here - a smart compiler will defer
> them until we need them, and it makes the code a lot easier to read, as
> well as getting rid of the uninitialized_var hack.

OK.

> > +			/*
> > +			 * If this is the first dirty inode for this bdi, we
> > +			 * have to wake-up the corresponding bdi thread to make
> > +			 * sure background write-back happens later.
> > +			 */
> > +			if (!wb_has_dirty_io(&bdi->wb) &&
> > +			    bdi_cap_writeback_dirty(bdi))
> > +				wakeup_bdi = true;
> 
> How about redoing this as:
> 
> 			if (bdi_cap_writeback_dirty(bdi)) {
> 				WARN(!test_bit(BDI_registered, &bdi->state),
> 				     "bdi-%s not registered\n", bdi->name);
> 
> 				/*
> 				 * If this is the first dirty inode for this
> 				 * bdi, we have to wake-up the corresponding
> 				 * flusher thread to make sure background
> 				 * writeback happens later.
> 				 */
> 				if (!wb_has_dirty_io(&bdi->wb))
> 					wakeup_bdi = true;
> 			}

OK.

> > +	if (wakeup_bdi) {
> > +		bool wakeup_default = false;
> > +
> > +		spin_lock(&bdi->wb_lock);
> > +		if (unlikely(!bdi->wb.task))
> > +			wakeup_default = true;
> > +		else
> > +			wake_up_process(bdi->wb.task);
> > +		spin_unlock(&bdi->wb_lock);
> > +
> > +		if (wakeup_default)
> > +			wake_up_process(default_backing_dev_info.wb.task);
> 
> Same comment about just keeping wb_lock over the
> default_backing_dev_info wakup as for one of the earlier patches applies
> here.

I just figured that I have to add 'trace_writeback_nothread(bdi, work)'
here, just like in 'bdi_queue_work()'. I'd feel safer to call tracer
outside the spinlock. What do you think?

> > --- a/mm/backing-dev.c
> > +++ b/mm/backing-dev.c
> > @@ -326,7 +326,7 @@ static unsigned long bdi_longest_inactive(void)
> >  	unsigned long interval;
> >  
> >  	interval = msecs_to_jiffies(dirty_writeback_interval * 10);
> > -	return max(5UL * 60 * HZ, wait_jiffies);
> > +	return max(5UL * 60 * HZ, interval);
> 
> So previously we just ignored interval here? 

Yes, my fault, thanks for catching.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

