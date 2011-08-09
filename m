Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab1HINSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 09:18:05 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:42548 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab1HINSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 09:18:04 -0400
Subject: [PATCH] hpsa: fix physical device lun and target numbering problem
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikem@beardog.cce.hp.com, stephenmcameron@gmail.com, thenzl@redhat.com,
        akpm@linux-foundation.org, stable@kernel.org
Date: Tue, 09 Aug 2011 08:18:01 -0500
Message-ID: <20110809131801.10649.44268.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

If a physical device exposed to the OS by hpsa
is replaced (e.g. one hot plug tape drive is replaced
by another, or a tape drive is placed into "OBDR" mode
in which it acts like a CD-ROM device) and a rescan is
initiated, the replaced device will be added to the
SCSI midlayer with target and lun numbers set to -1.
After that, a panic is likely to ensue.  When a physical
device is replaced, the lun and target number should be
preserved.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 1f32f06..b200b73 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -676,6 +676,16 @@ static void hpsa_scsi_replace_entry(struct ctlr_info *h, int hostno,
 	BUG_ON(entry < 0 || entry >= HPSA_MAX_SCSI_DEVS_PER_HBA);
 	removed[*nremoved] = h->dev[entry];
 	(*nremoved)++;
+
+	/*
+	 * New physical devices won't have target/lun assigned yet
+	 * so we need to preserve the values in the slot we are replacing.
+	 */
+	if (new_entry->target == -1) {
+		new_entry->target = h->dev[entry]->target;
+		new_entry->lun = h->dev[entry]->lun;
+	}
+
 	h->dev[entry] = new_entry;
 	added[*nadded] = new_entry;
 	(*nadded)++;

