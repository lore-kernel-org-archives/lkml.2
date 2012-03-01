Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab2CAAMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 19:12:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39332 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab2CAAMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 19:12:17 -0500
Date: Wed, 29 Feb 2012 16:12:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>, martin.petersen@oracle.com
Subject: Re: [PATCH] Fix setting bio flags in drivers (sd_dif/floppy).
Message-Id: <20120229161215.81505738.akpm@linux-foundation.org>
In-Reply-To: <CAFR8uef08sDCR=FM_v4EV0CLX9f4UuJezSTPFX6V7T-4b7xBVQ@mail.gmail.com>
References: <CAFR8uef08sDCR=FM_v4EV0CLX9f4UuJezSTPFX6V7T-4b7xBVQ@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012 18:22:14 -0500
Muthu Kumar <muthu.lkml@gmail.com> wrote:

> Fix setting bio flags in drivers (sd_dif/floppy).
> 
> ...
> 
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 9baf11e..744f078 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -3832,7 +3832,7 @@ static int __floppy_read_block_0(struct
> block_device *bdev)
>  	bio.bi_size = size;
>  	bio.bi_bdev = bdev;
>  	bio.bi_sector = 0;
> -	bio.bi_flags = BIO_QUIET;
> +	bio.bi_flags = (1 << BIO_QUIET);
>  	init_completion(&complete);
>  	bio.bi_private = &complete;
>  	bio.bi_end_io = floppy_rb0_complete;
> diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
> index 0cb39ff..f8fb2d6 100644
> --- a/drivers/scsi/sd_dif.c
> +++ b/drivers/scsi/sd_dif.c
> @@ -408,7 +408,7 @@ int sd_dif_prepare(struct request *rq, sector_t
> hw_sector, unsigned int sector_s
>  			kunmap_atomic(sdt, KM_USER0);
>  		}
> 
> -		bio->bi_flags |= BIO_MAPPED_INTEGRITY;
> +		bio->bi_flags |= (1 << BIO_MAPPED_INTEGRITY);
>  	}
> 
>  	return 0;

urgh.  This isn't the first time.

It's too easy for people to make this mistake.  I'm not sure what a
good fix would be - I don't think sparse can save us with __bitwise or
similar.

The approach we took in buffer_head.h with BH_Foo and BUFFER_FNS
accessors worked pretty well.

