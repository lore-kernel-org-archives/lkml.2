Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934693Ab1IOTsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 15:48:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33437 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934532Ab1IOTsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 15:48:18 -0400
Date: Thu, 15 Sep 2011 14:48:12 -0500
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Containers <containers@lists.osdl.org>,
        Andrew Morton <akpm@osdl.org>, Vasiliy Kulikov <segoon@openwall.com>,
        richard@nod.at
Subject: [PATCH] User namespace: don't allow sysctl in non-init user ns
Message-ID: <20110915194812.GA24348@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysctl.c has its own custom uid check, which is not user namespace
aware.  As discovered by Richard, that allows root in a container
privileged access to set all sysctls.

To fix that, just refuse access if current is not in init_user_ns.  We
may at some point want to relax that check so that some sysctls are
allowed - for instance dmesg_restrict when syslog is containerized.

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: richard@nod.at
---
 kernel/sysctl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 11d65b5..f2b42e2 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1697,6 +1697,8 @@ void register_sysctl_root(struct ctl_table_root *root)
 
 static int test_perm(int mode, int op)
 {
+	if (current_user_ns() != &init_user_ns)
+		return -EACCES;
 	if (!current_euid())
 		mode >>= 6;
 	else if (in_egroup_p(0))
-- 
1.7.5.4

