Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698Ab2CAVUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:20:54 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64664 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757888Ab2CAVUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:20:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of muthu.lkml@gmail.com designates 10.52.180.98 as permitted sender) smtp.mail=muthu.lkml@gmail.com; dkim=pass header.i=muthu.lkml@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F4FDB3E.7000405@kernel.dk>
References: <CAFR8uef08sDCR=FM_v4EV0CLX9f4UuJezSTPFX6V7T-4b7xBVQ@mail.gmail.com>
	<20120229161215.81505738.akpm@linux-foundation.org>
	<CAFR8uedyn_dmE1NPk_H8_vb_ohYcScaG2whEa9=aOcSRWDvcxg@mail.gmail.com>
	<4F4FDB3E.7000405@kernel.dk>
Date: Thu, 1 Mar 2012 13:20:51 -0800
Message-ID: <CAFR8uecR0+dYeY47ztGvg02uCPXv8TTi_cbaBqc+Cq-v=NMe4Q@mail.gmail.com>
Subject: Re: [PATCH] Fix setting bio flags in drivers (sd_dif/floppy).
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, martin.petersen@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 12:25 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2012-03-01 21:23, Muthu Kumar wrote:
>>>>                       kunmap_atomic(sdt, KM_USER0);
>>>>               }
>>>>
>>>> -             bio->bi_flags |= BIO_MAPPED_INTEGRITY;
>>>> +             bio->bi_flags |= (1 << BIO_MAPPED_INTEGRITY);
>>>>       }
>>>>
>>>>       return 0;
>>>
>>> urgh.  This isn't the first time.
>>>
>>> It's too easy for people to make this mistake.  I'm not sure what a
>>> good fix would be - I don't think sparse can save us with __bitwise or
>>> similar.
>>>
>>> The approach we took in buffer_head.h with BH_Foo and BUFFER_FNS
>>> accessors worked pretty well.
>>>
>>
>> Does this look good? BTW, I used the non-atomic variants __set/__clear
>> to match the behavior of current usage.
>> If this looks good, I can send the proper patch as attachment (so no
>> line wraps :)
>
> Lets not wrap this in macros, it just makes the code harder to read.
> Making the BIO_ flags a bit shift value was a mistake in hindsight, too
> easy to get wrong.
>
> If we're going to be changing everything anyway, it'd be better to have
> __ variants if we really need the bit shifts, and the non __ variants be
> the value. Similar to what is done for request flags.
>
> --
> Jens Axboe
>


You mean, like this? (sparing the gmail line wrap)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 4053cbd..035e1ef 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -83,19 +83,35 @@ struct bio {
 /*
  * bio flags
  */
-#define BIO_UPTODATE   0       /* ok after I/O completion */
-#define BIO_RW_BLOCK   1       /* RW_AHEAD set, and read/write would block */
-#define BIO_EOF                2       /* out-out-bounds error */
-#define BIO_SEG_VALID  3       /* bi_phys_segments valid */
-#define BIO_CLONED     4       /* doesn't own data */
-#define BIO_BOUNCED    5       /* bio is a bounce bio */
-#define BIO_USER_MAPPED 6      /* contains user pages */
-#define BIO_EOPNOTSUPP 7       /* not supported */
-#define BIO_NULL_MAPPED 8      /* contains invalid user pages */
-#define BIO_FS_INTEGRITY 9     /* fs owns integrity data, not block layer */
-#define BIO_QUIET      10      /* Make BIO Quiet */
-#define BIO_MAPPED_INTEGRITY 11/* integrity metadata has been remapped */
-#define bio_flagged(bio, flag) ((bio)->bi_flags & (1 << (flag)))
+enum bio_flag_bits {
+    __BIO_UPTODATE,             /* ok after I/O completion */
+    __BIO_RW_BLOCK,             /* RW_AHEAD set, and read/write would block */
+    __BIO_EOF,                  /* out-out-bounds error */
+    __BIO_SEG_VALID,            /* bi_phys_segments valid */
+    __BIO_CLONED,               /* doesn't own data */
+    __BIO_BOUNCED,              /* bio is a bounce bio */
+    __BIO_USER_MAPPED,          /* contains user pages */
+    __BIO_EOPNOTSUPP,           /* not supported */
+    __BIO_NULL_MAPPED,          /* contains invalid user pages */
+    __BIO_FS_INTEGRITY,         /* fs owns integrity data, not block layer */
+    __BIO_QUIET,                /* Make BIO Quiet */
+    __BIO_MAPPED_INTEGRITY,     /* integrity metadata has been remapped */
+};
+
+#define BIO_UPTODATE            (1 << __BIO_UPTODATE)
+#define BIO_RW_BLOCK            (1 << __BIO_RW_BLOCK)
+#define BIO_EOF                 (1 << __BIO_EOF)
+#define BIO_SEG_VALID           (1 << __BIO_SEG_VALID)
+#define BIO_CLONED              (1 << __BIO_CLONED)
+#define BIO_BOUNCED             (1 << __BIO_BOUNCED)
+#define BIO_USER_MAPPED         (1 << __BIO_USER_MAPPED)
+#define BIO_EOPNOTSUPP          (1 << __BIO_EOPNOTSUPP)
+#define BIO_NULL_MAPPED         (1 << __BIO_NULL_MAPPED)
+#define BIO_FS_INTEGRITY        (1 << __BIO_FS_INTEGRITY)
+#define BIO_QUIET               (1 << __BIO_QUIET)
+#define BIO_MAPPED_INTEGRITY    (1 << __BIO_MAPPED_INTEGRITY)
+
+#define bio_flagged(bio, flag) ((bio)->bi_flags & (flag))

 /*
  * top 4 bits of bio flags indicate the pool this bio came from
