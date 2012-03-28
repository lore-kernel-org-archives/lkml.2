Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab2C1Arm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:47:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:31868 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756295Ab2C1Arj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:47:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="146597548"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 02/13] sgi-xp: Use lockdep_assert_held
Date: Tue, 27 Mar 2012 17:47:06 -0700
Message-Id: <1332895637-32572-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

!spin_is_locked() is always true on a up build, so cannot
be used for assert.  Replace with lockdep_assert_held.

I realize UP builds are not very likely for this driver,
but it's still better to fix it.

Acked-by: Robin Holt <holt@sgi.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/misc/sgi-xp/xpc_channel.c |    6 +++---
 drivers/misc/sgi-xp/xpc_sn2.c     |    2 +-
 drivers/misc/sgi-xp/xpc_uv.c      |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/sgi-xp/xpc_channel.c b/drivers/misc/sgi-xp/xpc_channel.c
index 652593f..1655c21 100644
--- a/drivers/misc/sgi-xp/xpc_channel.c
+++ b/drivers/misc/sgi-xp/xpc_channel.c
@@ -28,7 +28,7 @@ xpc_process_connect(struct xpc_channel *ch, unsigned long *irq_flags)
 {
 	enum xp_retval ret;
 
-	DBUG_ON(!spin_is_locked(&ch->lock));
+	lockdep_assert_held(&ch->lock);
 
 	if (!(ch->flags & XPC_C_OPENREQUEST) ||
 	    !(ch->flags & XPC_C_ROPENREQUEST)) {
@@ -82,7 +82,7 @@ xpc_process_disconnect(struct xpc_channel *ch, unsigned long *irq_flags)
 	struct xpc_partition *part = &xpc_partitions[ch->partid];
 	u32 channel_was_connected = (ch->flags & XPC_C_WASCONNECTED);
 
-	DBUG_ON(!spin_is_locked(&ch->lock));
+	lockdep_assert_held(&ch->lock);
 
 	if (!(ch->flags & XPC_C_DISCONNECTING))
 		return;
@@ -758,7 +758,7 @@ xpc_disconnect_channel(const int line, struct xpc_channel *ch,
 {
 	u32 channel_was_connected = (ch->flags & XPC_C_CONNECTED);
 
-	DBUG_ON(!spin_is_locked(&ch->lock));
+	lockdep_assert_held(&ch->lock);
 
 	if (ch->flags & (XPC_C_DISCONNECTING | XPC_C_DISCONNECTED))
 		return;
diff --git a/drivers/misc/sgi-xp/xpc_sn2.c b/drivers/misc/sgi-xp/xpc_sn2.c
index 7d71c04..9d3b113 100644
--- a/drivers/misc/sgi-xp/xpc_sn2.c
+++ b/drivers/misc/sgi-xp/xpc_sn2.c
@@ -1674,7 +1674,7 @@ xpc_teardown_msg_structures_sn2(struct xpc_channel *ch)
 {
 	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
 
-	DBUG_ON(!spin_is_locked(&ch->lock));
+	lockdep_assert_held(&ch->lock);
 
 	ch_sn2->remote_msgqueue_pa = 0;
 
diff --git a/drivers/misc/sgi-xp/xpc_uv.c b/drivers/misc/sgi-xp/xpc_uv.c
index 17bbacb..666b081 100644
--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -1181,7 +1181,7 @@ xpc_teardown_msg_structures_uv(struct xpc_channel *ch)
 {
 	struct xpc_channel_uv *ch_uv = &ch->sn.uv;
 
-	DBUG_ON(!spin_is_locked(&ch->lock));
+	lockdep_assert_held(&ch->lock);
 
 	kfree(ch_uv->cached_notify_gru_mq_desc);
 	ch_uv->cached_notify_gru_mq_desc = NULL;
-- 
1.7.7.6

