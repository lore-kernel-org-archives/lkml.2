Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790Ab1JXOnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 10:43:11 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:57086 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932390Ab1JXOnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 10:43:06 -0400
Date: Mon, 24 Oct 2011 14:43:34 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: David Howells <dhowells@redhat.com>
Cc: "Andrew G. Morgan" <morgan@kernel.org>, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, akpm@linux-foundation.org, oleg@redhat.com,
        richard@nod.at, mikevs@xs4all.net, segoon@openwall.com, gregkh@suse.de,
        eparis@redhat.com, "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: [PATCH 05/10] user namespace: clamp down users of cap_raised
Message-ID: <20111024144334.GA26603@hallyn.com>
References: <CALQRfL51U=cuLdVUpFXTog++3WwMjJB+9S6T8gVibC5gdGa5JQ@mail.gmail.com>
 <1318974898-21431-1-git-send-email-serge@hallyn.com>
 <1318974898-21431-6-git-send-email-serge@hallyn.com>
 <14652.1319014868@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14652.1319014868@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
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

Changelog:
Oct 23: Use a nice macro to make the code shorter and easier to read,
	per advice from Andrew Morgan and David Howells.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: David Howells <dhowells@redhat.com>
---
 drivers/block/drbd/drbd_nl.c           |    2 +-
 drivers/md/dm-log-userspace-transfer.c |    2 +-
 drivers/staging/pohmelfs/config.c      |    2 +-
 drivers/video/uvesafb.c                |    2 +-
 include/linux/cred.h                   |    2 ++
 5 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 0feab26..f799b15 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2297,7 +2297,7 @@ static void drbd_connector_callback(struct cn_msg *req, struct netlink_skb_parms
 		return;
 	}
 
-	if (!cap_raised(current_cap(), CAP_SYS_ADMIN)) {
+	if (!IN_ROOT_USER_NS() || !cap_raised(current_cap(), CAP_SYS_ADMIN)) {
 		retcode = ERR_PERM;
 		goto fail;
 	}
diff --git a/drivers/md/dm-log-userspace-transfer.c b/drivers/md/dm-log-userspace-transfer.c
index 1f23e04..126a79b 100644
--- a/drivers/md/dm-log-userspace-transfer.c
+++ b/drivers/md/dm-log-userspace-transfer.c
@@ -134,7 +134,7 @@ static void cn_ulog_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 {
 	struct dm_ulog_request *tfr = (struct dm_ulog_request *)(msg + 1);
 
-	if (!cap_raised(current_cap(), CAP_SYS_ADMIN))
+	if (!IN_ROOT_USER_NS() || !cap_raised(current_cap(), CAP_SYS_ADMIN))
 		return;
 
 	spin_lock(&receiving_list_lock);
diff --git a/drivers/staging/pohmelfs/config.c b/drivers/staging/pohmelfs/config.c
index b6c42cb..327c047 100644
--- a/drivers/staging/pohmelfs/config.c
+++ b/drivers/staging/pohmelfs/config.c
@@ -525,7 +525,7 @@ static void pohmelfs_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *n
 {
 	int err;
 
-	if (!cap_raised(current_cap(), CAP_SYS_ADMIN))
+	if (!IN_ROOT_USER_NS() || !cap_raised(current_cap(), CAP_SYS_ADMIN))
 		return;
 
 	switch (msg->flags) {
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 7f8472c..94e0e9d 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -73,7 +73,7 @@ static void uvesafb_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *ns
 	struct uvesafb_task *utask;
 	struct uvesafb_ktask *task;
 
-	if (!cap_raised(current_cap(), CAP_SYS_ADMIN))
+	if (!IN_ROOT_USER_NS() || !cap_raised(current_cap(), CAP_SYS_ADMIN))
 		return;
 
 	if (msg->seq >= UVESAFB_TASKS_MAX)
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 4030896..2f75da7 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -359,9 +359,11 @@ static inline void put_cred(const struct cred *_cred)
 
 #ifdef CONFIG_USER_NS
 #define current_user_ns() (current_cred_xxx(user_ns))
+#define IN_ROOT_USER_NS() (current_user_ns() == &init_user_ns)
 #else
 extern struct user_namespace init_user_ns;
 #define current_user_ns() (&init_user_ns)
+#define IN_ROOT_USER_NS() (1)
 #endif
 
 
-- 
1.7.5.4

