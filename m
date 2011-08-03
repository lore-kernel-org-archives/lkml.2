Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab1HCLuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 07:50:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:49730 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab1HCLui convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 07:50:38 -0400
Subject: Re: [stable] [perf] overflow/perf_count_sw_cpu_clock crashes
 recent kernels
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Greg KH <greg@kroah.com>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        stable <stable@kernel.org>
In-Reply-To: <20110802163529.GA1341@kroah.com>
References: <alpine.DEB.2.00.1107221210160.21367@cl320.eecs.utk.edu>
	 <alpine.DEB.2.00.1107271446460.406@cl320.eecs.utk.edu>
	 <1311878830.2617.373.camel@laptop> <20110729050514.GA24999@kroah.com>
	 <1311940750.5890.348.camel@twins>  <20110802163529.GA1341@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 03 Aug 2011 13:49:31 +0200
Message-ID: <1312372171.1147.302.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-02 at 09:35 -0700, Greg KH wrote:
> On Fri, Jul 29, 2011 at 01:59:10PM +0200, Peter Zijlstra wrote:
> > On Thu, 2011-07-28 at 22:05 -0700, Greg KH wrote:
> > > 
> > > What is that commit id so it can be properly referenced in the patch
> > > below?  And what tree should this patch go into?  .39?  3.0?  Anything
> > > newer? 
> > 
> > .32+ in as far as anybody is still maintaining them, if it fails to
> > apply to any of them (quite possible) do tell and I can provide
> > backports etc..
> 
> I've applied it to 3.0, and it didn't apply to any older kernel due to
> file movements, so if you could, can you provide a version for
> .32-stable?


---
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

The below patch is for -stable only, upstream has a much larger patch
that contains the below hunk in commit a8b0ca17b80e92faab46ee7179ba9e99ccb61233

Vince found that under certain circumstances software event overflows
go wrong and deadlock. Avoid trying to delete a timer from the timer
callback.

Reported-by: Vince Weaver <vweaver1@eecs.utk.edu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 183d437..8f97aea 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3693,12 +3693,8 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
 	if (events && atomic_dec_and_test(&event->event_limit)) {
 		ret = 1;
 		event->pending_kill = POLL_HUP;
-		if (nmi) {
-			event->pending_disable = 1;
-			perf_pending_queue(&event->pending,
-					   perf_pending_event);
-		} else
-			perf_event_disable(event);
+		event->pending_disable = 1;
+		perf_pending_queue(&event->pending, perf_pending_event);
 	}
 
 	perf_event_output(event, nmi, data, regs);

