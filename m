Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab0GTNBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 09:01:10 -0400
Received: from smtp.nokia.com ([192.100.122.233]:63104 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757019Ab0GTNBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 09:01:08 -0400
Subject: Re: [RFC][PATCH 14/16] writeback: move bdi threads exiting logic
 to the forker thread
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100718070231.GK23811@infradead.org>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
	 <1279284312-2411-15-git-send-email-dedekind1@gmail.com>
	 <20100718070231.GK23811@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Jul 2010 15:54:26 +0300
Message-ID: <1279630466.16462.132.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 20 Jul 2010 13:00:53.0721 (UTC) FILETIME=[960A7490:01CB280B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-18 at 03:02 -0400, Christoph Hellwig wrote:
> Yes, only killing threads from the caller is much better, that's how
> the kthread API is supposed to be used anyway.
> 
> >  static void bdi_queue_work(struct backing_dev_info *bdi,
> >  		struct wb_writeback_work *work)
> >  {
> > +	bool wakeup_default = false;
> > +
> >  	trace_writeback_queue(bdi, work);
> >  
> >  	spin_lock(&bdi->wb_lock);
> >  	list_add_tail(&work->list, &bdi->work_list);
> > -	spin_unlock(&bdi->wb_lock);
> > -
> >  	/*
> >  	 * If the default thread isn't there, make sure we add it. When
> >  	 * it gets created and wakes up, we'll run this work.
> >  	 */
> > -	if (unlikely(!bdi->wb.task)) {
> > +	if (unlikely(!bdi->wb.task))
> > +		wakeup_default = true;
> > +	else
> > +		wake_up_process(bdi->wb.task);
> > +	spin_unlock(&bdi->wb_lock);
> > +
> > +	if (wakeup_default) {
> >  		trace_writeback_nothread(bdi, work);
> >  		wake_up_process(default_backing_dev_info.wb.task);
> 
> Why not simply do the defaul thread wakeup under wb_lock, too?
> It keeps the code a lot simpler, and this is not a typical path anyway.

Hmm, actually, I want to take this lock in __mark_inode_dirty() as well,
so it makes sense to micro-optimize this. Also, can
'trace_writeback_nothread()' be called under a spinlock? If no, then a
variable is needed anyway.


-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

