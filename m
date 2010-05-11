Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab0EKHs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 03:48:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:45429 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab0EKHsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 03:48:25 -0400
Subject: Re: [BUG] perf_event: crash in perf_output_begin
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       perfmon2-devel@lists.sf.net
In-Reply-To: <AANLkTinNDC2g79VzfKjpm0bN1LOE5OeuVxvacjrNsz7s@mail.gmail.com>
References: <AANLkTilxN7Lq8yywpsz8voqYo0hqOX0DGcoqHmAdmFW_@mail.gmail.com>
	 <1273506739.5605.3407.camel@twins>
	 <AANLkTinNDC2g79VzfKjpm0bN1LOE5OeuVxvacjrNsz7s@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 11 May 2010 09:47:57 +0200
Message-ID: <1273564077.5605.3489.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 22:03 +0200, Stephane Eranian wrote:
> On Mon, May 10, 2010 at 5:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2010-05-10 at 17:33 +0200, Stephane Eranian wrote:
> >> Hi,
> >>
> >> While testing 2.6.34-rc7 I ran into the following issue when
> >> using BTS sampling on Intel Core. It seems like something
> >> is not terminated properly. I am sampling BTS per-thread
> >> on a test program, then hit CTRL-C, one second later my
> >> machine crashes while running bash. Crash dump below:
> >>
> >> [  750.249109] general protection fault: 0000 [#1] SMP
> >> [  750.249270] CPU 3
> >> [  750.249270] Pid: 6132, comm: bash Not tainted 2.6.34-rc7-tip+ #46
> >
> > Can you try and reverting 4fd38e4595e2f6c9d27732c042a0e16b2753049c, I
> > spend most of the day chasing that, and I can't say I'm much wiser.
> >
> 
> It seems to avoid my problem. So that means with STATE_FREE, some code
> path is exercised differently and there is leftover state that
> generates spurious
> interrupts, as if some event_sched_out() code was not executed.

You're spot on. I'll send a full new patch Ingo wards as he already
pushed out the revert.

---
 kernel/perf_event.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 180151f..91f277e 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1871,6 +1871,7 @@ int perf_event_release_kernel(struct perf_event *event)
 {
 	struct perf_event_context *ctx = event->ctx;
 
+	perf_event_disable(event);
 	event->state = PERF_EVENT_STATE_FREE;
 
 	WARN_ON_ONCE(ctx->parent_ctx);

