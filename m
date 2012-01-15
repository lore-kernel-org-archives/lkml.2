Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348Ab2AOPmm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 10:42:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42875 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab2AOPmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 10:42:40 -0500
Date: Sun, 15 Jan 2012 21:11:07 +0530
From: Rabin Vincent <rabin@rab.in>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chanho Min <chanho0207@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/backing-dev.c: fix crash when USB/SCSI device is
 detached
Message-ID: <20120115153838.GA4279@debian>
References: <CAOAMb1AUHV6mHwkUbX4+0wfOJpnMuVj_vr9jvb=h-Q4+6HKFzg@mail.gmail.com>
 <CAH+eYFB8xBPLJdN+jfqpESsqjkxdeRQD7oyfU8qHewzfmbqHow@mail.gmail.com>
 <20120115125853.GA9234@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120115125853.GA9234@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 08:58:53PM +0800, Wu Fengguang wrote:
> On Sun, Jan 15, 2012 at 03:58:43PM +0530, Rabin Vincent wrote:
> > diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> > index 71034f4..a39ad70 100644
> > --- a/mm/backing-dev.c
> > +++ b/mm/backing-dev.c
> > @@ -318,7 +318,7 @@ static void wakeup_timer_fn(unsigned long data)
> >  	if (bdi->wb.task) {
> >  		trace_writeback_wake_thread(bdi);
> >  		wake_up_process(bdi->wb.task);
> > -	} else {
> > +	} else if (bdi->dev) {
> >  		/*
> >  		 * When bdi tasks are inactive for long time, they are killed.
> >  		 * In this case we have to wake-up the forker thread which
> > @@ -584,6 +584,8 @@ EXPORT_SYMBOL(bdi_register_dev);
> >   */
> >  static void bdi_wb_shutdown(struct backing_dev_info *bdi)
> >  {
> > +	struct task_struct *task = NULL;
> 
> NULL not necessary?

Will fix.

Also, I notice another problem here.  bdi->dev should be made NULL before the
device is unregistered, not after:

		if (!bdi_cap_flush_forker(bdi))
			bdi_wb_shutdown(bdi);
		bdi_debug_unregister(bdi);
		device_unregister(bdi->dev);
		bdi->dev = NULL;

