Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab2BIQIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 11:08:00 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:23408 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753776Ab2BIQH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 11:07:58 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZ4VH5-01-MJJ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Jason Wang <jasowang@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/2] perf-tool: Don't process samples with no valid machine object
Date: Thu, 9 Feb 2012 17:07:38 +0100
Message-ID: <1328803659-30449-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1328803659-30449-1-git-send-email-joerg.roedel@amd.com>
References: <1328803659-30449-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf sample processing code relies on a valid machine
object. Make sure that this path is only entered when such a
object exists.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 tools/perf/builtin-top.c  |    2 +-
 tools/perf/util/session.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index dd162aa..7c81d1d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -805,7 +805,7 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 		}
 
 
-		if (event->header.type == PERF_RECORD_SAMPLE) {
+		if (event->header.type == PERF_RECORD_SAMPLE && machine != NULL) {
 			perf_event__process_sample(&top->tool, event, evsel,
 						   &sample, machine);
 		} else if (event->header.type < PERF_RECORD_MAX) {
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index b5ca2558..c9593c7 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -792,7 +792,7 @@ static int perf_session_deliver_event(struct perf_session *session,
 	switch (event->header.type) {
 	case PERF_RECORD_SAMPLE:
 		dump_sample(session, event, sample);
-		if (evsel == NULL) {
+		if (evsel == NULL || machine == NULL) {
 			++session->hists.stats.nr_unknown_id;
 			return -1;
 		}
-- 
1.7.5.4


