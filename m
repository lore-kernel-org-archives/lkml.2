Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab0F1Mo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 08:44:56 -0400
Received: from verein.lst.de ([213.95.11.210]:36455 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768Ab0F1Mox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 08:44:53 -0400
Date: Mon, 28 Jun 2010 14:44:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
       dm-devel@redhat.com, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] block: defer the use of inline biovecs for discard requests
Message-ID: <20100628124429.GA7729@lst.de>
References: <20100622180029.GA15950@redhat.com> <1277582211-10725-2-git-send-email-snitzer@redhat.com> <4C2896C6.9030607@kernel.dk> <20100628123742.GB19497@redhat.com> <4C28987A.7000701@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C28987A.7000701@kernel.dk>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 02:41:30PM +0200, Jens Axboe wrote:
> The horrible part is working around that issue by fiddling with the
> assignment of the internal vec. THAT looks like a horrible solution
> to that problem.
> 
> How about just adding a check to bio_has_data() for non-zero
> bio->bi_vcnt?

The question is how a discard request from the block layer should look
like.  With Mike's patch we have the same situation as for a barrier
request:  absolutely no data transferred and no indicator of it.  IHMO
that's much better than any partially constructed request.  And yes,
that means enabling the payload later in the driver.

The other option would be to not reuse the request at all and just
allocate a new request and use that from sd_prep_fn.  That's what
I tried to implement first, but I couldn't get it to work.  Given
all the issue we have with the current approach I'm almost tempted
to try that again.

