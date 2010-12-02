Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab0LBUt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 15:49:27 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52240 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab0LBUt0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 15:49:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=sEvGMUPdW7gORucDp9jXRqRj5If0c1PccqBLxelAvJ1qTkYf1QfOg5OHLCjm+VbjkD
         nsLxmybgGAMkB2zuBNnUoq8VvUNScLQOEU6kzd5WVEd9ZBrIG3PlLHnzmkehrqhAKXGM
         NSU0rXesJBFAycQ6GqKnBQ87GXyhNwNQyzeMw=
MIME-Version: 1.0
In-Reply-To: <4CF7F83E.9080306@bluewatersys.com>
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com>
 <1291154254-22533-2-git-send-email-cdhmanning@gmail.com> <4CF7F83E.9080306@bluewatersys.com>
From: kevin granade <kevin.granade@gmail.com>
Date: Thu, 2 Dec 2010 14:48:56 -0600
Message-ID: <AANLkTinik7F1=OBnizuQ1Mb4Cya8JKX1Y99AoDZ1Dj-A@mail.gmail.com>
Subject: Re: [PATCH 1/8] Add yaffs2 file system: allocator, attribs, bitmap code
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Charles Manning <cdhmanning@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 2, 2010 at 1:49 PM, Ryan Mallon <ryan@bluewatersys.com> wrote:
> On 12/01/2010 10:57 AM, Charles Manning wrote:
>> Signed-off-by: Charles Manning <cdhmanning@gmail.com>
>> ---
>>  fs/yaffs2/yaffs_allocator.c |  397 +++++++++++++++++++++++++++++++++++++++++++
>>  fs/yaffs2/yaffs_allocator.h |   30 ++++
>>  fs/yaffs2/yaffs_attribs.c   |  124 ++++++++++++++
>>  fs/yaffs2/yaffs_attribs.h   |   28 +++
>>  fs/yaffs2/yaffs_bitmap.c    |  104 +++++++++++
>>  fs/yaffs2/yaffs_bitmap.h    |   33 ++++
>>  6 files changed, 716 insertions(+), 0 deletions(-)
>>  create mode 100644 fs/yaffs2/yaffs_allocator.c
>>  create mode 100644 fs/yaffs2/yaffs_allocator.h
>>  create mode 100644 fs/yaffs2/yaffs_attribs.c
>>  create mode 100644 fs/yaffs2/yaffs_attribs.h
>>  create mode 100644 fs/yaffs2/yaffs_bitmap.c
>>  create mode 100644 fs/yaffs2/yaffs_bitmap.h
>>
>> diff --git a/fs/yaffs2/yaffs_allocator.c b/fs/yaffs2/yaffs_allocator.c
>> new file mode 100644
>> index 0000000..b9fe31e
>> --- /dev/null
>> +++ b/fs/yaffs2/yaffs_allocator.c
>> @@ -0,0 +1,397 @@
>> +/*
>> + * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
>> + *
>> + * Copyright (C) 2002-2010 Aleph One Ltd.
>> + *   for Toby Churchill Ltd and Brightstar Engineering
>> + *
>> + * Created by Charles Manning <charles@aleph1.co.uk>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include "yaffs_allocator.h"
>> +#include "yaffs_guts.h"
>> +#include "yaffs_trace.h"
>> +#include "yportenv.h"
>> +
>> +#ifdef CONFIG_YAFFS_YMALLOC_ALLOCATOR
>
> This doesn't appear to be defined anywhere and is not in Kconfig. Is
> this just a wrapper for support on other operating systems or does it
> can it be used on Linux for debugging? In the former case it should
> probably removed and in the latter it should probably have a comment
> explaining why you would want to define it.
>
> <snip>
>
>> +
>> +#include "yaffs_bitmap.h"
>> +#include "yaffs_trace.h"
>> +/*
>> + * Chunk bitmap manipulations
>> + */
>> +
>> +static Y_INLINE u8 *yaffs_block_bits(struct yaffs_dev *dev, int blk)
>
> Should just use inline.
>
> <snip>
>
>> +
>> +int yaffs_still_some_chunks(struct yaffs_dev *dev, int blk)
>> +{
>> +     u8 *blk_bits = yaffs_block_bits(dev, blk);
>> +     int i;
>> +     for (i = 0; i < dev->chunk_bit_stride; i++) {
>
> Nitpick: You should have a blank line between variable declarations and
> start of code.
>
> <snip>
>
>> +int yaffs_count_chunk_bits(struct yaffs_dev *dev, int blk)
>> +{
>> +     u8 *blk_bits = yaffs_block_bits(dev, blk);
>> +     int i;
>> +     int n = 0;
>> +     for (i = 0; i < dev->chunk_bit_stride; i++) {
>> +             u8 x = *blk_bits;
>> +             while (x) {
>> +                     if (x & 1)
>> +                             n++;
>> +                     x >>= 1;
>> +             }
>> +
>> +             blk_bits++;
>> +     }
>> +     return n;
>> +}
>
>
> This is possibly more concise as a for loop. Also moving the definitions
> all to the top of the file and combining same types definitions on one
> line reduces this function to:
>
> int yaffs_count_chunk_bits(struct yaffs_dev *dev, int blk)
> {
>        u8 x, *blk_bits = yaffs_block_bits(dev, blk);
>        int i, n = 0;
>
>        for (i = 0; i < dev->chunk_bit_stride; i++, blk_bits++)
>                for (x = *blk_bits; x; x >>= 1)
>                        if (x & 1)
>                                n++;
>
>        return n;
> }

Actually, how about using the standard hamming weight function?
This adds a dependency on linux/bitops.h, but seems to be carefully
crafted to be as fast as possible based on the available hardware.

int yaffs_count_chunk_bits(struct yaffs_dev *dev, int blk)
{
       u8 *blk_bits = yaffs_block_bits(dev, blk);
       int i, n = 0;

       for (i = 0; i < dev->chunk_bit_stride; i++, blk_bits++)
               n += hweight8(*blk_bits);

       return n;
}

Kevin Granade


>
> ~Ryan
>
> --
> Bluewater Systems Ltd - ARM Technology Solution Centre
>
> Ryan Mallon                     5 Amuri Park, 404 Barbadoes St
> ryan@bluewatersys.com           PO Box 13 889, Christchurch 8013
> http://www.bluewatersys.com     New Zealand
> Phone: +64 3 3779127            Freecall: Australia 1800 148 751
> Fax:   +64 3 3779135                      USA 1800 261 2934
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
