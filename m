Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935038Ab1JEQsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:48:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41527 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934960Ab1JEQsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:48:31 -0400
Message-ID: <1317833310.1782.33.camel@Joe-Laptop>
Subject: [alternate PATCH] block: fix UUID string buffer length
From: Joe Perches <joe@perches.com>
To: Will Drewry <wad@chromium.org>
Cc: Rabin Vincent <rabin@rab.in>, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Date: Wed, 05 Oct 2011 09:48:30 -0700
In-Reply-To: <CABqD9hYw3qcMpcjyEtvstYD-WRB=QkVPS5S0MBbah=veZv9E6A@mail.gmail.com>
References: <1317808364-21081-1-git-send-email-rabin@rab.in>
	 <CABqD9hYw3qcMpcjyEtvstYD-WRB=QkVPS5S0MBbah=veZv9E6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The UUID string buffer is several bytes shorter than what is actually
required.  Fix it and remove the used once inline part_unpack_uuid,
use snprintf and printf extension %pU directly.

Based-on-a-patch-by: Rabin Vincent <rabin@rab.in>
cc: Will Drewry <wad@chromium.org>
Signed-off-by: Joe Perches <joe@perches.com>
---
 block/genhd.c         |    8 +++++---
 include/linux/genhd.h |    6 ------
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index e2f6790..427c955 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -735,7 +735,7 @@ void __init printk_all_partitions(void)
 		struct hd_struct *part;
 		char name_buf[BDEVNAME_SIZE];
 		char devt_buf[BDEVT_SIZE];
-		u8 uuid[PARTITION_META_INFO_UUIDLTH * 2 + 1];
+		char uuid[sizeof("12345678-1234-1234-1234-123456789012")];
 
 		/*
 		 * Don't show empty devices or things that have been
@@ -754,9 +754,11 @@ void __init printk_all_partitions(void)
 		while ((part = disk_part_iter_next(&piter))) {
 			bool is_part0 = part == &disk->part0;
 
-			uuid[0] = 0;
 			if (part->info)
-				part_unpack_uuid(part->info->uuid, uuid);
+				snprintf(uuid, sizeof(uuid),
+					 "%pU", part->info->uuid);
+			else
+				uuid[0] = '\0';
 
 			printk("%s%s %10llu %s %s", is_part0 ? "" : "  ",
 			       bdevt_str(part_devt(part), devt_buf),
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 02fa469..28bd275 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -221,12 +221,6 @@ static inline void part_pack_uuid(const u8 *uuid_str, u8 *to)
 	}
 }
 
-static inline char *part_unpack_uuid(const u8 *uuid, char *out)
-{
-	sprintf(out, "%pU", uuid);
-	return out;
-}
-
 static inline int disk_max_parts(struct gendisk *disk)
 {
 	if (disk->flags & GENHD_FL_EXT_DEVT)


