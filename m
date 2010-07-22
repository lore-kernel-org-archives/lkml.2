Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142Ab0GVJAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 05:00:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41012 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab0GVJAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 05:00:37 -0400
Date: Thu, 22 Jul 2010 05:00:23 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, Dave Chinner <dchinner@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCHv2 11/11] writeback: prevent unnecessary bdi threads
 wakeups
Message-ID: <20100722090023.GA7692@infradead.org>
References: <1279704706-1267-1-git-send-email-dedekind1@gmail.com>
 <1279704706-1267-12-git-send-email-dedekind1@gmail.com>
 <1279712741.2306.36.camel@localhost>
 <20100722004155.GZ32635@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722004155.GZ32635@dastard>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 10:41:55AM +1000, Dave Chinner wrote:
> 	if (wakeup_bdi) {
> 		trace_writeback_wakeup(bdi)
> 		spin_lock(&bdi->wb_lock);
> 		if (!bdi->wb.task) {{
> 			trace_writeback_wakeup_nothread(bdi);
> 			wake_up_process(default_backing_dev_info.wb.task);
> 		} else
> 			wake_up_process(bdi->wb.task);
> 		spin_unlock(&bdi->wb_lock);

That gives us duplicate traces for the first case, what about:

	 if (wakeup_bdi) {
	 	spin_lock(&bdi->wb_lock);
		if (bdi->wb.task) {
			trace_writeback_wake_thread(bdi);
			wake_up_process(bdi->wb.task);
		} else {
			trace_writeback_wake_forker_thread(bdi);
			wake_up_process(default_backing_dev_info.wb.task);
		}
		spin_unlock(&bdi->wb_lock);
	}

