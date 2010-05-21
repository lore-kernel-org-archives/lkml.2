Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423Ab0EUPUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 11:20:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57665 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab0EUPUH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 11:20:07 -0400
Date: Fri, 21 May 2010 11:20:06 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Josef Bacik <josef@redhat.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/6] direct-io: add a hook for the fs to provide its
	own submit_bio function V3
Message-ID: <20100521152006.GA16049@infradead.org>
References: <1274300694-8976-1-git-send-email-josef@redhat.com> <1274300694-8976-2-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1274300694-8976-2-git-send-email-josef@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 04:24:50PM -0400, Josef Bacik wrote:
> V1->V2:
> -Changed dio_end_io to EXPORT_SYMBOL_GPL
> -Removed the own_submit blockdev dio helper
> -Removed the boundary change

patch version changelogs go below the --- header so they don't go into
the commit message.  Also makes reading the patch description a lot
easier.  Also applies to all the other patches in the series.

> +void dio_end_io(struct bio *bio, int error)
> +{
> +	struct dio *dio = bio->bi_private;
> +
> +	if (dio->is_async)
> +		dio_bio_end_aio(bio, error);
> +	else
> +		dio_bio_end_io(bio, error);
> +}
> +EXPORT_SYMBOL_GPL(dio_end_io);

This one needs a good kerneldoc comment.

> -	submit_bio(dio->rw, bio);
> +	if (!dio->submit_io)
> +		submit_bio(dio->rw, bio);
> +	else
> +		dio->submit_io(dio->rw, bio, dio->inode,
> +			       dio->logical_offset_in_bio);

'd reverse the if condition - no need for an inversion here.

	if (dio->submit_io) {
		dio->submit_io(dio->rw, bio, dio->inode,
			       dio->logical_offset_in_bio);
	} else {
		submit_bio(dio->rw, bio);
	}

