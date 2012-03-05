Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab2CEPzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:55:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:53812 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2CEPzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:55:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/7] perf evlist: Restore original errno after open failed
Date: Mon,  5 Mar 2012 12:55:26 -0300
Message-Id: <1330962932-1796-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1330962932-1796-1-git-send-email-acme@infradead.org>
References: <1330962932-1796-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

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
 1 file changed, 1 insertion(+)

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
 
-- 
1.7.9.2.358.g22243

