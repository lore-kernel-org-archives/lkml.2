Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab2FUVvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:51:08 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47847 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760543Ab2FUVud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:50:33 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 13/15] UBI: Fastmap: Add new self check
Date: Thu, 21 Jun 2012 23:50:06 +0200
Message-Id: <1340315408-27375-14-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340315408-27375-1-git-send-email-richard@nod.at>
References: <UBI fastmap updates>
 <1340315408-27375-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If fastmap is able to detect that it's missing PEBs
fall back to scanning mode and print a fat warning.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 76b0d2f..68be3d5 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -461,6 +461,26 @@ out:
 	return ret;
 }
 
+static int self_check_fastmap(struct ubi_attach_info *ai)
+{
+	struct ubi_ainf_peb *aeb;
+	struct ubi_ainf_volume *av;
+	struct rb_node *rb1, *rb2;
+	int n = 0;
+
+	list_for_each_entry(aeb, &ai->erase, u.list)
+		n++;
+
+	list_for_each_entry(aeb, &ai->free, u.list)
+		n++;
+
+	 ubi_rb_for_each_entry(rb1, av, &ai->volumes, rb)
+		ubi_rb_for_each_entry(rb2, aeb, &av->root, u.rb)
+			n++;
+
+	return n;
+}
+
 /**
  * ubi_attach_fastmap - creates ubi_attach_info from a fastmap.
  * @ubi: UBI device object
@@ -978,6 +998,19 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		goto free_hdr;
 	}
 
+	/*
+	 * If fastmap is leaking PEBs (must not happen), raise a
+	 * fat warning and fall back to scanning mode.
+	 * We do this here because in ubi_wl_init() it's too late
+	 * and we cannot fall back to scanning.
+	 */
+	if (WARN_ON(self_check_fastmap(ai) != ubi->peb_count -
+		    ubi->bad_peb_count - used_blocks)) {
+		ret = UBI_BAD_FASTMAP;
+		kfree(fm);
+		goto free_hdr;
+	}
+
 	fm->size = fm_size;
 	fm->used_blocks = used_blocks;
 
-- 
1.7.6.5

