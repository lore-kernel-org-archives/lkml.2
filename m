Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab2AQRp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:45:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62145 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab2AQRpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:45:25 -0500
Date: Tue, 17 Jan 2012 09:45:20 -0800
From: Tejun Heo <tj@kernel.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Jens Axboe <axboe@kernel.dk>, Namhyung Kim <namhyung@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] block: prevent duplicated bio completion report
Message-ID: <20120117174520.GB6762@google.com>
References: <1326763928-1972-1-git-send-email-namhyung.kim@lge.com>
 <1326763928-1972-2-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326763928-1972-2-git-send-email-namhyung.kim@lge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jan 17, 2012 at 10:32:07AM +0900, Namhyung Kim wrote:
> Since previous patch make block_bio_complete TP working,
> it will generate duplicated BLK_TA_COMPLETEs for bounced
> bios. Fix it.
> 
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> Cc: Tejun Heo <tj@kernel.org>

This and the third patch should probably be merged to the first patch.
As it currently stands, it introduces window where spurious events are
generated.

> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 4053cbd4490e..45cd0074a1c8 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -97,6 +97,9 @@ struct bio {
>  #define BIO_MAPPED_INTEGRITY 11/* integrity metadata has been remapped */
>  #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
>  
> +/* masked bio's won't report its completion via tracepoint */
> +#define BIO_COMPLETE_MASK	(1 << BIO_BOUNCED)

And, who's setting this flag?

>  /*
>   * top 4 bits of bio flags indicate the pool this bio came from
>   */
> diff --git a/include/trace/events/block.h b/include/trace/events/block.h
> index 96955f4828b3..72888542e186 100644
> --- a/include/trace/events/block.h
> +++ b/include/trace/events/block.h
> @@ -219,7 +219,8 @@ TRACE_EVENT_CONDITION(block_bio_complete,
>  
>  	TP_ARGS(q, bio, error),
>  
> -	TP_CONDITION(bio->bi_bdev != NULL),
> +	TP_CONDITION(bio->bi_bdev != NULL &&
> +		     !(bio->bi_flags & BIO_COMPLETE_MASK)),

Bounced bio's are separate bio's too and I don't think masking its
completion from the TP itself is a good idea.  As I wrote before, why
not do this from blktrace code?

Thanks.

-- 
tejun
