Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381Ab0IHAAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 20:00:45 -0400
Received: from verein.lst.de ([213.95.11.210]:38130 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab0IHAAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 20:00:42 -0400
Date: Wed, 8 Sep 2010 02:00:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, jack@suse.cz, mst@redhat.com,
        linux-ide@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>,
        James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, hch@lst.de,
        k-ueda@ct.jp.nec.com, vst@vlnb.net, linux-scsi@vger.kernel.org,
        rusty@rustcorp.com.au, linux-raid@vger.kernel.org, mpatocka@redhat.com,
        swhiteho@redhat.com, chris.mason@oracle.com, tytso@mit.edu,
        jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, rwheeler@redhat.com,
        Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH 42/41] dm: convey that all flushes are processed as empty
Message-ID: <20100908000001.GA21552@lst.de>
References: <1283509796-1510-1-git-send-email-tj@kernel.org> <1283509796-1510-24-git-send-email-tj@kernel.org> <4C84CD18.6060906@redhat.com> <20100907211724.GA22525@redhat.com> <20100907221543.GB22525@redhat.com> <20100907234918.GA23921@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100907234918.GA23921@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 07:49:18PM -0400, Mike Snitzer wrote:
>  		if (!(bio->bi_rw & REQ_FLUSH) || !bio->bi_size) {
> +			/* done with normal IO or empty flush */
>  			trace_block_bio_complete(md->queue, bio);
>  			bio_endio(bio, io_error);
>  		} else {

To clarify this further I'd reorder the checks:

		if ((bio->bi_rw & REQ_FLUSH) && bio->bi_size) {
			/*
			 * Preflush done, ...
			 */
		} else {
		}

> @@ -1302,20 +1302,17 @@ static void __split_and_process_bio(struct mapped_device *md, struct bio *bio)
>  	ci.sector = bio->bi_sector;
>  	ci.idx = bio->bi_idx;
>  
> +	start_io_acct(ci.io);
>  	if (!is_flush) {

no need for the is_flush anymore now that it's only used once.  Again,
I think avoiding negatives without a reason in if statement usually
makes the code a bit more clear.

