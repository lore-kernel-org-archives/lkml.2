Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab0L1W3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 17:29:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39943 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab0L1W3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 17:29:17 -0500
Date: Tue, 28 Dec 2010 23:29:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] tracing fix
Message-ID: <20101228222903.GB29245@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
David Sharp (1):
      ring_buffer: Off-by-one and duplicate events in ring_buffer_read_page


 kernel/trace/ring_buffer.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 9ed509a..bd1c35a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3853,6 +3853,13 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 
 		/* Need to copy one event at a time */
 		do {
+			/* We need the size of one event, because
+			 * rb_advance_reader only advances by one event,
+			 * whereas rb_event_ts_length may include the size of
+			 * one or two events.
+			 * We have already ensured there's enough space if this
+			 * is a time extend. */
+			size = rb_event_length(event);
 			memcpy(bpage->data + pos, rpage->data + rpos, size);
 
 			len -= size;
@@ -3867,7 +3874,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 			event = rb_reader_event(cpu_buffer);
 			/* Always keep the time extend and data together */
 			size = rb_event_ts_length(event);
-		} while (len > size);
+		} while (len >= size);
 
 		/* update bpage */
 		local_set(&bpage->commit, pos);
