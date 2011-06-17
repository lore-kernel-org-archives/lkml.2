Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab1FQNhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 09:37:15 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:57858
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755723Ab1FQNhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 09:37:08 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMXSHP-01-0NV-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/5] perf, tools: Add support for guest/host-only profiling
Date: Fri, 17 Jun 2011 15:37:32 +0200
Message-ID: <1308317854-27398-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308317854-27398-1-git-send-email-joerg.roedel@amd.com>
References: <1308317854-27398-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To restrict a counter to either host or guest mode this
patch introduces two new event modifiers: G and H.
With G the counter is configured in guest-only mode and with
H in host-only mode.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 tools/perf/util/parse-events.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 41982c3..8bfb8de 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -728,8 +728,8 @@ static int
 parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 {
 	const char *str = *strp;
-	int exclude = 0;
-	int eu = 0, ek = 0, eh = 0, precise = 0;
+	int exclude = 0, exclude_GH = 0;
+	int eu = 0, ek = 0, eh = 0, eH = 0, eG = 0, precise = 0;
 
 	if (!*str)
 		return 0;
@@ -753,6 +753,14 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
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
@@ -769,6 +777,8 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 	attr->exclude_kernel = ek;
 	attr->exclude_hv     = eh;
 	attr->precise_ip     = precise;
+	attr->exclude_host   = eH;
+	attr->exclude_guest  = eG;
 
 	return 0;
 }
-- 
1.7.4.1


