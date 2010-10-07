Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab0JGTmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 15:42:08 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:24139 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751930Ab0JGTmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 15:42:06 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: J6_80yQVM1n8QC7YzLaeZKxi1BN_M2erir3G1ExMclxX0rm
 LNS5X46HJ3qfoIfMIfrsIkEvkIYIiHbHdZFoRonhZKMpFG2AOCefRPXJWDqu
 ww8Zs6oSdrlPs_5UWqM2z1x_dYO5iinf5DI3YMOtF4oCmYczx_fcUtjmgAeY
 .tcHAM0GuhIcVhpQ.HN1q5s.PJ16EYU5hg6I049Zf8nyyOJzqcGgljiLQlTr
 SBW1C12xxa_Bwo6EmrzuF3qEEltVENmQUCA--
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 7 Oct 2010 14:42:02 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] percpu_counter: change inaccurate comment
In-Reply-To: <1286469421.2912.240.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1010071440220.28032@router.home>
References: <1286469421.2912.240.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Oct 2010, Eric Dumazet wrote:

> percpu_counter used to be huge objects, they are not anymore,
> thanks to fine alloc_percpu() granularity.
>
> We now consume 4 bytes per possible cpu.

Ahh I did not notice that they switched.... Then we may also want the
following patch to improve performance. It would even be better if we
could do a this_cpu_add(fbc->counters, amount) there but the 64 bit size
fo count looks suspiciously like you are expecting overflows beyond ints
max size.


Subject: percpu_counter: Use this_cpu_ptr instead of per_cpu_ptr

this_cpu_ptr avoids an array lookup and can use the percpu
offset of the local cpu directly.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 lib/percpu_counter.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/lib/percpu_counter.c
===================================================================
--- linux-2.6.orig/lib/percpu_counter.c	2010-10-07 14:36:39.000000000 -0500
+++ linux-2.6/lib/percpu_counter.c	2010-10-07 14:38:43.000000000 -0500
@@ -30,9 +30,9 @@ void __percpu_counter_add(struct percpu_
 {
 	s64 count;
 	s32 *pcount;
-	int cpu = get_cpu();

-	pcount = per_cpu_ptr(fbc->counters, cpu);
+	preempt_disable();
+	pcount = this_cpu_ptr(fbc->counters);
 	count = *pcount + amount;
 	if (count >= batch || count <= -batch) {
 		spin_lock(&fbc->lock);
@@ -42,7 +42,7 @@ void __percpu_counter_add(struct percpu_
 	} else {
 		*pcount = count;
 	}
-	put_cpu();
+	preempt_enable();
 }
 EXPORT_SYMBOL(__percpu_counter_add);

