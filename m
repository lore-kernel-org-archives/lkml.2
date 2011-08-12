Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab1HLRyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:54:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:25587 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab1HLRyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:54:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="37959023"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Don Zickus" <dzickus@redhat.com>, "Matthew Garrett" <mjg@redhat.com>
Subject: pstore: change mutex locking to spin_locks
Date: Fri, 12 Aug 2011 10:54:51 -0700
Message-Id: <4e4568eb10165cbab6@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>

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
Signed-off-by: Tony Luck <tony.luck@intel.com>

---

Essentially the same patch that Don posted on July 20th. I just added the
efivars.c bit, and did some minor formatting changes to make it fit on
top of the "defer inserting OOPs entries into pstore" patch that I posted
yesterday.  I plan to add both patches to linux-next soon, and will send
to Linus in the 3.2 merge window.

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 2ca59dc..5e820ea 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -1165,7 +1165,7 @@ static int __init erst_init(void)
 		goto err_release_erange;
 
 	buf = kmalloc(erst_erange.size, GFP_KERNEL);
-	mutex_init(&erst_info.buf_mutex);
+	spin_lock_init(&erst_info.buf_lock);
 	if (buf) {
 		erst_info.buf = buf + sizeof(struct cper_pstore_record);
 		erst_info.bufsize = erst_erange.size -
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index eb80b54..be8bcb0 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -978,7 +978,7 @@ int register_efivars(struct efivars *efivars,
 	if (efivars->efi_pstore_info.buf) {
 		efivars->efi_pstore_info.bufsize = 1024;
 		efivars->efi_pstore_info.data = efivars;
-		mutex_init(&efivars->efi_pstore_info.buf_mutex);
+		spin_lock_init(&efivars->efi_pstore_info.buf_lock);
 		pstore_register(&efivars->efi_pstore_info);
 	}
 
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index ca60ebc..0472924 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -28,6 +28,7 @@
 #include <linux/timer.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/hardirq.h>
 #include <linux/workqueue.h>
 
 #include "internal.h"
@@ -88,13 +89,20 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 	u64		id;
 	int		hsize;
 	unsigned int	part = 1;
+	unsigned long	flags = 0;
+	int		is_locked = 0;
 
 	if (reason < ARRAY_SIZE(reason_str))
 		why = reason_str[reason];
 	else
 		why = "Unknown";
 
-	mutex_lock(&psinfo->buf_mutex);
+	if (in_nmi()) {
+		is_locked = spin_trylock(&psinfo->buf_lock);
+		if (!is_locked)
+			pr_err("pstore dump routine blocked in NMI, may corrupt error record\n");
+	} else
+		spin_lock_irqsave(&psinfo->buf_lock, flags);
 	oopscount++;
 	while (total < kmsg_bytes) {
 		dst = psinfo->buf;
@@ -123,7 +131,11 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		total += l1_cpy + l2_cpy;
 		part++;
 	}
-	mutex_unlock(&psinfo->buf_mutex);
+	if (in_nmi()) {
+		if (is_locked)
+			spin_unlock(&psinfo->buf_lock);
+	} else
+		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 }
 
 static struct kmsg_dumper pstore_dumper = {
@@ -188,11 +200,12 @@ void pstore_get_records(int quiet)
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
@@ -205,7 +218,7 @@ void pstore_get_records(int quiet)
 	}
 	psi->close(psi);
 out:
-	mutex_unlock(&psinfo->buf_mutex);
+	spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 
 	if (failed)
 		printk(KERN_WARNING "pstore: failed to load %d record(s) from '%s'\n",
@@ -233,7 +246,8 @@ static void pstore_timefunc(unsigned long dummy)
  */
 int pstore_write(enum pstore_type_id type, char *buf, size_t size)
 {
-	u64	id;
+	u64		id;
+	unsigned long	flags;
 
 	if (!psinfo)
 		return -ENODEV;
@@ -241,13 +255,13 @@ int pstore_write(enum pstore_type_id type, char *buf, size_t size)
 	if (size > psinfo->bufsize)
 		return -EFBIG;
 
-	mutex_lock(&psinfo->buf_mutex);
+	spin_lock_irqsave(&psinfo->buf_lock, flags);
 	memcpy(psinfo->buf, buf, size);
 	id = psinfo->write(type, 0, size, psinfo);
 	if (pstore_is_mounted())
 		pstore_mkfile(PSTORE_TYPE_DMESG, psinfo->name, id, psinfo->buf,
 			      size, CURRENT_TIME, psinfo);
-	mutex_unlock(&psinfo->buf_mutex);
+	spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 
 	return 0;
 }
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index cc03bbf..b91440e 100644
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
