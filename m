Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935240Ab1IOWcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 18:32:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54022 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935135Ab1IOWcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 18:32:16 -0400
Date: Thu, 15 Sep 2011 17:32:08 -0500
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morgan <morgan@kernel.org>,
        Vasiliy Kulikov <segoon@openwall.com>, Andrew Morton <akpm@osdl.org>,
        richard@nod.at, Linux Containers <containers@lists.osdl.org>
Subject: [PATCH] user namespace: clamp down users of cap_raised
Message-ID: <20110915223208.GA32247@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few modules are using cap_raised(current_cap(), cap) to authorize
actions.  This means that tasks which are privileged in non-initial
user namespaces will be deemed privileged.  The privilege should only
be granted if the task is in the initial user namespace.

Switching the calls to capable() would change the behavior - it would
cause the LSM capable hooks to be called, and set PF_SUPERPRIV if
the capability was used.  So instead, put in an explicit check and
refuse privilege if the caller is not in init_user_ns.

Vasiliy had suggested introducing a new helper for this.  I'm open
to suggestions, but for four callers and for a discouraged idiom,
I'd rather not pollute the capable* function namespace with a bad name.
(even has_capability goes through the LSM hooks)

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>
---
 drivers/block/drbd/drbd_nl.c           |    5 +++++
 drivers/md/dm-log-userspace-transfer.c |    3 +++
 drivers/staging/pohmelfs/config.c      |    3 +++
 drivers/video/uvesafb.c                |    3 +++
 4 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 0feab26..9a87a14 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2297,6 +2297,11 @@ static void drbd_connector_callback(struct cn_msg *req, struct netlink_skb_parms
 		return;
 	}
 
+	if (current_user_ns() != &init_user_ns) {
+		retcode = ERR_PERM;
+		goto fail;
+	}
+
 	if (!cap_raised(current_cap(), CAP_SYS_ADMIN)) {
 		retcode = ERR_PERM;
 		goto fail;
diff --git a/drivers/md/dm-log-userspace-transfer.c b/drivers/md/dm-log-userspace-transfer.c
index 1f23e04..140ca81 100644
--- a/drivers/md/dm-log-userspace-transfer.c
+++ b/drivers/md/dm-log-userspace-transfer.c
@@ -134,6 +134,9 @@ static void cn_ulog_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 {
 	struct dm_ulog_request *tfr = (struct dm_ulog_request *)(msg + 1);
 
+	if (current_user_ns() != &init_user_ns)
+		return;
+
 	if (!cap_raised(current_cap(), CAP_SYS_ADMIN))
 		return;
 
diff --git a/drivers/staging/pohmelfs/config.c b/drivers/staging/pohmelfs/config.c
index b6c42cb..cd259d0 100644
--- a/drivers/staging/pohmelfs/config.c
+++ b/drivers/staging/pohmelfs/config.c
@@ -525,6 +525,9 @@ static void pohmelfs_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *n
 {
 	int err;
 
+	if (current_user_ns() != &init_user_ns)
+		return;
+
 	if (!cap_raised(current_cap(), CAP_SYS_ADMIN))
 		return;
 
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 7f8472c..71dab8e 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -73,6 +73,9 @@ static void uvesafb_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *ns
 	struct uvesafb_task *utask;
 	struct uvesafb_ktask *task;
 
+	if (current_user_ns() != &init_user_ns)
+		return;
+
 	if (!cap_raised(current_cap(), CAP_SYS_ADMIN))
 		return;
 
-- 
1.7.0.4

