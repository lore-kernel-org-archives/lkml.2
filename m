Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab1JCJib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:38:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37868 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab1JCJiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:38:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:to:cc:subject:message-id:
	mime-version:content-type:content-disposition:user-agent:x-system-of-record;
	b=Oygpk01STjLvE8zxEU6E6x24SOMEOKi486LfVQfnX4HtSbML7vQWxTuVsMKfl7mnh
	nstFXOpaMWVyxXmQbTe0Q==
Date: Mon, 3 Oct 2011 11:38:15 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, mingo@elte.hu, dsahern@gmail.com
Subject: [PATCH] perf: fix broken number of samples for perf report -n
Message-ID: <20111003093815.GA6393@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The perf report -n option was broken because it was not reporting
the correct number of samples depending on the sorting mode. By
default, samples are sorted by comm,dso,sym. That means that
samples for the same command (binary) get collapsed.

The hists__collapse_insert_entry() had a bug whereby
it was aggregating the number of events observed (periods)
but not the number of samples. Consequently, the number
of samples reported could be below reality. The percentage
remained correct because based on the periods.

This patch fixes the problem by also aggregating
the number of samples. Here is an example:

$ perf report -n --stdio
# Events: 13K cycles
#
# Overhead  Samples    Command         Shared Object               Symbol
# ........ ..........  .......  ....................  ...................
#
    12.38%        842     pong  [kernel.kallsyms]     [k] __lock_acquire

Here pong (a ctxsw stress test), is the only program running
and thus it is the only one responsible for the lock_acquire samples.

If we change the sorting mode:

$ perf report -n --stdio --sort=sym
# Events: 13K cycles
#
# Overhead  Samples                         Symbol
# ........ ..........  ...........................
#
    12.38%       1732  [k] __lock_acquire

The actual number of samples is shown.

With the fix:

$ perf report -n --stdio
# Events: 13K cycles
#
# Overhead  Samples    Command         Shared Object               Symbol
# ........ ..........  .......  ....................  ...................
#
    12.38%       1732     pong  [kernel.kallsyms]     [k] __lock_acquire

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 677e1da..649eb99 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -239,6 +239,7 @@ static bool hists__collapse_insert_entry(struct hists *self,
 
 		if (!cmp) {
 			iter->period += he->period;
+			iter->nr_events += he->nr_events;
 			if (symbol_conf.use_callchain) {
 				callchain_cursor_reset(&self->callchain_cursor);
 				callchain_merge(&self->callchain_cursor, iter->callchain,
