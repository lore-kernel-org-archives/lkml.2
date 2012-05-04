Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab2EDUqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:46:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34670 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759706Ab2EDUqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:46:25 -0400
Message-Id: <20120504204228.477486913@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [ 48/75] tools/include: Add byteshift headers for endian access
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <matt.fleming@intel.com>

commit a07f7672d7cf0ff0d6e548a9feb6e0bd016d9c6c upstream.

There are various hostprogs in the kernel that are rolling their own
implementations of {get,put}_unaligned_le*(). Copy the byteshift
headers from include/linux/unaligned so that they can all use a single
implementation.

This requires changing some of the data types to the userspace
exported ones (u32 -> __u32, etc).

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1330436245-24875-2-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/include/tools/be_byteshift.h |   70 +++++++++++++++++++++++++++++++++++++
 tools/include/tools/le_byteshift.h |   70 +++++++++++++++++++++++++++++++++++++
 2 files changed, 140 insertions(+)

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


