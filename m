Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab1IWBjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 21:39:08 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:54963 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754681Ab1IWBjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 21:39:06 -0400
Date: Fri, 23 Sep 2011 01:40:31 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: Miquel van Smoorenburg <mikevs@xs4all.net>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, richard@nod.at,
        akpm@linux-foundation.org
Subject: [PATCH] User namespace: don't allow sysctl in non-init user ns (v2)
Message-ID: <20110923014031.GA27781@hallyn.com>
References: <xs4all.20110915194812.GA24348@sergelap>
 <1316598367.5939.12.camel@n2o.xs4all.nl>
 <20110921131514.GA2979@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921131514.GA2979@sergelap>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 11d65b5..95988dc 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1697,10 +1697,12 @@ void register_sysctl_root(struct ctl_table_root *root)
 
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

