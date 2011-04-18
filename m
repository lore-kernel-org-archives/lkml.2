Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab1DRHXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 03:23:21 -0400
Received: from smtp.nokia.com ([147.243.128.24]:52024 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab1DRHXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 03:23:16 -0400
Subject: Re: [PATCH 1/1] Add check for dirty_writeback_interval in
 bdi_wakeup_thread_delayed
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Raghavendra D Prabhu <rprabhu@wnohang.net>
Cc: linux-mm@kvack.org, Jens Axboe <jaxboe@fusionio.com>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110417162308.GA1208@Xye>
References: <20110417162308.GA1208@Xye>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Mon, 18 Apr 2011 10:19:12 +0300
Message-ID: <1303111152.2815.29.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-17 at 21:53 +0530, Raghavendra D Prabhu wrote:
> In the function bdi_wakeup_thread_delayed, no checks are performed on
> dirty_writeback_interval unlike other places and timeout is being set to
> zero as result, thus defeating the purpose. So, I have changed it to be
> passed default value of interval which is 500 centiseconds, when it is
> set to zero.
> I have also verified this and tested it.
> 
> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>

If  dirty_writeback_interval then the periodic write-back has to be
disabled. Which means we should rather do something like this:

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 0d9a036..f38722c 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -334,10 +334,12 @@ static void wakeup_timer_fn(unsigned long data)
  */
 void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi)
 {
-       unsigned long timeout;
+       if (dirty_writeback_interval) {
+               unsigned long timeout;
 
-       timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
-       mod_timer(&bdi->wb.wakeup_timer, jiffies + timeout);
+               timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
+               mod_timer(&bdi->wb.wakeup_timer, jiffies + timeout);
+       }
 }

I do not see why you use 500 centisecs instead - I think this is wrong.

> ---
>   mm/backing-dev.c |    5 ++++-
>   1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index befc875..d06533c 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -336,7 +336,10 @@ void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi)
>   {
>   	unsigned long timeout;
>   
> -	timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
> +	if (dirty_writeback_interval)
> +		timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
> +	else
> +		timeout = msecs_to_jiffies(5000);
>   	mod_timer(&bdi->wb.wakeup_timer, jiffies + timeout);
>   }
>   


-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

