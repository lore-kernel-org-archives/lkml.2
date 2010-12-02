Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab0LBCk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 21:40:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:41720 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133Ab0LBCky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 21:40:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,285,1288594800"; 
   d="scan'208";a="863381585"
Subject: [BUGFIX for 2.6.37] ACPI, APEI, use raw spinlock in ERST
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 10:40:53 +0800
Message-ID: <1291257653.12648.517.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERST writing may be used in NMI or Machine Check Exception handler. So
it need to use raw spinlock instead of normal spinlock.  This patch
fixes it.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/erst.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -86,7 +86,7 @@ static struct erst_erange {
  * It is used to provide exclusive accessing for ERST Error Log
  * Address Range too.
  */
-static DEFINE_SPINLOCK(erst_lock);
+static DEFINE_RAW_SPINLOCK(erst_lock);
 
 static inline int erst_errno(int command_status)
 {
@@ -421,9 +421,9 @@ ssize_t erst_get_record_count(void)
 	if (erst_disable)
 		return -ENODEV;
 
-	spin_lock_irqsave(&erst_lock, flags);
+	raw_spin_lock_irqsave(&erst_lock, flags);
 	count = __erst_get_record_count();
-	spin_unlock_irqrestore(&erst_lock, flags);
+	raw_spin_unlock_irqrestore(&erst_lock, flags);
 
 	return count;
 }
@@ -456,9 +456,9 @@ int erst_get_next_record_id(u64 *record_
 	if (erst_disable)
 		return -ENODEV;
 
-	spin_lock_irqsave(&erst_lock, flags);
+	raw_spin_lock_irqsave(&erst_lock, flags);
 	rc = __erst_get_next_record_id(record_id);
-	spin_unlock_irqrestore(&erst_lock, flags);
+	raw_spin_unlock_irqrestore(&erst_lock, flags);
 
 	return rc;
 }
@@ -624,17 +624,17 @@ int erst_write(const struct cper_record_
 		return -EINVAL;
 
 	if (erst_erange.attr & ERST_RANGE_NVRAM) {
-		if (!spin_trylock_irqsave(&erst_lock, flags))
+		if (!raw_spin_trylock_irqsave(&erst_lock, flags))
 			return -EBUSY;
 		rc = __erst_write_to_nvram(record);
-		spin_unlock_irqrestore(&erst_lock, flags);
+		raw_spin_unlock_irqrestore(&erst_lock, flags);
 		return rc;
 	}
 
 	if (record->record_length > erst_erange.size)
 		return -EINVAL;
 
-	if (!spin_trylock_irqsave(&erst_lock, flags))
+	if (!raw_spin_trylock_irqsave(&erst_lock, flags))
 		return -EBUSY;
 	memcpy(erst_erange.vaddr, record, record->record_length);
 	rcd_erange = erst_erange.vaddr;
@@ -642,7 +642,7 @@ int erst_write(const struct cper_record_
 	memcpy(&rcd_erange->persistence_information, "ER", 2);
 
 	rc = __erst_write_to_storage(0);
-	spin_unlock_irqrestore(&erst_lock, flags);
+	raw_spin_unlock_irqrestore(&erst_lock, flags);
 
 	return rc;
 }
@@ -696,9 +696,9 @@ ssize_t erst_read(u64 record_id, struct
 	if (erst_disable)
 		return -ENODEV;
 
-	spin_lock_irqsave(&erst_lock, flags);
+	raw_spin_lock_irqsave(&erst_lock, flags);
 	len = __erst_read(record_id, record, buflen);
-	spin_unlock_irqrestore(&erst_lock, flags);
+	raw_spin_unlock_irqrestore(&erst_lock, flags);
 	return len;
 }
 EXPORT_SYMBOL_GPL(erst_read);
@@ -719,20 +719,20 @@ ssize_t erst_read_next(struct cper_recor
 	if (erst_disable)
 		return -ENODEV;
 
-	spin_lock_irqsave(&erst_lock, flags);
+	raw_spin_lock_irqsave(&erst_lock, flags);
 	rc = __erst_get_next_record_id(&record_id);
 	if (rc) {
-		spin_unlock_irqrestore(&erst_lock, flags);
+		raw_spin_unlock_irqrestore(&erst_lock, flags);
 		return rc;
 	}
 	/* no more record */
 	if (record_id == APEI_ERST_INVALID_RECORD_ID) {
-		spin_unlock_irqrestore(&erst_lock, flags);
+		raw_spin_unlock_irqrestore(&erst_lock, flags);
 		return 0;
 	}
 
 	len = __erst_read(record_id, record, buflen);
-	spin_unlock_irqrestore(&erst_lock, flags);
+	raw_spin_unlock_irqrestore(&erst_lock, flags);
 
 	return len;
 }
@@ -746,12 +746,12 @@ int erst_clear(u64 record_id)
 	if (erst_disable)
 		return -ENODEV;
 
-	spin_lock_irqsave(&erst_lock, flags);
+	raw_spin_lock_irqsave(&erst_lock, flags);
 	if (erst_erange.attr & ERST_RANGE_NVRAM)
 		rc = __erst_clear_from_nvram(record_id);
 	else
 		rc = __erst_clear_from_storage(record_id);
-	spin_unlock_irqrestore(&erst_lock, flags);
+	raw_spin_unlock_irqrestore(&erst_lock, flags);
 
 	return rc;
 }


