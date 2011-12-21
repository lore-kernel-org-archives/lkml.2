Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab1LUIna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 03:43:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32833 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab1LUIn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 03:43:28 -0500
Date: Wed, 21 Dec 2011 00:43:03 -0800
From: tip-bot for Nelson Elhage <nelhage@nelhage.com>
Message-ID: <tip-301b195db179241da8be25f345f3c4e64960f1d5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        nelhage@nelhage.com, namhyung@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        nelhage@nelhage.com, namhyung@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1324301972-22740-2-git-send-email-nelhage@nelhage.com>
References: <1324301972-22740-2-git-send-email-nelhage@nelhage.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist:
  Fix errno value reporting on failed mmap
Git-Commit-ID: 301b195db179241da8be25f345f3c4e64960f1d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 00:43:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  301b195db179241da8be25f345f3c4e64960f1d5
Gitweb:     http://git.kernel.org/tip/301b195db179241da8be25f345f3c4e64960f1d5
Author:     Nelson Elhage <nelhage@nelhage.com>
AuthorDate: Mon, 19 Dec 2011 08:39:30 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 20 Dec 2011 13:31:15 -0200

perf evlist: Fix errno value reporting on failed mmap

On failure, perf_evlist__mmap_per_{cpu,thread} will try to munmap()
every map that doesn't have a NULL base. This will fail with EINVAL if
one of them has base == MAP_FAILED, clobbering errno, so that
perf_evlist__map will return EINVAL on any failure regardless of the
root cause.

Fix this by resetting failed maps to a NULL base.

Acked-by: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1324301972-22740-2-git-send-email-nelhage@nelhage.com
Signed-off-by: Nelson Elhage <nelhage@nelhage.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 8b19e7a..963d63d 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -447,8 +447,10 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist,
 	evlist->mmap[idx].mask = mask;
 	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, prot,
 				      MAP_SHARED, fd, 0);
-	if (evlist->mmap[idx].base == MAP_FAILED)
+	if (evlist->mmap[idx].base == MAP_FAILED) {
+		evlist->mmap[idx].base = NULL;
 		return -1;
+	}
 
 	perf_evlist__add_pollfd(evlist, fd);
 	return 0;
