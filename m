Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab1LMTtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 14:49:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:39382 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab1LMTts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 14:49:48 -0500
Message-ID: <1323805735.9082.47.camel@twins>
Subject: Re: perf NULL pointer dereference on -rc5
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Will Deacon <will.deacon@arm.com>
Cc: eranian@google.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Date: Tue, 13 Dec 2011 20:48:55 +0100
In-Reply-To: <20111213152651.GP20297@mudshark.cambridge.arm.com>
References: <20111213152651.GP20297@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 15:26 +0000, Will Deacon wrote:
> 
> Commit 10c6db11 ("perf: Fix loss of notification with multi-event") seems to
> dereference a NULL event->rb in the wakeup handler during Vince Weaver's perf
> tests (specifically corner_cases/overflow_requires_mmap).
> 
> This diff seems to fix the problem, but I'm not sure if it just hides something else:

No that is about right.. not so very good of us to have missed that.

Can I add your SoB to this? 

---
Subject: perf: Fix ring_buffer_wakeup()
From: Will Deacon <will.deacon@arm.com>
Date: Tue Dec 13 20:40:45 CET 2011

Commit 10c6db11 ("perf: Fix loss of notification with multi-event")
seems to unconditionally dereference event->rb in the wakeup handler,
this is wrong, there might not be a buffer attached.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20111213152651.GP20297@mudshark.cambridge.arm.com
---
 kernel/events/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3360,9 +3360,12 @@ static void ring_buffer_wakeup(struct pe
 
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
+	if (!rb)
+		goto unlock;
 	list_for_each_entry_rcu(event, &rb->event_list, rb_entry) {
 		wake_up_all(&event->waitq);
 	}
+unlock:
 	rcu_read_unlock();
 }
 

