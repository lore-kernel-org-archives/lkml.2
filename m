Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544Ab2K3Rst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:48:49 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50634 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519Ab2K3Rss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:48:48 -0500
From: Joonsoo Kim <js1304@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Android Kernel Team <kernel-team@android.com>,
        Joonsoo Kim <js1304@gmail.com>, John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Colin Cross <ccross@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Dima Zavin <dima@android.com>, Robert Love <rlove@google.com>
Subject: [RFC PATCH] staging, android, ashmem: invalidate pin/unpin ioctl for private map
Date: Sat,  1 Dec 2012 02:45:57 +0900
Message-Id: <1354297557-24486-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Private mapped ashmem doesn't install vm fault handler.
So, do_anonymous_page is called for handling fault in handle_pte_fault().
This type of backed memory isn't related to asma->file which is used by
ashmem shrinker. Shrinking unpinned area for this mapping
will not shrink memory actually.
Although it's memory doesn't actually removed, pin status will
return ASHMEM_WAS_PURGED. So application will re-load content.
This is needless overhead, so invalidate pin/unpin ioctl behavior for
private map.

CC: John Stultz <john.stultz@linaro.org>
CC: Brian Swetland <swetland@google.com>
CC: Colin Cross <ccross@android.com>
CC: Arve Hjønnevåg <arve@android.com>
CC: Dima Zavin <dima@android.com>
CC: Robert Love <rlove@google.com>
Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index 634b9ae..2fde9df 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -49,6 +49,7 @@ struct ashmem_area {
 	struct file *file;		 /* the shmem-based backing file */
 	size_t size;			 /* size of the mapping, in bytes */
 	unsigned long prot_mask;	 /* allowed prot bits, as vm_flags */
+	bool shared_mapping;		 /* mapping type */
 };
 
 /*
@@ -327,6 +328,7 @@ static int ashmem_mmap(struct file *file, struct vm_area_struct *vma)
 			fput(asma->file);
 			goto out;
 		}
+		asma->shared_mapping = 1;
 	}
 
 	if (vma->vm_file)
@@ -614,21 +616,35 @@ static int ashmem_pin_unpin(struct ashmem_area *asma, unsigned long cmd,
 	pgstart = pin.offset / PAGE_SIZE;
 	pgend = pgstart + (pin.len / PAGE_SIZE) - 1;
 
-	mutex_lock(&ashmem_mutex);
+	if (asma->shared_mapping) {
+		mutex_lock(&ashmem_mutex);
 
-	switch (cmd) {
-	case ASHMEM_PIN:
-		ret = ashmem_pin(asma, pgstart, pgend);
-		break;
-	case ASHMEM_UNPIN:
-		ret = ashmem_unpin(asma, pgstart, pgend);
-		break;
-	case ASHMEM_GET_PIN_STATUS:
-		ret = ashmem_get_pin_status(asma, pgstart, pgend);
-		break;
-	}
+		switch (cmd) {
+		case ASHMEM_PIN:
+			ret = ashmem_pin(asma, pgstart, pgend);
+			break;
+		case ASHMEM_UNPIN:
+			ret = ashmem_unpin(asma, pgstart, pgend);
+			break;
+		case ASHMEM_GET_PIN_STATUS:
+			ret = ashmem_get_pin_status(asma, pgstart, pgend);
+			break;
+		}
 
-	mutex_unlock(&ashmem_mutex);
+		mutex_unlock(&ashmem_mutex);
+
+	} else {
+		switch (cmd) {
+		/* if it is private map, pin/unpin have no impact to vm */
+		case ASHMEM_PIN:
+		case ASHMEM_UNPIN:
+			ret = ASHMEM_NOT_PURGED;
+			break;
+		case ASHMEM_GET_PIN_STATUS:
+			ret = ASHMEM_IS_PINNED;
+			break;
+		}
+	}
 
 	return ret;
 }
-- 
1.7.9.5

