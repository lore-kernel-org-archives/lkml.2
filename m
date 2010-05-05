Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201Ab0EEOLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 10:11:45 -0400
Received: from mailout2.zih.tu-dresden.de ([141.30.67.73]:57622 "EHLO
	mailout2.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759165Ab0EEOLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 10:11:44 -0400
Message-ID: <4BE17C90.2020205@tu-dresden.de>
Date: Wed, 05 May 2010 16:11:28 +0200
From: =?ISO-8859-15?Q?Ronny_Tsch=FCter?= <Ronny.Tschueter@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Tracing of power:power_start events doesn't work
References: <4BDECD66.2010906@tu-dresden.de> <1273019517.22438.10.camel@gandalf.stny.rr.com>
In-Reply-To: <1273019517.22438.10.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-TUD-Virus-Scanned: mailout2.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I took a look at ftrace and tried to narrow my problem down.

  1) <idle>-0    |                     |  cpuidle_idle_call() {
  1) <idle>-0    |                     |    menu_select() {
  1) <idle>-0    |   0.219 us    |      pm_qos_requirement();
  1) <idle>-0    |   0.219 us    |      tick_nohz_get_sleep_length();
  1) <idle>-0    |   0.210 us    |      nr_iowait_cpu();
  1) <idle>-0    |   0.213 us    |      this_cpu_load();
  1) <idle>-0    |   0.213 us    |      nr_iowait_cpu();
  1) <idle>-0    |   2.472 us    |    }
  1) <idle>-0    |                     |    acpi_idle_enter_simple() {
  1) <idle>-0    |                     |      
lapic_timer_state_broadcast() {
  1) <idle>-0    |                     |        clockevents_notify() {
  1) <idle>-0    |   0.234 us    |          _raw_spin_lock_irqsave();
  1) <idle>-0    |                     |          
raw_notifier_call_chain() {
  1) <idle>-0    |                     |            tick_notify() {
  1) <idle>-0    |                     |              
tick_broadcast_oneshot_control() {
  1) <idle>-0    |   0.237 us    |                _raw_spin_lock_irqsave();
  1) <idle>-0    |                     |                
clockevents_set_mode() {
  1) <idle>-0    |                     |                  
lapic_timer_setup() {
  1) <idle>-0    |   0.222 us    |                    
native_apic_mem_read();
  1) <idle>-0    |   0.213 us    |                    
native_apic_mem_write();
  1) <idle>-0    |   0.210 us    |                    
native_apic_mem_write();
  1) <idle>-0    |   1.554 us    |                  }
  1) <idle>-0    |   2.007 us    |                }
  1) <idle>-0    |                     |                
tick_dev_program_event() {
  1) <idle>-0    |                     |                  ktime_get() {
  1) <idle>-0    |   0.606 us    |                    read_hpet();
  1) <idle>-0    |   1.053 us    |                  }
  1) <idle>-0    |                     |                  
clockevents_program_event() {
  1) <idle>-0    |                     |                    
hpet_legacy_next_event() {
  1) <idle>-0    |   1.692 us    |                      hpet_next_event();
  1) <idle>-0    |   2.190 us    |                    }
  1) <idle>-0    |   2.664 us    |                  }
  1) <idle>-0    |   4.410 us    |                }
  1) <idle>-0    |   0.237 us    |                
_raw_spin_unlock_irqrestore();
  1) <idle>-0    |   8.022 us    |              }
  1) <idle>-0    |   8.460 us    |            }
  1) <idle>-0    |   8.943 us    |          }
  1) <idle>-0    |   0.231 us    |          _raw_spin_unlock_irqrestore();
  1) <idle>-0    | + 10.296 us   |        }
  1) <idle>-0    | + 10.734 us   |      }
  1) <idle>-0    |                     |      ktime_get_real() {
  1) <idle>-0    |                     |        getnstimeofday() {
  1) <idle>-0    |   0.630 us    |          read_hpet();
  1) <idle>-0    |   1.389 us    |        }
  1) <idle>-0    |   1.830 us    |      }
  1) <idle>-0    | ! 3833.301 us |      acpi_idle_do_entry()

Like the callgraph shows, my machine uses the cpuidle framework with 
menu governor and an acpi-based driver to handle idle states. 
Unfortunately I can't find any instrumentation for tracing power events 
in the cpuidle.c and processor_idle.c (acpi idle management). The 
following patch achieved success.

diff --git a/old/processor_idle.c b/new/processor_idle.c
index cc978a8..1668d34 100644
--- a/old/processor_idle.c
+++ b/new/processor_idle.c
@@ -42,6 +42,7 @@
  #include <linux/clockchips.h>
  #include <linux/cpuidle.h>
  #include <linux/irqflags.h>
+#include <trace/events/power.h>

  /*
   * Include the apic definitions for x86 to have the APIC timer related 
defines
@@ -796,6 +797,18 @@ static int acpi_idle_bm_check(void)
   */
  static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
  {
+    switch (cx->type) {
+    case ACPI_STATE_C1:
+        trace_power_start(POWER_CSTATE, 1);
+        break;
+    case ACPI_STATE_C2:
+        trace_power_start(POWER_CSTATE, 2);
+        break;
+    case ACPI_STATE_C3:
+        trace_power_start(POWER_CSTATE, 3);
+        break;
+    }
+
      /* Don't trace irqs off for idle */
      stop_critical_timings();
      if (cx->entry_method == ACPI_CSTATE_FFH) {

