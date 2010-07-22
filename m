Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab0GVAmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 20:42:21 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:34120 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753395Ab0GVAmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 20:42:20 -0400
Date: Thu, 22 Jul 2010 10:41:55 +1000
From: Dave Chinner <david@fromorbit.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCHv2 11/11] writeback: prevent unnecessary bdi threads
 wakeups
Message-ID: <20100722004155.GZ32635@dastard>
References: <1279704706-1267-1-git-send-email-dedekind1@gmail.com>
 <1279704706-1267-12-git-send-email-dedekind1@gmail.com>
 <1279712741.2306.36.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279712741.2306.36.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 02:45:41PM +0300, Artem Bityutskiy wrote:
> On Wed, 2010-07-21 at 12:31 +0300, Artem Bityutskiy wrote:
> >  	spin_unlock(&inode_lock);
> > +
> > +	if (wakeup_bdi) {
> > +		spin_lock(&bdi->wb_lock);
> > +		if (!bdi->wb.task)
> > +			wake_up_process(default_backing_dev_info.wb.task);
> > +		else
> > +			wake_up_process(bdi->wb.task);
> > +		spin_unlock(&bdi->wb_lock);
> > +	}
> >  }
> 
> Dave,
> 
> I do not know whether this stuff will end up in upstream, I did not get
> any feed back from Jens so far. But if it will, I'd like to let you know
> that the code quoted above is similar to the 'bdi_queue_work()'
> function. And the purpose is very similar. But you added a
> 'trace_writeback_nothread()' call to 'bdi_queue_work()', and I think a
> similar call has to be here.

Yes, that seems like a sane thing to do ;)

> Can I call 'trace_writeback_nothread()'? I guess not. Should I create
> another trace point? Any hints/instructions?

The bdi_queue_work() tracepoints expect a work structure to be
passed in, so you can't use them (or that class of event) if you
don't have a struct wb_writeback_work.

For __mark_inode_dirty(), I'd add two new tracepoints like:

DEFINE_WRITEBACK_EVENT(writeback_wakeup);
DEFINE_WRITEBACK_EVENT(writeback_wakeup_nothread);

and place them as:

	if (wakeup_bdi) {
		trace_writeback_wakeup(bdi)
		spin_lock(&bdi->wb_lock);
		if (!bdi->wb.task) {{
			trace_writeback_wakeup_nothread(bdi);
			wake_up_process(default_backing_dev_info.wb.task);
		} else
			wake_up_process(bdi->wb.task);
		spin_unlock(&bdi->wb_lock);
	}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
