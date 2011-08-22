Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab1HVUjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 16:39:00 -0400
Received: from yuna.grokhost.net ([87.117.228.63]:45460 "EHLO
	yuna.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab1HVUi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 16:38:58 -0400
From: Chris Boot <bootc@bootc.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Chris Boot <bootc@bootc.net>
Subject: [PATCH] firewire-sbp2: fix panic after rmmod with slow targets
Date: Mon, 22 Aug 2011 21:38:38 +0100
Message-Id: <1314045518-50629-1-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20110822163526.5b76d535@stein>
References: <20110822163526.5b76d535@stein>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If firewire-sbp2 starts a login to a target that doesn't complete ORBs
in a timely manner (and has to retry the login), and the module is
removed before the operation times out, you end up with a null-pointer
dereference and a kernel panic.

This happens because the code in sbp2_remove() just does a
sbp2_target_put(), assuming there are no remaining references to the
target. If there are jobs in the workqueue, this is not the case, and
the module is successfully unloaded while references still exist.

This patch cancels pending work for each unit in sbp2_remove(), which
hopefully means there are no extra references around that prevent us
from unloading. This fixes my crash.

Signed-off-by: Chris Boot <bootc@bootc.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: <linux1394-devel@lists.sourceforge.net>
---
 drivers/firewire/sbp2.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 41841a3..26397ec 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1198,6 +1198,11 @@ static int sbp2_remove(struct device *dev)
 {
 	struct fw_unit *unit = fw_unit(dev);
 	struct sbp2_target *tgt = dev_get_drvdata(&unit->device);
+	struct sbp2_logical_unit *lu, *next;
+
+	list_for_each_entry(lu, next, &tgt->lu_list, link) {
+		cancel_delayed_work_sync(&lu->work);
+	}
 
 	sbp2_target_put(tgt);
 	return 0;
-- 
1.7.5.4

