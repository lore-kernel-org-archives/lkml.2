Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab0DUB2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 21:28:20 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:37061 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab0DUB2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 21:28:17 -0400
Date: Tue, 20 Apr 2010 20:28:15 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, Ashwin Ganti <ashwin.ganti@gmail.com>,
       Greg KH <greg@kroah.com>, rsc@swtch.com, ericvh@gmail.com,
       linux-security-module@vger.kernel.org, Ron Minnich <rminnich@gmail.com>,
       jt.beard@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com,
       Eric Paris <eparis@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 2/3] p9auth: add CAP_GRANT_ID to authorize use of
 /dev/caphash
Message-ID: <20100421012815.GA24251@us.ibm.com>
References: <20100421012749.GA21338@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421012749.GA21338@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Granting userid capabilities to another task is a dangerous
privilege.  Don't just let file permissions authorize it.
Define CAP_GRANT_ID as a new capability needed to write to
/dev/caphash.

For one thing this lets us start a factotum server early on
in init, then have init drop CAP_GRANT_ID from its bounding
set so the rest of the system cannot regain it.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 include/linux/capability.h          |    6 +++++-
 security/selinux/include/classmap.h |    2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 39e5ff5..ba2cbfe 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -355,7 +355,11 @@ struct cpu_vfs_cap_data {
 
 #define CAP_MAC_ADMIN        33
 
-#define CAP_LAST_CAP         CAP_MAC_ADMIN
+/* Allow granting setuid capabilities through p9auth /dev/caphash */
+
+#define CAP_GRANT_ID         34
+
+#define CAP_LAST_CAP         CAP_GRANT_ID
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 8b32e95..f0ec53a 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -142,7 +142,7 @@ struct security_class_mapping secclass_map[] = {
 	    "node_bind", "name_connect", NULL } },
 	{ "memprotect", { "mmap_zero", NULL } },
 	{ "peer", { "recv", NULL } },
-	{ "capability2", { "mac_override", "mac_admin", NULL } },
+	{ "capability2", { "mac_override", "mac_admin", "grant_id", NULL } },
 	{ "kernel_service", { "use_as_override", "create_files_as", NULL } },
 	{ "tun_socket",
 	  { COMMON_SOCK_PERMS, NULL } },
-- 
1.7.0.4

