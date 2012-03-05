Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab2CEQUC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:20:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60868 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab2CEQT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:19:58 -0500
Date: Mon, 5 Mar 2012 08:18:54 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-41c21a68308f2f268a01ec1a7fa5f650e320a0f3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1329966816-23175-1-git-send-email-namhyung.kim@lge.com>
References: <1329966816-23175-1-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist:
  Restore original errno after open failed
Git-Commit-ID: 41c21a68308f2f268a01ec1a7fa5f650e320a0f3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Mar 2012 08:19:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41c21a68308f2f268a01ec1a7fa5f650e320a0f3
Gitweb:     http://git.kernel.org/tip/41c21a68308f2f268a01ec1a7fa5f650e320a0f3
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 23 Feb 2012 12:13:36 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Mar 2012 10:15:49 -0300

perf evlist: Restore original errno after open failed

If perf_evsel__open() failed, the errno was set and returned properly.

However since the perf_evlist__open() called close() on fd's for all of
evsel x cpu x thread after the failure, the errno was overridden by
other code (EBADF). So the caller of the function ended up seeing
different error message and getting confused.

Fit it by restoring original return value. Because one of caller of the
function is in the python extension, and it uses system errno
internally, it'd be better restoring the original value rather than
using the return value of the function directly, IMHO (i.e. I'm not a
python expert :)

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1329966816-23175-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index f8da9fa..159263d 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -765,6 +765,7 @@ out_err:
 	list_for_each_entry_reverse(evsel, &evlist->entries, node)
 		perf_evsel__close(evsel, ncpus, nthreads);
 
+	errno = -err;
 	return err;
 }
 
