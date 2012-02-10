Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085Ab2BJFxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:53:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932472Ab2BJFpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:45:43 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Subject: [PATCH 36/60] jbd2: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:39:57 +0800
Message-Id: <1328852421-19678-37-git-send-email-amwang@redhat.com>
In-Reply-To: <1328852421-19678-1-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cong Wang <amwang@redhat.com>
---
 fs/jbd2/commit.c      |    4 ++--
 fs/jbd2/journal.c     |   12 ++++++------
 fs/jbd2/transaction.c |    4 ++--
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 5069b84..c067a8c 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -286,10 +286,10 @@ static __u32 jbd2_checksum_data(__u32 crc32_sum, struct buffer_head *bh)
 	char *addr;
 	__u32 checksum;
 
-	addr = kmap_atomic(page, KM_USER0);
+	addr = kmap_atomic(page);
 	checksum = crc32_be(crc32_sum,
 		(void *)(addr + offset_in_page(bh->b_data)), bh->b_size);
-	kunmap_atomic(addr, KM_USER0);
+	kunmap_atomic(addr);
 
 	return checksum;
 }
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index c0a5f9f..5ff8940 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -345,7 +345,7 @@ repeat:
 		new_offset = offset_in_page(jh2bh(jh_in)->b_data);
 	}
 
-	mapped_data = kmap_atomic(new_page, KM_USER0);
+	mapped_data = kmap_atomic(new_page);
 	/*
 	 * Fire data frozen trigger if data already wasn't frozen.  Do this
 	 * before checking for escaping, as the trigger may modify the magic
@@ -364,7 +364,7 @@ repeat:
 		need_copy_out = 1;
 		do_escape = 1;
 	}
-	kunmap_atomic(mapped_data, KM_USER0);
+	kunmap_atomic(mapped_data);
 
 	/*
 	 * Do we need to do a data copy?
@@ -385,9 +385,9 @@ repeat:
 		}
 
 		jh_in->b_frozen_data = tmp;
-		mapped_data = kmap_atomic(new_page, KM_USER0);
+		mapped_data = kmap_atomic(new_page);
 		memcpy(tmp, mapped_data + new_offset, jh2bh(jh_in)->b_size);
-		kunmap_atomic(mapped_data, KM_USER0);
+		kunmap_atomic(mapped_data);
 
 		new_page = virt_to_page(tmp);
 		new_offset = offset_in_page(tmp);
@@ -406,9 +406,9 @@ repeat:
 	 * copying, we can finally do so.
 	 */
 	if (do_escape) {
-		mapped_data = kmap_atomic(new_page, KM_USER0);
+		mapped_data = kmap_atomic(new_page);
 		*((unsigned int *)(mapped_data + new_offset)) = 0;
-		kunmap_atomic(mapped_data, KM_USER0);
+		kunmap_atomic(mapped_data);
 	}
 
 	set_bh_page(new_bh, new_page, new_offset);
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 35ae096..e5aba56 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -783,12 +783,12 @@ done:
 			    "Possible IO failure.\n");
 		page = jh2bh(jh)->b_page;
 		offset = offset_in_page(jh2bh(jh)->b_data);
-		source = kmap_atomic(page, KM_USER0);
+		source = kmap_atomic(page);
 		/* Fire data frozen trigger just before we copy the data */
 		jbd2_buffer_frozen_trigger(jh, source + offset,
 					   jh->b_triggers);
 		memcpy(jh->b_frozen_data, source+offset, jh2bh(jh)->b_size);
-		kunmap_atomic(source, KM_USER0);
+		kunmap_atomic(source);
 
 		/*
 		 * Now that the frozen data is saved off, we need to store
-- 
1.7.7.6

