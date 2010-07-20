Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761267Ab0GTMaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 08:30:06 -0400
Received: from smtp.nokia.com ([192.100.122.230]:58269 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab0GTMaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 08:30:03 -0400
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
Date: Tue, 20 Jul 2010 15:23:19 +0300
Message-ID: <1279628599.16462.120.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 20 Jul 2010 12:29:45.0913 (UTC) FILETIME=[3CBD9290:01CB2807]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-18 at 03:02 -0400, Christoph Hellwig wrote:
> > +	if (wakeup_default) {
> >  		trace_writeback_nothread(bdi, work);
> >  		wake_up_process(default_backing_dev_info.wb.task);
> 
> Why not simply do the defaul thread wakeup under wb_lock, too?
> It keeps the code a lot simpler, and this is not a typical path anyway.

Will address.

> >  		if (dirty_writeback_interval) {
> > +			unsigned long wait_jiffies;
> > +
> >  			wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
> >  			schedule_timeout(wait_jiffies);
> 
> No real need for a local variable here.

Will address.

> > @@ -364,7 +395,7 @@ static int bdi_forker_thread(void *ptr)
> >  		if (!list_empty(&me->bdi->work_list))
> >  			__set_current_state(TASK_RUNNING);
> >  
> > -		if (!fork) {
> > +		if (!fork && !kill) {
> 
> I think the code here would be a lot cleaner if you implement the
> suggestion I have for the forking restructuring.

As I replied earlier, to fork/kill the the thread from inside list walk
we'd need to drop the spinlock, which is not very nice. So I am keeping
this part intact so far.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

