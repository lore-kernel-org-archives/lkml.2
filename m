Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964772Ab2EYT7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 15:59:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41931 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab2EYT71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 15:59:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/4] perf top: Fix counter name fixup when fallbacking to cpu-clock
Date: Fri, 25 May 2012 16:59:17 -0300
Message-Id: <1337975958-24047-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1337975958-24047-1-git-send-email-acme@infradead.org>
References: <1337975958-24047-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

In 40491eaa "perf top: Update event name when falling back to cpu-clock"
we freed counter->name but didn't reset it to NULL, then when setting it
to the result of event_name(), event_name() would use the cached value,
which by now was overwritten and thus we got garbage or a zero lenght
string.

Fix it by just freeing and setting counter->name to NULL, this way
event_name() when called afterwards, will find the right counter name
and cache it again.

Found while trying 'cycles:pp' on a machine were :pp couldn't be
honoured. Probably the best fallback here is to tell the user that that
level of precision is not available on the PMU and then go removing 'p',
levels of precision till we get to play 'cycles' and if even that fails,
_then_ get to 'cpu-clock'.

But that is the matter for another patch, this one just needs to fix the
caching issue, which in the end will show 'cpu-clock' when tools ask for
the event name being used, which clarifies things for the user, that
will see that 'cycles:pp' or whatever not support event is not being
used, some sort of fallback happened.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-w1neie2dqli89we1bzwkf4id@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 6031dce..d4a5f9b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -953,7 +953,7 @@ try_again:
 				attr->config = PERF_COUNT_SW_CPU_CLOCK;
 				if (counter->name) {
 					free(counter->name);
-					counter->name = strdup(event_name(counter));
+					counter->name = NULL;
 				}
 				goto try_again;
 			}
-- 
1.7.9.2.358.g22243

