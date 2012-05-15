Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965759Ab2EOQYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:24:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34866 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965642Ab2EOQYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:24:05 -0400
Date: Tue, 15 May 2012 09:24:00 -0700
From: Tejun Heo <tejun@google.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 02/16] Bio pool freeing
Message-ID: <20120515162400.GB17216@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <ba8ce9fcca87f192ff5f5d3a436eb8f4d0bcb006.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba8ce9fcca87f192ff5f5d3a436eb8f4d0bcb006.1336619038.git.koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 11:08:34PM -0400, Kent Overstreet wrote:
> When you allocate a bio from a bio pool, to free it you have to know
> where it came from; this adds a flag which, if set, means bi_destructor
> is the pointer to the pool and bio_put() can do the right thing.
> 
> This is used in bcache, so we can cleanly use per device bio pools.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> ---
> @@ -417,7 +418,11 @@ void bio_put(struct bio *bio)
>  	 */
>  	if (atomic_dec_and_test(&bio->bi_cnt)) {
>  		bio->bi_next = NULL;
> -		bio->bi_destructor(bio);
> +
> +		if (bio_flagged(bio, BIO_HAS_POOL))
> +			bio_free(bio, (void *) bio->bi_destructor);
> +		else
> +			bio->bi_destructor(bio);

Ummm... this is way too cryptic.  Please just add another field to
bio.

Thanks.

-- 
tejun
