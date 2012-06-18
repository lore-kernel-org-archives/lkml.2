Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab2FRQWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:22:05 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47837 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274Ab2FRQTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:19:38 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 13/22] UBI: Fastmap: Fix EC values
Date: Mon, 18 Jun 2012 18:18:56 +0200
Message-Id: <1340036345-96726-14-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340036345-96726-1-git-send-email-richard@nod.at>
References: <1340036345-96726-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the correct EC values back to the WL sub-system.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |    2 ++
 drivers/mtd/ubi/wl.c      |    4 +++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 33a14cf..b4f7fce 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -721,6 +721,7 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 		list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &free, u.list) {
 			if (aeb->pnum == tmp_aeb->pnum) {
 				aeb->scrub = tmp_aeb->scrub;
+				aeb->ec = tmp_aeb->ec;
 				list_del(&tmp_aeb->u.list);
 				kfree(tmp_aeb);
 				continue;
@@ -1345,6 +1346,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 
 			ec = be64_to_cpu(ec_hdr->ec);
 			ec += ret;
+			old_fm->e[0]->ec = ec;
 			if (ec > UBI_MAX_ERASECOUNTER) {
 				ubi_err("erase counter overflow!");
 				kfree(ec_hdr);
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 25d2e0b..eec3940 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -839,8 +839,10 @@ int ubi_wl_put_fm_peb(struct ubi_device *ubi, struct ubi_wl_entry *fm_e,
 		e = fm_e;
 		ubi_assert(e->ec);
 		ubi->lookuptbl[pnum] = e;
-	} else
+	} else {
+		e->ec = fm_e->ec;
 		kfree(fm_e);
+	}
 
 	spin_unlock(&ubi->wl_lock);
 
-- 
1.7.6.5

