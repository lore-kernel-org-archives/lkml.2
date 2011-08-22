Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab1HVNQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:16:46 -0400
Received: from yuna.grokhost.net ([87.117.228.63]:38795 "EHLO
	yuna.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab1HVNQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:16:45 -0400
X-Greylist: delayed 563 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Aug 2011 09:16:44 EDT
From: Chris Boot <bootc@bootc.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Chris Boot <bootc@bootc.net>
Subject: [PATCH] firewire-sbp2: fix panic after rmmod with slow targets
Date: Mon, 22 Aug 2011 14:07:16 +0100
Message-Id: <1314018436-9329-1-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If firewire-sbp2 starts a login to a target that doesn't complete ORBs
in a timely manner (and has to retry the login), and the module is
removed before the operation times out, you end up with a null-pointer
dereference and a kernel panic.

This happens because the code in sbp2_remove() just does a
sbp2_target_put(), assuming it will be the last remaining reference. If
there are jobs in the workqueue, this is not the case, and the module is
successfully unloaded while references still exist.

This patch cancels pending work for each unit in sbp2_remove(), which
hopefully means there are no extra references around that prevent us
from unloading. This fixes my crash.

Signed-off-by: Chris Boot <bootc@bootc.net>
---
 drivers/firewire/sbp2.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 41841a3..3867aaa 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1198,6 +1198,11 @@ static int sbp2_remove(struct device *dev)
 {
 	struct fw_unit *unit = fw_unit(dev);
 	struct sbp2_target *tgt = dev_get_drvdata(&unit->device);
+	struct sbp2_logical_unit *lu, *next;
+
+	list_for_each_entry_safe(lu, next, &tgt->lu_list, link) {
+		cancel_delayed_work_sync(&lu->work);
+	}
 
 	sbp2_target_put(tgt);
 	return 0;
-- 
1.7.5.4

