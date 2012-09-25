Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab2IYLzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:55:04 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:55477 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab2IYLy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:54:59 -0400
Date: Tue, 25 Sep 2012 13:54:52 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, linux-s390@vger.kernel.org,
        Chris Mason <chris.mason@fusionio.com>, neilb@suse.de,
        Jiri Kosina <jkosina@suse.cz>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Alasdair Kergon <agk@redhat.com>, tj@kernel.org,
        Steven Whitehouse <swhiteho@redhat.com>, vgoyal@redhat.com,
        Lars Ellenberg <drbd-dev@lists.linbit.com>
Subject: Re: [Drbd-dev] [PATCH v3 06/26] block: Add bio_end_sector()
Message-ID: <20120925115452.GF8143@soda.linbit>
Mail-Followup-To: Kent Overstreet <koverstreet@google.com>,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com, axboe@kernel.dk, linux-s390@vger.kernel.org,
	Chris Mason <chris.mason@fusionio.com>, neilb@suse.de,
	Jiri Kosina <jkosina@suse.cz>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Alasdair Kergon <agk@redhat.com>, tj@kernel.org,
	Steven Whitehouse <swhiteho@redhat.com>, vgoyal@redhat.com,
	Lars Ellenberg <drbd-dev@lists.linbit.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-7-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348526106-17074-7-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 03:34:46PM -0700, Kent Overstreet wrote:
> Just a little convenience macro - main reason to add it now is preparing
> for immutable bio vecs, it'll reduce the size of the patch that puts
> bi_sector/bi_size/bi_idx into a struct bvec_iter.


For the DRBD part:

> diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
> index 01b2ac6..d90a1fd 100644
> --- a/drivers/block/drbd/drbd_req.c
> +++ b/drivers/block/drbd/drbd_req.c
> @@ -1144,7 +1144,7 @@ void drbd_make_request(struct request_queue *q, struct bio *bio)
>  	/* to make some things easier, force alignment of requests within the
>  	 * granularity of our hash tables */
>  	s_enr = bio->bi_sector >> HT_SHIFT;
> -	e_enr = bio->bi_size ? (bio->bi_sector+(bio->bi_size>>9)-1) >> HT_SHIFT : s_enr;
> +	e_enr = (bio_end_sector(bio) - 1) >> HT_SHIFT;

You ignored the bio->bi_size ? : ;

#define bio_end_sector(bio)	((bio)->bi_sector + bio_sectors(bio))
which turns out (bio->bi_sector + (bio->bi_size >> 9))

Note that bi_size may be 0, bio_end_sector(bio)-1 then is bi_sector -1,
for an empty flush with bi_sector == 0, this ends up as (sector_t)-1ULL,
and this code path breaks horribly.


+	e_enr = bio->bi_size ? (bio_end_sector(bio) - 1) >> HT_SHIFT : s_enr;


Thanks,
	Lars
