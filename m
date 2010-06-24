Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab0FXHKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 03:10:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:42377 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab0FXHKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 03:10:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=SKSIQlLY5kX+zCNJ2ISCuUlme7z46P3cmTlkgmlJeoerJ99VIZl3oeUZAZdziqbLzM
         IdHN5m/ZorF/3S3z3+tCcLg0jEf8wW9XCvDdFGZQ2Vhx38e3tcrk8+eHcJrEU5JbtfRs
         LtzLG5EQr7PqbrLq5RgNzYmoZiDU2Gk03UgjM=
From: =?UTF-8?q?Henri=20H=C3=A4kkinen?= <henuxd@gmail.com>
To: gregkh@suse.de, ossama.othman@intel.com, henuxd@gmail.com,
       alan@linux.intel.com, mattij.lammi@gmail.com, randy.dunlap@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging: memrar: Fixed memrar_handler.c
Date: Thu, 24 Jun 2010 10:09:46 +0300
Message-Id: <1277363386-4817-2-git-send-email-henuxd@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277363386-4817-1-git-send-email-henuxd@gmail.com>
References: <1277363386-4817-1-git-send-email-henuxd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed memrar_handler.c to use the new memrar_allocator API.  Removed
the corresponding issue from TODO.  Implemented locking in
memrar_allocator_largest_free_area().

Signed-off-by: Henri Häkkinen <henuxd@gmail.com
---
 drivers/staging/memrar/TODO               |   16 +---------------
 drivers/staging/memrar/memrar_allocator.c |   12 +++++++++---
 drivers/staging/memrar/memrar_handler.c   |   13 ++++---------
 3 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/memrar/TODO b/drivers/staging/memrar/TODO
index 0087447..9659aab 100644
--- a/drivers/staging/memrar/TODO
+++ b/drivers/staging/memrar/TODO
@@ -16,21 +16,7 @@ memrar_allocator.[ch]
 ---------------------
 1. Address potential fragmentation issues with the memrar_allocator.
 
-2. Hide struct memrar_allocator details/fields.  They need not be
-   exposed to the user.
-     a. Forward declare struct memrar_allocator.
-     b. Move all three struct definitions to `memrar_allocator.c'
-        source file.
-     c. Add a memrar_allocator_largest_free_area() function, or
-        something like that to get access to the value of the struct
-        memrar_allocator "largest_free_area" field.  This allows the
-        struct memrar_allocator fields to be completely hidden from
-        the user.  The memrar_handler code really only needs this for
-        statistic gathering on-demand.
-     d. Do the same for the "capacity" field as the
-        "largest_free_area" field.
-
-3. Move memrar_allocator.* to kernel `lib' directory since it is HW
+2. Move memrar_allocator.* to kernel `lib' directory since it is HW
    neutral.
      a. Alternatively, use lib/genalloc.c instead.
      b. A kernel port of Doug Lea's malloc() implementation may also
diff --git a/drivers/staging/memrar/memrar_allocator.c b/drivers/staging/memrar/memrar_allocator.c
index cb74e3c..924eab3 100644
--- a/drivers/staging/memrar/memrar_allocator.c
+++ b/drivers/staging/memrar/memrar_allocator.c
@@ -455,9 +455,15 @@ exit_memrar_free:
 
 size_t memrar_allocator_largest_free_area(struct memrar_allocator *allocator)
 {
-	if (allocator == NULL)
-		return 0;
-	return allocator->largest_free_area;
+	size_t tmp = 0;
+
+	if (allocator != NULL) {
+		mutex_lock(&allocator->lock);
+		tmp = allocator->largest_free_area;
+		mutex_unlock(&allocator->lock);
+	}
+
+	return tmp;
 }
 
 size_t memrar_allocator_capacity(struct memrar_allocator *allocator)
diff --git a/drivers/staging/memrar/memrar_handler.c b/drivers/staging/memrar/memrar_handler.c
index 22208cd..a652593 100644
--- a/drivers/staging/memrar/memrar_handler.c
+++ b/drivers/staging/memrar/memrar_handler.c
@@ -351,7 +351,8 @@ static int memrar_init_rar_resources(int rarnum, char const *devname)
 		devname, rarnum, (unsigned long) low, (unsigned long) high);
 
 	pr_info("%s: BRAR[%d] size = %zu KiB\n",
-			devname, rarnum, rar->allocator->capacity / 1024);
+			devname, rarnum,
+			memrar_allocator_capacity(rar->allocator) / 1024);
 
 	rar->allocated = 1;
 	return 0;
@@ -542,15 +543,9 @@ static long memrar_get_stat(struct RAR_stat *r)
 
 	BUG_ON(allocator == NULL);
 
-	/*
-	 * Allocator capacity doesn't change over time.  No
-	 * need to synchronize.
-	 */
-	r->capacity = allocator->capacity;
+	r->capacity = memrar_allocator_capacity(allocator);
+	r->largest_block_size = memrar_allocator_largest_free_area(allocator);
 
-	mutex_lock(&allocator->lock);
-	r->largest_block_size = allocator->largest_free_area;
-	mutex_unlock(&allocator->lock);
 	return 0;
 }
 
-- 
1.7.1

