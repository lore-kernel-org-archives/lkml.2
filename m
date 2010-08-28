Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab0H1Bdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 21:33:49 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46647 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab0H1Bdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 21:33:43 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 3/4] AppArmor: Fix splitting an fqname into separate namespace and profile names
Date: Fri, 27 Aug 2010 18:33:28 -0700
Message-Id: <1282959209-5431-4-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282959209-5431-1-git-send-email-john.johansen@canonical.com>
References: <1282959209-5431-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.7.0.4

