Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030263Ab2B1TXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 14:23:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54966 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964782Ab2B1TXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 14:23:36 -0500
Date: Tue, 28 Feb 2012 11:23:04 -0800
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-a07f7672d7cf0ff0d6e548a9feb6e0bd016d9c6c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, matt.fleming@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, matt.fleming@intel.com
In-Reply-To: <1330436245-24875-2-git-send-email-matt@console-pimps.org>
References: <1330436245-24875-2-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] tools/include:
  Add byteshift headers for endian access
Git-Commit-ID: a07f7672d7cf0ff0d6e548a9feb6e0bd016d9c6c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 28 Feb 2012 11:23:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a07f7672d7cf0ff0d6e548a9feb6e0bd016d9c6c
Gitweb:     http://git.kernel.org/tip/a07f7672d7cf0ff0d6e548a9feb6e0bd016d9c6c
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Tue, 28 Feb 2012 13:37:20 +0000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 28 Feb 2012 10:22:51 -0800

tools/include: Add byteshift headers for endian access

There are various hostprogs in the kernel that are rolling their own
implementations of {get,put}_unaligned_le*(). Copy the byteshift
headers from include/linux/unaligned so that they can all use a single
implementation.

This requires changing some of the data types to the userspace
exported ones (u32 -> __u32, etc).

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1330436245-24875-2-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 tools/include/tools/be_byteshift.h |   70 ++++++++++++++++++++++++++++++++++++
 tools/include/tools/le_byteshift.h |   70 ++++++++++++++++++++++++++++++++++++
 2 files changed, 140 insertions(+), 0 deletions(-)

diff --git a/tools/include/tools/be_byteshift.h b/tools/include/tools/be_byteshift.h
new file mode 100644
index 0000000..f4912e2
--- /dev/null
+++ b/tools/include/tools/be_byteshift.h
@@ -0,0 +1,70 @@
+#ifndef _TOOLS_BE_BYTESHIFT_H
+#define _TOOLS_BE_BYTESHIFT_H
+
+#include <linux/types.h>
+
+static inline __u16 __get_unaligned_be16(const __u8 *p)
+{
+	return p[0] << 8 | p[1];
+}
+
+static inline __u32 __get_unaligned_be32(const __u8 *p)
+{
+	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
+}
+
+static inline __u64 __get_unaligned_be64(const __u8 *p)
+{
+	return (__u64)__get_unaligned_be32(p) << 32 |
+	       __get_unaligned_be32(p + 4);
+}
+
+static inline void __put_unaligned_be16(__u16 val, __u8 *p)
+{
+	*p++ = val >> 8;
+	*p++ = val;
+}
+
+static inline void __put_unaligned_be32(__u32 val, __u8 *p)
+{
+	__put_unaligned_be16(val >> 16, p);
+	__put_unaligned_be16(val, p + 2);
+}
+
+static inline void __put_unaligned_be64(__u64 val, __u8 *p)
+{
+	__put_unaligned_be32(val >> 32, p);
+	__put_unaligned_be32(val, p + 4);
+}
+
+static inline __u16 get_unaligned_be16(const void *p)
+{
+	return __get_unaligned_be16((const __u8 *)p);
+}
+
+static inline __u32 get_unaligned_be32(const void *p)
+{
+	return __get_unaligned_be32((const __u8 *)p);
+}
+
+static inline __u64 get_unaligned_be64(const void *p)
+{
+	return __get_unaligned_be64((const __u8 *)p);
+}
+
+static inline void put_unaligned_be16(__u16 val, void *p)
+{
+	__put_unaligned_be16(val, p);
+}
+
+static inline void put_unaligned_be32(__u32 val, void *p)
+{
+	__put_unaligned_be32(val, p);
+}
+
+static inline void put_unaligned_be64(__u64 val, void *p)
+{
+	__put_unaligned_be64(val, p);
+}
+
+#endif /* _TOOLS_BE_BYTESHIFT_H */
diff --git a/tools/include/tools/le_byteshift.h b/tools/include/tools/le_byteshift.h
new file mode 100644
index 0000000..c99d45a
--- /dev/null
+++ b/tools/include/tools/le_byteshift.h
@@ -0,0 +1,70 @@
+#ifndef _TOOLS_LE_BYTESHIFT_H
+#define _TOOLS_LE_BYTESHIFT_H
+
+#include <linux/types.h>
+
+static inline __u16 __get_unaligned_le16(const __u8 *p)
+{
+	return p[0] | p[1] << 8;
+}
+
+static inline __u32 __get_unaligned_le32(const __u8 *p)
+{
+	return p[0] | p[1] << 8 | p[2] << 16 | p[3] << 24;
+}
+
+static inline __u64 __get_unaligned_le64(const __u8 *p)
+{
+	return (__u64)__get_unaligned_le32(p + 4) << 32 |
+	       __get_unaligned_le32(p);
+}
+
+static inline void __put_unaligned_le16(__u16 val, __u8 *p)
+{
+	*p++ = val;
+	*p++ = val >> 8;
+}
+
+static inline void __put_unaligned_le32(__u32 val, __u8 *p)
+{
+	__put_unaligned_le16(val >> 16, p + 2);
+	__put_unaligned_le16(val, p);
+}
+
+static inline void __put_unaligned_le64(__u64 val, __u8 *p)
+{
+	__put_unaligned_le32(val >> 32, p + 4);
+	__put_unaligned_le32(val, p);
+}
+
+static inline __u16 get_unaligned_le16(const void *p)
+{
+	return __get_unaligned_le16((const __u8 *)p);
+}
+
+static inline __u32 get_unaligned_le32(const void *p)
+{
+	return __get_unaligned_le32((const __u8 *)p);
+}
+
+static inline __u64 get_unaligned_le64(const void *p)
+{
+	return __get_unaligned_le64((const __u8 *)p);
+}
+
+static inline void put_unaligned_le16(__u16 val, void *p)
+{
+	__put_unaligned_le16(val, p);
+}
+
+static inline void put_unaligned_le32(__u32 val, void *p)
+{
+	__put_unaligned_le32(val, p);
+}
+
+static inline void put_unaligned_le64(__u64 val, void *p)
+{
+	__put_unaligned_le64(val, p);
+}
+
+#endif /* _TOOLS_LE_BYTESHIFT_H */
