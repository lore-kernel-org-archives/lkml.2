Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611Ab2CBJvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 04:51:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44080 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab2CBJvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 04:51:11 -0500
Date: Fri, 2 Mar 2012 01:49:45 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-30e68bcc67e41ab6dab4e4e1efc7ea8ca893c0af@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, namhyung.kim@lge.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, namhyung.kim@lge.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1329702447-25045-1-git-send-email-namhyung.kim@lge.com>
References: <1329702447-25045-1-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evlist:
  Return first evsel for non-sample event on old kernel
Git-Commit-ID: 30e68bcc67e41ab6dab4e4e1efc7ea8ca893c0af
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 02 Mar 2012 01:50:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30e68bcc67e41ab6dab4e4e1efc7ea8ca893c0af
Gitweb:     http://git.kernel.org/tip/30e68bcc67e41ab6dab4e4e1efc7ea8ca893c0af
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 20 Feb 2012 10:47:26 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Feb 2012 18:29:44 -0300

perf evlist: Return first evsel for non-sample event on old kernel

On old kernels that don't support sample_id_all feature,
perf_evlist__id2evsel() returns NULL for non-sampling events.

This breaks perf top when multiple events are given on command line. Fix
it by using first evsel in the evlist. This will also prevent getting
the same (potential) problem in such new tool/ old kernel combo.

Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1329702447-25045-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 3f16e08..ea32a06 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -349,6 +349,10 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
 	hlist_for_each_entry(sid, pos, head, node)
 		if (sid->id == id)
 			return sid->evsel;
+
+	if (!perf_evlist__sample_id_all(evlist))
+		return list_entry(evlist->entries.next, struct perf_evsel, node);
+
 	return NULL;
 }
 
