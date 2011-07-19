Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab1GSS2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 14:28:50 -0400
Received: from usindmx02.hds.com ([207.126.252.13]:53913 "EHLO
	usindmx02.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab1GSS2s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 14:28:48 -0400
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
Date: Tue, 19 Jul 2011 14:27:36 -0400
Subject: [RFC][PATCH -mmotm 4/4] pstore: ramoops support
Thread-Topic: [RFC][PATCH -mmotm 4/4] pstore: ramoops support
Thread-Index: AcxGQPNfkgYolSqJQyKgeplzzN4MfQAAHXcQ
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C199C64C9@USINDEVS01.corp.hds.com>
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

Pstore can support ramoops with this patch.

 drivers/char/Kconfig
 - Add "depends on PSTORE" to CONFIG_RAMOOPS

 drivers/char/ramoops.c
 - Add pstore_info structure so that ramoops can call pstore_register()
 - Remove kmsg_dump_unregister because pstore doesn't support unregister operation
 - Remove do_gettimeofday() from kexec/panic path for avoiding dead lock due to logbuf_lock of WARN_ON() in getnstimeofday().

 kernel/time/timekeeping.c
 - introduce get_useconds() which get "xtime.nsec / 1000" without taking lock 

TODO:
  - I couldn't find any Documentation about ramoops.
    Please let me know how to test my patch.

  - I haven't implemented reader/eraser callbacks supported by pstore.

  - If ramoops users would like to unload module,
    pstore needs to support unregister operation.

 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 drivers/char/Kconfig      |    1 +
 drivers/char/ramoops.c    |  114 ++++++++++++++++++++++++++++++---------------
 include/linux/time.h      |    1 +
 kernel/time/timekeeping.c |    6 ++
 4 files changed, 85 insertions(+), 37 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 423fd56..c805d1e 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -603,6 +603,7 @@ source "drivers/s390/char/Kconfig"
 config RAMOOPS
 	tristate "Log panic/oops to a RAM buffer"
 	depends on HAS_IOMEM
+	depends on PSTORE
 	default n
 	help
 	  This enables panic and oops messages to be logged to a circular
diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index 8092c31..41c82e3 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -24,6 +24,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/kmsg_dump.h>
+#include <linux/pstore.h>
 #include <linux/time.h>
 #include <linux/io.h>
 #include <linux/ioport.h>
@@ -34,6 +35,7 @@
 #include <linux/debugfs.h>
 
 #define RAMOOPS_KERNMSG_HDR "===="
+#define RAMOOPS_HDR_SIZE 44 /* 4 (RAMOOPS_KERN_MSG_HDR)  + 40 (timestamp) */
 #define MIN_MEM_SIZE 4096UL
 #define RAMOOPS_DIR "ramoops"
 #define RAMOOPS_NEXT "next"
@@ -58,6 +60,43 @@ module_param(dump_oops, int, 0600);
 MODULE_PARM_DESC(dump_oops,
 		"set to 1 to dump oopses, 0 to only dump panics (default 1)");
 
+static unsigned long total_size;
+static int ramoops_open(struct pstore_info *psi);
+static int ramoops_close(struct pstore_info *psi);
+static ssize_t ramoops_reader(u64 *id, enum pstore_type_id *type,
+			      struct timespec *time);
+static u64 ramoops_dumper(enum pstore_type_id type, size_t size,
+			  enum kmsg_dump_reason reason);
+static int ramoops_eraser(u64 record_id);
+
+static struct pstore_info ramoops_info = {
+	.owner		= THIS_MODULE,
+	.name		= "ramoops",
+	.open		= ramoops_open,
+	.close		= ramoops_close,
+	.read		= ramoops_reader,
+	.write		= ramoops_dumper,
+	.erase		= ramoops_eraser
+};
+
+static int ramoops_open(struct pstore_info *psi)
+{
+	return 0;
+}
+
+static int ramoops_close(struct pstore_info *psi)
+{
+	return 0;
+}
+
+static ssize_t ramoops_reader(u64 *id, enum pstore_type_id *type,
+			      struct timespec *time)
+{
+	return -EINVAL;
+}
+
+
+
 static struct ramoops_context {
 	struct kmsg_dumper dump;
 	void *virt_addr;
@@ -141,49 +180,51 @@ static const struct file_operations ramoops_next_fops = {
 	.read = ramoops_read_next,
 };
 
-static void ramoops_do_dump(struct kmsg_dumper *dumper,
-		enum kmsg_dump_reason reason, const char *s1, unsigned long l1,
-		const char *s2, unsigned long l2)
+static u64 ramoops_dumper(enum pstore_type_id type, size_t size,
+			  enum kmsg_dump_reason reason)
 {
-	struct ramoops_context *cxt = container_of(dumper,
-			struct ramoops_context, dump);
-	unsigned long s1_start, s2_start;
-	unsigned long l1_cpy, l2_cpy;
-	int res, hdr_size;
-	char *buf, *buf_orig;
+	char *buf;
 	struct timeval timestamp;
+	struct ramoops_context *cxt = &oops_cxt;
 
 	if (reason != KMSG_DUMP_OOPS &&
-	    reason != KMSG_DUMP_PANIC)
-		return;
+	    reason != KMSG_DUMP_PANIC &&
+	    reason != KMSG_DUMP_KEXEC)
+		return 0;
 
 	/* Only dump oopses if dump_oops is set */
 	if (reason == KMSG_DUMP_OOPS && !cxt->dump_oops)
-		return;
+		return 0;
 
-	mutex_lock(&ramoops_mutex);
-	buf = cxt->virt_addr + (cxt->count * cxt->record_size);
-	buf_orig = buf;
+	if (total_size >= record_size)
+		return 0;
 
-	memset(buf, '\0', cxt->record_size);
-	res = sprintf(buf, "%s", RAMOOPS_KERNMSG_HDR);
-	buf += res;
-	do_gettimeofday(&timestamp);
-	res = sprintf(buf, "%lu.%lu\n", (long)timestamp.tv_sec, (long)timestamp.tv_usec);
-	buf += res;
+	if (reason == KMSG_DUMP_OOPS) {
+		mutex_lock(&ramoops_mutex);
+		do_gettimeofday(&timestamp);
+	} else {
+		timestamp.tv_sec = get_seconds();
+		timestamp.tv_usec = get_useconds();
+	}
 
-	hdr_size = buf - buf_orig;
-	l2_cpy = min(l2, cxt->record_size - hdr_size);
-	l1_cpy = min(l1, cxt->record_size - hdr_size - l2_cpy);
+	buf = cxt->virt_addr + (cxt->count * record_size);
+	snprintf(buf, RAMOOPS_HDR_SIZE, "%s%lu.%lu\n",
+		 RAMOOPS_KERNMSG_HDR, (long)timestamp.tv_sec,
+		 (long)timestamp.tv_usec);
+	ramoops_info.buf += record_size;
+	total_size = total_size + size + RAMOOPS_HDR_SIZE;
 
-	s2_start = l2 - l2_cpy;
-	s1_start = l1 - l1_cpy;
+	cxt->count = (cxt->count + 1) % cxt->max_count;
 
-	memcpy(buf, s1 + s1_start, l1_cpy);
-	memcpy(buf + l1_cpy, s2 + s2_start, l2_cpy);
+	if (reason == KMSG_DUMP_OOPS)
+		mutex_unlock(&ramoops_mutex);
 
-	cxt->count = (cxt->count + 1) % cxt->max_count;
-	mutex_unlock(&ramoops_mutex);
+	return 0;
+}
+
+static int ramoops_eraser(u64 record_id)
+{
+	return 0;
 }
 
 static int __init ramoops_probe(struct platform_device *pdev)
@@ -233,11 +274,13 @@ static int __init ramoops_probe(struct platform_device *pdev)
 		pr_err("ioremap failed\n");
 		goto fail2;
 	}
