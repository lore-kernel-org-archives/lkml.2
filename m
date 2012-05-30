Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab2E3Hps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:45:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35281 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab2E3Hpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:45:46 -0400
Date: Wed, 30 May 2012 00:45:29 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-w1neie2dqli89we1bzwkf4id@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf top:
  Fix counter name fixup when fallbacking to cpu-clock
Git-Commit-ID: 895d97663c83f8ed7a3386e912009155524fe7dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 00:45:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  895d97663c83f8ed7a3386e912009155524fe7dd
Gitweb:     http://git.kernel.org/tip/895d97663c83f8ed7a3386e912009155524fe7dd
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 25 May 2012 14:49:51 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 25 May 2012 14:59:37 -0300

perf top: Fix counter name fixup when fallbacking to cpu-clock

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
 1 files changed, 1 insertions(+), 1 deletions(-)

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
