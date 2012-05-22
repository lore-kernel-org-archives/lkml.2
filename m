Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab2EVVbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 17:31:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:40615 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab2EVVbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 17:31:52 -0400
Date: Tue, 22 May 2012 23:31:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Zen Lin <zen@openhuawei.org>
Subject: Re: [RFC][PATCH 00/32] Nohz cpusets v2 (adaptive tickless kernel)
In-Reply-To: <1332861025.16159.236.camel@twins>
Message-ID: <alpine.LFD.2.02.1205222327080.3231@ionos>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>  <CAOtvUMf0Zp9C-jT=ymEo6oyxnsgkvSiGDUs5V_56v4Ai2QyBJQ@mail.gmail.com> <1332861025.16159.236.camel@twins>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2012, Peter Zijlstra wrote:

> On Tue, 2012-03-27 at 17:02 +0200, Gilad Ben-Yossef wrote:
> > 
> > In my case, I also had to disable the clocksource watchdog, but only
> > because TSC is not stable on my VM.
> > This is really not a nohz/cpuset problem. 
> 
> No but that thing is annoying, I ran afoul of it too the other day.
> 
> Thomas, would you object to a means of turning that thing off? And if
> not, do you have a preference as to what particular means
> (sysctl/sysfs/etc..) ?

We have the commandline option "tsc=reliable" already. That disables
the stupid watchdog. Handle with care.

To take it a level further, use the patch below :)

Thanks,

	tglx

------------>
x86: Add tsc=perfect option which enforces sched_clock_stable
    
The sched_clock dance with updating local clocks can be avoided even
if the CPU does not have all the magic features.
    
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 590900c..dc8ecc3 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -109,6 +109,10 @@ static int __init tsc_setup(char *str)
 {
 	if (!strcmp(str, "reliable"))
 		tsc_clocksource_reliable = 1;
+	if (!strcmp(str, "perfect")) {
+		tsc_clocksource_reliable = 1;
+		sched_clock_stable = 1;
+	}
 	if (!strncmp(str, "noirqtime", 9))
 		no_sched_irq_time = 1;
 	return 1;
 
