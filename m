Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030251Ab2CPB7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 21:59:00 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:40566
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750750Ab2CPB66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 21:58:58 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3/3] Tools: hv: Support enumeration from all the pools
Date: Thu, 15 Mar 2012 17:48:45 -0700
Message-Id: <1331858925-827-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1331858925-827-1-git-send-email-kys@microsoft.com>
References: <1331858893-775-1-git-send-email-kys@microsoft.com>
 <1331858925-827-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have supported enumeration only from the AUTO pool. Now support
enumeration from all the available pools.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hv_kvp.c      |    7 ++-
 include/linux/hyperv.h   |    1 +
 tools/hv/hv_kvp_daemon.c |  124 +++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 122 insertions(+), 10 deletions(-)

diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index 3485dee..843bfa3 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -288,14 +288,15 @@ kvp_respond_to_host(char *key, char *value, int error)
 
 
 	/*
-	 * If the error parameter is set, terminate the host's enumeration.
+	 * If the error parameter is set, terminate the host's enumeration
+	 * on this pool.
 	 */
 	if (error) {
 		/*
 		 * Something failed or the we have timedout;
-		 * terminate the host-side iteration by returning an error.
+		 * terminate the current  host-side iteration.
 		 */
-		icmsghdrp->status = HV_E_FAIL;
+		icmsghdrp->status = HV_S_CONT;
 		goto response_done;
 	}
 
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index e88a979..5852545 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -952,6 +952,7 @@ void vmbus_driver_unregister(struct hv_driver *hv_driver);
 
 #define HV_S_OK				0x00000000
 #define HV_E_FAIL			0x80004005
+#define HV_S_CONT			0x80070103
 #define HV_ERROR_NOT_SUPPORTED		0x80070032
 #define HV_ERROR_MACHINE_LOCKED		0x800704F7
 
diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 2fb9c3d..146fd61 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -148,6 +148,51 @@ static void kvp_update_file(int pool)
 	kvp_release_lock(pool);
 }
 
