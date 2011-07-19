Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab1GSS1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 14:27:41 -0400
Received: from usindmx02.hds.com ([207.126.252.13]:53256 "EHLO
	usindmx02.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab1GSS1k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 14:27:40 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        Matthew Garrett <mjg@redhat.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jarod Wilson <jwilson@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Tue, 19 Jul 2011 14:26:34 -0400
Subject: [RFC][PATCH -mmotm 3/4] pstore: mtdoops support
Thread-Topic: [RFC][PATCH -mmotm 3/4] pstore: mtdoops support
Thread-Index: AcxGQPNfkgYolSqJQyKgeplzzN4MfQAAFV1g
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C199C64C8@USINDEVS01.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Pstore can support mtdoops with this patch.

fs/pstore/platform.c
 - Add "reason" argument to pstore_dump() so that mtdoops can select its behaivor in accordance with each reason

 drivers/mtd/Kconfig
 - Add "depends on PSTORE" to CONFIG_MTD_OOPS

 drivers/mtd/mtdoops.c
 - Add pstore_info structure so that mtdoops can call pstore_register()
 - Remove kmsg_dump_unregister because pstore doesn't support unregister operation
 - Change printk() to DEBUG() in kexec path for avoiding dead lock due to logbuf_lock

 drivers/acpi/apei/erst.c
 - Add "reason" argument to erst_write()

TODO:
  - I don't have any access to machine capable of Memory Technology Device.
    Please help to test my patch.

  - I haven't implemented reader/eraser callbacks supported by pstore.
  - If mtdoops users would like to unload module,
    pstore needs to support unregister operation.

 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 drivers/acpi/apei/erst.c |    6 ++-
 drivers/mtd/Kconfig      |    1 +
 drivers/mtd/mtdoops.c    |   95 +++++++++++++++++++++++++++++++--------------
 fs/pstore/platform.c     |    5 +-
 include/linux/pstore.h   |    3 +-
 5 files changed, 75 insertions(+), 35 deletions(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index e6cef8e..ee936b6 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -933,7 +933,8 @@ static int erst_open_pstore(struct pstore_info *psi);
 static int erst_close_pstore(struct pstore_info *psi);
 static ssize_t erst_reader(u64 *id, enum pstore_type_id *type,
 		       struct timespec *time);
-static u64 erst_writer(enum pstore_type_id type, size_t size);
+static u64 erst_writer(enum pstore_type_id type, size_t size,
+		       enum kmsg_dump_reason reason);
 
 static struct pstore_info erst_info = {
 	.owner		= THIS_MODULE,
@@ -1037,7 +1038,8 @@ out:
 	return (rc < 0) ? rc : (len - sizeof(*rcd));
 }
 
-static u64 erst_writer(enum pstore_type_id type, size_t size)
+static u64 erst_writer(enum pstore_type_id type, size_t size,
+		       enum kmsg_dump_reason reason)
 {
 	struct cper_pstore_record *rcd = (struct cper_pstore_record *)
 					(erst_info.buf - sizeof(*rcd));
diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index cc02e21..63a6e04 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -301,6 +301,7 @@ config SM_FTL
 
 config MTD_OOPS
 	tristate "Log panic/oops to an MTD buffer"
+	depends on PSTORE
 	help
 	  This enables panic and oops messages to be logged to a circular
 	  buffer in a flash partition where it can be read back at some
diff --git a/drivers/mtd/mtdoops.c b/drivers/mtd/mtdoops.c
index 56eac4e..61b1120 100644
--- a/drivers/mtd/mtdoops.c
+++ b/drivers/mtd/mtdoops.c
@@ -32,6 +32,7 @@
 #include <linux/interrupt.h>
 #include <linux/mtd/mtd.h>
 #include <linux/kmsg_dump.h>
+#include <linux/pstore.h>
 
 /* Maximum MTD partition size */
 #define MTDOOPS_MAX_MTD_SIZE (8 * 1024 * 1024)
@@ -54,6 +55,25 @@ module_param(dump_oops, int, 0600);
 MODULE_PARM_DESC(dump_oops,
 		"set to 1 to dump oopses, 0 to only dump panics (default 1)");
 
+static unsigned long total_size;
+static int mtdoops_open(struct pstore_info *psi);
+static int mtdoops_close(struct pstore_info *psi);
+static ssize_t mtdoops_reader(u64 *id, enum pstore_type_id *type,
+			       struct timespec *time);
+static u64 mtdoops_dumper(enum pstore_type_id type, size_t size,
+			  enum kmsg_dump_reason reason);
+static int mtdoops_eraser(u64 record_id);
+
+static struct pstore_info mtdoops_info = {
+	.owner          = THIS_MODULE,
+	.name           = "mtdoops",
+	.open           = mtdoops_open,
+	.close          = mtdoops_close,
+	.read           = mtdoops_reader,
+	.write          = mtdoops_dumper,
+	.erase          = mtdoops_eraser
+};
+
 static struct mtdoops_context {
 	struct kmsg_dumper dump;
 
@@ -229,8 +249,9 @@ static void mtdoops_write(struct mtdoops_context *cxt, int panic)
 					record_size, &retlen, cxt->oops_buf);
 
 	if (retlen != record_size || ret < 0)
-		printk(KERN_ERR "mtdoops: write failure at %ld (%td of %ld written), error %d\n",
-		       cxt->nextpage * record_size, retlen, record_size, ret);
+		DEBUG(MTD_DEBUG_LEVEL3, "mtdoops: write failure at %ld (%td of "
+		      "%ld written), error %d\n", cxt->nextpage * record_size,
+		      retlen, record_size, ret);
 	mark_page_used(cxt, cxt->nextpage);
 	memset(cxt->oops_buf, 0xff, record_size);
 
@@ -297,47 +318,62 @@ static void find_next_position(struct mtdoops_context *cxt)
 	mtdoops_inc_counter(cxt);
 }
 
-static void mtdoops_do_dump(struct kmsg_dumper *dumper,
-		enum kmsg_dump_reason reason, const char *s1, unsigned long l1,
-		const char *s2, unsigned long l2)
+static int mtdoops_open(struct pstore_info *psi)
+{
+	return 0;
+}
+
+static int mtdoops_close(struct pstore_info *psi)
+{
+	return 0;
+}
+
+static ssize_t mtdoops_reader(u64 *id, enum pstore_type_id *type,
+			     struct timespec *time)
 {
-	struct mtdoops_context *cxt = container_of(dumper,
-			struct mtdoops_context, dump);
-	unsigned long s1_start, s2_start;
-	unsigned long l1_cpy, l2_cpy;
-	char *dst;
+	return -EINVAL;
+}
+
+static u64 mtdoops_dumper(enum pstore_type_id type, size_t size,
+			  enum kmsg_dump_reason reason)
+{
+	struct mtdoops_context *cxt = &oops_cxt;
 
 	if (reason != KMSG_DUMP_OOPS &&
-	    reason != KMSG_DUMP_PANIC)
-		return;
+	    reason != KMSG_DUMP_PANIC &&
+	    reason != KMSG_DUMP_KEXEC)
+		return 0;
 
 	/* Only dump oopses if dump_oops is set */
 	if (reason == KMSG_DUMP_OOPS && !dump_oops)
-		return;
-
-	dst = cxt->oops_buf + MTDOOPS_HEADER_SIZE; /* Skip the header */
-	l2_cpy = min(l2, record_size - MTDOOPS_HEADER_SIZE);
-	l1_cpy = min(l1, record_size - MTDOOPS_HEADER_SIZE - l2_cpy);
-
-	s2_start = l2 - l2_cpy;
-	s1_start = l1 - l1_cpy;
+		return 0;
 
-	memcpy(dst, s1 + s1_start, l1_cpy);
-	memcpy(dst + l1_cpy, s2 + s2_start, l2_cpy);
+	if (total_size >= record_size)
+		return 0;
 
 	/* Panics must be written immediately */
 	if (reason != KMSG_DUMP_OOPS) {
 		if (!cxt->mtd->panic_write)
-			printk(KERN_ERR "mtdoops: Cannot write from panic without panic_write\n");
-		else
+			DEBUG(MTD_DEBUG_LEVEL3, "mtdoops: Cannot write from "
+			      "panic without panic_write\n");
+		else {
 			mtdoops_write(cxt, 1);
-		return;
+			total_size = total_size + size + MTDOOPS_HEADER_SIZE;
+		}
+		return 0;
 	}
 
 	/* For other cases, schedule work to write it "nicely" */
 	schedule_work(&cxt->work_write);
+	return 0;
 }
 
+static int mtdoops_eraser(u64 record_id)
+{
+	return 0;
+}
+
+
 static void mtdoops_notify_add(struct mtd_info *mtd)
 {
 	struct mtdoops_context *cxt = &oops_cxt;
@@ -374,8 +410,10 @@ static void mtdoops_notify_add(struct mtd_info *mtd)
 		return;
 	}
 
-	cxt->dump.dump = mtdoops_do_dump;
-	err = kmsg_dump_register(&cxt->dump);
+	mutex_init(&mtdoops_info.buf_mutex);
+	mtdoops_info.buf = cxt->oops_buf + MTDOOPS_HEADER_SIZE;
+	mtdoops_info.bufsize = record_size - MTDOOPS_HEADER_SIZE;
+	err = pstore_register(&mtdoops_info);
 	if (err) {
 		printk(KERN_ERR "mtdoops: registering kmsg dumper failed, error %d\n", err);
 		vfree(cxt->oops_page_used);
@@ -396,9 +434,6 @@ static void mtdoops_notify_remove(struct mtd_info *mtd)
 	if (mtd->index != cxt->mtd_index || cxt->mtd_index < 0)
 		return;
 
-	if (kmsg_dump_unregister(&cxt->dump) < 0)
-		printk(KERN_WARNING "mtdoops: could not unregister kmsg_dumper\n");
-
 	cxt->mtd = NULL;
 	flush_work_sync(&cxt->work_erase);
 	flush_work_sync(&cxt->work_write);
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 061911c..cd42b4e 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -105,7 +105,8 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		memcpy(dst, s1 + s1_start, l1_cpy);
 		memcpy(dst + l1_cpy, s2 + s2_start, l2_cpy);
 
-		id = psinfo->write(PSTORE_TYPE_DMESG, hsize + l1_cpy + l2_cpy);
+		id = psinfo->write(PSTORE_TYPE_DMESG, hsize + l1_cpy + l2_cpy,
+				   reason);
 		if (reason == KMSG_DUMP_OOPS && pstore_is_mounted())
 			pstore_mkfile(PSTORE_TYPE_DMESG, psinfo->name, id,
 				      psinfo->buf, hsize + l1_cpy + l2_cpy,
@@ -220,7 +221,7 @@ int pstore_write(enum pstore_type_id type, char *buf, size_t size)
 
 	mutex_lock(&psinfo->buf_mutex);
 	memcpy(psinfo->buf, buf, size);
-	id = psinfo->write(type, size);
+	id = psinfo->write(type, size, 0);
 	if (pstore_is_mounted())
 		pstore_mkfile(PSTORE_TYPE_DMESG, psinfo->name, id, psinfo->buf,
 			      size, CURRENT_TIME, psinfo->erase);
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 5cf008d..47b974f 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -41,7 +41,8 @@ struct pstore_info {
 	int		(*close)(struct pstore_info *psi);
 	ssize_t		(*read)(u64 *id, enum pstore_type_id *type,
 			struct timespec *time);
-	u64		(*write)(enum pstore_type_id type, size_t size);
+	u64		(*write)(enum pstore_type_id type, size_t size,
+				 enum kmsg_dump_reason reason);
 	int		(*erase)(u64 id);
 };
 
-- 
1.7.1

