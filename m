Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab1FNNDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 09:03:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52340 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1FNNDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 09:03:45 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-pm@lists.linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Nishanth Menon <nm@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH] power: opp: Fix rcu_dereference_check() without protection!
Date: Tue, 14 Jun 2011 18:33:20 +0530
Message-ID: <1308056600-17601-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.5.6.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With RCU debug options enabled, below warning is observed.

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
drivers/base/power/opp.c:151 invoked rcu_dereference_check() without protection!

other info that might help us debug this:

rcu_scheduler_active = 1, debug_locks = 1
no locks held by swapper/1.
...

---------------------------------------------------

Fix the same by protecting it with rcu_read lock.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Nishanth Menon <nm@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
---
 drivers/base/power/opp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 56a6899..cbed5e1 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -148,7 +148,9 @@ unsigned long opp_get_voltage(struct opp *opp)
 	struct opp *tmp_opp;
 	unsigned long v = 0;
 
+	rcu_read_lock();
 	tmp_opp = rcu_dereference(opp);
+	rcu_read_unlock();
 	if (unlikely(IS_ERR_OR_NULL(tmp_opp)) || !tmp_opp->available)
 		pr_err("%s: Invalid parameters\n", __func__);
 	else
-- 
1.6.0.4

