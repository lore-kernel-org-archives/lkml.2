Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab1GTU4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 16:56:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab1GTU4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 16:56:40 -0400
From: Don Zickus <dzickus@redhat.com>
To: tony.luck@intel.com
Cc: LKML <linux-kernel@vger.kernel.org>, ying.huang@intel.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH] pstore: change mutex locking to spin_locks
Date: Wed, 20 Jul 2011 16:56:26 -0400
Message-Id: <1311195386-22743-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pstore was using mutex locking to protect read/write access to the
backend plug-ins.  This causes problems when pstore is executed in
an NMI context through panic() -> kmsg_dump().

This patch changes the mutex to a spin_lock_irqsave then also checks to
see if we are in an NMI context.  If we are in an NMI and can't get the
lock, just print a message stating that and blow by the locking.

All this is probably a hack around the bigger locking problem but it
solves my current situation of trying to sleep in an NMI context.

Tested by loading the lkdtm module and executing a HARDLOCKUP which
will cause the machine to panic inside the nmi handler.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 drivers/acpi/apei/erst.c |    2 +-
 fs/pstore/platform.c     |   28 ++++++++++++++++++++++------
 include/linux/pstore.h   |    2 +-
 3 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index e6cef8e..3d9c2a3 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -1155,7 +1155,7 @@ static int __init erst_init(void)
 		goto err_release_erange;
 
 	buf = kmalloc(erst_erange.size, GFP_KERNEL);
-	mutex_init(&erst_info.buf_mutex);
+	spin_lock_init(&erst_info.buf_lock);
 	if (buf) {
 		erst_info.buf = buf + sizeof(struct cper_pstore_record);
 		erst_info.bufsize = erst_erange.size -
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index f2c3ff2..53ba00b 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -27,6 +27,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/hardirq.h>
 
 #include "internal.h"
 
@@ -68,13 +69,21 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 	char		*dst, *why;
 	u64		id;
 	int		hsize, part = 1;
+	unsigned long	flags = 0;
+	int 		is_locked = 0;
 
 	if (reason < ARRAY_SIZE(reason_str))
 		why = reason_str[reason];
 	else
 		why = "Unknown";
 
-	mutex_lock(&psinfo->buf_mutex);
+	if (in_nmi()) {
+		is_locked = spin_trylock(&psinfo->buf_lock);
+		if (!is_locked)
+			pr_err("pstore dump routine blocked in NMI, may corrupt error record\n");
+	} else {
+		spin_lock_irqsave(&psinfo->buf_lock, flags);
+	}
 	oopscount++;
 	while (total < kmsg_bytes) {
 		dst = psinfo->buf;
@@ -103,7 +112,12 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		l2 -= l2_cpy;
 		total += l1_cpy + l2_cpy;
 	}
-	mutex_unlock(&psinfo->buf_mutex);
+	if (in_nmi()) {
+		if (is_locked)
+			spin_unlock(&psinfo->buf_lock);
+	} else {
+		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
+	}
 }
 
 static struct kmsg_dumper pstore_dumper = {
@@ -157,11 +171,12 @@ void pstore_get_records(void)
 	enum pstore_type_id	type;
 	struct timespec		time;
 	int			failed = 0, rc;
+	unsigned long		flags;
 
 	if (!psi)
 		return;
 
-	mutex_lock(&psinfo->buf_mutex);
+	spin_lock_irqsave(&psinfo->buf_lock, flags);
 	rc = psi->open(psi);
 	if (rc)
 		goto out;
@@ -173,7 +188,7 @@ void pstore_get_records(void)
 	}
 	psi->close(psi);
 out:
-	mutex_unlock(&psinfo->buf_mutex);
+	spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 
 	if (failed)
 		printk(KERN_WARNING "pstore: failed to load %d record(s) from '%s'\n",
@@ -187,6 +202,7 @@ out:
 int pstore_write(enum pstore_type_id type, char *buf, size_t size)
 {
 	u64	id;
+	unsigned long flags;
 
 	if (!psinfo)
 		return -ENODEV;
@@ -194,13 +210,13 @@ int pstore_write(enum pstore_type_id type, char *buf, size_t size)
 	if (size > psinfo->bufsize)
 		return -EFBIG;
 
-	mutex_lock(&psinfo->buf_mutex);
+	spin_lock_irqsave(&psinfo->buf_lock, flags);
 	memcpy(psinfo->buf, buf, size);
 	id = psinfo->write(type, size);
 	if (pstore_is_mounted())
 		pstore_mkfile(PSTORE_TYPE_DMESG, psinfo->name, id, psinfo->buf,
 			      size, CURRENT_TIME, psinfo->erase);
-	mutex_unlock(&psinfo->buf_mutex);
+	spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 
 	return 0;
 }
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 2455ef2..2d77b82 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -32,7 +32,7 @@ enum pstore_type_id {
 struct pstore_info {
 	struct module	*owner;
 	char		*name;
-	struct mutex	buf_mutex;	/* serialize access to 'buf' */
+	spinlock_t	buf_lock;	/* serialize access to 'buf' */
 	char		*buf;
 	size_t		bufsize;
 	int		(*open)(struct pstore_info *psi);
-- 
1.7.6

