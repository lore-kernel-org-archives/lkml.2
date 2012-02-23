Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab2BWCyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 21:54:45 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58161 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab2BWCyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 21:54:44 -0500
X-AuditID: 9c930179-b7c4fae0000073fb-11-4f45aa7160a1
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf evlist: Restore original errno after open failed
Date: Thu, 23 Feb 2012 12:13:36 +0900
Message-Id: <1329966816-23175-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If perf_evsel__open() failed, the errno was set and returned properly.
However since the perf_evlist__open() called close() on fd's for all of
evsel x cpu x thread after the failure, the errno was overridden by
other code (EBADF). So the caller of the function ended up seeing
different error message and getting confused.

Fit it by restoring original return value. Because one of caller of the
function is in the python extension, and it uses system errno internally,
it'd be better restoring the original value rather than using the return
value of the function directly, IMHO (i.e. I'm not a python expert :)

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/evlist.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index ec4e338ee291..1986d8051bd1 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -767,6 +767,7 @@ out_err:
 	list_for_each_entry_reverse(evsel, &evlist->entries, node)
 		perf_evsel__close(evsel, ncpus, nthreads);
 
+	errno = -err;
 	return err;
 }
 
-- 
1.7.9

