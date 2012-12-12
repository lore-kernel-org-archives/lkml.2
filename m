Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750962Ab2LLFk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 00:40:27 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:39244 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750778Ab2LLFk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 00:40:26 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: Neil Zhang <zhangwm@marvell.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>
CC: Chao Xie <cxie4@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 11 Dec 2012 21:38:15 -0800
Subject: RE: [PATCH] sched/rt: don't enable runtime if already enabled
Thread-Topic: [PATCH] sched/rt: don't enable runtime if already enabled
Thread-Index: Ac3RLGYp/SEY+TnwTU+CRLhGZB/RLwA1VntAAYo+kwA=
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE1C737A51CB@SC-VEXCH4.marvell.com>
References: <1354521675-31245-1-git-send-email-zhangwm@marvell.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE1C7364A68B@SC-VEXCH4.marvell.com>
In-Reply-To: <175CCF5F49938B4D99B2E3EF7F558EBE1C7364A68B@SC-VEXCH4.marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBC5eb4D016883

Ingo and All,

-----Original Message-----
From: Neil Zhang 
Sent: 2012Äê12ÔÂ4ÈÕ 17:31
To: Neil Zhang; peterz@infradead.org; mingo@kernel.org
Cc: Chao Xie; linux-kernel@vger.kernel.org
Subject: RE: [PATCH] sched/rt: don't enable runtime if already enabled

Hi All,

-----Original Message-----
From: Neil Zhang [mailto:zhangwm@marvell.com] 
Sent: 2012Äê12ÔÂ3ÈÕ 16:01
To: mingo@redhat.com; peterz@infradead.org
Cc: Chao Xie; linux-kernel@vger.kernel.org; Neil Zhang
Subject: [PATCH] sched/rt: don't enable runtime if already enabled

There are two paths will call __enable_runtime, they are enable_runtime and rq_online. Don't enable runtime again if it is already enabled.
It can fix the following kernel BUG when do cpu hotplug while there are realtime threads running.

[ 3347.091644] kernel BUG at kernel/sched/rt.c:687!
[ 3347.091674] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM [ 3347.091674] Modules linked in: cidatattydev(O) gs_diag(O) diag(O) gs_modem(O) ccinetdev(O) cci_datastub(O) citty(O) msocke
[ 3347.091705] CPU: 1    Tainted: G           O  (3.4.5+ #439)
[ 3347.091735] PC is at __disable_runtime+0x1e4/0x240 [ 3347.091735] LR is at __disable_runtime+0x1dc/0x240
[ 3347.091735] pc : [<c0162124>]    lr : [<c016211c>]    psr:
	a0000093
[ 3347.091735] sp : e0061dc8  ip : c0807861  fp : c07a9740 [ 3347.091766] r10: c1a0b740  r9 : ffffffff  r8 : fd050f80 [ 3347.091766] r7 : 00000002  r6 : 000003f8  r5 : c1a13740  r4 : c1a137d8 [ 3347.091766] r3 : ffffffff  r2 : e0061dbc  r1 : c06b11b6  r0 : 00000037 [ 3347.091796] Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel [ 3347.091796] Control: 10c53c7d  Table: 21e5004a  DAC: 00000015

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 kernel/sched/rt.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c index 418feb0..6525e5b 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -722,9 +722,11 @@ static void __enable_runtime(struct rq *rq)
 
 		raw_spin_lock(&rt_b->rt_runtime_lock);
 		raw_spin_lock(&rt_rq->rt_runtime_lock);
-		rt_rq->rt_runtime = rt_b->rt_runtime;
-		rt_rq->rt_time = 0;
-		rt_rq->rt_throttled = 0;
+		if (rt_rq->rt_runtime == RUNTIME_INF) {
+			rt_rq->rt_runtime = rt_b->rt_runtime;
+			rt_rq->rt_time = 0;
+			rt_rq->rt_throttled = 0;
+		}
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 		raw_spin_unlock(&rt_b->rt_runtime_lock);
 	}
--
1.7.4.1

Ingo seems use another mail now, update the To list.

Best Regards,
Neil Zhang

Please help review it.

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
