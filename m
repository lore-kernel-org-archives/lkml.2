Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab0F1Mth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 08:49:37 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:39184 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab0F1Mtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 08:49:35 -0400
Message-ID: <4C289A5E.2060007@kernel.dk>
Date: Mon, 28 Jun 2010 14:49:34 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
       James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
       martin.petersen@oracle.com, akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] block: defer the use of inline biovecs for discard
 requests
References: <20100622180029.GA15950@redhat.com> <1277582211-10725-2-git-send-email-snitzer@redhat.com> <4C2896C6.9030607@kernel.dk> <20100628123742.GB19497@redhat.com> <4C28987A.7000701@kernel.dk> <20100628124429.GA7729@lst.de>
In-Reply-To: <20100628124429.GA7729@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-28 14:44, Christoph Hellwig wrote:
> On Mon, Jun 28, 2010 at 02:41:30PM +0200, Jens Axboe wrote:
>> The horrible part is working around that issue by fiddling with the
>> assignment of the internal vec. THAT looks like a horrible solution
>> to that problem.
>>
>> How about just adding a check to bio_has_data() for non-zero
>> bio->bi_vcnt?
> 
> The question is how a discard request from the block layer should look
> like.  With Mike's patch we have the same situation as for a barrier
> request:  absolutely no data transferred and no indicator of it.  IHMO
> that's much better than any partially constructed request.  And yes,
> that means enabling the payload later in the driver.

With a barrier, it's more clear I think - if it carries data, then
you account that. If it's an empty barrier, then there's nothing to
account. There will be an impact on the io stream, but that is
indicated in blktrace for instance.

> The other option would be to not reuse the request at all and just
> allocate a new request and use that from sd_prep_fn.  That's what
> I tried to implement first, but I couldn't get it to work.  Given
> all the issue we have with the current approach I'm almost tempted
> to try that again.

That sounds way cleaner...

-- 
Jens Axboe

