Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab2JBOJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 10:09:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab2JBOJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 10:09:04 -0400
Date: Tue, 2 Oct 2012 10:08:47 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk,
        "Martin K. Petersen" <martin.petersen@oracle.com>, tj@kernel.org
Subject: Re: [dm-devel] [PATCH v3 01/26] block: Fix a buffer overrun in
 bio_integrity_split()
Message-ID: <20121002140847.GD758@redhat.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-2-git-send-email-koverstreet@google.com>
 <20121001212336.GA17165@redhat.com>
 <20121001214241.GE26488@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001214241.GE26488@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 02:42:41PM -0700, Kent Overstreet wrote:

[..]
> Here's the new patch:
> 
> 
> commit e270c9ca843b5c86d59431b0d7a676b7846946d6
> Author: Kent Overstreet <koverstreet@google.com>
> Date:   Mon Oct 1 14:41:08 2012 -0700
> 
>     block: Fix a buffer overrun in bio_integrity_split()
>     
>     bio_integrity_split() seemed to be confusing pointers and arrays -
>     bip_vec in bio_integrity_payload is an array appended to the end of the
>     payload, so the bio_vecs in struct bio_pair need to come immediately
>     after the bio_integrity_payload they're for, and there was an assignment
>     in bio_integrity_split() that didn't make any sense.
>     
>     Also, changed bio_integrity_split() to not refer to the bvecs embedded
>     in struct bio_pair, in case there's padding between them and
>     bip->bip_vec.
>     
>     Signed-off-by: Kent Overstreet <koverstreet@google.com>
>     CC: Jens Axboe <axboe@kernel.dk>
>     CC: Martin K. Petersen <martin.petersen@oracle.com>
> 
> diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
> index a3f28f3..4ae22a8 100644
> --- a/fs/bio-integrity.c
> +++ b/fs/bio-integrity.c
> @@ -694,15 +694,12 @@ void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
>  	bp->bio1.bi_integrity = &bp->bip1;
>  	bp->bio2.bi_integrity = &bp->bip2;
>  
> -	bp->iv1 = bip->bip_vec[0];
> -	bp->iv2 = bip->bip_vec[0];
> +	*bp->bip1.bip_vec = bip->bip_vec[0];
> +	*bp->bip2.bip_vec = bip->bip_vec[0];

I think this is horrible. Why not introduce bvec pointer in bip (like bio),
to cover the case when bvec are not inline.

Thanks
Vivek
