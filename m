Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab0HBCQJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 22:16:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59438 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab0HBCQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 22:16:05 -0400
Date: Mon, 2 Aug 2010 12:16:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Johansen <john.johansen@canonical.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: linux-next: build failure after merge of the security-testing tree
Message-Id: <20100802121601.363af4a9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

After merging the security-testing tree, today's linux-next build (x86_64
allmodconfig) failed like this (also some warnings ...):

security/apparmor/ipc.c: In function 'aa_ptrace':
security/apparmor/ipc.c:103: warning: initialization discards qualifiers from pointer target type
security/apparmor/domain.c: In function 'may_change_ptraced_domain':
security/apparmor/domain.c:73: warning: assignment discards qualifiers from pointer target type
security/apparmor/lsm.c:701: error: 'param_ops_aabool' undeclared here (not in a function)
security/apparmor/lsm.c:721: error: 'param_ops_aalockpolicy' undeclared here (not in a function)
security/apparmor/lsm.c:729: error: 'param_ops_aauint' undeclared here (not in a function)

Error caused by commit e0500000b50a50ec8cc9967001f3ed201b83cb36
("AppArmor: LSM interface, and security module initialization")
interacting with commit 0685652df0929cec7d78efa85127f6eb34962132
("param:param_ops") from the rr tree.

I applied the following merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 2 Aug 2010 12:00:43 +1000
Subject: [PATCH] AppArmor: update for module_param_named API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 security/apparmor/lsm.c |   36 ++++++++++++++++++++++++------------
 1 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 8db33a8..d5666d3 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -667,17 +667,29 @@ static struct security_operations apparmor_ops = {
  * AppArmor sysfs module parameters
  */
 
-static int param_set_aabool(const char *val, struct kernel_param *kp);
-static int param_get_aabool(char *buffer, struct kernel_param *kp);
+static int param_set_aabool(const char *val, const struct kernel_param *kp);
+static int param_get_aabool(char *buffer, const struct kernel_param *kp);
 #define param_check_aabool(name, p) __param_check(name, p, int)
+static struct kernel_param_ops param_ops_aabool = {
+	.set = param_set_aabool,
+	.get = param_get_aabool
+};
 
-static int param_set_aauint(const char *val, struct kernel_param *kp);
-static int param_get_aauint(char *buffer, struct kernel_param *kp);
+static int param_set_aauint(const char *val, const struct kernel_param *kp);
+static int param_get_aauint(char *buffer, const struct kernel_param *kp);
 #define param_check_aauint(name, p) __param_check(name, p, int)
+static struct kernel_param_ops param_ops_aauint = {
+	.set = param_set_aauint,
+	.get = param_get_aauint
+};
 
-static int param_set_aalockpolicy(const char *val, struct kernel_param *kp);
-static int param_get_aalockpolicy(char *buffer, struct kernel_param *kp);
+static int param_set_aalockpolicy(const char *val, const struct kernel_param *kp);
+static int param_get_aalockpolicy(char *buffer, const struct kernel_param *kp);
 #define param_check_aalockpolicy(name, p) __param_check(name, p, int)
+static struct kernel_param_ops param_ops_aalockpolicy = {
+	.set = param_set_aalockpolicy,
+	.get = param_get_aalockpolicy
+};
 
 static int param_set_audit(const char *val, struct kernel_param *kp);
 static int param_get_audit(char *buffer, struct kernel_param *kp);
@@ -751,7 +763,7 @@ static int __init apparmor_enabled_setup(char *str)
 __setup("apparmor=", apparmor_enabled_setup);
 
 /* set global flag turning off the ability to load policy */
-static int param_set_aalockpolicy(const char *val, struct kernel_param *kp)
+static int param_set_aalockpolicy(const char *val, const struct kernel_param *kp)
 {
 	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
@@ -760,35 +772,35 @@ static int param_set_aalockpolicy(const char *val, struct kernel_param *kp)
 	return param_set_bool(val, kp);
 }
 
-static int param_get_aalockpolicy(char *buffer, struct kernel_param *kp)
+static int param_get_aalockpolicy(char *buffer, const struct kernel_param *kp)
 {
 	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
 	return param_get_bool(buffer, kp);
 }
 
-static int param_set_aabool(const char *val, struct kernel_param *kp)
+static int param_set_aabool(const char *val, const struct kernel_param *kp)
 {
 	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
 	return param_set_bool(val, kp);
 }
 
-static int param_get_aabool(char *buffer, struct kernel_param *kp)
+static int param_get_aabool(char *buffer, const struct kernel_param *kp)
 {
 	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
 	return param_get_bool(buffer, kp);
 }
 
-static int param_set_aauint(const char *val, struct kernel_param *kp)
+static int param_set_aauint(const char *val, const struct kernel_param *kp)
 {
 	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
 	return param_set_uint(val, kp);
 }
 
-static int param_get_aauint(char *buffer, struct kernel_param *kp)
+static int param_get_aauint(char *buffer, const struct kernel_param *kp)
 {
 	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
