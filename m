Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab0IFLPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 07:15:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898Ab0IFLPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 07:15:33 -0400
Message-ID: <4C84CD18.6060906@redhat.com>
Date: Mon, 06 Sep 2010 13:14:32 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100821 Lightning/1.0b2 Icedove/3.1.2
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: Tejun Heo <tj@kernel.org>, jaxboe@fusionio.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-raid@vger.kernel.org, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        snitzer@redhat.com, k-ueda@ct.jp.nec.com, mpatocka@redhat.com
Subject: Re: [dm-devel] [PATCH 23/41] dm: implement REQ_FLUSH/FUA support
 for	bio-based dm
References: <1283509796-1510-1-git-send-email-tj@kernel.org> <1283509796-1510-24-git-send-email-tj@kernel.org>
In-Reply-To: <1283509796-1510-24-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2010 12:29 PM, Tejun Heo wrote:

> +++ b/drivers/md/dm-crypt.c
> @@ -1278,7 +1278,7 @@ static int crypt_map(struct dm_target *ti, struct bio *bio,
>  	struct dm_crypt_io *io;
>  	struct crypt_config *cc;
>  
> -	if (unlikely(bio_empty_barrier(bio))) {
> +	if (bio->bi_rw & REQ_FLUSH) {
>  		cc = ti->private;
>  		bio->bi_bdev = cc->dev->bdev;
>  		return DM_MAPIO_REMAPPED;

...

> +++ b/drivers/md/dm.c
> @@ -1400,14 +1391,22 @@ static void __split_and_process_bio(struct mapped_device *md, struct bio *bio)
>  	ci.io->md = md;
>  	spin_lock_init(&ci.io->endio_lock);
>  	ci.sector = bio->bi_sector;
> -	ci.sector_count = bio_sectors(bio);
> -	if (unlikely(bio_empty_barrier(bio)))
> +	if (!(bio->bi_rw & REQ_FLUSH))
> +		ci.sector_count = bio_sectors(bio);
> +	else {
> +		/* all FLUSH bio's reaching here should be empty */
> +		WARN_ON_ONCE(bio_has_data(bio));
>  		ci.sector_count = 1;
> +	}


I would add BUG_ON(bio_has_data(bio)) either to dm-crypt target or directly to DM core
in this path.

Note that empty barrier request bypass encryption layer now in dm-crypt, so if some bio
with data payload reach it after the change, it causes data corruption
(moreover plain data reach the disk directly).

Milan
