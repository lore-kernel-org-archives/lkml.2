Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243Ab1LFKdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:33:03 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:59831
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933146Ab1LFKc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:32:59 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVS2MS-01-BNO-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 04/10] perf tools: Fix out-of-bound access to struct perf_session
Date: Tue, 6 Dec 2011 11:32:34 +0100
Message-ID: <1323167560-2282-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
References: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If filename is NULL there is an out-of-bound access to struct
perf_session if it would be used with perf_session__open(). Shouldn't
actually happen in current implementation as filename is always
!NULL. Fixing this by always null-terminating filename.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/util/session.c |    2 +-
 tools/perf/util/session.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 85c1e6b7..2ad9c10 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -132,7 +132,7 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 				       bool force, bool repipe,
 				       struct perf_event_ops *ops)
 {
-	size_t len = filename ? strlen(filename) + 1 : 0;
+	size_t len = filename ? strlen(filename) : 0;
 	struct perf_session *self = zalloc(sizeof(*self) + len);
 
 	if (self == NULL)
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 6e393c9..f320cd5 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -54,7 +54,7 @@ struct perf_session {
 	char			*cwd;
 	struct ordered_samples	ordered_samples;
 	struct callchain_cursor	callchain_cursor;
-	char			filename[0];
+	char			filename[1];
 };
 
 struct perf_evsel;
-- 
1.7.7


