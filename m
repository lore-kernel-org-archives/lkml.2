Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab2EMIrm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 04:47:42 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:41455
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751675Ab2EMIrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 04:47:40 -0400
Date: Sun, 13 May 2012 10:47:37 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [patch] UBI: add means to clear ubi work queue for particular
 lnums
In-Reply-To: <alpine.DEB.2.00.1205121712410.24689@eristoteles.iwoars.net>
Message-ID: <alpine.DEB.2.00.1205131043370.654@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205121712410.24689@eristoteles.iwoars.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second part of a patch to allow UBI to force the erasure of
particular logical eraseblock numbers. In this patch, a new function,
ubi_lnum_purge, is added that allows the caller to synchronously erase all
unmapped erase blocks whose LEB number corresponds to the parameter. This
requires a previous patch that stores the LEB number in struct ubi_work.

This was tested by disabling the call to do_work in ubi thread, which results
in the work queue remaining unless explicitly called to remove. UBIFS was
changed to call ubifs_leb_change 50 times for three different LEBs. Then the
new function was called to clear the queue for the three differnt LEB numbers
one at a time. The work queue was dumped each time and the selective removal
of the particular LEB numbers was observed.

Calls to down_read(&ubi->work_sem) are not being done (unlike in
do_work).. I'm not sure
exactly where its needed / what it does, so perhaps someone can enlighten
me.


Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
---
 drivers/mtd/ubi/kapi.c  |   31 +++++++++++++++++++++++++++++++
 drivers/mtd/ubi/ubi.h   |    1 +
 drivers/mtd/ubi/wl.c    |   35 +++++++++++++++++++++++++++++++++++
 include/linux/mtd/ubi.h |    1 +
 4 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ubi/kapi.c b/drivers/mtd/ubi/kapi.c
index 9fdb353..bfd4e22 100644
--- a/drivers/mtd/ubi/kapi.c
+++ b/drivers/mtd/ubi/kapi.c
@@ -720,6 +720,37 @@ int ubi_sync(int ubi_num)
 }
 EXPORT_SYMBOL_GPL(ubi_sync);

+/**
+ * ubi_lnum_purge - synchronously erase unmapped PEBs by LEB number.
+ * @ubi_num: UBI device to erase PEBs
+ * @lnum: the LEB number to erase old unmapped PEBs.
+ *
+ * This function is designed to offer a means to ensure that the contents of
+ * old, unmapped LEBs are securely erased without having to flush the entire
+ * work queue of all erase blocks that need erasure.  Simply erasing the block
+ * at the time of unmapped is insufficient, as the wear-levelling subsystem
+ * may have already moved the contents. This function navigates the list of
+ * erase blocks that need erasures, and performs an immediate and synchronous
+ * erasure of any erase block that has held data for this particular @lnum.
+ * This may include eraseblocks that held older versions of the same @lnum.
+ * Returns zero in case of success and a negative error code in case of
+ * failure.
+ */
+int ubi_lnum_purge(int ubi_num, int lnum)
+{
+	int err;
+	struct ubi_device *ubi;
+
+	ubi = ubi_get_device(ubi_num);
+	if (!ubi)
+		return -ENODEV;
+
+	err = ubi_wl_flush_lnum(ubi, lnum);
+	ubi_put_device(ubi);
+	return err;
+}
+EXPORT_SYMBOL_GPL(ubi_lnum_purge);
+
 BLOCKING_NOTIFIER_HEAD(ubi_notifiers);

 /**
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 14443a0..e1a29ea 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -539,6 +539,7 @@ int ubi_eba_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si);
 int ubi_wl_get_peb(struct ubi_device *ubi, int dtype);
 int ubi_wl_put_peb(struct ubi_device *ubi, int pnum, int torture, int lnum);
 int ubi_wl_flush(struct ubi_device *ubi);
+int ubi_wl_flush_lnum(struct ubi_device *ubi, int lnum);
 int ubi_wl_scrub_peb(struct ubi_device *ubi, int pnum);
 int ubi_wl_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si);
 void ubi_wl_close(struct ubi_device *ubi);
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 7f6dd7e..bc8111d 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -1278,6 +1278,41 @@ retry:
 }

 /**
+ * ubi_wl_flush_lnum - flush all pending works associated with a LEB number
+ * @ubi: UBI device description object
+ * @lnum: the LEB number only for which work should be synchronously executed
+ *
+ * This function executes all pending works for PEBs whose associated with a
+ * particular LEB number. This function returns zero in case of success and a
+ * negative error code in case of failure.
+ */
+int ubi_wl_flush_lnum(struct ubi_device *ubi, int lnum)
+{
+	int err = 0;
+	struct ubi_work *wrk, *tmp;
+
+	/* For each pending work, if it corresponds to the parameter @lnum,
+	 * then execute the work.
+	 */
+	dbg_wl("flush lnum %d", lnum);
+	list_for_each_entry_safe(wrk, tmp, &ubi->works, list) {
+		if (wrk->lnum == lnum) {
+			spin_lock(&ubi->wl_lock);
+			list_del(&wrk->list);
+			ubi->works_count -= 1;
+			ubi_assert(ubi->works_count >= 0);
+			spin_unlock(&ubi->wl_lock);
+
+			err = wrk->func(ubi, wrk, 0);
+			if (err)
+				ubi_err("work failed with error code %d", err);
+		}
+	}
+
+	return err;
+}
+
+/**
  * ubi_wl_flush - flush all pending works.
  * @ubi: UBI device description object
  *
diff --git a/include/linux/mtd/ubi.h b/include/linux/mtd/ubi.h
index db4836b..1d1b6a1 100644
--- a/include/linux/mtd/ubi.h
+++ b/include/linux/mtd/ubi.h
@@ -216,6 +216,7 @@ int ubi_leb_unmap(struct ubi_volume_desc *desc, int lnum);
 int ubi_leb_map(struct ubi_volume_desc *desc, int lnum, int dtype);
 int ubi_is_mapped(struct ubi_volume_desc *desc, int lnum);
 int ubi_sync(int ubi_num);
+int ubi_lnum_purge(int ubi_num, int lnum);

 /*
  * This function is the same as the 'ubi_leb_read()' function, but it does not
-- 
1.7.5.4


