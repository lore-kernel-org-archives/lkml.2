Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab2E3Hxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:53:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35443 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab2E3Hxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:53:47 -0400
Date: Wed, 30 May 2012 00:53:18 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-q4egci70rjgxh7bogbbfpcyf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf annotate browser:
  Read perf config file for settings
Git-Commit-ID: c323cf0400c1fed853738e6d81e83c6ac7ff5105
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 00:53:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c323cf0400c1fed853738e6d81e83c6ac7ff5105
Gitweb:     http://git.kernel.org/tip/c323cf0400c1fed853738e6d81e83c6ac7ff5105
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 29 May 2012 22:06:30 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 29 May 2012 22:06:30 -0300

perf annotate browser: Read perf config file for settings

The defaults are:

[annotate]

	hide_src_code = false
	use_offset = true
	jump_arrows = true
	show_nr_jumps = false

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-q4egci70rjgxh7bogbbfpcyf@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perfconfig.example |    8 ++++
 tools/perf/ui/browser.c                     |    2 +
 tools/perf/ui/browser.h                     |    1 +
 tools/perf/ui/browsers/annotate.c           |   49 +++++++++++++++++++++++++++
 4 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perfconfig.example b/tools/perf/Documentation/perfconfig.example
index 42c6fd2..767ea24 100644
--- a/tools/perf/Documentation/perfconfig.example
+++ b/tools/perf/Documentation/perfconfig.example
@@ -19,3 +19,11 @@
 
 	# Default, disable using /dev/null
 	dir = /root/.debug
+
+[annotate]
+
+	# Defaults
+	hide_src_code = false
+	use_offset = true
+	jump_arrows = true
+	show_nr_jumps = false
diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index cde4d0f..c3a769ad 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -708,4 +708,6 @@ void ui_browser__init(void)
 		struct ui_browser__colorset *c = &ui_browser__colorsets[i++];
 		sltt_set_color(c->colorset, c->name, c->fg, c->bg);
 	}
+
+	annotate_browser__init();
 }
diff --git a/tools/perf/ui/browser.h b/tools/perf/ui/browser.h
index dd96d82..af70314 100644
--- a/tools/perf/ui/browser.h
+++ b/tools/perf/ui/browser.h
@@ -69,4 +69,5 @@ void ui_browser__list_head_seek(struct ui_browser *self, off_t offset, int whenc
 unsigned int ui_browser__list_head_refresh(struct ui_browser *self);
 
 void ui_browser__init(void);
+void annotate_browser__init(void);
 #endif /* _PERF_UI_BROWSER_H_ */
diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 02afa03..77b5b12 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -900,3 +900,52 @@ out_free_offsets:
 	free(browser.offsets);
 	return ret;
 }
+
+#define ANNOTATE_CFG(n) \
+	{ .name = #n, .value = &annotate_browser__opts.n, }
+	
+/*
+ * Keep the entries sorted, they are bsearch'ed
+ */
+static struct annotate__config {
+	const char *name;
+	bool *value;
+} annotate__configs[] = {
+	ANNOTATE_CFG(hide_src_code),
+	ANNOTATE_CFG(jump_arrows),
+	ANNOTATE_CFG(show_nr_jumps),
+	ANNOTATE_CFG(use_offset),
+};
+
+#undef ANNOTATE_CFG
+
+static int annotate_config__cmp(const void *name, const void *cfgp)
+{
+	const struct annotate__config *cfg = cfgp;
+
+	return strcmp(name, cfg->name);
+}
+
+static int annotate__config(const char *var, const char *value, void *data __used)
+{
+	struct annotate__config *cfg;
+	const char *name;
+
+	if (prefixcmp(var, "annotate.") != 0)
+		return 0;
+
+	name = var + 9;
+	cfg = bsearch(name, annotate__configs, ARRAY_SIZE(annotate__configs),
+		      sizeof(struct annotate__config), annotate_config__cmp);
+
+	if (cfg == NULL)
+		return -1;
+
+	*cfg->value = perf_config_bool(name, value);
+	return 0;
+}
+
+void annotate_browser__init(void)
+{
+	perf_config(annotate__config, NULL);
+}
