Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410Ab0GVNeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 09:34:36 -0400
Received: from smtp.nokia.com ([192.100.105.134]:50347 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759370Ab0GVNec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 09:34:32 -0400
Subject: Re: [PATCHv2 11/11] writeback: prevent unnecessary bdi threads
 wakeups
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Dave Chinner <dchinner@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20100722090023.GA7692@infradead.org>
References: <1279704706-1267-1-git-send-email-dedekind1@gmail.com>
	 <1279704706-1267-12-git-send-email-dedekind1@gmail.com>
	 <1279712741.2306.36.camel@localhost> <20100722004155.GZ32635@dastard>
	 <20100722090023.GA7692@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 16:27:00 +0300
Message-ID: <1279805220.3044.56.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Jul 2010 13:33:49.0233 (UTC) FILETIME=[845D2A10:01CB29A2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 05:00 -0400, Christoph Hellwig wrote:
> On Thu, Jul 22, 2010 at 10:41:55AM +1000, Dave Chinner wrote:
> > 	if (wakeup_bdi) {
> > 		trace_writeback_wakeup(bdi)
> > 		spin_lock(&bdi->wb_lock);
> > 		if (!bdi->wb.task) {{
> > 			trace_writeback_wakeup_nothread(bdi);
> > 			wake_up_process(default_backing_dev_info.wb.task);
> > 		} else
> > 			wake_up_process(bdi->wb.task);
> > 		spin_unlock(&bdi->wb_lock);
> 
> That gives us duplicate traces for the first case, what about:
> 
> 	 if (wakeup_bdi) {
> 	 	spin_lock(&bdi->wb_lock);
> 		if (bdi->wb.task) {
> 			trace_writeback_wake_thread(bdi);
> 			wake_up_process(bdi->wb.task);
> 		} else {
> 			trace_writeback_wake_forker_thread(bdi);
> 			wake_up_process(default_backing_dev_info.wb.task);
> 		}
> 		spin_unlock(&bdi->wb_lock);
> 	}

But Dave's version is what we have in 'bdi_queue_work()' as well. I it
is OK - first trace point is triggered every time the bdi thread is
_wanted_ to be woken up.

Then if it does not exist, we need to do something special to wake it up
(ask the forker thread which to create it). This is a different event
and we use a different trace point.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

