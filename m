Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065Ab2KWJd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:33:57 -0500
Received: from www.linutronix.de ([62.245.132.108]:44700 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759018Ab2KWJd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:33:56 -0500
Date: Fri, 23 Nov 2012 10:33:54 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Norbert Warmuth <nwarmuth@t-online.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [regression] 3.7+ suspend to RAM/offline CPU fails with
 nmi_watchdog=0 (bisected)
In-Reply-To: <86sj83pbwy.fsf@belegost.ivcecceob.t-online.de>
Message-ID: <alpine.LFD.2.02.1211231033230.2701@ionos>
References: <86sj83pbwy.fsf@belegost.ivcecceob.t-online.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2012, Norbert Warmuth wrote:
> 3.7-rc6 booted with nmi_watchdog=0 fails to suspend to RAM or
> offline CPUs. It's reproducable with a KVM guest and physical
> system. 

Does the patch below fix it?

Thanks,

	tglx

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 9d4c8d5..e3ef521 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -368,6 +368,9 @@ static void watchdog_disable(unsigned int cpu)
 {
 	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
 
+	if (!watchdog_enabled)
+		return;
+
 	watchdog_set_prio(SCHED_NORMAL, 0);
 	hrtimer_cancel(hrtimer);
 	/* disable the perf event */
