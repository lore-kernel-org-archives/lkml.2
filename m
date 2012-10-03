Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab2JCVXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 17:23:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:14585 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755989Ab2JCVXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 17:23:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,529,1344236400"; 
   d="scan'208";a="229623480"
From: Andi Kleen <andi@firstfloor.org>
To: acme@redhat.com
Cc: jolsa@redhat.com, eranian@google.com, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/3] perf, tools: Default to cpu// for events
Date: Wed,  3 Oct 2012 14:22:42 -0700
Message-Id: <1349299363-30714-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1349299363-30714-1-git-send-email-andi@firstfloor.org>
References: <1349299363-30714-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When an event fails to parse and it's not in a new style format,
try to parse it again as a cpu event.

This allows to use sysfs exported events directly without //, so I can use

perf record -e tx-aborts ...

instead of

perf record -e cpu/tx-aborts/

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/parse-events.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index de1cb9e..4e7117f 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -785,6 +785,16 @@ static int parse_events__scanner(const char *str, void *data, int start_token)
 	parse_events__flush_buffer(buffer, scanner);
 	parse_events__delete_buffer(buffer, scanner);
 	parse_events_lex_destroy(scanner);
+
+	if (ret && !strchr(str, '/')) {
+		char *s = malloc(strlen(str) + strlen("cpu/") + 2);
+
+		if (!s)
+			return ret;
+		sprintf(s, "cpu/%s/", str);
+		str = s;
+		return parse_events__scanner(str, data, start_token);
+	}
 	return ret;
 }
 
-- 
1.7.7.6

