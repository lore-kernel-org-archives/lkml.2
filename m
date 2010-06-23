Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab0FWTlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 15:41:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752611Ab0FWTlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 15:41:13 -0400
Date: Wed, 23 Jun 2010 12:40:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tao Ma <tao.ma@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
       Mike Snitzer <snitzer@redhat.com>, stable@kernel.org
Subject: Re: [PATCH] block: Don't count_vm_events for discard bio in
 submit_bio.
Message-Id: <20100623124046.4dec96d1.akpm@linux-foundation.org>
In-Reply-To: <1277263491-4068-1-git-send-email-tao.ma@oracle.com>
References: <1277263491-4068-1-git-send-email-tao.ma@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jun 2010 11:24:51 +0800
Tao Ma <tao.ma@oracle.com> wrote:

> In submit_bio, we count vm events by check READ/WRITE.
> But actually DISCARD_NOBARRIER also has the WRITE flag set.
> It looks as if in blkdev_issue_discard, we also add a
> page as the payload and the bio_has_data check isn't enough.
> So add another check for discard bio.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  block/blk-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index f84cce4..a725602 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1586,7 +1586,7 @@ void submit_bio(int rw, struct bio *bio)
>  	 * If it's a regular read/write or a barrier with data attached,
>  	 * go through the normal accounting stuff before submission.
>  	 */
> -	if (bio_has_data(bio)) {
> +	if (bio_has_data(bio) && !(rw & BIO_RW_DISCARD)) {
>  		if (rw & WRITE) {
>  			count_vm_events(PGPGOUT, count);
>  		} else {

Yes, that's a buglet.

Note that Christoph's "[PATCH, RFC] block: don't allocate a payload for
discard request" will fix it in a better way.  That patch is in
linux-next now, but I expect it will be taken out again (quickly,
please) because Mike has found a number of problems with it.  

Your patch looks like a decent temporary fix for mainline, and a
permanent one for -stable.
