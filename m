Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab1FKSJn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 14:09:43 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41793 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab1FKSJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 14:09:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=EHRHGAWimzc29x8FX357WQ8cKC5f9NT17+CIkanptYlf2gxizRVbjvacOfcpaMyvir
         X6CQAVTKnTyajYBR91UNLDovqotLk9b3oPgnG6uV8k1hv6exxkBWW9VbROXjcmDkgXdQ
         DqNPnIMecMLM96m94LmDH/fi8kDaKLmfsbMVs=
MIME-Version: 1.0
Date: Sun, 12 Jun 2011 02:09:40 +0800
Message-ID: <BANLkTinXzHiCTb6EWWGSJmzz5dS1P9p1sg@mail.gmail.com>
Subject: [PATCH] [perf] fix annotation loading when symbol sort order not used.
From: Sam Liao <phyomh@gmail.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When "symbol" is not in "-s" sort order options, the hist entry's
ms.sym is not equal to sample's addr_location.sym where we should
not load annotation. This fix check if symbol sort order used, if
not, disable symbol annonation for report command in tui mode.
---
 tools/perf/builtin-report.c |    2 +-
 tools/perf/util/sort.c      |    5 +++++
 tools/perf/util/sort.h      |    1 +
 3 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 2ceac45..83ba06b 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -79,7 +79,7 @@ static int perf_session__add_hist_entry(struct
perf_session *session,
 	 * so we don't allocated the extra space needed because the stdio
 	 * code will not use it.
 	 */
-	if (al->sym != NULL && use_browser > 0) {
+	if (sort__has_symbol && al->sym != NULL && use_browser > 0) {
 		struct annotation *notes = symbol__annotation(he->ms.sym);

 		assert(evsel != NULL);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index f44fa54..a6e1e13 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -8,6 +8,7 @@ const char	default_sort_order[] = "comm,dso,symbol";
 const char	*sort_order = default_sort_order;
 int		sort__need_collapse = 0;
 int		sort__has_parent = 0;
+int		sort__has_symbol = 0;

 enum sort_type	sort__first_dimension;

@@ -294,6 +295,10 @@ int sort_dimension__add(const char *tok)
 			sort__has_parent = 1;
 		}

+		if (sd->entry == &sort_sym) {
+			sort__has_symbol = 1;
+		}
+
 		if (list_empty(&hist_entry__sort_list)) {
 			if (!strcmp(sd->name, "pid"))
 				sort__first_dimension = SORT_PID;
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 0b91053..404de31 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -31,6 +31,7 @@ extern const char *parent_pattern;
 extern const char default_sort_order[];
 extern int sort__need_collapse;
 extern int sort__has_parent;
+extern int sort__has_symbol;
 extern char *field_sep;
 extern struct sort_entry sort_comm;
 extern struct sort_entry sort_dso;
-- 
1.7.4.1
