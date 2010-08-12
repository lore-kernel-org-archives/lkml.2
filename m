Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231Ab0HLPP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:15:57 -0400
Received: from adelie.canonical.com ([91.189.90.139]:52496 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab0HLPPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:15:55 -0400
Message-ID: <4C641024.5070006@canonical.com>
Date: Thu, 12 Aug 2010 11:15:48 -0400
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] apparmor: issue with ns name without a following profile
References: <20100807110639.GY9031@bicker>
In-Reply-To: <20100807110639.GY9031@bicker>
X-Enigmail-Version: 1.1.1
Content-Type: multipart/mixed;
 boundary="------------060605000509070104050402"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060605000509070104050402
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 08/07/2010 04:50 AM, Dan Carpenter wrote:
> If we have a ns name without a following profile then in the original
> code it did "*ns_name = &name[1];".  "name" is NULL so "*ns_name" is
> 0x1.  That isn't useful and could cause an oops when this function is
> called from aa_remove_profiles(). 
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Indeed.  I am sorry to say this case was not enabled in the test suite :(
However proposed patch is incorrect, in that it results in namespace
name that starts at &name[1].

I've attached two patches, the first fixes this issue, and the second
fixes a locking bug in namespace removal, for this case (ie. where
there is no profile name specified.

Thanks for catching this

John


--------------060605000509070104050402
Content-Type: text/x-diff;
 name="0001-AppArmor-Fix-splitting-an-fqname-into-separate-names.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-AppArmor-Fix-splitting-an-fqname-into-separate-names.pa";
 filename*1="tch"

>From 07abf5de857614c13449031b9ac9e06c8efb7765 Mon Sep 17 00:00:00 2001
From: John Johansen <john.johansen@canonical.com>
Date: Mon, 9 Aug 2010 08:53:51 -0400
Subject: [PATCH 1/2] AppArmor: Fix splitting an fqname into separate namespace and profile names

As per Dan Carpenter <error27@gmail.com>
  If we have a ns name without a following profile then in the original
  code it did "*ns_name = &name[1];".  "name" is NULL so "*ns_name" is
  0x1.  That isn't useful and could cause an oops when this function is
  called from aa_remove_profiles().

Beyond this the assignment of the namespace name was wrong in the case
where the profile name was provided as it was being set to &name[1]
after name  = skip_spaces(split + 1);

Move the ns_name assignment before updating name for the split and
also add skip_spaces, making the interface more robust.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/apparmor/lib.c b/security/apparmor/lib.c
index 6e85cdb..506d2ba 100644
--- a/security/apparmor/lib.c
+++ b/security/apparmor/lib.c
@@ -40,6 +40,7 @@ char *aa_split_fqname(char *fqname, char **ns_name)
 	*ns_name = NULL;
 	if (name[0] == ':') {
 		char *split = strchr(&name[1], ':');
+		*ns_name = skip_spaces(&name[1]);
 		if (split) {
 			/* overwrite ':' with \0 */
 			*split = 0;
@@ -47,7 +48,6 @@ char *aa_split_fqname(char *fqname, char **ns_name)
 		} else
 			/* a ns name without a following profile is allowed */
 			name = NULL;
-		*ns_name = &name[1];
 	}
 	if (name && *name == 0)
 		name = NULL;
-- 
1.7.1


--------------060605000509070104050402
Content-Type: text/x-diff;
 name="0002-AppArmor-Fix-locking-from-removal-of-profile-namespa.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-AppArmor-Fix-locking-from-removal-of-profile-namespa.pa";
 filename*1="tch"

>From 8109a95a05dd6e5349e43a2a6bb7149565cc886e Mon Sep 17 00:00:00 2001
From: John Johansen <john.johansen@canonical.com>
Date: Thu, 12 Aug 2010 07:49:12 -0400
Subject: [PATCH 2/2] AppArmor: Fix locking from removal of profile namespace

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
1.7.1


--------------060605000509070104050402--
