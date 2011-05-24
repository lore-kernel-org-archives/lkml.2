Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab1EXPTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:19:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54387 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836Ab1EXPTO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:19:14 -0400
Subject: Re: perf: regression with PERF_EVENT_IOC_REFRESH
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: linux-kernel@vger.kernel.org, fbuihuu@gmail.com, mingo@elte.hu,
        paulus@samba.org, acme@redhat.com
In-Reply-To: <1306249914.18455.43.camel@twins>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu>
	 <1306182141.2497.5.camel@laptop>
	 <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu>
	 <1306233036.2497.15.camel@laptop>
	 <alpine.DEB.2.00.1105241041490.10575@cl320.eecs.utk.edu>
	 <1306249914.18455.43.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 24 May 2011 17:18:38 +0200
Message-ID: <1306250318.18455.44.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 17:11 +0200, Peter Zijlstra wrote:
> On Tue, 2011-05-24 at 11:04 -0400, Vince Weaver wrote:
> > As an aside, I also wasted 6 hours last night finding out that you don't 
> > get signaled on overflow if you don't have a ring-buffer mmap()ed, even
> > if you never read from the buffer and you only are interested in counting
> > the number of overflows. 
> 
> That sounds like something we could fix, let me investigate.

Does the below cure this?

---
 kernel/events/core.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index c09767f..bd1ba5e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5018,9 +5018,12 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
 		event->pending_kill = POLL_HUP;
 		if (nmi) {
 			event->pending_disable = 1;
+			event->pending_wakeup = 1;
 			irq_work_queue(&event->pending);
-		} else
+		} else {
 			perf_event_disable(event);
+			perf_event_wakeup(event);
+		}
 	}
 
 	if (event->overflow_handler)

