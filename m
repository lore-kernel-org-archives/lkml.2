Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab2CAUXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:23:17 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38505 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab2CAUXP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:23:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of muthu.lkml@gmail.com designates 10.52.180.98 as permitted sender) smtp.mail=muthu.lkml@gmail.com; dkim=pass header.i=muthu.lkml@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120229161215.81505738.akpm@linux-foundation.org>
References: <CAFR8uef08sDCR=FM_v4EV0CLX9f4UuJezSTPFX6V7T-4b7xBVQ@mail.gmail.com>
	<20120229161215.81505738.akpm@linux-foundation.org>
Date: Thu, 1 Mar 2012 15:23:14 -0500
Message-ID: <CAFR8uedyn_dmE1NPk_H8_vb_ohYcScaG2whEa9=aOcSRWDvcxg@mail.gmail.com>
Subject: Re: [PATCH] Fix setting bio flags in drivers (sd_dif/floppy).
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>, martin.petersen@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>                       kunmap_atomic(sdt, KM_USER0);
>>               }
>>
>> -             bio->bi_flags |= BIO_MAPPED_INTEGRITY;
>> +             bio->bi_flags |= (1 << BIO_MAPPED_INTEGRITY);
>>       }
>>
>>       return 0;
>
> urgh.  This isn't the first time.
>
> It's too easy for people to make this mistake.  I'm not sure what a
> good fix would be - I don't think sparse can save us with __bitwise or
> similar.
>
> The approach we took in buffer_head.h with BH_Foo and BUFFER_FNS
> accessors worked pretty well.
>

Does this look good? BTW, I used the non-atomic variants __set/__clear
to match the behavior of current usage.
If this looks good, I can send the proper patch as attachment (so no
line wraps :)


diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 4053cbd..8b2fbbb 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -8,6 +8,7 @@
 #ifdef CONFIG_BLOCK

 #include <linux/types.h>
+#include <linux/bitops.h>

 struct bio_set;
 struct bio;
@@ -98,6 +99,43 @@ struct bio {
 #define bio_flagged(bio, flag) ((bio)->bi_flags & (1 << (flag)))

 /*
+ * Macro tricks similar to setting b_state in buffer_head.h.
+ * To set uptodate flag in a bio:
+ *      bio_flags_set_uptodate(bio);
+ * To clear
+ *      bio_flags_clear_uptodate(bio);
+ * To test if it is set
+ *      bio_flagged_uptodate(bio);
+ */
+#define BIO_FLAGS_FNS(bit, name)                                         \
+static inline void bio_flags_set_##name(struct bio *bio)                 \
+{                                                                        \
+    __set_bit(BIO_##bit, &(bio)->bi_flags);                              \
+}                                                                        \
+static inline void bio_flags_clear_##name(struct bio *bio)               \
+{                                                                        \
+    __clear_bit(BIO_##bit, &(bio)->bi_flags);                            \
+}                                                                        \
+static inline int bio_flagged_##name(const struct bio *bio)              \
+{                                                                        \
+    return test_bit(BIO_##bit, &(bio)->bi_flags);                        \
+}                                                                        \
+
+BIO_FLAGS_FNS(UPTODATE, uptodate)
+BIO_FLAGS_FNS(RW_BLOCK, rw_block)
+BIO_FLAGS_FNS(EOF, eof)
+BIO_FLAGS_FNS(SEG_VALID, seg_valid)
+BIO_FLAGS_FNS(CLONED, cloned)
+BIO_FLAGS_FNS(BOUNCED, bounced)
+BIO_FLAGS_FNS(USER_MAPPED, user_mapped)
+BIO_FLAGS_FNS(EOPNOTSUPP, eopnotsupp)
+BIO_FLAGS_FNS(NULL_MAPPED, null_mapped)
+BIO_FLAGS_FNS(FS_INTEGRITY, fs_integrity)
+BIO_FLAGS_FNS(QUIET, quiet)
+BIO_FLAGS_FNS(MAPPED_INTEGRITY, mapped_integrity)
+
+/*
  * top 4 bits of bio flags indicate the pool this bio came from
  */
 #define BIO_POOL_BITS          (4)
