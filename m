Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab0IAQEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 12:04:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53294 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab0IAQEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 12:04:07 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, Wolfram Sang <w.sang@pengutronix.de>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [RFC] jffs2: use cond_resched() instead of yield()
Date: Wed,  1 Sep 2010 18:03:41 +0200
Message-Id: <1283357021-16187-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.1
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yield() has different semantics meanwhile and even causes RT-kernels to
BUG. Replace the only appearance left in jffs2.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

The aforementioned BUG() showed up in one of our customer's RT-projects. While
this could be handled by rearranging his thread-priorities, I wondered if such
a patch would be worthwhile, still. Reading through the material covering
yield() and related replacements, I believe this patch should be appropriate.
Please say if I missed some side-effects.

 fs/jffs2/erase.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jffs2/erase.c b/fs/jffs2/erase.c
index abac961..e513f19 100644
--- a/fs/jffs2/erase.c
+++ b/fs/jffs2/erase.c
@@ -151,7 +151,7 @@ int jffs2_erase_pending_blocks(struct jffs2_sb_info *c, int count)
 		}
 
 		/* Be nice */
-		yield();
+		cond_resched();
 		mutex_lock(&c->erase_free_sem);
 		spin_lock(&c->erase_completion_lock);
 	}
-- 
1.7.1

