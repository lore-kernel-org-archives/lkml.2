Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab2DWNoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 09:44:46 -0400
Received: from 207-126-122-235.ip.openhosting.com ([207.126.122.235]:41838
	"EHLO drepperk.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753786Ab2DWNop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 09:44:45 -0400
X-Greylist: delayed 2330 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Apr 2012 09:44:45 EDT
Date: Mon, 23 Apr 2012 09:04:29 -0400
From: Ulrich Drepper <drepper@akkadia.org>
Message-Id: <201204231304.q3ND4TFe020805@drepperk.user.openhosting.com>
To: a.p.zijlstra@chello.nl, acme@ghostprotocols.net, dsahern@gmail.com,
        eranian@google.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulus@samba.org, robert.richter@amd.com
Subject: [PATCH] Small perf cleanup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just noticed this.  The if branch is completely unnecessary since
'realloc' handles NULL pointers for the first parameter.  This is
really only a cleanup and submitted mainly to prevent proliferation
of bad practices.


Signed-off-by: Ulrich Drepper <drepper@gmail.com>

 tools/perf/util/header.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4c7c2d7..6e618ba 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -31,21 +31,16 @@ static const char **header_argv;
 
 int perf_header__push_event(u64 id, const char *name)
 {
+	struct perf_trace_event_type *nevents;
+
 	if (strlen(name) > MAX_EVENT_NAME)
 		pr_warning("Event %s will be truncated\n", name);
 
-	if (!events) {
-		events = malloc(sizeof(struct perf_trace_event_type));
-		if (events == NULL)
-			return -ENOMEM;
-	} else {
-		struct perf_trace_event_type *nevents;
+	nevents = realloc(events, (event_count + 1) * sizeof(*events));
+	if (nevents == NULL)
+		return -ENOMEM;
+	events = nevents;
 
-		nevents = realloc(events, (event_count + 1) * sizeof(*events));
-		if (nevents == NULL)
-			return -ENOMEM;
-		events = nevents;
-	}
 	memset(&events[event_count], 0, sizeof(struct perf_trace_event_type));
 	events[event_count].event_id = id;
 	strncpy(events[event_count].name, name, MAX_EVENT_NAME - 1);
