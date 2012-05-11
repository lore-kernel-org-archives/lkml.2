Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab2EKKaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:30:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab2EKKaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:30:20 -0400
Date: Fri, 11 May 2012 12:25:22 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, tool: Add modifiers to be part of the event name
Message-ID: <20120511102522.GA2012@m.brq.redhat.com>
References: <1336695468-5464-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336695468-5464-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 05:17:48PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> We need to save the original string for perf stat output,
> otherwise :t and :c are invisible.

right, the modifier got lost

We need to fix the name once modifier is detected and final
event name is assigned (e.g. there could be "*?" in the tracepoint
event name, causing the name to be unwinded..).

Please check attached patch.

I'll add some testcases later, since there's patchset
waiting in Arnaldo's queue that would need to be rebased.

thanks,
jirka


---
We lost modifier as part of the event name after event parser
refactoring. Adding it back so it could be properly displayed
in perf stat output.

If there's a modifier specified for the event we fix the event
name to include it.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5b3a0ef..6125f5e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -684,11 +684,24 @@ void parse_events_update_lists(struct list_head *list_event,
 	INIT_LIST_HEAD(list_event);
 }
 
+static int update_event_name(struct perf_evsel *evsel, char *mod)
+{
+	char name[MAX_NAME_LEN];
+
+	/* Each event should have a name defined at this point. */
+	BUG_ON(!evsel->name);
+	snprintf(name, MAX_NAME_LEN, "%s:%s", evsel->name, mod);
+	free(evsel->name);
+	evsel->name = strdup(name);
+	return evsel->name ? 0 : -ENOMEM;
+}
+
 int parse_events_modifier(struct list_head *list, char *str)
 {
 	struct perf_evsel *evsel;
 	int exclude = 0, exclude_GH = 0;
 	int eu = 0, ek = 0, eh = 0, eH = 0, eG = 0, precise = 0;
+	char *mod = str;
 
 	if (str == NULL)
 		return 0;
@@ -742,6 +755,9 @@ int parse_events_modifier(struct list_head *list, char *str)
 		evsel->attr.precise_ip     = precise;
 		evsel->attr.exclude_host   = eH;
 		evsel->attr.exclude_guest  = eG;
+
+		if (update_event_name(evsel, mod))
+			return -ENOMEM;
 	}
 
 	return 0;
-- 
1.7.7.6

