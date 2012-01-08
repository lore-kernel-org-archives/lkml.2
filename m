Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab2AHLuG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 06:50:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39218 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2AHLuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 06:50:04 -0500
Date: Sun, 8 Jan 2012 03:49:38 -0800
From: tip-bot for Joerg Roedel <joerg.roedel@amd.com>
Message-ID: <tip-or5aj3rghy9ngyg882z6kln9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, joerg.roedel@amd.com,
        joro@8bytes.org, gleb@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, joerg.roedel@amd.com, a.p.zijlstra@chello.nl,
        joro@8bytes.org, gleb@redhat.com, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add support for guest/
 host-only profiling
Git-Commit-ID: 99320cc8240affcf33c04d28f47259de3b1a75d1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 08 Jan 2012 03:49:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99320cc8240affcf33c04d28f47259de3b1a75d1
Gitweb:     http://git.kernel.org/tip/99320cc8240affcf33c04d28f47259de3b1a75d1
Author:     Joerg Roedel <joerg.roedel@amd.com>
AuthorDate: Wed, 4 Jan 2012 17:54:19 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 6 Jan 2012 15:49:49 -0200

perf tools: Add support for guest/host-only profiling

To restrict a counter to either host or guest mode this patch introduces
two new event modifiers: G and H.

With G the counter is configured in guest-only mode and with H in
host-only mode.

Cc: Gleb Natapov <gleb@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Link: http://lkml.kernel.org/n/tip-or5aj3rghy9ngyg882z6kln9@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-list.txt |    2 ++
 tools/perf/util/parse-events.c         |   14 ++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index 7a527f7..ddc2252 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -21,6 +21,8 @@ EVENT MODIFIERS
 Events can optionally have a modifer by appending a colon and one or
 more modifiers.  Modifiers allow the user to restrict when events are
 counted with 'u' for user-space, 'k' for kernel, 'h' for hypervisor.
+Additional modifiers are 'G' for guest counting (in KVM guests) and 'H'
+for host counting (not in KVM guests).
 
 The 'p' modifier can be used for specifying how precise the instruction
 address should be. The 'p' modifier is currently only implemented for
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index dcf999c..b029296 100644
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