+	memset(cxt->virt_addr, '\0', cxt->size);
 
-	cxt->dump.dump = ramoops_do_dump;
-	err = kmsg_dump_register(&cxt->dump);
-	if (err) {
-		pr_err("registering kmsg dumper failed\n");
+	mutex_init(&ramoops_info.buf_mutex);
+	ramoops_info.buf = cxt->virt_addr + RAMOOPS_HDR_SIZE;
+	ramoops_info.bufsize = record_size - RAMOOPS_HDR_SIZE;
+	if (pstore_register(&ramoops_info)) {
+		printk(KERN_ERR "Could not register with persistent store\n");
 		goto fail1;
 	}
 
@@ -284,9 +327,6 @@ static int __exit ramoops_remove(struct platform_device *pdev)
 {
 	struct ramoops_context *cxt = &oops_cxt;
 
-	if (kmsg_dump_unregister(&cxt->dump) < 0)
-		pr_warn("could not unregister kmsg_dumper\n");
-
 	iounmap(cxt->virt_addr);
 	release_mem_region(cxt->phys_addr, cxt->size);
 	return 0;
diff --git a/include/linux/time.h b/include/linux/time.h
index b306178..cff6bb5 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -121,6 +121,7 @@ void timekeeping_init(void);
 extern int timekeeping_suspended;
 
 unsigned long get_seconds(void);
+unsigned long get_useconds(void);
 struct timespec current_kernel_time(void);
 struct timespec __current_kernel_time(void); /* does not take xtime_lock */
 struct timespec get_monotonic_coarse(void);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 342408c..1927edc 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1029,6 +1029,12 @@ unsigned long get_seconds(void)
 }
 EXPORT_SYMBOL(get_seconds);
 
+unsigned long get_useconds(void)
+{
+	return xtime.tv_sec / 1000;
+}
+EXPORT_SYMBOL(get_useconds);
+
 struct timespec __current_kernel_time(void)
 {
 	return xtime;
-- 
1.7.1

