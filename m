Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab2IMXwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 19:52:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759196Ab2IMXt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 19:49:58 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 12/16] X.509: Add utility functions to render OIDs as strings
To: herbert@gondor.hengli.com.au, rusty@rustcorp.com.au
Cc: linux-crypto@vger.kernel.org, zohar@us.ibm.com, dmitry.kasatkin@intel.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 14 Sep 2012 00:49:47 +0100
Message-ID: <20120913234947.3575.9661.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120913234802.3575.77103.stgit@warthog.procyon.org.uk>
References: <20120913234802.3575.77103.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a pair of utility functions to render OIDs as strings.  The first takes an
encoded OID and turns it into a "a.b.c.d" form string:

	int sprint_oid(const void *data, size_t datasize,
		       char *buffer, size_t bufsize);

The second takes an OID enum index and calls the first on the data held
therein:

	int sprint_OID(enum OID oid, char *buffer, size_t bufsize);

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/oid_registry.h |    2 +
 lib/oid_registry.c           |   81 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+)


diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
index 5928546..6926db7 100644
--- a/include/linux/oid_registry.h
+++ b/include/linux/oid_registry.h
@@ -86,5 +86,7 @@ enum OID {
 };
 
 extern enum OID look_up_OID(const void *data, size_t datasize);
+extern int sprint_oid(const void *, size_t, char *, size_t);
+extern int sprint_OID(enum OID, char *, size_t);
 
 #endif /* _LINUX_OID_REGISTRY_H */
diff --git a/lib/oid_registry.c b/lib/oid_registry.c
index 33cfd17..d8de11f 100644
--- a/lib/oid_registry.c
+++ b/lib/oid_registry.c
@@ -11,6 +11,9 @@
 
 #include <linux/export.h>
 #include <linux/oid_registry.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/bug.h>
 #include "oid_registry_data.c"
 
 /**
@@ -87,3 +90,81 @@ enum OID look_up_OID(const void *data, size_t datasize)
 	return OID__NR;
 }
 EXPORT_SYMBOL_GPL(look_up_OID);
+
+/*
+ * sprint_OID - Print an Object Identifier into a buffer
+ * @data: The encoded OID to print
+ * @datasize: The size of the encoded OID
+ * @buffer: The buffer to render into
+ * @bufsize: The size of the buffer
+ *
+ * The OID is rendered into the buffer in "a.b.c.d" format and the number of
+ * bytes is returned.  -EBADMSG is returned if the data could not be intepreted
+ * and -ENOBUFS if the buffer was too small.
+ */
+int sprint_oid(const void *data, size_t datasize, char *buffer, size_t bufsize)
+{
+	const unsigned char *v = data, *end = v + datasize;
+	unsigned long num;
+	unsigned char n;
+	size_t ret;
+	int count;
+
+	if (v >= end)
+		return -EBADMSG;
+
+	n = *v++;
+	ret = count = snprintf(buffer, bufsize, "%u.%u", n / 40, n % 40);
+	buffer += count;
+	bufsize -= count;
+	if (bufsize == 0)
+		return -ENOBUFS;
+
+	while (v < end) {
+		num = 0;
+		n = *v++;
+		if (!(n & 0x80)) {
+			num = n;
+		} else {
+			num = n & 0x7f;
+			do {
+				if (v >= end)
+					return -EBADMSG;
+				n = *v++;
+				num <<= 7;
+				num |= n & 0x7f;
+			} while (n & 0x80);
+		}
+		ret += count = snprintf(buffer, bufsize, ".%lu", num);
+		buffer += count;
+		bufsize -= count;
+		if (bufsize == 0)
+			return -ENOBUFS;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sprint_oid);
+
+/**
+ * sprint_OID - Print an Object Identifier into a buffer
+ * @oid: The OID to print
+ * @buffer: The buffer to render into
+ * @bufsize: The size of the buffer
+ *
+ * The OID is rendered into the buffer in "a.b.c.d" format and the number of
+ * bytes is returned.
+ */
+int sprint_OID(enum OID oid, char *buffer, size_t bufsize)
+{
+	int ret;
+
+	BUG_ON(oid >= OID__NR);
+
+	ret = sprint_oid(oid_data + oid_index[oid],
+			 oid_index[oid + 1] - oid_index[oid],
+			 buffer, bufsize);
+	BUG_ON(ret == -EBADMSG);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sprint_OID);

