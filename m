Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab2FLW46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 18:56:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9001 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab2FLWy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 18:54:27 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=PEwD_rDiu7QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=pGLkceISAAAA:8 a=k7Q1rW-QWTxsl8EJ898A:9 a=EvKJbDF4Ut8A:10 a=Zh68SRI7RUMA:10 a=jEp0ucaQiEUA:10 a=CY6gl2JlH4YA:10 a=jbrJJM5MRmoA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=eOVO0nAAItXBF5A2:21 a=s2YU2Dbj3bYeS3At:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120612225425.937573870@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 12 Jun 2012 18:43:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: [RFC][PATCH 07/13 v2] ftrace: add ftrace_set_filter_ip() for address based filter
References: <20120612224327.426900129@goodmis.org>
Content-Disposition: inline; filename=0007-ftrace-add-ftrace_set_filter_ip-for-address-based-fi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Add a new filter update interface ftrace_set_filter_ip()
to set ftrace filter by ip address, not only glob pattern.

Link: http://lkml.kernel.org/r/20120605102808.27845.67952.stgit@localhost.localdomain

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    3 +++
 kernel/trace/ftrace.c  |   59 ++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 70b2c32..34ac110 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -297,6 +297,8 @@ struct dyn_ftrace {
 };
 
 int ftrace_force_update(void);
+int ftrace_set_filter_ip(struct ftrace_ops *ops, unsigned long ip,
+			 int remove, int reset);
 int ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
 		       int len, int reset);
 int ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
@@ -524,6 +526,7 @@ static inline int ftrace_text_reserved(void *start, void *end)
  */
 #define ftrace_regex_open(ops, flag, inod, file) ({ -ENODEV; })
 #define ftrace_set_early_filter(ops, buf, enable) do { } while (0)
+#define ftrace_set_filter_ip(ops, ip, remove, reset) ({ -ENODEV; })
 #define ftrace_set_filter(ops, buf, len, reset) ({ -ENODEV; })
 #define ftrace_set_notrace(ops, buf, len, reset) ({ -ENODEV; })
 #define ftrace_free_filter(ops) do { } while (0)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f6fc9d5..0a0da8b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3203,8 +3203,27 @@ ftrace_notrace_write(struct file *file, const char __user *ubuf,
 }
 
 static int
-ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
-		 int reset, int enable)
+ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
+{
+	struct ftrace_func_entry *entry;
+
+	if (!ftrace_location(ip))
+		return -EINVAL;
+
+	if (remove) {
+		entry = ftrace_lookup_ip(hash, ip);
+		if (!entry)
+			return -ENOENT;
+		free_hash_entry(hash, entry);
+		return 0;
+	}
+
+	return add_hash_entry(hash, ip);
+}
+
+static int
+ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
+		unsigned long ip, int remove, int reset, int enable)
 {
 	struct ftrace_hash **orig_hash;
 	struct ftrace_hash *hash;
@@ -3233,6 +3252,11 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
 		ret = -EINVAL;
 		goto out_regex_unlock;
 	}
+	if (ip) {
+		ret = ftrace_match_addr(hash, ip, remove);
+		if (ret < 0)
+			goto out_regex_unlock;
+	}
 
 	mutex_lock(&ftrace_lock);
 	ret = ftrace_hash_move(ops, enable, orig_hash, hash);
@@ -3249,6 +3273,37 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
 	return ret;
 }
 
+static int
+ftrace_set_addr(struct ftrace_ops *ops, unsigned long ip, int remove,
+		int reset, int enable)
+{
+	return ftrace_set_hash(ops, 0, 0, ip, remove, reset, enable);
+}
+
+/**
+ * ftrace_set_filter_ip - set a function to filter on in ftrace by address
+ * @ops - the ops to set the filter with
+ * @ip - the address to add to or remove from the filter.
+ * @remove - non zero to remove the ip from the filter
+ * @reset - non zero to reset all filters before applying this filter.
+ *
+ * Filters denote which functions should be enabled when tracing is enabled
+ * If @ip is NULL, it failes to update filter.
+ */
+int ftrace_set_filter_ip(struct ftrace_ops *ops, unsigned long ip,
+			 int remove, int reset)
+{
+	return ftrace_set_addr(ops, ip, remove, reset, 1);
+}
+EXPORT_SYMBOL_GPL(ftrace_set_filter_ip);
+
+static int
+ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
+		 int reset, int enable)
+{
+	return ftrace_set_hash(ops, buf, len, 0, 0, reset, enable);
+}
+
 /**
  * ftrace_set_filter - set a function to filter on in ftrace
  * @ops - the ops to set the filter with
-- 
1.7.10


