Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab2E2MtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 08:49:18 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38826 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab2E2MtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 08:49:14 -0400
X-AuditID: b753bd60-903faba000003d24-82-4fc4c5c72d8f
X-AuditID: b753bd60-903faba000003d24-82-4fc4c5c72d8f
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [RFC PATCH -tip 4/9] ftrace: add ftrace_set_filter_ip() for address
 based filter
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 29 May 2012 21:49:19 +0900
Message-ID: <20120529124919.9191.26520.stgit@localhost.localdomain>
In-Reply-To: <20120529124833.9191.23007.stgit@localhost.localdomain>
References: <20120529124833.9191.23007.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new filter update interface ftrace_set_filter_ip()
to set ftrace filter by ip address, not only glob pattern.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---

 include/linux/ftrace.h |    3 ++
 kernel/trace/ftrace.c  |   59 ++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 11abe4e..f3c5487 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -263,6 +263,8 @@ struct dyn_ftrace {
 };
 
 int ftrace_force_update(void);
+int ftrace_set_filter_ip(struct ftrace_ops *ops, unsigned long ip,
+			 int remove, int reset);
 int ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
 		       int len, int reset);
 int ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
@@ -432,6 +434,7 @@ static inline int ftrace_text_reserved(void *start, void *end)
  */
 #define ftrace_regex_open(ops, flag, inod, file) ({ -ENODEV; })
 #define ftrace_set_early_filter(ops, buf, enable) do { } while (0)
+#define ftrace_set_filter_ip(ops, ip, remove, reset) ({ -ENODEV; })
 #define ftrace_set_filter(ops, buf, len, reset) ({ -ENODEV; })
 #define ftrace_set_notrace(ops, buf, len, reset) ({ -ENODEV; })
 #define ftrace_free_filter(ops) do { } while (0)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 357b15b..3ce1219 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3175,8 +3175,27 @@ ftrace_notrace_write(struct file *file, const char __user *ubuf,
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
@@ -3205,6 +3224,11 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
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
@@ -3221,6 +3245,37 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
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

