Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab1BRDUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:20:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45917 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab1BRDUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:20:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=eYXipzzMcs+QM7c3FEXrnM5JjiVrDN2rK3L82AJfVMuR2EuT/lWBJIQC5jiD5h4+Oq
         TBS3n0C/QFwXMF8XujsbiKk1OjK9zBjK6dOI4moTDjFTDCQnSjphSO/yahfFYqFBnkiv
         7KAlCDYNWdj87lkb1plu2TIPJOby7kM2lUR9Q=
MIME-Version: 1.0
In-Reply-To: <20110218134025.2a2e5bbb@notabene.brown>
References: <20110216183114.26a3613b@notabene.brown> <20110216155305.GC14653@redhat.com>
 <20110217113536.2bbf308e@notabene.brown> <20110217011029.GA6793@redhat.com>
 <20110217165501.47f3c26f@notabene.brown> <20110217165906.GE9075@redhat.com> <20110218134025.2a2e5bbb@notabene.brown>
From: Mike Snitzer <snitzer@redhat.com>
Date: Thu, 17 Feb 2011 22:19:52 -0500
X-Google-Sender-Auth: mf3HA8Nr-kzQG0sSy7GXoXMORzU
Message-ID: <AANLkTi=t0vFTTDr9jBZ70UmJ9YYzziA0cRP8t0T9wswW@mail.gmail.com>
Subject: Re: blk_throtl_exit taking q->queue_lock is problematic
To: NeilBrown <neilb@suse.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 9:40 PM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 17 Feb 2011 11:59:06 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:
>> So if we do this change for performance reasons, it still makes sense
>> but doing this change because md provided a q->queue_lock and took away that
>> lock without notifying block layer hence we do this change, is still not
>> the right reason, IMHO.
>
> Well...I like that patch, as it makes my life easier....
>
> But I agree that md is doing something wrong.  Now that ->queue_lock is
> always initialised, it is wrong to leave it in a state where it not defined.
>
> So maybe I'll apply this (after testing it a bit.  The only reason for taking
> the lock queue_lock in a couple of places is to silence some warnings.
>
> Thanks,
> NeilBrown
>
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index a23ffa3..909282d 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -959,7 +961,9 @@ static int make_request(mddev_t *mddev, struct bio * bio)
>                atomic_inc(&r1_bio->remaining);
>                spin_lock_irqsave(&conf->device_lock, flags);
>                bio_list_add(&conf->pending_bio_list, mbio);
> +               spin_lock(mddev->queue->queue_lock);
>                blk_plug_device(mddev->queue);
> +               spin_unlock(mddev->queue->queue_lock);
>                spin_unlock_irqrestore(&conf->device_lock, flags);
>        }
>        r1_bio_write_done(r1_bio, bio->bi_vcnt, behind_pages, behind_pages != NULL);

Noticed an inconsistency, raid10.c's additional locking also protects
the bio_list_add() whereas raid1.c's doesn't.  Seems the additional
protection in raid10 isn't needed?

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 3b607b2..60e6cb1 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -970,8 +972,10 @@ static int make_request(mddev_t *mddev, struct bio * bio)
>
>                atomic_inc(&r10_bio->remaining);
>                spin_lock_irqsave(&conf->device_lock, flags);
> +               spin_lock(mddev->queue->queue_lock);
>                bio_list_add(&conf->pending_bio_list, mbio);
>                blk_plug_device(mddev->queue);
> +               spin_unlock(mddev->queue->queue_lock);
>                spin_unlock_irqrestore(&conf->device_lock, flags);
>        }
>
