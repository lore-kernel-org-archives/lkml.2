Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760391Ab2FDLqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:46:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56565 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759630Ab2FDLqP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:46:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120604101237.GD7670@quack.suse.cz>
References: <1338644416-11417-1-git-send-email-akinobu.mita@gmail.com>
	<20120604101237.GD7670@quack.suse.cz>
Date: Mon, 4 Jun 2012 20:46:14 +0900
Message-ID: <CAC5umyjP0Pov1a3b7N3VzNVHc1uhan2tLmy2_bOzWeY0u7h2FA@mail.gmail.com>
Subject: Re: [PATCH v2 01/10] string: introduce memweight
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Anders Larsen <al@alarsen.net>, Alasdair Kergon <agk@redhat.com>,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
        linux-ext4@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>, Matthew Wilcox <matthew@wil.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/4 Jan Kara <jack@suse.cz>:
> On Sat 02-06-12 22:40:07, Akinobu Mita wrote:
>> memweight() is the function that counts the total number of bits set
>> in memory area.  Unlike bitmap_weight(), memweight() takes pointer
>> and size in bytes to specify a memory area which does not need to be
>> aligned to long-word boundary.
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> Cc: Anders Larsen <al@alarsen.net>
>> Cc: Alasdair Kergon <agk@redhat.com>
>> Cc: dm-devel@redhat.com
>> Cc: linux-fsdevel@vger.kernel.org
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: linux-media@vger.kernel.org
>> Cc: Mark Fasheh <mfasheh@suse.com>
>> Cc: Joel Becker <jlbec@evilplan.org>
>> Cc: ocfs2-devel@oss.oracle.com
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: linux-ext4@vger.kernel.org
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
>> Cc: "Theodore Ts'o" <tytso@mit.edu>
>> Cc: Matthew Wilcox <matthew@wil.cx>
>> ---
>>
>> v2: simplify memweight(), adviced by Jan Kara
>>
>>  include/linux/string.h |    3 +++
>>  lib/string.c           |   32 ++++++++++++++++++++++++++++++++
>>  2 files changed, 35 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/string.h b/include/linux/string.h
>> index e033564..ffe0442 100644
>> --- a/include/linux/string.h
>> +++ b/include/linux/string.h
>> @@ -145,4 +145,7 @@ static inline bool strstarts(const char *str, const char *prefix)
>>       return strncmp(str, prefix, strlen(prefix)) == 0;
>>  }
>>  #endif
>> +
>> +extern size_t memweight(const void *ptr, size_t bytes);
>> +
>>  #endif /* _LINUX_STRING_H_ */
>> diff --git a/lib/string.c b/lib/string.c
>> index e5878de..bf4d5a8 100644
>> --- a/lib/string.c
>> +++ b/lib/string.c
>> @@ -26,6 +26,7 @@
>>  #include <linux/export.h>
>>  #include <linux/bug.h>
>>  #include <linux/errno.h>
>> +#include <linux/bitmap.h>
>>
>>  #ifndef __HAVE_ARCH_STRNICMP
>>  /**
>> @@ -824,3 +825,34 @@ void *memchr_inv(const void *start, int c, size_t bytes)
>>       return check_bytes8(start, value, bytes % 8);
>>  }
>>  EXPORT_SYMBOL(memchr_inv);
>> +
>> +/**
>> + * memweight - count the total number of bits set in memory area
>> + * @ptr: pointer to the start of the area
>> + * @bytes: the size of the area
>> + */
>> +size_t memweight(const void *ptr, size_t bytes)
>> +{
>> +     size_t w = 0;
>> +     size_t longs;
>> +     const unsigned char *bitmap = ptr;
>> +
>> +     for (; bytes > 0 && ((unsigned long)bitmap) % sizeof(long);
>> +                     bytes--, bitmap++)
>> +             w += hweight8(*bitmap);
>> +
>> +     longs = bytes / sizeof(long);
>> +     if (longs) {
>> +             BUG_ON(longs >= INT_MAX / BITS_PER_LONG);
>> +             w += bitmap_weight((unsigned long *)bitmap,
>> +                             longs * BITS_PER_LONG);
>> +             bytes -= longs * sizeof(long);
>> +             bitmap += longs * sizeof(long);
>> +     }
>> +
>> +     for (; bytes > 0; bytes--, bitmap++)
>> +             w += hweight8(*bitmap);
>  Looking at bitmap_weight() it seems this last loop is not needed. Just
> pass to bitmap_weight() bytes*BITS_PER_BYTE. Also generally this function
> doesn't seem necessary at all at least for ext2 & ext3 (sorry for not
> noticing this earlier...).

This last loop is necessary for big-endian architecture.
if bytes % sizeof(long) != 0, bitmap_weight() counts one-bits in wrong
byte-field
of the last long word.
