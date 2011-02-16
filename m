Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab1BPORU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 09:17:20 -0500
Received: from smtp-out.google.com ([216.239.44.51]:38536 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab1BPORQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 09:17:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=yP+9zARBXU77jdzMSUByXK52zv1vSiE/j61JdHpSR+aLhW56q7UeLYF/4bjZ2t9UN8
         Ay060ZDQh4BrolD/NZmw==
Message-ID: <4d5bdc64.98a1df0a.7aa3.06c2@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Wed, 16 Feb 2011 15:10:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com,
        arun@sharma-home.net, linux-perf-users@vger.kernel.org
Subject: [PATCH] perf: make perf stat print user provided full event names
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the way perf stat prints event names at the end
of a run. Until now, it was trying to reconstruct the event name
from its encoding. The problem is that it would only print generic
events without their modifiers (u, k, pp).

This patch saves the event name as passed by the user in the evsel
struct and uses it to print the final event name.

This would also work in case perf is linked with a library (such as
libpfm4) which provides full PMU event tables.

$ perf stat -e cycles:u,cycles:k date
Wed Feb 16 14:58:52 CET 2011

 Performance counter stats for 'date':

            568600 cycles:u                
           2779715 cycles:k                

        0.001908182  seconds time elapsed

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 211063e..5f1f364 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -85,6 +85,7 @@ void perf_evsel__exit(struct perf_evsel *evsel)
 void perf_evsel__delete(struct perf_evsel *evsel)
 {
 	perf_evsel__exit(evsel);
+	free(evsel->name);
 	free(evsel);
 }
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index eecdc3a..c32b348 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -45,6 +45,7 @@ struct perf_evsel {
 	struct perf_counts	*counts;
 	int			idx;
 	void			*priv;
+	char			*name;
 };
 
 struct cpu_map;
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index cf082da..80a3dd5 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -268,6 +268,9 @@ const char *event_name(struct perf_evsel *evsel)
 	u64 config = evsel->attr.config;
 	int type = evsel->attr.type;
 
+	if (evsel->name)
+		return evsel->name;
+
 	return __event_name(type, config);
 }
 
@@ -782,8 +785,10 @@ int parse_events(const struct option *opt, const char *str, int unset __used)
 	struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
 	struct perf_event_attr attr;
 	enum event_result ret;
+	const char *ostr;
 
 	for (;;) {
+		ostr = str;
 		memset(&attr, 0, sizeof(attr));
 		ret = parse_event_symbols(opt, &str, &attr);
 		if (ret == EVT_FAILED)
@@ -798,6 +803,11 @@ int parse_events(const struct option *opt, const char *str, int unset __used)
 			if (evsel == NULL)
 				return -1;
 			perf_evlist__add(evlist, evsel);
+
+			evsel->name = calloc(str - ostr + 1, 1);
+			if (!evsel->name)
+				return -1;
+			strncpy(evsel->name, ostr, str - ostr);
 		}
 
 		if (*str == 0)
