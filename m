Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493Ab0HEBh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 21:37:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58163 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab0HEBhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 21:37:54 -0400
Date: Thu, 5 Aug 2010 11:37:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: John Johansen <john.johansen@canonical.com>,
        James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the security-testing
 tree
Message-Id: <20100805113751.373dae0d.sfr@canb.auug.org.au>
In-Reply-To: <4C575D0C.9080203@canonical.com>
References: <20100802121601.363af4a9.sfr@canb.auug.org.au>
	<4C575D0C.9080203@canonical.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Mon, 02 Aug 2010 17:04:28 -0700 John Johansen <john.johansen@canonical.com> wrote:
>
> On 08/01/2010 07:16 PM, Stephen Rothwell wrote:
> > 
> > After merging the security-testing tree, today's linux-next build (x86_64
> > allmodconfig) failed like this (also some warnings ...):
> > 
> > security/apparmor/ipc.c: In function 'aa_ptrace':
> > security/apparmor/ipc.c:103: warning: initialization discards qualifiers from pointer target type
> > security/apparmor/domain.c: In function 'may_change_ptraced_domain':
> > security/apparmor/domain.c:73: warning: assignment discards qualifiers from pointer target type
> > security/apparmor/lsm.c:701: error: 'param_ops_aabool' undeclared here (not in a function)
> > security/apparmor/lsm.c:721: error: 'param_ops_aalockpolicy' undeclared here (not in a function)
> > security/apparmor/lsm.c:729: error: 'param_ops_aauint' undeclared here (not in a function)
> > 
> > Error caused by commit e0500000b50a50ec8cc9967001f3ed201b83cb36
> > ("AppArmor: LSM interface, and security module initialization")
> > interacting with commit 0685652df0929cec7d78efa85127f6eb34962132
> > ("param:param_ops") from the rr tree.
> > 
> > I applied the following merge fix patch:
> > 
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Mon, 2 Aug 2010 12:00:43 +1000
> > Subject: [PATCH] AppArmor: update for module_param_named API change
> > 
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> looks good, thanks Stephen
> 
> Signed-off-by: John Johansen <john.johansen@canonical.com>

The security-testing tree has been merged by Linus, so this patch can now
be added to the rr tree.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 2 Aug 2010 12:00:43 +1000
Subject: [PATCH] AppArmor: update for module_param_named API change

Fixes these build errors:
security/apparmor/lsm.c:701: error: 'param_ops_aabool' undeclared here (not in a function)
security/apparmor/lsm.c:721: error: 'param_ops_aalockpolicy' undeclared here (not in a function)
security/apparmor/lsm.c:729: error: 'param_ops_aauint' undeclared here (not in a function)

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: John Johansen <john.johansen@canonical.com>
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
