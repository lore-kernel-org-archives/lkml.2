Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab1EaSbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:31:44 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42730 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891Ab1EaSbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:31:43 -0400
Date: Tue, 31 May 2011 11:31:41 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] AppArmor: fix oops in apparmor_setprocattr
Message-ID: <20110531183141.GH19633@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When invalid parameters are passed to apparmor_setprocattr a NULL deref
oops occurs when it tries to record an audit message. This is because
it is passing NULL for the profile parameter for aa_audit. But aa_audit
now requires that the profile passed is not NULL.

Fix this by passing the current profile on the task that is trying to
setprocattr.

Signed-off-by: Kees Cook <kees@ubuntu.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/lsm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index ae3a698..ec1bcec 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -593,7 +593,8 @@ static int apparmor_setprocattr(struct task_struct *task, char *name,
 			sa.aad.op = OP_SETPROCATTR;
 			sa.aad.info = name;
 			sa.aad.error = -EINVAL;
-			return aa_audit(AUDIT_APPARMOR_DENIED, NULL, GFP_KERNEL,
+			return aa_audit(AUDIT_APPARMOR_DENIED,
+					__aa_current_profile(), GFP_KERNEL,
 					&sa, NULL);
 		}
 	} else if (strcmp(name, "exec") == 0) {
-- 
1.7.4.1


-- 
Kees Cook
Ubuntu Security Team
