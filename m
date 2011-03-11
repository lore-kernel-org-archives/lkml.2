Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab1CKJr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:47:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:46007 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab1CKJr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:47:27 -0500
Date: Fri, 11 Mar 2011 09:47:00 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, phan@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, phan@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1299528821-17521-3-git-send-email-jolsa@redhat.com>
References: <1299528821-17521-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Don't let events to eat up whole header line
Message-ID: <tip-6547250381eb315acff3d52b4872ad775359407c@git.kernel.org>
Git-Commit-ID: 6547250381eb315acff3d52b4872ad775359407c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 11 Mar 2011 09:47:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6547250381eb315acff3d52b4872ad775359407c
Gitweb:     http://git.kernel.org/tip/6547250381eb315acff3d52b4872ad775359407c
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 7 Mar 2011 21:13:41 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 10 Mar 2011 10:55:00 -0300

perf top: Don't let events to eat up whole header line

Passing multiple events might force out information about pid/tid/cpu.
Attached patch leaves 30 characters for this info at the expense of the
events' names.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Han Pingtian <phan@redhat.com>
LKML-Reference: <1299528821-17521-3-git-send-email-jolsa@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/top.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index 4f869da..75cfe4d 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -115,9 +115,23 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 	if (!top->display_weighted) {
 		ret += SNPRINTF(bf + ret, size - ret, "%s",
 				event_name(top->sym_evsel));
-	} else list_for_each_entry(counter, &top->evlist->entries, node) {
-		ret += SNPRINTF(bf + ret, size - ret, "%s%s",
-				counter->idx ? "/" : "", event_name(counter));
+	} else {
+		/*
+		 * Don't let events eat all the space. Leaving 30 bytes
+		 * for the rest should be enough.
+		 */
+		size_t last_pos = size - 30;
+
+		list_for_each_entry(counter, &top->evlist->entries, node) {
+			ret += SNPRINTF(bf + ret, size - ret, "%s%s",
+					counter->idx ? "/" : "",
+					event_name(counter));
+			if (ret > last_pos) {
+				sprintf(bf + last_pos - 3, "..");
+				ret = last_pos - 1;
+				break;
+			}
+		}
 	}
 
 	ret += SNPRINTF(bf + ret, size - ret, "], ");
