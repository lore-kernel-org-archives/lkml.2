Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab1JMHwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 03:52:44 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40483 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab1JMHwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 03:52:43 -0400
Date: Thu, 13 Oct 2011 15:52:30 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH -rt] hrtimer: Add missing debug_activate() aid [Was: Re:
 [ANNOUNCE] 3.0.6-rt17]
Message-ID: <20111013075230.GA2740@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <alpine.LFD.2.02.1110070046270.3240@ionos>
 <4E8F3605.6060104@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4E8F3605.6060104@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 10:25:25AM -0700, Fernando Lopez-Lezcano wrote:
> On 10/06/2011 06:15 PM, Thomas Gleixner wrote:
> >Dear RT Folks,
> >
> >I'm pleased to announce the 3.0.6-rt17 release.
> 
> Hi and thanks again. So far this one is not hanging which is very
> good news. But I still see the hrtimer_fixup_activate warnings I
> reported for rt16...

Hi Fernando,

I think below patch will smooth your concern?

Thanks,
Yong

---
From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH -rt] hrtimer: Add missing debug_activate() aid

It will fix below warning, which is also reported by Fernando:

[    7.616090] ------------[ cut here ]------------
[    7.616093] WARNING: at kernel/hrtimer.c:391 hrtimer_fixup_activate+0x27/0x50()
[    7.616094] Hardware name: OptiPlex 755
[    7.616096] Modules linked in:
[    7.616099] Pid: 0, comm: kworker/0:0 Tainted: G        W 3.0.6-rt17-00284-g9d73a61 #15
[    7.616100] Call Trace:
[    7.616103]  [<c014d9a2>] warn_slowpath_common+0x72/0xa0
[    7.616106]  [<c0175417>] ? hrtimer_fixup_activate+0x27/0x50
[    7.616109]  [<c0175417>] ? hrtimer_fixup_activate+0x27/0x50
[    7.616112]  [<c014d9f2>] warn_slowpath_null+0x22/0x30
[    7.616115]  [<c0175417>] hrtimer_fixup_activate+0x27/0x50
[    7.616118]  [<c03b3ab0>] debug_object_activate+0x100/0x130
[    7.616121]  [<c0176b96>] ? hrtimer_start_range_ns+0x26/0x30
[    7.616123]  [<c0175a59>] enqueue_hrtimer+0x19/0x100
[    7.616126]  [<c0176b96>] ? hrtimer_start_range_ns+0x26/0x30
[    7.616129]  [<c0176744>] __hrtimer_start_range_ns+0x144/0x540
[    7.616132]  [<c072705a>] ? _raw_spin_unlock_irqrestore+0x3a/0x80
[    7.616136]  [<c0176b96>] hrtimer_start_range_ns+0x26/0x30
[    7.616139]  [<c01852b5>] tick_nohz_restart_sched_tick+0x185/0x1b0
[    7.616142]  [<c0101878>] cpu_idle+0x98/0xc0
[    7.616146]  [<c071fcd8>] start_secondary+0x1d3/0x1da
[    7.616148] ---[ end trace 0000000000000003 ]---

Reported-by: Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>
Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 kernel/hrtimer.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index dfa77c5..af89591 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1040,6 +1040,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 			 * remove it again and report a failure. This avoids
 			 * stale base->first entries.
 			 */
+			debug_deactivate(timer);
 			__remove_hrtimer(timer, new_base,
 					timer->state & HRTIMER_STATE_CALLBACK, 0);
 		}
-- 
1.7.4.1

