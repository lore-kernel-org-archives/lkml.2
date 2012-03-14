Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab2CNUBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 16:01:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49766 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab2CNUA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 16:00:59 -0400
Date: Wed, 14 Mar 2012 13:00:08 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-kwxo2eh29cxmd8ilixi2005x@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        anton@samba.org, acme@redhat.com, hpa@zytor.com, mingo@redhat.com,
        yanmin_zhang@linux.intel.com, peterz@infradead.org, efault@gmx.de,
        emunson@mgebm.net, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, anton@samba.org,
        paulus@samba.org, eranian@google.com, linux-kernel@vger.kernel.org,
        efault@gmx.de, peterz@infradead.org, yanmin_zhang@linux.intel.com,
        emunson@mgebm.net, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Use scnprintf where applicable
Git-Commit-ID: e7f01d1e3d8d501deb8abeaa269d5d48a703b8b0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 14 Mar 2012 13:00:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7f01d1e3d8d501deb8abeaa269d5d48a703b8b0
Gitweb:     http://git.kernel.org/tip/e7f01d1e3d8d501deb8abeaa269d5d48a703b8b0
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 14 Mar 2012 12:29:29 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Mar 2012 12:36:19 -0300

perf tools: Use scnprintf where applicable

Several places were expecting that the value returned was the number of
characters printed, not what would be printed if there was space.

Fix it by using the scnprintf and vscnprintf variants we inherited from
the kernel sources.

Some corner cases where the number of printed characters were not
accounted were fixed too.

Reported-by: Anton Blanchard <anton@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: stable@kernel.org
Link: http://lkml.kernel.org/n/tip-kwxo2eh29cxmd8ilixi2005x@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/powerpc/util/header.c |    2 +-
 tools/perf/arch/x86/util/header.c     |    2 +-
 tools/perf/util/color.c               |    9 +++++----
 tools/perf/util/header.c              |    4 ++--
 tools/perf/util/hist.c                |   30 +++++++++++++++---------------
 tools/perf/util/strbuf.c              |    7 ++++---
 tools/perf/util/ui/browsers/hists.c   |   12 ++++++------
 tools/perf/util/ui/helpline.c         |    2 +-
 8 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/tools/perf/arch/powerpc/util/header.c b/tools/perf/arch/powerpc/util/header.c
index eba80c2..2f7073d 100644
--- a/tools/perf/arch/powerpc/util/header.c
+++ b/tools/perf/arch/powerpc/util/header.c
@@ -25,7 +25,7 @@ get_cpuid(char *buffer, size_t sz)
 
 	pvr = mfspr(SPRN_PVR);
 
-	nb = snprintf(buffer, sz, "%lu,%lu$", PVR_VER(pvr), PVR_REV(pvr));
+	nb = scnprintf(buffer, sz, "%lu,%lu$", PVR_VER(pvr), PVR_REV(pvr));
 
 	/* look for end marker to ensure the entire data fit */
 	if (strchr(buffer, '$')) {
diff --git a/tools/perf/arch/x86/util/header.c b/tools/perf/arch/x86/util/header.c
index f940060..146d12a 100644
--- a/tools/perf/arch/x86/util/header.c
+++ b/tools/perf/arch/x86/util/header.c
@@ -48,7 +48,7 @@ get_cpuid(char *buffer, size_t sz)
 		if (family >= 0x6)
 			model += ((a >> 16) & 0xf) << 4;
 	}
-	nb = snprintf(buffer, sz, "%s,%u,%u,%u$", vendor, family, model, step);
+	nb = scnprintf(buffer, sz, "%s,%u,%u,%u$", vendor, family, model, step);
 
 	/* look for end marker to ensure the entire data fit */
 	if (strchr(buffer, '$')) {
diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
index 521c38a..11e46da 100644
--- a/tools/perf/util/color.c
+++ b/tools/perf/util/color.c
@@ -1,3 +1,4 @@
+#include <linux/kernel.h>
 #include "cache.h"
 #include "color.h"
 
@@ -182,12 +183,12 @@ static int __color_vsnprintf(char *bf, size_t size, const char *color,
 	}
 
 	if (perf_use_color_default && *color)
-		r += snprintf(bf, size, "%s", color);
-	r += vsnprintf(bf + r, size - r, fmt, args);
+		r += scnprintf(bf, size, "%s", color);
+	r += vscnprintf(bf + r, size - r, fmt, args);
 	if (perf_use_color_default && *color)
-		r += snprintf(bf + r, size - r, "%s", PERF_COLOR_RESET);
+		r += scnprintf(bf + r, size - r, "%s", PERF_COLOR_RESET);
 	if (trail)
-		r += snprintf(bf + r, size - r, "%s", trail);
+		r += scnprintf(bf + r, size - r, "%s", trail);
 	return r;
 }
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ecd7f4d..14bb035 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -280,7 +280,7 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 	if (realname == NULL || filename == NULL || linkname == NULL)
 		goto out_free;
 
