Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab0KYRSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 12:18:20 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:45806
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752802Ab0KYRST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 12:18:19 -0500
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Nov 2010 12:18:19 EST
Date: Thu, 25 Nov 2010 17:11:32 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: Eric Paris <eparis@redhat.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        "Christopher J. PeBenito" <cpebenito@tresys.com>
Subject: [PATCH 1/1] Define CAP_SYSLOG
Message-ID: <20101125171132.GA25703@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Privileged syslog operations currently require CAP_SYS_ADMIN.  Split
this off into a new CAP_SYSLOG privilege which we can sanely take away
from a container through the capability bounding set.

With this patch, an lxc container can be prevented from messing with
the host's syslog (i.e. dmesg -c).

Changelog: mar 12 2010: add selinux capability2:cap_syslog perm
Changelog: nov 22 2010:
	. port to new kernel
	. add a WARN_ONCE if userspace isn't using CAP_SYSLOG

Signed-off-by: Serge Hallyn <serge.hallyn@ubuntu.com>
Acked-by: Andrew G. Morgan <morgan@kernel.org>
Acked-By: Kees Cook <kees.cook@canonical.com>
Cc: James Morris <jmorris@namei.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: "Christopher J. PeBenito" <cpebenito@tresys.com>
Cc: Eric Paris <eparis@parisplace.org>
---
 include/linux/capability.h          |    7 +++++--
 kernel/printk.c                     |    8 +++++++-
 security/selinux/include/classmap.h |    2 +-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 90012b9..fb16a36 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -246,7 +246,6 @@ struct cpu_vfs_cap_data {
 /* Allow configuration of the secure attention key */
 /* Allow administration of the random device */
 /* Allow examination and configuration of disk quotas */
-/* Allow configuring the kernel's syslog (printk behaviour) */
 /* Allow setting the domainname */
 /* Allow setting the hostname */
 /* Allow calling bdflush() */
@@ -352,7 +351,11 @@ struct cpu_vfs_cap_data {
 
 #define CAP_MAC_ADMIN        33
 
-#define CAP_LAST_CAP         CAP_MAC_ADMIN
+/* Allow configuring the kernel's syslog (printk behaviour) */
+
+#define CAP_SYSLOG           34
+
+#define CAP_LAST_CAP         CAP_SYSLOG
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
diff --git a/kernel/printk.c b/kernel/printk.c
index 9a2264f..111cdc2 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -283,8 +283,14 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 			return -EPERM;
 		if ((type != SYSLOG_ACTION_READ_ALL &&
 		     type != SYSLOG_ACTION_SIZE_BUFFER) &&
-		    !capable(CAP_SYS_ADMIN))
+		    !capable(CAP_SYSLOG)) {
+			/* remove after 2.6.28 */
+			if (capable(CAP_SYS_ADMIN))
+				WARN_ONCE(1, "Attempt to access syslog with "
+				  "CAP_SYS_ADMIN but no CAP_SYSLOG "
+				  "(deprecated and denied).\n");
 			return -EPERM;
+		}
 	}
 
 	error = security_syslog(type);
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 8858d2b..7ed3663 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -142,7 +142,7 @@ struct security_class_mapping secclass_map[] = {
 	    "node_bind", "name_connect", NULL } },
 	{ "memprotect", { "mmap_zero", NULL } },
 	{ "peer", { "recv", NULL } },
-	{ "capability2", { "mac_override", "mac_admin", NULL } },
+	{ "capability2", { "mac_override", "mac_admin", "syslog", NULL } },
 	{ "kernel_service", { "use_as_override", "create_files_as", NULL } },
 	{ "tun_socket",
 	  { COMMON_SOCK_PERMS, NULL } },
-- 
1.7.0.4

