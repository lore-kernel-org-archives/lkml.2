Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab0KZPTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:19:01 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42494 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab0KZPS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:18:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=qfWRSTexiqBjhYkMDWi/d0c0x+bTlvZznVj53TLS0wp/5doC3WQfwXriPAOWFrFnQK
         bmnaCWVfoK36coVZWzdBBugAtsr8wpYxi3iPSEoV/2qAK6WLXcqzMY2E1mfVNgnML9U+
         auqWhO4qC6XIdVL0dVzaK9McOKOOXB8PiQSF4=
Date: Fri, 26 Nov 2010 23:18:47 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: john.johansen@canonical.com, apparmor@lists.ubuntu.com,
        linux-security-module@vger.kernel.org
Subject: [PATCH] APPARMOR: Fix NULL Pointer dereference while __add_new_profile
Message-ID: <20101126151847.GA2721@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In aa_replace_profiles(), if __lookup_parent() path failed, policy is set 
to NULL and goto audit label, old_profile and rename_profile are both NULL,
__add_new_profile is called, the parameter policy is NULL, it will cause
NULL pointer dereference via __list_add_profile(&policy->profiles, profile);

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 security/apparmor/policy.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 52cc865..832d9e9 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -940,6 +940,8 @@ static int replacement_allowed(struct aa_profile *profile, int noreplace,
 static void __add_new_profile(struct aa_namespace *ns, struct aa_policy *policy,
 			      struct aa_profile *profile)
 {
+	if (!policy)
+		return ;
 	if (policy != &ns->base)
 		/* released on profile replacement or free_profile */
 		profile->parent = aa_get_profile((struct aa_profile *) policy);
-- 
1.6.5.3

