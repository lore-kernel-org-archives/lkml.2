Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030808Ab2ERCxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:53:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40593 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030755Ab2ERCwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:54 -0400
Message-Id: <20120518023259.780177163@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:34 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Bernhard Kohl <Riedel-und-Kohl@t-online.de>,
        Bernhard Kohl <bernhard.kohl@gmx.net>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 40/53] target: Fix SPC-2 RELEASE bug for multi-session iSCSI client setups
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernhard Kohl <Riedel-und-Kohl@t-online.de>

commit edc318d9fea6854df752ec8c645b960b0d5a1d23 upstream.

This patch addresses a bug in a special case for target core SPC-2 RELEASE
logic where the same physical client (eg: iSCSI InitiatorName) with
differing iSCSI session identifiers (ISID) is allowed to incorrectly release
the same client's SPC-2 reservation from the non reservation holding path.

Note this bug is specific to iscsi-target w/ SPC-2 reservations, and
with the default enforce_pr_isids=1 device attr setting in target-core
controls if a InitiatorName + different ISID reservations are handled
the same as a single iSCSI client entity.

Signed-off-by: Bernhard Kohl <bernhard.kohl@gmx.net>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_pr.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 86f0c3b..c3148b1 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -220,6 +220,9 @@ int target_scsi2_reservation_release(struct se_task *task)
 	if (dev->dev_reserved_node_acl != sess->se_node_acl)
 		goto out_unlock;
 
+	if (dev->dev_res_bin_isid != sess->sess_bin_isid)
+		goto out_unlock;
+
 	dev->dev_reserved_node_acl = NULL;
 	dev->dev_flags &= ~DF_SPC2_RESERVATIONS;
 	if (dev->dev_flags & DF_SPC2_RESERVATIONS_WITH_ISID) {
-- 
1.7.10



