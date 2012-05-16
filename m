Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966800Ab2EPNCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 09:02:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:40313 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966280Ab2EPNC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 09:02:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="153608653"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        robert.richter@amd.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH 3/3] perf script/python: Pass thread/dso name and symbol info to event handler in python
Date: Wed, 16 May 2012 20:59:15 +0800
Message-Id: <1337173155-25780-3-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1337173155-25780-1-git-send-email-feng.tang@intel.com>
References: <1337173155-25780-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 .../util/scripting-engines/trace-event-python.c    |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index a202881..c96f5e2 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -336,6 +336,7 @@ static void python_process_general_event(union perf_event *pevent __unused,
 	static char handler_name[64];
 	unsigned n = 0;
 	void *data = sample->raw_data;
+	struct thread *thread = al->thread;
 
 	t = PyTuple_New(MAX_FIELDS);
 	if (!t)
@@ -348,13 +349,21 @@ static void python_process_general_event(union perf_event *pevent __unused,
 		goto exit;
 	}
 
-	/* Pass 3 parameters: event_attr, perf_sample, raw data, thread name */
+	/* Pass parameters: attr, perf_sample, raw data, thread and dso name */
 	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
 			(const char *)&evsel->attr, sizeof(evsel->attr)));
 	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
 			(const char *)sample, sizeof(*sample)));
 	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
 			data, sample->raw_size));
+	PyTuple_SetItem(t, n++, PyString_FromString(thread->comm));
+	PyTuple_SetItem(t, n++, PyString_FromString(al->map->dso->name));
+
+	/* Pass the resolved symbol if there is, othersize pass "Unkown" */
+	if (al->sym)
+		PyTuple_SetItem(t, n++, PyString_FromString(al->sym->name));
+	else
+		PyTuple_SetItem(t, n++, PyString_FromString("Unknown"));
 
 	if (_PyTuple_Resize(&t, n) == -1)
 		Py_FatalError("error resizing Python tuple");
-- 
1.7.1

