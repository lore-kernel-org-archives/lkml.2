Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325Ab2EWBoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 21:44:54 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59661 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933148Ab2EWBov convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 21:44:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120522224255.GM14339@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
	<9ea33658f2a71b3b9bd2ec10bee959bef146f23c.1336619038.git.koverstreet@google.com>
	<20120522224255.GM14339@google.com>
Date: Tue, 22 May 2012 18:44:50 -0700
Message-ID: <CAH+dOx+=XuLzrDqyigAghCT=c6O1HJdd-SMHUw-XpK0NeY8PnA@mail.gmail.com>
Subject: Re: [Bcache v13 14/16] bcache: Request, io and allocation code
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tejun@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm gonna grovel through the code history, but that looks to me like dead code.

On Tue, May 22, 2012 at 3:42 PM, Tejun Heo <tejun@google.com> wrote:
> On Wed, May 09, 2012 at 11:11:25PM -0400, Kent Overstreet wrote:
>> +int submit_bbio_split(struct bio *bio, struct cache_set *c,
>> +                   struct bkey *k, unsigned ptr)
>> +{
>> +     struct closure *cl = bio->bi_private;
>> +     struct bbio *b;
>> +     struct bio *n;
>> +     unsigned sectors_done = 0;
>> +
>> +     closure_get(cl);
>> +
>> +     bio->bi_sector  = PTR_OFFSET(k, ptr);
>> +     bio->bi_bdev    = PTR_CACHE(c, k, ptr)->bdev;
>> +
>> +     do {
>> +             n = bio_split_get(bio, bio_max_sectors(bio), c);
>> +             if (!n) {
>> +                     closure_put(cl);
>> +                     return -ENOMEM;
>> +             }
>> +
>> +             b = container_of(n, struct bbio, bio);
>> +
>> +             bkey_copy_single_ptr(&b->key, k, ptr);
>> +             SET_KEY_SIZE(&b->key, KEY_SIZE(k) - sectors_done);
>> +             SET_PTR_OFFSET(&b->key, 0, PTR_OFFSET(k, ptr) + sectors_done);
>> +
>> +             b->submit_time_us = local_clock_us();
>> +             generic_make_request(n);
>> +     } while (n != bio);
>> +
>> +     return 0;
>> +}
>
> Hmmm... where is @sectors_done updated?
>
> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
