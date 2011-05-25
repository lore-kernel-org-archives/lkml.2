Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab1EYVK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:10:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:51337 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab1EYVKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:10:55 -0400
Date: Wed, 25 May 2011 23:10:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [bisected] Strange slowdowns timerfd related
In-Reply-To: <20110525202721.GA1738@x4.trippels.de>
Message-ID: <alpine.LFD.2.02.1105252309040.3078@ionos>
References: <20110525202721.GA1738@x4.trippels.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Markus Trippelsdorf wrote:

> I've tested the latest git-kernel today and did experience long delays
> in Firefox. Just opening a new tab would take a few seconds and after
> typing a few characters into the "awesome bar" I would have to wait ages
> before the results were shown.
> 
> This is the bisection result:
> 
>  commit 9ec2690758a5467f24beb301cca5098078073bba
>  Author: Thomas Gleixner <tglx@linutronix.de>
>  Date:   Fri May 20 16:18:50 2011 +0200
> 
>      timerfd: Manage cancelable timers in timerfd
> 
> Reverting the commit above fixes the problem.

Yes, Linus came to the same result. Fix below.

Thanks,

	tglx_hidden_under_a_brown_paperbag

------->
	
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index c541ee5..a9205e3 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -748,7 +748,7 @@ static inline void retrigger_next_event(void *arg) { }
  */
 void clock_was_set(void)
 {
-#ifdef CONFIG_HIGHRES_TIMERS
+#ifdef CONFIG_HIGH_RES_TIMERS
 	/* Retrigger the CPU local events everywhere */
 	on_each_cpu(retrigger_next_event, NULL, 1);
 #endif
