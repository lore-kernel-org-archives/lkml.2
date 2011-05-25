Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022Ab1EYPCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 11:02:22 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:17044 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994Ab1EYPCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 11:02:21 -0400
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 May 2011 11:02:21 EDT
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=from:message-id;
	b=09NtWKlKTYLnTnBziCsXsynIxLq+uSWd+/CnFY2i3Lc69rkjoFpqfQmp8KDt
	csH+zJHGBKcKmFoXVsD4BF6/4EzkOS6ejsD3qLfyJoUUsR4a3/kh5oSkQ
	TVjqIQJGh9HTGZ2a6myr8xIqQfI0PuB4eogAm0/RRbtjP/Y/7tTd9w=;
X-Spam-Processed: mail.digidescorp.com, Wed, 25 May 2011 09:56:56 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1126de5331=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [Bug #23902] 2.6.37-rc3 massive interactivity regression on ARM
From: "Steven J. Magnani" <steve@digidescorp.com>
To: andi@firstfloor.org, LKML <linux-kernel@vger.kernel.org>
Cc: rjw@sisk.pl, stable@kernel.org, a.p.zijlstra@chello.nl
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 09:56:51 -0500
Message-ID: <1306335411.2643.21.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi -

This bug appears to have crept into 2.6.35.12 via
a3fe22ee824895aafdc1b788e19c081a2e6dd9da and is still present in
2.6.35.13.

Mainline patch fe44d62122829959e960bc699318d58966922a69 (sched: Fix the
irqtime code to deal with u64 wraps) seems to fix my system although I
recommend also applying  8e92c20183ed0579d94501311b81c42b65cb2129
(sched: Fix the irqtime code for 32bit). Any stable releases that have
picked up 305e6835e05513406fa12820e40e4a8ecb63743c (sched: Do not
account irq time to current task) should probably also apply these.

Before I could get these patches to apply to 2.6.35.13 I had to tweak
sched.c:update_rq_clock() to match
f26f9aff6aaf67e9a430d16c266f91b13a5bff64 (Sched: fix skip_clock_update
optimization). That patch was applied to 2.6.35-longterm, except for the
update_rq_clock() portion. I believe that was because that portion
depended on a patch from Ventakesh that wasn't applied until later. It
looks like the logic that ended up in 2.6.35.12 was slightly different
than in mainline; I'm not familiar enough with the scheduler details to
know what the effects would be.

------------------------------------------------------------------------
Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/kernel/sched.c b/kernel/sched.c
--- a/kernel/sched.c	2011-05-25 09:39:05.200320708 -0500
+++ b/kernel/sched.c	2011-05-25 09:39:27.990238065 -0500
@@ -654,8 +654,10 @@ inline void update_rq_clock(struct rq *r
 	int cpu = cpu_of(rq);
 	u64 irq_time;
 
-	if (!rq->skip_clock_update)
-		rq->clock = sched_clock_cpu(cpu_of(rq));
+	if (rq->skip_clock_update)
+		return;
+
+	rq->clock = sched_clock_cpu(cpu);
 	irq_time = irq_time_cpu(cpu);
 	if (rq->clock - irq_time > rq->clock_task)
 		rq->clock_task = rq->clock - irq_time;
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>



