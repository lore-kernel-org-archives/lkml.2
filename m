Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab1LGJDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:03:11 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:4398 "EHLO
	VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753898Ab1LGJDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:03:08 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LVTT50-01-ASI-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH v2 2/7] perf tools: Fix out-of-bound access to struct perf_session
Date: Wed, 7 Dec 2011 10:02:52 +0100
Message-ID: <1323248577-11268-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1323248577-11268-1-git-send-email-robert.richter@amd.com>
References: <1323248577-11268-1-git-send-email-robert.richter@amd.com>
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
index d9318d8..ea17dfb 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -107,7 +107,7 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 				       bool force, bool repipe,
 				       struct perf_tool *tool)
 {
-	size_t len = filename ? strlen(filename) + 1 : 0;
+	size_t len = filename ? strlen(filename) : 0;
 	struct perf_session *self = zalloc(sizeof(*self) + len);
 
 	if (self == NULL)
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 30e9c6b6..7d3be1b 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -50,7 +50,7 @@ struct perf_session {
 	int			cwdlen;
 	char			*cwd;
 	struct ordered_samples	ordered_samples;
-	char			filename[0];
+	char			filename[1];
 };
 
 struct perf_tool;
-- 
1.7.7