-	len = snprintf(filename, size, "%s%s%s",
+	len = scnprintf(filename, size, "%s%s%s",
 		       debugdir, is_kallsyms ? "/" : "", realname);
 	if (mkdir_p(filename, 0755))
 		goto out_free;
@@ -295,7 +295,7 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 			goto out_free;
 	}
 
-	len = snprintf(linkname, size, "%s/.build-id/%.2s",
+	len = scnprintf(linkname, size, "%s/.build-id/%.2s",
 		       debugdir, sbuild_id);
 
 	if (access(linkname, X_OK) && mkdir_p(linkname, 0755))
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6f505d1..e11e482 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -768,7 +768,7 @@ static int hist_entry__pcnt_snprintf(struct hist_entry *he, char *s,
 						     sep ? "%.2f" : "   %6.2f%%",
 						     (period * 100.0) / total);
 		else
-			ret = snprintf(s, size, sep ? "%.2f" : "   %6.2f%%",
+			ret = scnprintf(s, size, sep ? "%.2f" : "   %6.2f%%",
 				       (period * 100.0) / total);
 		if (symbol_conf.show_cpu_utilization) {
 			ret += percent_color_snprintf(s + ret, size - ret,
@@ -791,20 +791,20 @@ static int hist_entry__pcnt_snprintf(struct hist_entry *he, char *s,
 			}
 		}
 	} else
-		ret = snprintf(s, size, sep ? "%" PRIu64 : "%12" PRIu64 " ", period);
+		ret = scnprintf(s, size, sep ? "%" PRIu64 : "%12" PRIu64 " ", period);
 
 	if (symbol_conf.show_nr_samples) {
 		if (sep)
-			ret += snprintf(s + ret, size - ret, "%c%" PRIu64, *sep, nr_events);
+			ret += scnprintf(s + ret, size - ret, "%c%" PRIu64, *sep, nr_events);
 		else
-			ret += snprintf(s + ret, size - ret, "%11" PRIu64, nr_events);
+			ret += scnprintf(s + ret, size - ret, "%11" PRIu64, nr_events);
 	}
 
 	if (symbol_conf.show_total_period) {
 		if (sep)
-			ret += snprintf(s + ret, size - ret, "%c%" PRIu64, *sep, period);
+			ret += scnprintf(s + ret, size - ret, "%c%" PRIu64, *sep, period);
 		else
-			ret += snprintf(s + ret, size - ret, " %12" PRIu64, period);
+			ret += scnprintf(s + ret, size - ret, " %12" PRIu64, period);
 	}
 
 	if (pair_hists) {
@@ -819,25 +819,25 @@ static int hist_entry__pcnt_snprintf(struct hist_entry *he, char *s,
 		diff = new_percent - old_percent;
 
 		if (fabs(diff) >= 0.01)
-			snprintf(bf, sizeof(bf), "%+4.2F%%", diff);
+			ret += scnprintf(bf, sizeof(bf), "%+4.2F%%", diff);
 		else
-			snprintf(bf, sizeof(bf), " ");
+			ret += scnprintf(bf, sizeof(bf), " ");
 
 		if (sep)
-			ret += snprintf(s + ret, size - ret, "%c%s", *sep, bf);
+			ret += scnprintf(s + ret, size - ret, "%c%s", *sep, bf);
 		else
-			ret += snprintf(s + ret, size - ret, "%11.11s", bf);
+			ret += scnprintf(s + ret, size - ret, "%11.11s", bf);
 
 		if (show_displacement) {
 			if (displacement)
-				snprintf(bf, sizeof(bf), "%+4ld", displacement);
+				ret += scnprintf(bf, sizeof(bf), "%+4ld", displacement);
 			else
-				snprintf(bf, sizeof(bf), " ");
+				ret += scnprintf(bf, sizeof(bf), " ");
 
 			if (sep)
-				ret += snprintf(s + ret, size - ret, "%c%s", *sep, bf);
+				ret += scnprintf(s + ret, size - ret, "%c%s", *sep, bf);
 			else
-				ret += snprintf(s + ret, size - ret, "%6.6s", bf);
+				ret += scnprintf(s + ret, size - ret, "%6.6s", bf);
 		}
 	}
 
@@ -855,7 +855,7 @@ int hist_entry__snprintf(struct hist_entry *he, char *s, size_t size,
 		if (se->elide)
 			continue;
 
-		ret += snprintf(s + ret, size - ret, "%s", sep ?: "  ");
+		ret += scnprintf(s + ret, size - ret, "%s", sep ?: "  ");
 		ret += se->se_snprintf(he, s + ret, size - ret,
 				       hists__col_len(hists, se->se_width_idx));
 	}
diff --git a/tools/perf/util/strbuf.c b/tools/perf/util/strbuf.c
index 92e0685..2eeb51b 100644
--- a/tools/perf/util/strbuf.c
+++ b/tools/perf/util/strbuf.c
@@ -1,4 +1,5 @@
 #include "cache.h"
+#include <linux/kernel.h>
 
 int prefixcmp(const char *str, const char *prefix)
 {
@@ -89,14 +90,14 @@ void strbuf_addf(struct strbuf *sb, const char *fmt, ...)
 	if (!strbuf_avail(sb))
 		strbuf_grow(sb, 64);
 	va_start(ap, fmt);
-	len = vsnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
+	len = vscnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
 	va_end(ap);
 	if (len < 0)
-		die("your vsnprintf is broken");
+		die("your vscnprintf is broken");
 	if (len > strbuf_avail(sb)) {
 		strbuf_grow(sb, len);
 		va_start(ap, fmt);
-		len = vsnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
+		len = vscnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
 		va_end(ap);
 		if (len > strbuf_avail(sb)) {
 			die("this should not happen, your snprintf is broken");
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index e81aef1..bb9197c 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -837,15 +837,15 @@ static int hists__browser_title(struct hists *self, char *bf, size_t size,
 	unsigned long nr_events = self->stats.nr_events[PERF_RECORD_SAMPLE];
 
 	nr_events = convert_unit(nr_events, &unit);
-	printed = snprintf(bf, size, "Events: %lu%c %s", nr_events, unit, ev_name);
+	printed = scnprintf(bf, size, "Events: %lu%c %s", nr_events, unit, ev_name);
 
 	if (thread)
-		printed += snprintf(bf + printed, size - printed,
+		printed += scnprintf(bf + printed, size - printed,
 				    ", Thread: %s(%d)",
 				    (thread->comm_set ? thread->comm : ""),
 				    thread->pid);
 	if (dso)
-		printed += snprintf(bf + printed, size - printed,
+		printed += scnprintf(bf + printed, size - printed,
 				    ", DSO: %s", dso->short_name);
 	return printed;
 }
@@ -1095,7 +1095,7 @@ static void perf_evsel_menu__write(struct ui_browser *browser,
 						       HE_COLORSET_NORMAL);
 
 	nr_events = convert_unit(nr_events, &unit);
-	printed = snprintf(bf, sizeof(bf), "%lu%c%s%s", nr_events,
+	printed = scnprintf(bf, sizeof(bf), "%lu%c%s%s", nr_events,
 			   unit, unit == ' ' ? "" : " ", ev_name);
 	slsmg_printf("%s", bf);
 
@@ -1105,8 +1105,8 @@ static void perf_evsel_menu__write(struct ui_browser *browser,
 		if (!current_entry)
 			ui_browser__set_color(browser, HE_COLORSET_TOP);
 		nr_events = convert_unit(nr_events, &unit);
-		snprintf(bf, sizeof(bf), ": %ld%c%schunks LOST!", nr_events,
-			 unit, unit == ' ' ? "" : " ");
+		printed += scnprintf(bf, sizeof(bf), ": %ld%c%schunks LOST!",
+				     nr_events, unit, unit == ' ' ? "" : " ");
 		warn = bf;
 	}
 
diff --git a/tools/perf/util/ui/helpline.c b/tools/perf/util/ui/helpline.c
index 4f48f59..2f950c2 100644
--- a/tools/perf/util/ui/helpline.c
+++ b/tools/perf/util/ui/helpline.c
@@ -64,7 +64,7 @@ int ui_helpline__show_help(const char *format, va_list ap)
 	static int backlog;
 
 	pthread_mutex_lock(&ui__lock);
-	ret = vsnprintf(ui_helpline__last_msg + backlog,
+	ret = vscnprintf(ui_helpline__last_msg + backlog,
 			sizeof(ui_helpline__last_msg) - backlog, format, ap);
 	backlog += ret;
 
