Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab2KTMrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:47:08 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:51199 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab2KTMrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:47:02 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Tue, 20 Nov 2012 04:43:39 -0800
Message-Id: <1353415420-5457-11-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353415420-5457-1-git-send-email-ebiederm@xmission.com>
References: <87pq38wimv.fsf@xmission.com>
 <1353415420-5457-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX18anMuoKDBzBO86CjYNwFbs4tdSFpfOXQQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0045]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH RFC 11/12] userns: Now that everything has been converted remove the unnecessary infrastructure
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

In particular kill UIDGID_CONVERTED and UIDGID_STRICT_TYPE_CHECKS
and have the code treat them as always true.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/posix_acl.h |    3 ---
 include/linux/projid.h    |   15 ---------------
 include/linux/uidgid.h    |   22 ----------------------
 init/Kconfig              |   23 -----------------------
 4 files changed, 0 insertions(+), 63 deletions(-)

diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 7931efe..f0f7746 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -39,9 +39,6 @@ struct posix_acl_entry {
 	union {
 		kuid_t		e_uid;
 		kgid_t		e_gid;
-#ifndef CONFIG_UIDGID_STRICT_TYPE_CHECKS
-		unsigned int	e_id;
-#endif
 	};
 };
 
diff --git a/include/linux/projid.h b/include/linux/projid.h
index 36517b9..8c1f2c5 100644
--- a/include/linux/projid.h
+++ b/include/linux/projid.h
@@ -18,8 +18,6 @@ extern struct user_namespace init_user_ns;
 
 typedef __kernel_uid32_t projid_t;
 
-#ifdef CONFIG_UIDGID_STRICT_TYPE_CHECKS
-
 typedef struct {
 	projid_t val;
 } kprojid_t;
@@ -31,19 +29,6 @@ static inline projid_t __kprojid_val(kprojid_t projid)
 
 #define KPROJIDT_INIT(value) (kprojid_t){ value }
 
-#else
-
-typedef projid_t kprojid_t;
-
-static inline projid_t __kprojid_val(kprojid_t projid)
-{
-	return projid;
-}
-
-#define KPROJIDT_INIT(value) ((kprojid_t) value )
-
-#endif
-
 #define INVALID_PROJID KPROJIDT_INIT(-1)
 #define OVERFLOW_PROJID 65534
 
diff --git a/include/linux/uidgid.h b/include/linux/uidgid.h
index 8e522cbc..2d1f9b6 100644
--- a/include/linux/uidgid.h
+++ b/include/linux/uidgid.h
@@ -17,8 +17,6 @@
 struct user_namespace;
 extern struct user_namespace init_user_ns;
 
-#ifdef CONFIG_UIDGID_STRICT_TYPE_CHECKS
-
 typedef struct {
 	uid_t val;
 } kuid_t;
@@ -41,26 +39,6 @@ static inline gid_t __kgid_val(kgid_t gid)
 	return gid.val;
 }
 
-#else
-
-typedef uid_t kuid_t;
-typedef gid_t kgid_t;
-
-static inline uid_t __kuid_val(kuid_t uid)
-{
-	return uid;
-}
-
-static inline gid_t __kgid_val(kgid_t gid)
-{
-	return gid;
-}
-
-#define KUIDT_INIT(value) ((kuid_t) value )
-#define KGIDT_INIT(value) ((kgid_t) value )
-
-#endif
-
 #define GLOBAL_ROOT_UID KUIDT_INIT(0)
 #define GLOBAL_ROOT_GID KGIDT_INIT(0)
 
diff --git a/init/Kconfig b/init/Kconfig
index fb5e192..6c93bd8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -963,9 +963,6 @@ config IPC_NS
 config USER_NS
 	bool "User namespace (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
-	depends on UIDGID_CONVERTED
-	select UIDGID_STRICT_TYPE_CHECKS
-
 	default n
 	help
 	  This allows containers, i.e. vservers, to use user namespaces
@@ -990,26 +987,6 @@ config NET_NS
 
 endif # NAMESPACES
 
-config UIDGID_CONVERTED
-	# True if all of the selected software conmponents are known
-	# to have uid_t and gid_t converted to kuid_t and kgid_t
-	# where appropriate and are otherwise safe to use with
-	# the user namespace.
-	bool
-	default y
-
-	# Filesystems
-
-config UIDGID_STRICT_TYPE_CHECKS
-	bool "Require conversions between uid/gids and their internal representation"
-	depends on UIDGID_CONVERTED
-	default n
-	help
-	 While the nececessary conversions are being added to all subsystems this option allows
-	 the code to continue to build for unconverted subsystems.
-
-	 Say Y here if you want the strict type checking enabled
-
 config SCHED_AUTOGROUP
 	bool "Automatic process group scheduling"
 	select EVENTFD
-- 
1.7.5.4

