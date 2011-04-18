Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1DRACN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 20:02:13 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:41299 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751570Ab1DRACI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 20:02:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqgEABd8q015LHHJgWdsb2JhbAClWhUBARYmJcMSDoVjBJQ5
Date: Mon, 18 Apr 2011 10:02:04 +1000
From: Dave Chinner <david@fromorbit.com>
To: Raghavendra D Prabhu <rprabhu@wnohang.net>
Cc: linux-mm@kvack.org, Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Jens Axboe <jaxboe@fusionio.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Add check for dirty_writeback_interval in
 bdi_wakeup_thread_delayed
Message-ID: <20110418000204.GQ21395@dastard>
References: <20110417162308.GA1208@Xye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110417162308.GA1208@Xye>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 17, 2011 at 09:53:08PM +0530, Raghavendra D Prabhu wrote:
> In the function bdi_wakeup_thread_delayed, no checks are performed on
> dirty_writeback_interval unlike other places and timeout is being set to
> zero as result, thus defeating the purpose. So, I have changed it to be
> passed default value of interval which is 500 centiseconds, when it is
> set to zero.
> I have also verified this and tested it.
> 
> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
> ---
>  mm/backing-dev.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index befc875..d06533c 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -336,7 +336,10 @@ void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi)
>  {
>  	unsigned long timeout;
> -	timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
> +	if (dirty_writeback_interval)
> +		timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
> +	else
> +		timeout = msecs_to_jiffies(5000);
>  	mod_timer(&bdi->wb.wakeup_timer, jiffies + timeout);
>  }

Isn't the problem that the sysctl handler does not have a min/max
valid value set? I.e. to prevent invalid values from being set in
the first place?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
