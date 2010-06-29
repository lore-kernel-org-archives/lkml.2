Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab0F2OtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 10:49:14 -0400
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:43137 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754509Ab0F2OtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 10:49:13 -0400
Message-ID: <4C2A07E8.7000005@tu-dresden.de>
Date: Tue, 29 Jun 2010 16:49:12 +0200
From: =?UTF-8?B?Um9ubnkgVHNjaMO8dGVy?= <Ronny.Tschueter@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.9.1.10) Gecko/20100512 Lightning/1.0b1 Thunderbird/3.0.5
MIME-Version: 1.0
To: =?UTF-8?B?Um9iZXJ0IFNjaMO2bmU=?= <robert.schoene@tu-dresden.de>
CC: Arjan van de Ven <arjan@linux.intel.com>, rostedt@goodmis.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Tracing of power:power_start events doesn't work
References: <4BDECD66.2010906@tu-dresden.de>	 <1273019517.22438.10.camel@gandalf.stny.rr.com>	 <4BE17C90.2020205@tu-dresden.de>	 <1273069881.22438.17.camel@gandalf.stny.rr.com>	 <4BE181BD.8010804@linux.intel.com> <1273654646.3598.227.camel@localhost> <4C120F67.3050400@tu-dresden.de>
In-Reply-To: <4C120F67.3050400@tu-dresden.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I use Linux performance counters to trace some performance related 
events. Unfortunately power:power_start events are not reported on my 
machine. In /drivers/acpi/processor_idle.c I found three different ways 
to call a C-state, but only one way (via architectural FFH based C-state 
and using MONITOR/MWAIT) is currently instrumented. Here is my patch to 
instrument the remaining two possibilities:

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index b1b3856..08e7c42 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -43,6 +43,7 @@
  #include <linux/clockchips.h>
  #include <linux/cpuidle.h>
  #include <linux/irqflags.h>
+#include <trace/events/power.h>

  /*
   * Include the apic definitions for x86 to have the APIC timer related 
defines
@@ -136,6 +137,7 @@ static void acpi_safe_halt(void)
       */
      smp_mb();
      if (!need_resched()) {
+        trace_power_start(POWER_CSTATE,1);
          safe_halt();
          local_irq_disable();
      }
@@ -797,6 +799,10 @@ static inline void acpi_idle_do_entry(struct 
acpi_processor_cx *cx)
      } else {
          int unused;
          /* IO port based C-state */
+        trace_power_start(POWER_CSTATE,
+        cx->type == ACPI_STATE_C1 ? 1 :
+        cx->type == ACPI_STATE_C2 ? 2 :
+        3);
          inb(cx->address);
          /* Dummy wait op - must do something useless after P_LVL2 read
             because chipsets cannot guarantee that STPCLK# signal
