Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab1IBUAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 16:00:40 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:39501 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755223Ab1IBTz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 15:55:59 -0400
From: Serge Hallyn <serge@hallyn.com>
To: akpm@osdl.org, segooon@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        dhowells@redhat.com, ebiederm@xmission.com, rdunlap@xenotime.net
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: [PATCH 03/15] keyctl: check capabilities against key's user_ns
Date: Fri,  2 Sep 2011 19:56:28 +0000
Message-Id: <1314993400-6910-6-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314993400-6910-1-git-send-email-serge@hallyn.com>
References: <1314993400-6910-1-git-send-email-serge@hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Serge E. Hallyn" <serge.hallyn@canonical.com>

ATM, task should only be able to get his own user_ns's keys
anyway, so nsown_capable should also work, but there is no
advantage to doing that, while using key's user_ns is clearer.

changelog: jun 6:
	compile fix: keyctl.c (key_user, not key has user_ns)

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 security/keys/keyctl.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index eca5191..fa7d420 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -745,7 +745,7 @@ long keyctl_chown_key(key_serial_t id, uid_t uid, gid_t gid)
 	ret = -EACCES;
 	down_write(&key->sem);
 
-	if (!capable(CAP_SYS_ADMIN)) {
+	if (!ns_capable(key->user->user_ns, CAP_SYS_ADMIN)) {
 		/* only the sysadmin can chown a key to some other UID */
 		if (uid != (uid_t) -1 && key->uid != uid)
 			goto error_put;
@@ -852,7 +852,8 @@ long keyctl_setperm_key(key_serial_t id, key_perm_t perm)
 	down_write(&key->sem);
 
 	/* if we're not the sysadmin, we can only change a key that we own */
-	if (capable(CAP_SYS_ADMIN) || key->uid == current_fsuid()) {
+	if (ns_capable(key->user->user_ns, CAP_SYS_ADMIN) ||
+	    key->uid == current_fsuid()) {
 		key->perm = perm;
 		ret = 0;
 	}
-- 
1.7.5.4

