Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030576Ab2CCAJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 19:09:37 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38822 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965489Ab2CCAJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 19:09:34 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of anton.vorontsov@linaro.org designates 10.204.133.204 as permitted sender) smtp.mail=anton.vorontsov@linaro.org
Date: Sat, 3 Mar 2012 04:09:32 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 3/3] vmevent: Should not grab mutex in the atomic context
Message-ID: <20120303000932.GC30207@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is not need to grab mutex in the atomic context, moreover this is
wrong and causes the following bug:

BUG: sleeping function called from invalid context at kernel/mutex.c:271
in_atomic(): 1, irqs_disabled(): 1, pid: 1056, name: m
no locks held by m/1056.
irq event stamp: 58768
hardirqs last  enabled at (58767): [<ffffffff8101ca35>] do_page_fault+0x275/0x450
hardirqs last disabled at (58768): [<ffffffff81325a2b>] apic_timer_interrupt+0x6b/0x80
softirqs last  enabled at (58676): [<ffffffff81038def>] __do_softirq+0x10f/0x160
softirqs last disabled at (58671): [<ffffffff813262ac>] call_softirq+0x1c/0x26
Pid: 1056, comm: m Not tainted 3.2.0+ #3
Call Trace:
 <IRQ>  [<ffffffff81062530>] ? print_irqtrace_events+0xd0/0xe0
 [<ffffffff8102f5da>] __might_sleep+0x12a/0x1e0
 [<ffffffff81321dbc>] mutex_lock_nested+0x3c/0x340
 [<ffffffff81053a8c>] ? __run_hrtimer+0x4c/0x100
 [<ffffffff810bd920>] ? vmevent_read+0x100/0x100
 [<ffffffff810bd79e>] vmevent_sample+0x6e/0xf0
 [<ffffffff810bd946>] vmevent_timer_fn+0x26/0x60
 [<ffffffff81053a92>] __run_hrtimer+0x52/0x100
 [<ffffffff81054463>] hrtimer_interrupt+0xf3/0x220
 [<ffffffff810166d4>] smp_apic_timer_interrupt+0x64/0xa0
 [<ffffffff81325a30>] apic_timer_interrupt+0x70/0x80
 <EOI>  [<ffffffff8101ca3a>] ? do_page_fault+0x27a/0x450
 [<ffffffff8101ca35>] ? do_page_fault+0x275/0x450
 [<ffffffff810036bf>] ? do_softirq+0x6f/0xc0
 [<ffffffff8132485d>] ? retint_restore_args+0xe/0xe
 [<ffffffff8132484a>] ? retint_swapgs+0xe/0x13
 [<ffffffff8116b31d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff81324a3f>] page_fault+0x1f/0x30

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---

The patch is for git://github.com/penberg/linux.git vmevent/core.

 mm/vmevent.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/mm/vmevent.c b/mm/vmevent.c
index 1375f9d..1dbefb5 100644
--- a/mm/vmevent.c
+++ b/mm/vmevent.c
@@ -71,8 +71,6 @@ static void vmevent_sample(struct vmevent_watch *watch)
 	if (!vmevent_match(watch, &event))
 		return;
 
-	mutex_lock(&watch->mutex);
-
 	watch->pending = true;
 
 	if (watch->config.event_attrs & VMEVENT_EATTR_NR_AVAIL_PAGES)
@@ -85,8 +83,6 @@ static void vmevent_sample(struct vmevent_watch *watch)
 		watch->attr_values[n++] = event.nr_swap_pages;
 
 	watch->nr_attrs = n;
-
-	mutex_unlock(&watch->mutex);
 }
 
 static enum hrtimer_restart vmevent_timer_fn(struct hrtimer *hrtimer)
-- 
1.7.7.6
