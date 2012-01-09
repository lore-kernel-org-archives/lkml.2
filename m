Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab2AIBaM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 20:30:12 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46320 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab2AIBaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 20:30:10 -0500
X-AuditID: 9c93016f-b7cadae000005111-0f-4f0a431f97aa
Message-ID: <4F0A431E.3090106@lge.com>
Date: Mon, 09 Jan 2012 10:30:06 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dsharp@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] block: block_bio_complete tracepoint was missing
References: <1325806974-23486-1-git-send-email-tj@kernel.org> <1325806974-23486-4-git-send-email-tj@kernel.org>
In-Reply-To: <1325806974-23486-4-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-01-06 8:42 AM, Tejun Heo wrote:
> block_bio_complete tracepoint was defined but not invoked anywhere.
> Fix it.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> ---
>   fs/bio.c |    3 +++
>   1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/fs/bio.c b/fs/bio.c
> index b1fe82c..96548da 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -1447,6 +1447,9 @@ void bio_endio(struct bio *bio, int error)
>   	else if (!test_bit(BIO_UPTODATE,&bio->bi_flags))
>   		error = -EIO;
>
> +	if (bio->bi_bdev)
> +		trace_block_bio_complete(bdev_get_queue(bio->bi_bdev),
> +					 bio, error);
>   	if (bio->bi_end_io)
>   		bio->bi_end_io(bio, error);
>   }

Hi,

Just adding the TP unconditionally will produce duplicated (in some 
sense) reports about the completion. For example, normal request based 
IO reports whole request completion prior to its bio's, and further, 
some of nested block IO handling routines - bounced bio and btrfs with 
compression, etc - call bio_endio() more than once. Also there are cases 
that bio fails before it's enqueued for some reason.

I have no idea about the ioblame can deal with all of such corner cases. 
However it might confuse blktrace somewhat, I guess.

I already posted similar patch a couple of weeks ago, but didn't receive 
a comment yet. [1] Please take a look this too :)

After a quick glance, the ioblame seems to carry all IO accounting info 
through the first bio in the request. If so, why don't you use the 
request structure for that?


Thanks,
Namhyung Kim


[1] https://lkml.org/lkml/2011/12/27/111
