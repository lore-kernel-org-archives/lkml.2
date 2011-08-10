Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab1HJIZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 04:25:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:50833 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab1HJIZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 04:25:39 -0400
Date: Wed, 10 Aug 2011 08:25:14 GMT
From: tip-bot for Jovi Zhang <bookjovi@gmail.com>
Message-ID: <tip-ce27a443d17dccf613079a7147cf0d220bc4ec82@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        bookjovi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        bookjovi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1311602888-2389-1-git-send-email-bookjovi@gmail.com>
References: <1311602888-2389-1-git-send-email-bookjovi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Fix coredump introduced by probe module option
Git-Commit-ID: ce27a443d17dccf613079a7147cf0d220bc4ec82
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Aug 2011 08:25:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce27a443d17dccf613079a7147cf0d220bc4ec82
Gitweb:     http://git.kernel.org/tip/ce27a443d17dccf613079a7147cf0d220bc4ec82
Author:     Jovi Zhang <bookjovi@gmail.com>
AuthorDate: Mon, 25 Jul 2011 22:08:08 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Aug 2011 09:35:41 -0300

perf probe: Fix coredump introduced by probe module option

perf will coredump if the user doesn't give the "-m" option in probe
command, this patch fixes it.

[root@localhost perf]# ./perf probe --add='PROBE'
Segmentation fault (core dumped)

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1311602888-2389-1-git-send-email-bookjovi@gmail.com
Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index b82d54f..1c7bfa5 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1820,11 +1820,15 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
 		ret = -ENOMEM;
 		goto error;
 	}
-	tev->point.module = strdup(module);
-	if (tev->point.module == NULL) {
-		ret = -ENOMEM;
-		goto error;
+
+	if (module) {
+		tev->point.module = strdup(module);
+		if (tev->point.module == NULL) {
+			ret = -ENOMEM;
+			goto error;
+		}
 	}
+
 	tev->point.offset = pev->point.offset;
 	tev->point.retprobe = pev->point.retprobe;
 	tev->nargs = pev->nargs;
