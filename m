Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab0HMFjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 01:39:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271Ab0HMFjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 01:39:13 -0400
Date: Fri, 13 Aug 2010 01:38:54 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: nhorman@redhat.com, kexec@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Amerigo Wang <amwang@redhat.com>,
        akpm@linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>,
        huang ying <huang.ying.caritas@gmail.com>, ebiederm@xmission.com
Message-Id: <20100813054314.5564.21503.sendpatchset@localhost.localdomain>
Subject: [Resend][Patch v2] kexec: increase max of kexec segments and use dynamic allocation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently KEXEC_SEGMENT_MAX is only 16 which is too small for machine with
many memory ranges.  When hibernate on a machine with disjoint memory we do
need one segment for each memory region. Increase this hard limit to 16K
which is reasonably large.

And change ->segment from a static array to a dynamically allocated memory.

Cc: Neil Horman <nhorman@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: huang ying <huang.ying.caritas@gmail.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: WANG Cong <amwang@redhat.com>

---

diff --git a/arch/powerpc/kernel/machine_kexec_64.c b/arch/powerpc/kernel/machine_kexec_64.c
index 583af70..93f0542 100644
--- a/arch/powerpc/kernel/machine_kexec_64.c
+++ b/arch/powerpc/kernel/machine_kexec_64.c
@@ -134,10 +134,7 @@ static void copy_segments(unsigned long ind)
 void kexec_copy_flush(struct kimage *image)
 {
 	long i, nr_segments = image->nr_segments;
-	struct  kexec_segment ranges[KEXEC_SEGMENT_MAX];
-
-	/* save the ranges on the stack to efficiently flush the icache */
-	memcpy(ranges, image->segment, sizeof(ranges));
+	struct  kexec_segment range;
 
 	/*
 	 * After this call we may not use anything allocated in dynamic
@@ -151,9 +148,11 @@ void kexec_copy_flush(struct kimage *image)
 	 * we need to clear the icache for all dest pages sometime,
 	 * including ones that were in place on the original copy
 	 */
-	for (i = 0; i < nr_segments; i++)
-		flush_icache_range((unsigned long)__va(ranges[i].mem),
-			(unsigned long)__va(ranges[i].mem + ranges[i].memsz));
+	for (i = 0; i < nr_segments; i++) {
+		memcpy(&range, &image->segment[i], sizeof(range));
+		flush_icache_range((unsigned long)__va(range.mem),
+			(unsigned long)__va(range.mem + range.memsz));
+	}
 }
 
 #ifdef CONFIG_SMP
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 03e8e8d..ec783c1 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -57,7 +57,7 @@ typedef unsigned long kimage_entry_t;
 #define IND_DONE         0x4
 #define IND_SOURCE       0x8
 
-#define KEXEC_SEGMENT_MAX 16
+#define KEXEC_SEGMENT_MAX (1024*16)
 struct kexec_segment {
 	void __user *buf;
 	size_t bufsz;
@@ -86,7 +86,7 @@ struct kimage {
 	struct page *swap_page;
 
 	unsigned long nr_segments;
-	struct kexec_segment segment[KEXEC_SEGMENT_MAX];
+	struct kexec_segment *segment;
 
 	struct list_head control_pages;
 	struct list_head dest_pages;
diff --git a/kernel/kexec.c b/kernel/kexec.c
index c0613f7..22ff794 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -131,6 +131,11 @@ static int do_kimage_alloc(struct kimage **rimage, unsigned long entry,
 	if (!image)
 		goto out;
 
+	image->segment = kzalloc(nr_segments * sizeof(struct kexec_segment),
+				 GFP_KERNEL);
+	if (!image->segment)
+		goto out;
+
 	image->head = 0;
 	image->entry = &image->head;
 	image->last_entry = &image->head;
@@ -218,8 +223,10 @@ static int do_kimage_alloc(struct kimage **rimage, unsigned long entry,
 out:
 	if (result == 0)
 		*rimage = image;
-	else
+	else if (image) {
+		kfree(image->segment);
 		kfree(image);
+	}
 
 	return result;
 
@@ -263,8 +270,10 @@ static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
  out:
 	if (result == 0)
 		*rimage = image;
-	else
+	else if (image) {
+		kfree(image->segment);
 		kfree(image);
+	}
 
 	return result;
 }
@@ -332,8 +341,10 @@ static int kimage_crash_alloc(struct kimage **rimage, unsigned long entry,
 out:
 	if (result == 0)
 		*rimage = image;
-	else
+	else if (image) {
+		kfree(image->segment);
 		kfree(image);
+	}
 
 	return result;
 }
@@ -658,6 +669,7 @@ static void kimage_free(struct kimage *image)
 
 	/* Free the kexec control pages... */
 	kimage_free_page_list(&image->control_pages);
+	kfree(image->segment);
 	kfree(image);
 }
 
