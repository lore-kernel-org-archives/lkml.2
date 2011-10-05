Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934567Ab1JEMBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 08:01:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934513Ab1JEMBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 08:01:48 -0400
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: avi@redhat.com, kvm@vger.kernel.org, joerg.roedel@amd.com, mingo@elte.hu,
        a.p.zijlstra@chello.nl
Subject: [PATCH v2 3/9] perf, tools: Add support for guest/host-only profiling
Date: Wed,  5 Oct 2011 14:01:18 +0200
Message-Id: <1317816084-18026-4-git-send-email-gleb@redhat.com>
In-Reply-To: <1317816084-18026-1-git-send-email-gleb@redhat.com>
References: <1317816084-18026-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

To restrict a counter to either host or guest mode this
patch introduces two new event modifiers: G and H.
With G the counter is configured in guest-only mode and with
H in host-only mode.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 tools/perf/util/parse-events.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 928918b..3b00775 100644
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
1.7.5.3