+static void kvp_update_mem_state(int pool)
+{
+	FILE *filep;
+	size_t records_read = 0;
+	struct kvp_record *record = kvp_file_info[pool].records;
+	struct kvp_record *readp;
+	int num_blocks = kvp_file_info[pool].num_blocks;
+	int alloc_unit = sizeof(struct kvp_record) * ENTRIES_PER_BLOCK;
+
+	kvp_acquire_lock(pool);
+
+	filep = fopen(kvp_file_info[pool].fname, "r");
+	if (!filep) {
+		kvp_release_lock(pool);
+		syslog(LOG_ERR, "Failed to open file, pool: %d", pool);
+		exit(-1);
+	}
+	while (!feof(filep)) {
+		readp = &record[records_read];
+		records_read += fread(readp, sizeof(struct kvp_record),
+					ENTRIES_PER_BLOCK * num_blocks,
+					filep);
+
+		if (!feof(filep)) {
+			/*
+			 * We have more data to read.
+			 */
+			num_blocks++;
+			record = realloc(record, alloc_unit * num_blocks);
+
+			if (record == NULL) {
+				syslog(LOG_ERR, "malloc failed");
+				exit(-1);
+			}
+			continue;
+		}
+		break;
+	}
+
+	kvp_file_info[pool].num_blocks = num_blocks;
+	kvp_file_info[pool].records = record;
+	kvp_file_info[pool].num_records = records_read;
+
+	kvp_release_lock(pool);
+}
 static int kvp_file_init(void)
 {
 	int ret, fd;
@@ -223,8 +268,16 @@ static int kvp_key_delete(int pool, __u8 *key, int key_size)
 {
 	int i;
 	int j, k;
-	int num_records = kvp_file_info[pool].num_records;
-	struct kvp_record *record = kvp_file_info[pool].records;
+	int num_records;
+	struct kvp_record *record;
+
+	/*
+	 * First update the in-memory state.
+	 */
+	kvp_update_mem_state(pool);
+
+	num_records = kvp_file_info[pool].num_records;
+	record = kvp_file_info[pool].records;
 
 	for (i = 0; i < num_records; i++) {
 		if (memcmp(key, record[i].key, key_size))
@@ -259,14 +312,23 @@ static int kvp_key_add_or_modify(int pool, __u8 *key, int key_size, __u8 *value,
 {
 	int i;
 	int j, k;
-	int num_records = kvp_file_info[pool].num_records;
-	struct kvp_record *record = kvp_file_info[pool].records;
-	int num_blocks = kvp_file_info[pool].num_blocks;
+	int num_records;
+	struct kvp_record *record;
+	int num_blocks;
 
 	if ((key_size > HV_KVP_EXCHANGE_MAX_KEY_SIZE) ||
 		(value_size > HV_KVP_EXCHANGE_MAX_VALUE_SIZE))
 		return 1;
 
+	/*
+	 * First update the in-memory state.
+	 */
+	kvp_update_mem_state(pool);
+
+	num_records = kvp_file_info[pool].num_records;
+	record = kvp_file_info[pool].records;
+	num_blocks = kvp_file_info[pool].num_blocks;
+
 	for (i = 0; i < num_records; i++) {
 		if (memcmp(key, record[i].key, key_size))
 			continue;
@@ -304,13 +366,21 @@ static int kvp_get_value(int pool, __u8 *key, int key_size, __u8 *value,
 			int value_size)
 {
 	int i;
-	int num_records = kvp_file_info[pool].num_records;
-	struct kvp_record *record = kvp_file_info[pool].records;
+	int num_records;
+	struct kvp_record *record;
 
 	if ((key_size > HV_KVP_EXCHANGE_MAX_KEY_SIZE) ||
 		(value_size > HV_KVP_EXCHANGE_MAX_VALUE_SIZE))
 		return 1;
 
+	/*
+	 * First update the in-memory state.
+	 */
+	kvp_update_mem_state(pool);
+
+	num_records = kvp_file_info[pool].num_records;
+	record = kvp_file_info[pool].records;
+
 	for (i = 0; i < num_records; i++) {
 		if (memcmp(key, record[i].key, key_size))
 			continue;
@@ -324,6 +394,31 @@ static int kvp_get_value(int pool, __u8 *key, int key_size, __u8 *value,
 	return 1;
 }
 
+static void kvp_pool_enumerate(int pool, int index, __u8 *key, int key_size,
+				__u8 *value, int value_size)
+{
+	struct kvp_record *record;
+
+	/*
+	 * First update our in-memory database.
+	 */
+	kvp_update_mem_state(pool);
+	record = kvp_file_info[pool].records;
+
+	if (index >= kvp_file_info[pool].num_records) {
+		/*
+		 * This is an invalid index; terminate enumeration;
+		 * - a NULL value will do the trick.
+		 */
+		strcpy(value, "");
+		return;
+	}
+
+	memcpy(key, record[index].key, key_size);
+	memcpy(value, record[index].value, value_size);
+}
+
+
 void kvp_get_os_info(void)
 {
 	FILE	*file;
@@ -678,6 +773,21 @@ int main(void)
 		if (hv_msg->kvp_hdr.operation != KVP_OP_ENUMERATE)
 			goto kvp_done;
 
+		/*
+		 * If the pool is KVP_POOL_AUTO, dynamically generate
+		 * both the key and the value; if not read from the
+		 * appropriate pool.
+		 */
+		if (hv_msg->kvp_hdr.pool != KVP_POOL_AUTO) {
+			kvp_pool_enumerate(hv_msg->kvp_hdr.pool,
+					hv_msg->body.kvp_enum_data.index,
+					hv_msg->body.kvp_enum_data.data.key,
+					HV_KVP_EXCHANGE_MAX_KEY_SIZE,
+					hv_msg->body.kvp_enum_data.data.value,
+					HV_KVP_EXCHANGE_MAX_VALUE_SIZE);
+			goto kvp_done;
+		}
+
 		hv_msg = (struct hv_kvp_msg *)incoming_cn_msg->data;
 		key_name = (char *)hv_msg->body.kvp_enum_data.data.key;
 		key_value = (char *)hv_msg->body.kvp_enum_data.data.value;
-- 
1.7.4.1

