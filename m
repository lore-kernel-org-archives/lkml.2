Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab2EXATu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 20:19:50 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:44315 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab2EXATs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 20:19:48 -0400
Message-ID: <4FBD7E80.4020005@ce.jp.nec.com>
Date: Thu, 24 May 2012 09:19:12 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, yehuda@hq.newdream.net,
        mpatocka@redhat.com, vgoyal@redhat.com, bharrosh@panasas.com,
        tj@kernel.org, sage@newdream.net, agk@redhat.com,
        drbd-dev@lists.linbit.com
Subject: Re: [dm-devel] [PATCH v2 02/14] dm: kill dm_rq_bio_destructor
References: <1337817771-25038-1-git-send-email-koverstreet@google.com> <1337817771-25038-3-git-send-email-koverstreet@google.com>
In-Reply-To: <1337817771-25038-3-git-send-email-koverstreet@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/24/12 09:02, Kent Overstreet wrote:
> @@ -1438,15 +1439,6 @@ void dm_dispatch_request(struct request *rq)
>  }
>  EXPORT_SYMBOL_GPL(dm_dispatch_request);
>  
> -static void dm_rq_bio_destructor(struct bio *bio)
> -{
> -	struct dm_rq_clone_bio_info *info = bio->bi_private;
> -	struct mapped_device *md = info->tio->md;
> -
> -	free_bio_info(info);
> -	bio_free(bio, md->bs);
> -}
> -
>  static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
>  				 void *data)
>  {
> @@ -1461,7 +1453,6 @@ static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
>  	info->tio = tio;
>  	bio->bi_end_io = end_clone_bio;
>  	bio->bi_private = info;
> -	bio->bi_destructor = dm_rq_bio_destructor;

The destructor may also be called from blk_rq_unprep_clone(),
which just puts bio.
So this patch will introduce a memory leak.

Please check this comment as well:
https://www.redhat.com/archives/dm-devel/2012-May/msg00216.html

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
