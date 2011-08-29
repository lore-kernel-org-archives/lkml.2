Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab1H2MlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 08:41:25 -0400
Received: from smtp-out.google.com ([74.125.121.67]:28939 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab1H2MlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 08:41:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:to:cc:subject:message-id:
	mime-version:content-type:content-disposition:user-agent:x-system-of-record;
	b=xO4Nfrq2RWOIwInXsknZVAhJy15H3fqVXt2leKVhdshpboIyQYUFggPKkvIdZx1va
	KdjQ2ZS8j7+NiRu2uZt+A==
Date: Mon, 29 Aug 2011 14:41:12 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, emunson@mgebm.net,
        vweaver1@eecs.utk.edu
Subject: [PATCH] perf_event: fix broken calc_timer_values()
Message-ID: <20110829124112.GA4828@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We detected a serious issue with PERF_SAMPLE_READ and
timing information when events were being multiplexing.

Samples would have time_running > time_enabled. That
was easy to reproduce with a libpfm4 example (ran 3
times to cause multiplexing on Core 2):

$ syst_smpl -e uops_retired:freq=1 &
$ syst_smpl -e uops_retired:freq=1 &
$ syst_smpl -e uops_retired:freq=1 &
IIP:0x0000000040062d ... PERIOD:2355332948 ENA=40144625315 RUN=60014875184
syst_smpl: WARNING: time_running > time_enabled
	63277537998 uops_retired:freq=1 , scaled

The bug was not present in kernel up to 3.0. It turns
out the bug was introduced by the following commit:

commit c4794295917ebeda8013b6cb9c8d71ab4f74a1fa
Author: Eric B Munson <emunson@mgebm.net>
Date:   Thu Jun 23 16:34:38 2011 -0400

    events: Move lockless timer calculation into helper function
    
The parameters of the function got reversed yet the call sites
were not updated to reflect the change. That lead to time_running
and time_enabled being swapped. That had no effect when there was
no multiplexing because in that case time_running = time_enabled
but it would show up in any other scenario.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/kernel/events/core.c b/kernel/events/core.c
index adc3ef3..6bacaee 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3354,8 +3354,8 @@ static int perf_event_index(struct perf_event *event)
 }
 
 static void calc_timer_values(struct perf_event *event,
-				u64 *running,
-				u64 *enabled)
+				u64 *enabled,
+				u64 *running)
 {
 	u64 now, ctx_time;
 
