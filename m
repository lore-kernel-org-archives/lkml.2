Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab2FRQVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:21:40 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47844 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab2FRQTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:19:40 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 15/22] UBI: Fastmap: Kill old fastmap in case of a failure
Date: Mon, 18 Jun 2012 18:18:58 +0200
Message-Id: <1340036345-96726-16-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340036345-96726-1-git-send-email-richard@nod.at>
References: <1340036345-96726-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have to make sure that the old (and from this point on
invalid) fastmap is killed if we fail to create a new one.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |  177 +++++++++++++++++++++++++--------------------
 1 files changed, 100 insertions(+), 77 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index f9e5dbb..7d36034 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1266,6 +1266,59 @@ out:
 	return ret;
 }
 
+static int erase_block(struct ubi_device *ubi, int pnum)
+{
+	int ret;
+	struct ubi_ec_hdr *ec_hdr;
+	long long ec;
+
+	ec_hdr = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
+	if (!ec_hdr)
+		return -ENOMEM;
+
+	ret = ubi_io_read_ec_hdr(ubi, pnum, ec_hdr, 0);
+	if (ret < 0)
+		goto out;
+	else if (ret && ret != UBI_IO_BITFLIPS) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = ubi_io_sync_erase(ubi, pnum, 0);
+	if (ret < 0)
+		goto out;
+
+	ec = be64_to_cpu(ec_hdr->ec);
+	ec += ret;
+	if (ec > UBI_MAX_ERASECOUNTER) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ec_hdr->ec = cpu_to_be64(ec);
+	ret = ubi_io_write_ec_hdr(ubi, pnum, ec_hdr);
+	if (ret < 0)
+		goto out;
+
+	ret = ec;
+out:
+	kfree(ec_hdr);
+	return ret;
+}
+
+static int invalidate_fastmap(struct ubi_device *ubi,
+			      struct ubi_fastmap_layout *fm)
+{
+	int ret, i;
+
+	ret = erase_block(ubi, fm->e[0]->pnum);
+
+	for (i = 0; i < fm->used_blocks; i++)
+		ubi_wl_put_fm_peb(ubi, fm->e[i], fm->to_be_tortured[i]);
+
+	return ret;
+}
+
 /**
  * ubi_update_fastmap - will be called by UBI if a volume changes or
  * a fastmap pool becomes full.
@@ -1307,10 +1360,35 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 	}
 
 	mutex_lock(&ubi->fm_mutex);
-
 	old_fm = ubi->fm;
 	ubi->fm = NULL;
 
+	if (new_fm->used_blocks > UBI_FM_MAX_BLOCKS) {
+		ubi_err("fastmap too large");
+		ret = -ENOSPC;
+		goto err;
+	}
+
+	for (i = 1; i < new_fm->used_blocks; i++) {
+		spin_lock(&ubi->wl_lock);
+		tmp_e = ubi_wl_get_fm_peb(ubi, -1);
+		spin_unlock(&ubi->wl_lock);
+
+		if (!tmp_e) {
+			int j;
+			ubi_err("could not get any free erase block");
+
+			for (j = 1; j < i; j++)
+				ubi_wl_put_fm_peb(ubi, new_fm->e[j], 0);
+
+			ret = -ENOSPC;
+			goto err;
+		}
+
+		new_fm->e[i]->pnum = tmp_e->pnum;
+		new_fm->e[i]->ec = tmp_e->ec;
+	}
+
 	spin_lock(&ubi->wl_lock);
 	tmp_e = ubi_wl_get_fm_peb(ubi, UBI_FM_MAX_START);
 	spin_unlock(&ubi->wl_lock);
@@ -1318,53 +1396,14 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 	if (old_fm) {
 		/* no fresh early PEB was found, reuse the old one */
 		if (!tmp_e) {
-			struct ubi_ec_hdr *ec_hdr;
-			long long ec;
-
-			ec_hdr = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
-			if (!ec_hdr) {
-				ret = -ENOMEM;
-				goto err;
-			}
-
-			/* we have to erase the block by hand */
-			ret = ubi_io_read_ec_hdr(ubi, old_fm->e[0]->pnum,
-						 ec_hdr, 0);
-			if (ret && ret != UBI_IO_BITFLIPS) {
-				ubi_err("unable to read EC header");
-				kfree(ec_hdr);
-				goto err;
-			}
-
-			ret = ubi_io_sync_erase(ubi, old_fm->e[0]->pnum,
-						0);
+			ret = erase_block(ubi, old_fm->e[0]->pnum);
 			if (ret < 0) {
-				ubi_err("unable to erase old SB");
-				kfree(ec_hdr);
-				goto err;
-			}
-
-			ec = be64_to_cpu(ec_hdr->ec);
-			ec += ret;
-			old_fm->e[0]->ec = ec;
-			if (ec > UBI_MAX_ERASECOUNTER) {
-				ubi_err("erase counter overflow!");
-				kfree(ec_hdr);
-				ret = -EINVAL;
-				goto err;
-			}
-
-			ec_hdr->ec = cpu_to_be64(ec);
-			ret = ubi_io_write_ec_hdr(ubi, old_fm->e[0]->pnum,
-						  ec_hdr);
-			kfree(ec_hdr);
-			if (ret) {
-				ubi_err("unable to write new EC header");
+				ubi_err("could not erase old early PEB");
 				goto err;
 			}
 
 			new_fm->e[0]->pnum = old_fm->e[0]->pnum;
-			new_fm->e[0]->ec = old_fm->e[0]->ec;
+			new_fm->e[0]->ec = ret;
 		} else {
 			/* we've got a new early PEB, return the old one */
 			ubi_wl_put_fm_peb(ubi, old_fm->e[0],
@@ -1389,48 +1428,32 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 		new_fm->e[0]->ec = tmp_e->ec;
 	}
 
-	if (new_fm->used_blocks > UBI_FM_MAX_BLOCKS) {
-		ubi_err("fastmap too large");
-		ret = -ENOSPC;
-		goto err;
-	}
-
-	/* give the wl subsystem a chance to produce some free blocks */
-	cond_resched();
-
-	for (i = 1; i < new_fm->used_blocks; i++) {
-		spin_lock(&ubi->wl_lock);
-		tmp_e = ubi_wl_get_fm_peb(ubi, -1);
-		spin_unlock(&ubi->wl_lock);
-
-		if (!tmp_e) {
-			ubi_err("could not get any free erase block");
-
-			while (i--) {
-				ubi_wl_put_fm_peb(ubi, new_fm->e[i], 0);
-				kfree(new_fm->e[i]);
-			}
-			ret = -ENOSPC;
-			goto err;
-		}
-
-		new_fm->e[i]->pnum = tmp_e->pnum;
-		new_fm->e[i]->ec = tmp_e->ec;
-	}
-
-	kfree(old_fm);
-
-	down_write(&ubi->fm_sem);
 	down_write(&ubi->work_sem);
+	down_write(&ubi->fm_sem);
 	ret = ubi_write_fastmap(ubi, new_fm);
-	up_write(&ubi->work_sem);
 	up_write(&ubi->fm_sem);
+	up_write(&ubi->work_sem);
+
+	if (ret)
+		goto err;
+
 out_unlock:
 	mutex_unlock(&ubi->fm_mutex);
-
+	kfree(old_fm);
 	return ret;
 
 err:
 	kfree(new_fm);
+
+	ubi_warn("Unable to write new fastmap, err=%i", ret);
+
+	ret = 0;
+	if (old_fm) {
+		ret = invalidate_fastmap(ubi, old_fm);
+		if (ret < 0)
+			ubi_err("Unable to invalidiate current fastmap!");
+		else if (ret)
+			ret = 0;
+	}
 	goto out_unlock;
 }
-- 
1.7.6.5

