Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002Ab1FGXUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:20:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43754 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab1FGXUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:20:13 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=pLsqZL0N_DgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=T5YMzGyW4ga40eWvFkAA:9 a=-EgWaKaVhjParVRI4d4A:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] blktrace: add FLUSH/FUA support
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <1306917509-6819-1-git-send-email-namhyung@gmail.com>
References: <1306917509-6819-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 07 Jun 2011 19:20:12 -0400
Message-ID: <1307488812.9218.17.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 17:38 +0900, Namhyung Kim wrote:
> Add FLUSH/FUA support to blktrace. As FLUSH precedes WRITE and/or
> FUA follows WRITE, use the same 'F' flag for both cases and
> distinguish them by their (relative) position. The end results
> look like (other flags might be shown also):
> 
>  - WRITE:            W
>  - WRITE_FLUSH:      FW
>  - WRITE_FUA:        WF
>  - WRITE_FLUSH_FUA:  FWF
> 
> Note that BLK_TC_FLUSH should be the last one due to MASC_TC_BIT().
> Otherwise it will cause unpleasant result because __REQ_FLUSH (23)
> would be greater than ilog2(BLK_TC_FLUSH) + BLK_TC_SHIFT (16) so the
> negative value. __REQ_FUA (12) doesn't have this problem.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
>  include/linux/blktrace_api.h |    5 +++--
>  include/trace/events/block.h |   18 +++++++++---------
>  kernel/trace/blktrace.c      |   21 ++++++++++++++++-----
>  3 files changed, 28 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
> index b22fb0d3db0f..05a688648bef 100644
> --- a/include/linux/blktrace_api.h
> +++ b/include/linux/blktrace_api.h
> @@ -14,7 +14,7 @@
>  enum blktrace_cat {
>  	BLK_TC_READ	= 1 << 0,	/* reads */
>  	BLK_TC_WRITE	= 1 << 1,	/* writes */
> -	BLK_TC_BARRIER	= 1 << 2,	/* barrier */
> +	BLK_TC_FUA	= 1 << 2,	/* fua requests */
>  	BLK_TC_SYNC	= 1 << 3,	/* sync IO */
>  	BLK_TC_SYNCIO	= BLK_TC_SYNC,
>  	BLK_TC_QUEUE	= 1 << 4,	/* queueing/merging */
> @@ -28,8 +28,9 @@ enum blktrace_cat {
>  	BLK_TC_META	= 1 << 12,	/* metadata */
>  	BLK_TC_DISCARD	= 1 << 13,	/* discard requests */
>  	BLK_TC_DRV_DATA	= 1 << 14,	/* binary per-driver data */
> +	BLK_TC_FLUSH	= 1 << 15,	/* flush requests */
>  
> -	BLK_TC_END	= 1 << 15,	/* only 16-bits, reminder */
> +	BLK_TC_END	= 1 << 15,	/* we've run out of bits! */
>  };
>  
>  #define BLK_TC_SHIFT		(16)
> diff --git a/include/trace/events/block.h b/include/trace/events/block.h
> index bf366547da25..f21fea24216d 100644
> --- a/include/trace/events/block.h
> +++ b/include/trace/events/block.h
> @@ -19,7 +19,7 @@ DECLARE_EVENT_CLASS(block_rq_with_error,
>  		__field(  sector_t,	sector			)
>  		__field(  unsigned int,	nr_sector		)
>  		__field(  int,		errors			)
> -		__array(  char,		rwbs,	6		)
> +		__array(  char,		rwbs,	8		)
>  		__dynamic_array( char,	cmd,	blk_cmd_buf_len(rq)	)
>  	),
>  
> @@ -104,7 +104,7 @@ DECLARE_EVENT_CLASS(block_rq,
>  		__field(  sector_t,	sector			)
>  		__field(  unsigned int,	nr_sector		)
>  		__field(  unsigned int,	bytes			)
> -		__array(  char,		rwbs,	6		)
> +		__array(  char,		rwbs,	8		)
>  		__array(  char,         comm,   TASK_COMM_LEN   )
>  		__dynamic_array( char,	cmd,	blk_cmd_buf_len(rq)	)
>  	),
> @@ -183,7 +183,7 @@ TRACE_EVENT(block_bio_bounce,
>  		__field( dev_t,		dev			)
>  		__field( sector_t,	sector			)
>  		__field( unsigned int,	nr_sector		)
> -		__array( char,		rwbs,	6		)
> +		__array( char,		rwbs,	8		)
>  		__array( char,		comm,	TASK_COMM_LEN	)
>  	),
>  


Wouldn't it be better to replace all these "6" and "8"'s with a macro?
Then it would be a heck of a lot easier to change in the future.

-- Steve


