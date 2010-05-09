Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab0EIUpQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 16:45:16 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:55564 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab0EIUnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 16:43:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=nDWBb472uYvkrLIv1V3FIEM72alOGy1VVgVwsZcvqUMK0oEU9rvWi6nHscFa1dKMfm
         UKUKCsrWEttkbYEj2ehJQo8jWeeDk5e7YXuqxGHnnz63yRt8G/KQFB3gnmYN2G543f1C
         O/dxn4tZc/Uk510SpLcAMqC3/q7YgAQajz+Iw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [PATCH 05/10] perf lock: Always check min AND max wait time
Date: Sun,  9 May 2010 22:43:33 +0200
Message-Id: <1273437818-8130-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
References: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a lock is acquired after beeing contended, we update the
wait time statistics for the given lock.
But if the min wait time is updated, we don't check the max wait
time. This is wrong because the first time we update the wait time,
we want to update both min and max wait time.

Before:
	Name   acquired  contended total wait (ns)   max wait (ns)   min wait (ns)
	key          8          1           21656           0           21656

After:
	Name   acquired  contended total wait (ns)   max wait (ns)   min wait (ns)
	key          8          1           21656           21656           21656

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
---
 tools/perf/builtin-lock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index d7dde9c..e549f45 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -496,7 +496,7 @@ report_lock_acquired_event(struct trace_acquired_event *acquired_event,
 		ls->wait_time_total += contended_term;
 		if (contended_term < ls->wait_time_min)
 			ls->wait_time_min = contended_term;
-		else if (ls->wait_time_max < contended_term)
+		if (ls->wait_time_max < contended_term)
 			ls->wait_time_max = contended_term;
 		break;
 	case SEQ_STATE_RELEASED:
-- 
1.6.2.3

