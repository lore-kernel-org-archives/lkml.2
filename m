Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab2LLJje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:39:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54026 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab2LLJja convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:39:30 -0500
Message-ID: <1355305167.6142.15.camel@marge.simpson.net>
Subject: RE: [PATCH] sched/rt: don't enable runtime if already enabled
From: Mike Galbraith <bitbucket@online.de>
To: Neil Zhang <zhangwm@marvell.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>, Chao Xie <cxie4@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 12 Dec 2012 10:39:27 +0100
In-Reply-To: <175CCF5F49938B4D99B2E3EF7F558EBE1C737A51CB@SC-VEXCH4.marvell.com>
References: <1354521675-31245-1-git-send-email-zhangwm@marvell.com>
	 <175CCF5F49938B4D99B2E3EF7F558EBE1C7364A68B@SC-VEXCH4.marvell.com>
	 <175CCF5F49938B4D99B2E3EF7F558EBE1C737A51CB@SC-VEXCH4.marvell.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Provags-ID: V02:K0:DzYutkpm8a+yUbJyyclRnaxhNEqbft1QpOIIb04MIJz
 8aTxzOTAhhdgqZ9qRpH2/Cudo59sYo+Nkvf3pm9IBU6xeYkg7b
 xRJ07dfn9iri+FTjw4qrc1ZaQplVhKWxozksbmxxvaprLDvse4
 WDR7VMm0o2ywh+DjBIDnff7e+TuJnT9fcYXAlXP44K5x925mzt
 HIP87+BSrMa4qkDjLn8LDm+0Ej82NLkyF99ROosy+rXsgjRC7Q
 75frfYE7Ikfuyv5JjPFIFXgan1lX7sOABi3MGKP0BQs02q0FoO
 v/vNQ+z3YWEKtIyUNm8EYdaIkAIQSajsrYs1CTyWogOtHPyYul
 viy4XvEBWZsNwBd2yRZ4E9lRNRfokQn1Z1y40CZmLZKZm5Vp1y
 lKqpJZL4o99Eg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-11 at 21:38 -0800, Neil Zhang wrote: 
> Ingo and All,

Hm, /me wonders why we would even need update_runtime() handler.  We
disable at CPU_DOWN_PREPARE in update_runtime(), again at CPU_DYING in
migration_call(), and enable at CPU_ONLINE in both.

> -----Original Message-----
> From: Neil Zhang 
> Sent: 2012年12月4日 17:31
> To: Neil Zhang; peterz@infradead.org; mingo@kernel.org
> Cc: Chao Xie; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH] sched/rt: don't enable runtime if already enabled
> 
> Hi All,
> 
> -----Original Message-----
> From: Neil Zhang [mailto:zhangwm@marvell.com] 
> Sent: 2012年12月3日 16:01
> To: mingo@redhat.com; peterz@infradead.org
> Cc: Chao Xie; linux-kernel@vger.kernel.org; Neil Zhang
> Subject: [PATCH] sched/rt: don't enable runtime if already enabled
> 
> There are two paths will call __enable_runtime, they are enable_runtime and rq_online. Don't enable runtime again if it is already enabled.
> It can fix the following kernel BUG when do cpu hotplug while there are realtime threads running.
> 
> [ 3347.091644] kernel BUG at kernel/sched/rt.c:687!
> [ 3347.091674] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM [ 3347.091674] Modules linked in: cidatattydev(O) gs_diag(O) diag(O) gs_modem(O) ccinetdev(O) cci_datastub(O) citty(O) msocke
> [ 3347.091705] CPU: 1    Tainted: G           O  (3.4.5+ #439)
> [ 3347.091735] PC is at __disable_runtime+0x1e4/0x240 [ 3347.091735] LR is at __disable_runtime+0x1dc/0x240
> [ 3347.091735] pc : [<c0162124>]    lr : [<c016211c>]    psr:
> 	a0000093
> [ 3347.091735] sp : e0061dc8  ip : c0807861  fp : c07a9740 [ 3347.091766] r10: c1a0b740  r9 : ffffffff  r8 : fd050f80 [ 3347.091766] r7 : 00000002  r6 : 000003f8  r5 : c1a13740  r4 : c1a137d8 [ 3347.091766] r3 : ffffffff  r2 : e0061dbc  r1 : c06b11b6  r0 : 00000037 [ 3347.091796] Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel [ 3347.091796] Control: 10c53c7d  Table: 21e5004a  DAC: 00000015
> 
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>  kernel/sched/rt.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c index 418feb0..6525e5b 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -722,9 +722,11 @@ static void __enable_runtime(struct rq *rq)
>  
>  		raw_spin_lock(&rt_b->rt_runtime_lock);
>  		raw_spin_lock(&rt_rq->rt_runtime_lock);
> -		rt_rq->rt_runtime = rt_b->rt_runtime;
> -		rt_rq->rt_time = 0;
> -		rt_rq->rt_throttled = 0;
> +		if (rt_rq->rt_runtime == RUNTIME_INF) {
> +			rt_rq->rt_runtime = rt_b->rt_runtime;
> +			rt_rq->rt_time = 0;
> +			rt_rq->rt_throttled = 0;
> +		}
>  		raw_spin_unlock(&rt_rq->rt_runtime_lock);
>  		raw_spin_unlock(&rt_b->rt_runtime_lock);
>  	}
> --
> 1.7.4.1
> 
> Ingo seems use another mail now, update the To list.
> 
> Best Regards,
> Neil Zhang
> 
> Please help review it.
> 
> Best Regards,
> Neil Zhang
> NР骒rybX肚v^)藓{.n+伐{赙zXФ≤}财z&j:+v赙zZ++zf＂h~izwア?ㄨ&)撷f^j谦ym@Aa囤0鹅hi


