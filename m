Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab2HUPJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:09:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59378 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab2HUPJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:09:26 -0400
Date: Tue, 21 Aug 2012 08:09:04 -0700
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-647664eaf4033501739ac1f42dd52ce8c9266ccc@git.kernel.org>
Cc: fche@redhat.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@kernel.org, ananth@in.ibm.com, fweisbec@gmail.com,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, fche@redhat.com, ananth@in.ibm.com,
        fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com,
        akpm@linux-foundation.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20120605102808.27845.67952.stgit@localhost.localdomain>
References: <20120605102808.27845.67952.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace: add ftrace_set_filter_ip()
  for address based filter
Git-Commit-ID: 647664eaf4033501739ac1f42dd52ce8c9266ccc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:09:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  647664eaf4033501739ac1f42dd52ce8c9266ccc
Gitweb:     http://git.kernel.org/tip/647664eaf4033501739ac1f42dd52ce8c9266ccc
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Tue, 5 Jun 2012 19:28:08 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 31 Jul 2012 10:29:55 -0400

ftrace: add ftrace_set_filter_ip() for address based filter

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
 include/linux/ftrace.h |    3 ++
 kernel/trace/ftrace.c  |   59 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9962e95..3e71112 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -317,6 +317,8 @@ struct dyn_ftrace {
 };
 
 int ftrace_force_update(void);
+int ftrace_set_filter_ip(struct ftrace_ops *ops, unsigned long ip,
+			 int remove, int reset);
 int ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
 		       int len, int reset);
 int ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
@@ -544,6 +546,7 @@ static inline int ftrace_text_reserved(void *start, void *end)
  */
 #define ftrace_regex_open(ops, flag, inod, file) ({ -ENODEV; })
 #define ftrace_set_early_filter(ops, buf, enable) do { } while (0)
+#define ftrace_set_filter_ip(ops, ip, remove, reset) ({ -ENODEV; })
 #define ftrace_set_filter(ops, buf, len, reset) ({ -ENODEV; })
 #define ftrace_set_notrace(ops, buf, len, reset) ({ -ENODEV; })
 #define ftrace_free_filter(ops) do { } while (0)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 528d997..9dcf15d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3242,8 +3242,27 @@ ftrace_notrace_write(struct file *file, const char __user *ubuf,
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
@@ -3272,6 +3291,11 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
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
@@ -3288,6 +3312,37 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
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
