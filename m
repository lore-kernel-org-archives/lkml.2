Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab2FUVuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:50:23 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab2FUVuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:50:21 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 01/15] UBI: Fastmap: Relax EBA selfcheck
Date: Thu, 21 Jun 2012 23:49:54 +0200
Message-Id: <1340315408-27375-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340315408-27375-1-git-send-email-richard@nod.at>
References: <UBI fastmap updates>
 <1340315408-27375-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is allowed that fastmap knows an EBA table entry
as unmapped while scanning would know this entry as
mapped.
Fastmap knows the current EBA table and scannning
reconstructs it. This case can happen if the fastmap
gets written while the entry is alredy unmapped but the
PEB has not been erased.
If the UBI device gets detached at this moment, scanning
may detect this EBA entry as mapped.
(Of course the upper layer, UBIFS, knows this LEB is no longer
used)

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/eba.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 2bee8be..6698d5e 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -1276,7 +1276,8 @@ int self_check_eba(struct ubi_device *ubi, struct ubi_attach_info *ai_fastmap,
 
 		for (j = 0; j < vol->reserved_pebs; j++) {
 			if (scan_eba[i][j] != fm_eba[i][j]) {
-				if (scan_eba[i][j] == UBI_LEB_UNMAPPED)
+				if (scan_eba[i][j] == UBI_LEB_UNMAPPED ||
+					fm_eba[i][j] == UBI_LEB_UNMAPPED)
 					continue;
 
 				ubi_err("LEB:%i is mapped to PEB:%i instead of PEB:%i!", i, fm_eba[i][j], scan_eba[i][j]);
-- 
1.7.6.5

