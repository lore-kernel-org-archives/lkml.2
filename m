Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab2EIGLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:11:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39119 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756858Ab2EIFxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:31 -0400
Message-Id: <20120509055048.944252709@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:49 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Lin Ming <ming.m.lin@intel.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 140/167] [PATCH] libata: skip old error history when counting probe trials
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Ming <ming.m.lin@intel.com>

commit 6868225e3e92399068be9a5f1635752d91012ad5 upstream.

Commit d902747("[libata] Add ATA transport class") introduced
ATA_EFLAG_OLD_ER to mark entries in the error ring as cleared.

But ata_count_probe_trials_cb() didn't check this flag and it still
counts the old error history. So wrong probe trials count is returned
and it causes problem, for example, SATA link speed is slowed down from
3.0Gbps to 1.5Gbps.

Fix it by checking ATA_EFLAG_OLD_ER in ata_count_probe_trials_cb().

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/libata-eh.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index c61316e..d1fbd59 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3501,7 +3501,8 @@ static int ata_count_probe_trials_cb(struct ata_ering_entry *ent, void *void_arg
 	u64 now = get_jiffies_64();
 	int *trials = void_arg;
 
-	if (ent->timestamp < now - min(now, interval))
+	if ((ent->eflags & ATA_EFLAG_OLD_ER) ||
+	    (ent->timestamp < now - min(now, interval)))
 		return -1;
 
 	(*trials)++;
-- 
1.7.10



