Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab2C0PST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 11:18:19 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39519 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab2C0PSS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 11:18:18 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <1332861025.16159.236.camel@twins>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
	<CAOtvUMf0Zp9C-jT=ymEo6oyxnsgkvSiGDUs5V_56v4Ai2QyBJQ@mail.gmail.com>
	<1332861025.16159.236.camel@twins>
Date: Tue, 27 Mar 2012 17:18:17 +0200
Message-ID: <CAOtvUMc2E7YqkCPBemnXpyPWNnmjjfN+RjBiAZJ3NNxaSrxxTQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 00/32] Nohz cpusets v2 (adaptive tickless kernel)
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
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
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 5:10 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2012-03-27 at 17:02 +0200, Gilad Ben-Yossef wrote:
>>
>> In my case, I also had to disable the clocksource watchdog, but only
>> because TSC is not stable on my VM.
>> This is really not a nohz/cpuset problem.
>
> No but that thing is annoying, I ran afoul of it too the other day.
>
> Thomas, would you object to a means of turning that thing off? And if
> not, do you have a preference as to what particular means
> (sysctl/sysfs/etc..) ?

For what it's worth, there's already an CONFIG_CLOCKSOURCE_WATCHDOG
option, which is hard coded true right now.
Making it select-able was the path of least resistance for me:

commit 7a7af328cc0c8f8b837f8b23b4099e5bfd4c5462
Author: Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Mon Mar 12 17:12:41 2012 +0200

    x86: make clocksource watchdog configurable (not for mainline)

    The clock source watchdog will wake up idle cores.

    Since I'm using KVM to test, where the TSC is always marked
    unstable, I've added this option to allow to disable it to
    assist testing.

    This is not intended for mainlining, just a reference for
    how I tested the patch set.

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0d3116c..21ffc76 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -100,9 +100,6 @@ config ARCH_DEFCONFIG
 config GENERIC_CMOS_UPDATE
 	def_bool y

-config CLOCKSOURCE_WATCHDOG
-	def_bool y
-
 config GENERIC_CLOCKEVENTS
 	def_bool y

@@ -1690,6 +1687,12 @@ config HOTPLUG_CPU
 	    automatically on SMP systems. )
 	  Say N if you want to disable CPU hotplug.

+config CLOCKSOURCE_WATCHDOG
+	bool "Clocksource watchdog"
+	default y
+	help
+	  Enable clock source watchdog.
+
 config COMPAT_VDSO
 	def_bool y
 	prompt "Compat VDSO support"
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index a45ca16..30223da 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -450,6 +450,8 @@ static void clocksource_enqueue_watchdog(struct
clocksource *cs)
 static inline void clocksource_dequeue_watchdog(struct clocksource *cs) { }
 static inline void clocksource_resume_watchdog(void) { }
 static inline int clocksource_watchdog_kthread(void *data) { return 0; }
+void clocksource_mark_unstable(struct clocksource *cs) { }
+

 #endif /* CONFIG_CLOCKSOURCE_WATCHDOG */



-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
