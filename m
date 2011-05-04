Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab1EDDHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 23:07:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:2301 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab1EDDGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 23:06:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,312,1301900400"; 
   d="scan'208";a="430025897"
From: Chen Gong <gong.chen@linux.intel.com>
To: tony.luck@intel.com, ying.huang@intel.com
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH 1/3] fix one type of return value in pstore
Date: Wed,  4 May 2011 11:06:50 +0800
Message-Id: <1304478412-11843-2-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.5.185.g0b9dee
In-Reply-To: <1304478412-11843-1-git-send-email-gong.chen@linux.intel.com>
References: <1304478412-11843-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the return type of function _read_ in pstore is size_t,
but in the callback function of _read_, the logic doesn't
consider it too much, which means if negative value (assuming
error here) is returned, it will be converted to positive because
of type casting. ssize_t is enough for this function.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
---
 drivers/acpi/apei/erst.c |    4 ++--
 fs/pstore/platform.c     |    4 ++--
 include/linux/pstore.h   |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index d6cb0ff..d5a89d0 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -929,7 +929,7 @@ static int erst_check_table(struct acpi_table_erst *erst_tab)
 	return 0;
 }
 
-static size_t erst_reader(u64 *id, enum pstore_type_id *type,
+static ssize_t erst_reader(u64 *id, enum pstore_type_id *type,
 		       struct timespec *time);
 static u64 erst_writer(enum pstore_type_id type, size_t size);
 
@@ -957,7 +957,7 @@ struct cper_pstore_record {
 	char data[];
 } __packed;
 
-static size_t erst_reader(u64 *id, enum pstore_type_id *type,
+static ssize_t erst_reader(u64 *id, enum pstore_type_id *type,
 		       struct timespec *time)
 {
 	int rc;
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index f835a25..912403c 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -152,7 +152,7 @@ EXPORT_SYMBOL_GPL(pstore_register);
 void pstore_get_records(void)
 {
 	struct pstore_info *psi = psinfo;
-	size_t			size;
+	ssize_t			size;
 	u64			id;
 	enum pstore_type_id	type;
 	struct timespec		time;
@@ -163,7 +163,7 @@ void pstore_get_records(void)
 
 	mutex_lock(&psinfo->buf_mutex);
 	while ((size = psi->read(&id, &type, &time)) > 0) {
-		if (pstore_mkfile(type, psi->name, id, psi->buf, size,
+		if (pstore_mkfile(type, psi->name, id, psi->buf, (size_t)size,
 				  time, psi->erase))
 			failed++;
 	}
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 4197773..14ce2f5 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -35,7 +35,7 @@ struct pstore_info {
 	struct mutex	buf_mutex;	/* serialize access to 'buf' */
 	char		*buf;
 	size_t		bufsize;
-	size_t		(*read)(u64 *id, enum pstore_type_id *type,
+	ssize_t		(*read)(u64 *id, enum pstore_type_id *type,
 			struct timespec *time);
 	u64		(*write)(enum pstore_type_id type, size_t size);
 	int		(*erase)(u64 id);
-- 
1.7.5.185.g0b9dee

