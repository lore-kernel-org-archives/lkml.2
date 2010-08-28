Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab0H1Bds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 21:33:48 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46669 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab0H1Bdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 21:33:46 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 4/4] AppArmor: Fix locking from removal of profile namespace
Date: Fri, 27 Aug 2010 18:33:29 -0700
Message-Id: <1282959209-5431-5-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282959209-5431-1-git-send-email-john.johansen@canonical.com>
References: <1282959209-5431-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The locking for profile namespace removal is wrong, when removing a
profile namespace, it needs to be removed from its parent's list.
Lock the parent of namespace list instead of the namespace being removed.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/policy.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 3cdc1ad..52cc865 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1151,12 +1151,14 @@ ssize_t aa_remove_profiles(char *fqname, size_t size)
 		/* released below */
 		ns = aa_get_namespace(root);
 
-	write_lock(&ns->lock);
 	if (!name) {
 		/* remove namespace - can only happen if fqname[0] == ':' */
+		write_lock(&ns->parent->lock);
 		__remove_namespace(ns);
+		write_unlock(&ns->parent->lock);
 	} else {
 		/* remove profile */
+		write_lock(&ns->lock);
 		profile = aa_get_profile(__lookup_profile(&ns->base, name));
 		if (!profile) {
 			error = -ENOENT;
@@ -1165,8 +1167,8 @@ ssize_t aa_remove_profiles(char *fqname, size_t size)
 		}
 		name = profile->base.hname;
 		__remove_profile(profile);
+		write_unlock(&ns->lock);
 	}
-	write_unlock(&ns->lock);
 
 	/* don't fail removal if audit fails */
 	(void) audit_policy(OP_PROF_RM, GFP_KERNEL, name, info, error);
-- 
1.7.0.4

