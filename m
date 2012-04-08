Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab2DHFUI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:20:08 -0400
Received: from out08.mta.xmission.com ([166.70.13.238]:56919 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752618Ab2DHFMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 01:12:20 -0400
From: "\"Eric W. Beiderman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat,  7 Apr 2012 22:15:09 -0700
Message-Id: <1333862139-31737-13-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19fgzGZVBHBaJytJ0jREb1CIYG8dpEsYaU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 13/43] userns: Add kuid_t and kgid_t and associated infrastructure in uidgid.h
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Start distinguishing between internal kernel uids and gids and
values that userspace can use.  This is done by introducing two
new types: kuid_t and kgid_t.  These types and their associated
functions are infrastructure are declared in the new header
uidgid.h.

Ultimately there will be a different implementation of the mapping
functions for use with user namespaces.  But to keep it simple
we introduce the mapping functions first to separate the meat
from the mechanical code conversions.

Export overflowuid and overflowgid so we can use from_kuid_munged
and from_kgid_munged in modular code.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/uidgid.h |  176 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sys.c           |    2 -
 2 files changed, 176 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/uidgid.h

diff --git a/include/linux/uidgid.h b/include/linux/uidgid.h
new file mode 100644
index 0000000..a0addb8
--- /dev/null
+++ b/include/linux/uidgid.h
@@ -0,0 +1,176 @@
+#ifndef _LINUX_UIDGID_H
+#define _LINUX_UIDGID_H
+
+/*
+ * A set of types for the internal kernel types representing uids and gids.
+ *
+ * The types defined in this header allow distinguishing which uids and gids in
+ * the kernel are values used by userspace and which uid and gid values are
+ * the internal kernel values.  With the addition of user namespaces the values
+ * can be different.  Using the type system makes it possible for the compiler
+ * to detect when we overlook these differences.
+ *
+ */
+#include <linux/types.h>
+#include <linux/highuid.h>
+
+struct user_namespace;
+extern struct user_namespace init_user_ns;
+
+#if defined(NOTYET)
+
+typedef struct {
+	uid_t val;
+} kuid_t;
+
+
+typedef struct {
+	gid_t val;
+} kgid_t;
+
+#define KUIDT_INIT(value) (kuid_t){ value }
+#define KGIDT_INIT(value) (kgid_t){ value }
+
+static inline uid_t __kuid_val(kuid_t uid)
+{
+	return uid.val;
+}
+
+static inline gid_t __kgid_val(kgid_t gid)
+{
+	return gid.val;
+}
+
+#else
+
+typedef uid_t kuid_t;
+typedef gid_t kgid_t;
+
+static inline uid_t __kuid_val(kuid_t uid)
+{
+	return uid;
+}
+
+static inline gid_t __kgid_val(kgid_t gid)
+{
+	return gid;
+}
+
+#define KUIDT_INIT(value) ((kuid_t) value )
+#define KGIDT_INIT(value) ((kgid_t) value )
+
+#endif
+
+#define GLOBAL_ROOT_UID KUIDT_INIT(0)
+#define GLOBAL_ROOT_GID KGIDT_INIT(0)
+
+#define INVALID_UID KUIDT_INIT(-1)
+#define INVALID_GID KGIDT_INIT(-1)
+
+static inline bool uid_eq(kuid_t left, kuid_t right)
+{
+	return __kuid_val(left) == __kuid_val(right);
+}
+
+static inline bool gid_eq(kgid_t left, kgid_t right)
+{
+	return __kgid_val(left) == __kgid_val(right);
+}
+
+static inline bool uid_gt(kuid_t left, kuid_t right)
+{
+	return __kuid_val(left) > __kuid_val(right);
+}
+
+static inline bool gid_gt(kgid_t left, kgid_t right)
+{
+	return __kgid_val(left) > __kgid_val(right);
+}
+
+static inline bool uid_gte(kuid_t left, kuid_t right)
+{
+	return __kuid_val(left) >= __kuid_val(right);
+}
+
+static inline bool gid_gte(kgid_t left, kgid_t right)
+{
+	return __kgid_val(left) >= __kgid_val(right);
+}
+
+static inline bool uid_lt(kuid_t left, kuid_t right)
+{
+	return __kuid_val(left) < __kuid_val(right);
+}
+
+static inline bool gid_lt(kgid_t left, kgid_t right)
+{
+	return __kgid_val(left) < __kgid_val(right);
+}
+
+static inline bool uid_lte(kuid_t left, kuid_t right)
+{
+	return __kuid_val(left) <= __kuid_val(right);
+}
+
+static inline bool gid_lte(kgid_t left, kgid_t right)
+{
+	return __kgid_val(left) <= __kgid_val(right);
+}
+
+static inline bool uid_valid(kuid_t uid)
+{
+	return !uid_eq(uid, INVALID_UID);
+}
+
+static inline bool gid_valid(kgid_t gid)
+{
+	return !gid_eq(gid, INVALID_GID);
+}
+
+static inline kuid_t make_kuid(struct user_namespace *from, uid_t uid)
+{
+	return KUIDT_INIT(uid);
+}
+
+static inline kgid_t make_kgid(struct user_namespace *from, gid_t gid)
+{
+	return KGIDT_INIT(gid);
+}
+
+static inline uid_t from_kuid(struct user_namespace *to, kuid_t kuid)
+{
+	return __kuid_val(kuid);
+}
+
+static inline gid_t from_kgid(struct user_namespace *to, kgid_t kgid)
+{
+	return __kgid_val(kgid);
+}
+
+static inline uid_t from_kuid_munged(struct user_namespace *to, kuid_t kuid)
+{
+	uid_t uid = from_kuid(to, kuid);
+	if (uid == (uid_t)-1)
+		uid = overflowuid;
+	return uid;
+}
+
+static inline gid_t from_kgid_munged(struct user_namespace *to, kgid_t kgid)
+{
+	gid_t gid = from_kgid(to, kgid);
+	if (gid == (gid_t)-1)
+		gid = overflowgid;
+	return gid;
+}
+
+static inline bool kuid_has_mapping(struct user_namespace *ns, kuid_t uid)
+{
+	return true;
+}
+
+static inline bool kgid_has_mapping(struct user_namespace *ns, kgid_t gid)
+{
+	return true;
+}
+
+#endif /* _LINUX_UIDGID_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 82d8714..7185241 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -93,10 +93,8 @@
 int overflowuid = DEFAULT_OVERFLOWUID;
 int overflowgid = DEFAULT_OVERFLOWGID;
 
-#ifdef CONFIG_UID16
 EXPORT_SYMBOL(overflowuid);
 EXPORT_SYMBOL(overflowgid);
-#endif
 
 /*
  * the same as above, but for filesystems which can only store a 16-bit
-- 
1.7.2.5

