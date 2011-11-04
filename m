Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab1KDWYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 18:24:12 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:45259 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab1KDWYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 18:24:08 -0400
From: Serge Hallyn <serge@hallyn.com>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Cc: oleg@redhat.com, richard@nod.at, akpm@linux-foundation.org,
        ebiederm@xmission.com, serge@hallyn.com, dhowells@redhat.com,
        eparis@redhat.com, Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Miquel van Smoorenburg <mikevs@xs4all.net>
Subject: [PATCH 2/6] User namespace: don't allow sysctl in non-init user ns (v2)
Date: Fri,  4 Nov 2011 22:24:38 +0000
Message-Id: <1320445482-8459-3-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1320445482-8459-1-git-send-email-serge@hallyn.com>
References: <1320445482-8459-1-git-send-email-serge@hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge Hallyn <serge.hallyn@canonical.com>

sysctl.c has its own custom uid check, which is not user namespace
aware.  As discovered by Richard, that allows root in a container
privileged access to set all sysctls.

To fix that, don't compare uid or groups if current is not in the
initial user namespace.  We may at some point want to relax that check
so that some sysctls are allowed - for instance dmesg_restrict when
syslog is containerized.

Changelog:
Sep 22: As Miquel van Smoorenburg pointed out, rather than always
	refusing access if not in initial user_ns, we should allow
	world access rights to sysctl files.  We just want to prevent
	a task in a non-init user namespace from getting the root user
	or group access rights.

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: richard@nod.at
Cc: Miquel van Smoorenburg <mikevs@xs4all.net>
---
 kernel/sysctl.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ae27196..473df41 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1708,10 +1708,12 @@ void register_sysctl_root(struct ctl_table_root *root)
 
 static int test_perm(int mode, int op)
 {
-	if (!current_euid())
-		mode >>= 6;
-	else if (in_egroup_p(0))
-		mode >>= 3;
+	if (current_user_ns() == &init_user_ns) {
+		if (!current_euid())
+			mode >>= 6;
+		else if (in_egroup_p(0))
+			mode >>= 3;
+	}
 	if ((op & ~mode & (MAY_READ|MAY_WRITE|MAY_EXEC)) == 0)
 		return 0;
 	return -EACCES;
-- 
1.7.0.4

