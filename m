Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab2FRQTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:19:52 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47840 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425Ab2FRQTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:19:45 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 21/22] UBI: Fastmap: Fix and explain duplicated PEBs
Date: Mon, 18 Jun 2012 18:19:04 +0200
Message-Id: <1340036345-96726-22-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340036345-96726-1-git-send-email-richard@nod.at>
References: <1340036345-96726-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index bea9446..45f70db 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -714,6 +714,15 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 		kmem_cache_free(ai->aeb_slab_cache, tmp_aeb);
 	}
 
+	/*
+	 * Sort out dups. We are allowed to have duplicates here because
+	 * the fastmap can be written without refilling all pools.
+	 * E.g. If PEB X is in a pool fastmap may detect it as empty and
+	 * puts it into the free list. But ff PEB X is in the pool, get's
+	 * used and returned (e.g. by schedule_erase()) it remains in
+	 * the erase or free list too.
+	 * We could also sort out these dups while creating the fastmap.
+	 */
 	if (list_empty(&free))
 		goto out;
 
@@ -729,6 +738,18 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 		}
 	}
 
+	list_for_each_entry(aeb, &ai->erase, u.list) {
+		list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &free, u.list) {
+			if (aeb->pnum == tmp_aeb->pnum) {
+				aeb->scrub = tmp_aeb->scrub;
+				aeb->ec = tmp_aeb->ec;
+				list_del(&tmp_aeb->u.list);
+				kfree(tmp_aeb);
+				continue;
+			}
+		}
+	}
+
 	list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &free, u.list) {
 		list_del(&tmp_aeb->u.list);
 		list_add_tail(&tmp_aeb->u.list, &ai->free);
-- 
1.7.6.5

