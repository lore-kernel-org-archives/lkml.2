Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030606Ab2AFVQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 16:16:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:46101 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759171Ab2AFVQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 16:16:19 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Gleb Natapov <gleb@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/6] perf tools: Add support for guest/host-only profiling
Date: Fri,  6 Jan 2012 19:16:03 -0200
Message-Id: <1325884564-23322-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.GIT
In-Reply-To: <1325884564-23322-1-git-send-email-acme@infradead.org>
References: <1325884564-23322-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

To restrict a counter to either host or guest mode this patch introduces
two new event modifiers: G and H.

With G the counter is configured in guest-only mode and with H in
host-only mode.

Cc: Gleb Natapov <gleb@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Link: http://lkml.kernel.org/n/tip-or5aj3rghy9ngyg882z6kln9@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-list.txt |    2 ++
 tools/perf/util/parse-events.c         |   14 ++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index 7a527f7..ddc2252 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -21,6 +21,8 @@ EVENT MODIFIERS
 Events can optionally have a modifer by appending a colon and one or
 more modifiers.  Modifiers allow the user to restrict when events are
 counted with 'u' for user-space, 'k' for kernel, 'h' for hypervisor.
+Additional modifiers are 'G' for guest counting (in KVM guests) and 'H'
+for host counting (not in KVM guests).
 
 The 'p' modifier can be used for specifying how precise the instruction
 address should be. The 'p' modifier is currently only implemented for
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index dcf999c..b029296 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -735,8 +735,8 @@ static int
 parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 {
 	const char *str = *strp;
-	int exclude = 0;
-	int eu = 0, ek = 0, eh = 0, precise = 0;
+	int exclude = 0, exclude_GH = 0;
+	int eu = 0, ek = 0, eh = 0, eH = 0, eG = 0, precise = 0;
 
 	if (!*str)
 		return 0;
@@ -760,6 +760,14 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 			if (!exclude)
 				exclude = eu = ek = eh = 1;
 			eh = 0;
+		} else if (*str == 'G') {
+			if (!exclude_GH)
+				exclude_GH = eG = eH = 1;
+			eG = 0;
+		} else if (*str == 'H') {
+			if (!exclude_GH)
+				exclude_GH = eG = eH = 1;
+			eH = 0;
 		} else if (*str == 'p') {
 			precise++;
 		} else
@@ -776,6 +784,8 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 	attr->exclude_kernel = ek;
 	attr->exclude_hv     = eh;
 	attr->precise_ip     = precise;
+	attr->exclude_host   = eH;
+	attr->exclude_guest  = eG;
 
 	return 0;
 }
-- 
1.7.4.4

