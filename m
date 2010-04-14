Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab0DNAhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 20:37:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34595 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab0DNAhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 20:37:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=EmYe7szzMkhqofFHJxtgprq7Sc7nX/8zl6PtdZMx3f769jnolHtjSAkDoqtyen7tzp
         PzqRSsaHiYGMs55J8Ic7KLpZfZxRq8ompldylQYYkxdINdhIEOQf4D5vo+hBoLT85MW4
         LaQ99RKvCfn/9olQeOppMY0uDMhIHoi2/xPPo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] perf: Fix accidentally preprocessed snprintf callback
Date: Wed, 14 Apr 2010 02:37:48 +0200
Message-Id: <1271205468-8202-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct sort_entry has a callback named snprintf that turns an
entry into a string result.

But there are glibc versions that implement snprintf through a
macro. The following expression is then going to get the snprintf
call preprocessed:

	ent->snprintf(...)

to finally end up in a build error:

	util/hist.c: Dans la fonction «hist_entry__snprintf» :
	util/hist.c:539: erreur: «struct sort_entry» has no member named «__builtin___snprintf_chk»

To fix this, rename struct sort_entry::snprintf() callback to
to_string(), assuming at least Java methods naming won't ever
conflict with perf.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/hist.c |    4 ++--
 tools/perf/util/sort.c |   10 +++++-----
 tools/perf/util/sort.h |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 18cf8b3..d07eccd 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -536,8 +536,8 @@ int hist_entry__snprintf(struct hist_entry *self,
 			continue;
 
 		ret += snprintf(s + ret, size - ret, "%s", sep ?: "  ");
-		ret += se->snprintf(self, s + ret, size - ret,
-				    se->width ? *se->width : 0);
+		ret += se->to_string(self, s + ret, size - ret,
+				     se->width ? *se->width : 0);
 	}
 
 	return ret;
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 9d24d4b..b8acf51 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -32,7 +32,7 @@ static int hist_entry__parent_snprintf(struct hist_entry *self, char *bf,
 struct sort_entry sort_thread = {
 	.header = "Command:  Pid",
 	.cmp	= sort__thread_cmp,
-	.snprintf = hist_entry__thread_snprintf,
+	.to_string = hist_entry__thread_snprintf,
 	.width	= &threads__col_width,
 };
 
@@ -40,27 +40,27 @@ struct sort_entry sort_comm = {
 	.header		= "Command",
 	.cmp		= sort__comm_cmp,
 	.collapse	= sort__comm_collapse,
-	.snprintf	= hist_entry__comm_snprintf,
+	.to_string	= hist_entry__comm_snprintf,
 	.width		= &comms__col_width,
 };
 
 struct sort_entry sort_dso = {
 	.header = "Shared Object",
 	.cmp	= sort__dso_cmp,
-	.snprintf = hist_entry__dso_snprintf,
+	.to_string   = hist_entry__dso_snprintf,
 	.width	= &dsos__col_width,
 };
 
 struct sort_entry sort_sym = {
 	.header = "Symbol",
 	.cmp	= sort__sym_cmp,
-	.snprintf = hist_entry__sym_snprintf,
+	.to_string = hist_entry__sym_snprintf,
 };
 
 struct sort_entry sort_parent = {
 	.header = "Parent symbol",
 	.cmp	= sort__parent_cmp,
-	.snprintf = hist_entry__parent_snprintf,
+	.to_string = hist_entry__parent_snprintf,
 	.width	= &parent_symbol__col_width,
 };
 
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 6d7b4be..3a29fb5 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -82,8 +82,8 @@ struct sort_entry {
 
 	int64_t (*cmp)(struct hist_entry *, struct hist_entry *);
 	int64_t (*collapse)(struct hist_entry *, struct hist_entry *);
-	int	(*snprintf)(struct hist_entry *self, char *bf, size_t size,
-			    unsigned int width);
+	int	(*to_string)(struct hist_entry *self, char *bf, size_t size,
+			     unsigned int width);
 	unsigned int *width;
 	bool	elide;
 };
-- 
1.6.2.3

