Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab0GHRTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 13:19:40 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:59160 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab0GHRTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 13:19:38 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Naren A Devaiah <naren.devaiah@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 08 Jul 2010 22:42:05 +0530
Message-Id: <20100708171205.29165.73177.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100708171003.29165.57615.sendpatchset@localhost6.localdomain6>
References: <20100708171003.29165.57615.sendpatchset@localhost6.localdomain6>
Subject: [PATCHv8 2.6.35-rc4-tip 10/12]  perf: Re-Add make_absolute_path
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

revert_make_absolute_path

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

perf: Re-Add make_absolute_path

perf probe for uprobes would use make_absolute_path.
make_absolute_path can be used to convert a file name to a dso name.

so if user specifies the function to be traced as malloc@/lib/libc.so.6
it needs to be converted to malloc@libc-2.5.so

This patch reverts a part of a41794cdd7ee94a5199e14f642c26d649d383fa5

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 tools/perf/util/abspath.c |   81 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/cache.h   |    1 +
 2 files changed, 82 insertions(+), 0 deletions(-)


diff --git a/tools/perf/util/abspath.c b/tools/perf/util/abspath.c
index 0e76aff..0a985fd 100644
--- a/tools/perf/util/abspath.c
+++ b/tools/perf/util/abspath.c
@@ -1,5 +1,86 @@
 #include "cache.h"
 
+/*
+ * Do not use this for inspecting *tracked* content.  When path is a
+ * symlink to a directory, we do not want to say it is a directory when
+ * dealing with tracked content in the working tree.
+ */
+static int is_directory(const char *path)
+{
+	struct stat st;
+	return !stat(path, &st) && S_ISDIR(st.st_mode);
+}
+
+/* We allow "recursive" symbolic links. Only within reason, though. */
+#define MAXDEPTH 5
+
+const char *make_absolute_path(const char *path)
+{
+	static char bufs[2][PATH_MAX + 1], *buf = bufs[0], *next_buf = bufs[1];
+	char cwd[1024] = "";
+	int buf_index = 1, len;
+
+	int depth = MAXDEPTH;
+	char *last_elem = NULL;
+	struct stat st;
+
+	if (strlcpy(buf, path, PATH_MAX) >= PATH_MAX)
+		die("Too long path: %.*s", 60, path);
+
+	while (depth--) {
+		if (!is_directory(buf)) {
+			char *last_slash = strrchr(buf, '/');
+			if (last_slash) {
+				*last_slash = '\0';
+				last_elem = xstrdup(last_slash + 1);
+			} else {
+				last_elem = xstrdup(buf);
+				*buf = '\0';
+			}
+		}
+
+		if (*buf) {
+			if (!*cwd && !getcwd(cwd, sizeof(cwd)))
+				die("Could not get current working directory");
+
+			if (chdir(buf))
+				die("Could not switch to '%s'", buf);
+		}
+		if (!getcwd(buf, PATH_MAX))
+			die("Could not get current working directory");
+
+		if (last_elem) {
+			len = strlen(buf);
+
+			if (len + strlen(last_elem) + 2 > PATH_MAX)
+				die("Too long path name: '%s/%s'",
+						buf, last_elem);
+			buf[len] = '/';
+			strcpy(buf + len + 1, last_elem);
+			free(last_elem);
+			last_elem = NULL;
+		}
+
+		if (!lstat(buf, &st) && S_ISLNK(st.st_mode)) {
+			len = readlink(buf, next_buf, PATH_MAX);
+			if (len < 0)
+				die("Invalid symlink: %s", buf);
+			if (PATH_MAX <= len)
+				die("symbolic link too long: %s", buf);
+			next_buf[len] = '\0';
+			buf = next_buf;
+			buf_index = 1 - buf_index;
+			next_buf = bufs[buf_index];
+		} else
+			break;
+	}
+
+	if (*cwd && chdir(cwd))
+		die("Could not change back to '%s'", cwd);
+
+	return buf;
+}
+
 static const char *get_pwd_cwd(void)
 {
 	static char cwd[PATH_MAX + 1];
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 27e9ebe..0dfed40 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -73,6 +73,7 @@ static inline int is_absolute_path(const char *path)
 	return path[0] == '/';
 }
 
+const char *make_absolute_path(const char *path);
 const char *make_nonrelative_path(const char *path);
 char *strip_path_suffix(const char *path, const char *suffix);
 
