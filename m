Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab1GSSZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 14:25:43 -0400
Received: from usindmx04.hds.com ([207.126.252.15]:38150 "EHLO
	usindmx04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab1GSSZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 14:25:41 -0400
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
Date: Tue, 19 Jul 2011 14:24:27 -0400
Subject: [RFC][PATCH -mmotm 1/4] Add static function calls of pstore to
 kexec path
Thread-Topic: [RFC][PATCH -mmotm 1/4] Add static function calls of pstore to
 kexec path
Thread-Index: AcxGQPNfkgYolSqJQyKgeplzzN4MfQAAARgw
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C199C64C3@USINDEVS01.corp.hds.com>
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

This patch adds static function calls so that both pstore and APEI storage backend can work reliably in kexec path.


 kernel/kexec.c
   - Add pstore_kmsg_dump_in_interrupt(KMSG_DUMP_KEXEC) just after machine_crash_shutdown() so that pstore can
     work with one cpu.

 kernel/printk.c
   - Introduce get_logbuf_nolock() so that pstore can get values of logbuf without taking lock.

 fs/pstore/platform.c
   - Introduce pstore_kmsg_dump_in_interrupt() so that pstore/APEI storage backend can output kernel messages without taking lock.
   pstore_dump()
   - Add error checks below because pstore_dump() is called from kmsg_dump(KMSG_DUMP_KEXEC) directly.
       - Skip if no driver is registered
       - Skip if there is a driver calling pstore_register()/pstore_unregister()
   - Remove mutex_lock from kexec path

TODO:
  APEI storage backend will work with this patch.
  However, I don't have any access to servers capable of APEI storage backend.
  Please help to test my patch.

 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 fs/pstore/platform.c      |   27 +++++++++++++++++++++++++--
 include/linux/kmsg_dump.h |    1 +
 include/linux/pstore.h    |    9 +++++++++
 kernel/kexec.c            |    3 +++
 kernel/printk.c           |   29 +++++++++++++++++++++++++++++
 5 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index f2c3ff2..85e0a9c 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -74,7 +74,17 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 	else
 		why = "Unknown";
 
-	mutex_lock(&psinfo->buf_mutex);
+	switch (reason) {
+	case KMSG_DUMP_KEXEC:
+		/* Skip if there is no driver or there is a driver calling
+		   pstore_register() */
+		if (!psinfo || !spin_trylock(&pstore_lock))
+			return;
+		break;
+	default:
+		mutex_lock(&psinfo->buf_mutex);
+	}
+
 	oopscount++;
 	while (total < kmsg_bytes) {
 		dst = psinfo->buf;
@@ -103,7 +113,20 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		l2 -= l2_cpy;
 		total += l1_cpy + l2_cpy;
 	}
-	mutex_unlock(&psinfo->buf_mutex);
+
+	if (reason != KMSG_DUMP_KEXEC)
+		mutex_unlock(&psinfo->buf_mutex);
+}
+
+void pstore_kmsg_dump_in_interrupt(enum kmsg_dump_reason reason)
+{
+	const char *s1, *s2;
+	unsigned long l1, l2;
+
+	/* get logbuf values without spin_lock for avoiding dead lock */
+	get_logbuf_nolock(&s1, &l1, &s2, &l2);
+
+	pstore_dump(NULL, reason, s1, l1, s2, l2);
 }
 
 static struct kmsg_dumper pstore_dumper = {
diff --git a/include/linux/kmsg_dump.h b/include/linux/kmsg_dump.h
index fee6631..ee0c952 100644
--- a/include/linux/kmsg_dump.h
+++ b/include/linux/kmsg_dump.h
@@ -18,6 +18,7 @@
 enum kmsg_dump_reason {
 	KMSG_DUMP_OOPS,
 	KMSG_DUMP_PANIC,
+	KMSG_DUMP_KEXEC,
 	KMSG_DUMP_RESTART,
 	KMSG_DUMP_HALT,
 	KMSG_DUMP_POWEROFF,
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 2455ef2..5cf008d 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -22,6 +22,8 @@
 #ifndef _LINUX_PSTORE_H
 #define _LINUX_PSTORE_H
 
+#include<linux/kmsg_dump.h>
+
 /* types */
 enum pstore_type_id {
 	PSTORE_TYPE_DMESG	= 0,
@@ -46,6 +48,9 @@ struct pstore_info {
 #ifdef CONFIG_PSTORE
 extern int pstore_register(struct pstore_info *);
 extern int pstore_write(enum pstore_type_id type, char *buf, size_t size);
+extern void pstore_kmsg_dump_in_interrupt(enum kmsg_dump_reason reason);
+extern void get_logbuf_nolock(const char **s1, unsigned long *l1,
+			      const char **s2, unsigned long *l2);
 #else
 static inline int
 pstore_register(struct pstore_info *psi)
@@ -57,6 +62,10 @@ pstore_write(enum pstore_type_id type, char *buf, size_t size)
 {
 	return -ENODEV;
 }
+static inline void
+pstore_kmsg_dump_in_interrupt(enum kmsg_dump_reason reason)
+{
+}
 #endif
 
 #endif /*_LINUX_PSTORE_H*/
diff --git a/kernel/kexec.c b/kernel/kexec.c
index e24bc1b..8e2761a 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -33,6 +33,8 @@
 #include <linux/vmalloc.h>
 #include <linux/swap.h>
 #include <linux/syscore_ops.h>
+#include <linux/kmsg_dump.h>
+#include <linux/pstore.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -1081,6 +1083,7 @@ void crash_kexec(struct pt_regs *regs)
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
+			pstore_kmsg_dump_in_interrupt(KMSG_DUMP_KEXEC);
 			machine_kexec(kexec_crash_image);
 		}
 		mutex_unlock(&kexec_mutex);
diff --git a/kernel/printk.c b/kernel/printk.c
index 37dff34..966a7d9 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1710,6 +1710,35 @@ int kmsg_dump_unregister(struct kmsg_dumper *dumper)
 }
 EXPORT_SYMBOL_GPL(kmsg_dump_unregister);
 
+
+void get_logbuf_nolock(const char **s1, unsigned long *l1, const char **s2,
+		       unsigned long *l2)
+{
+	unsigned long end;
+	unsigned chars;
+
+	/* Theoretically, the log could move on after we do this, but
+	   there's not a lot we can do about that. The new messages
+	   will overwrite the start of what we dump. */
+	end = log_end & LOG_BUF_MASK;
+	chars = logged_chars;
+
+	if (chars > end) {
+		*s1 = log_buf + log_buf_len - chars + end;
+		*l1 = chars - end;
+
+		*s2 = log_buf;
+		*l2 = end;
+	} else {
+		*s1 = "";
+		*l1 = 0;
+
+		*s2 = log_buf + end - chars;
+		*l2 = chars;
+	}
+
+}
+
 /**
  * kmsg_dump - dump kernel log to kernel message dumpers.
  * @reason: the reason (oops, panic etc) for dumping
-- 
1.7.1
