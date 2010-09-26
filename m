Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab0IZVZR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 17:25:17 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39356 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab0IZVZP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 17:25:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=VefkL6ODq8/cY8D7FDmXoa8FypwjXuOlZv7Mh3MgD8ttUmR+mseychxlbuqMmrfXGZ
         qJ7ic5X8rqaehQpFYTASThg7sckixwLaGQw2HkD/2p5VKSElfEGIaN6daZPqvKOSj2Vh
         Y9NP/Tp4QH7q1R5Q6N+0SNYC6OlkqOx897a6U=
MIME-Version: 1.0
Date: Sun, 26 Sep 2010 23:25:14 +0200
Message-ID: <AANLkTik99SDg1-StoOF+jbAH+H=NaqPRPFHCvMQg1YbD@mail.gmail.com>
Subject: 2.6.35.4: intel_idle has reduced residency in high C states.
From: Corrado Zoccolo <czoccolo@gmail.com>
To: lenb <lenb@kernel.org>, Linux-Kernel <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,
I tested intel_idle on my Acer Aspire One netbook (Atom based), and
got lower residency in high C states compared to acpi_idle:
Immediately after boot, PowerTOP 1.11 reports for intel_idle:
Your CPU supports the following C-states : C1 C2 C4
Your BIOS reports the following C-states : C1 C2 C4
Cn                Avg residency
C0 (cpu occupata)      ( 2,3%)
polling           0,0ms ( 0,0%)
C1 mwait         54,4ms (57,3%)
C2 mwait          1,7ms ( 2,8%)
C4 mwait          3,1ms (37,6%)
P-states (frequencies)
  1,60 Ghz     0,0%
  1333 Mhz     0,0%
  1066 Mhz     0,0%
   800 Mhz   100,0%
Wakeups-from-idle per second : 149,4    interval: 15,0s
no ACPI power usage estimate available
Top causes for wakeups:
  74,0% ( 98,5)     <kernel core> : hrtimer_start_range_ns (tick_sched_timer)
   6,5% (  8,7)       <interrupt> : acpi
   4,0% (  5,3)     <kernel core> : hrtimer_start (tick_sched_timer)
   3,7% (  4,9)       <interrupt> : eth0
   1,9% (  2,5)                 X : __mod_timer (i915_hangcheck_elapsed)
   1,5% (  2,0)           lxpanel : hrtimer_start_range_ns (hrtimer_wakeup)
   1,3% (  1,7)        lxterminal : hrtimer_start_range_ns (hrtimer_wakeup)
   1,0% (  1,3)           lxpanel : __mod_timer (process_timeout)
   0,8% (  1,1)      <kernel IPI> : TLB shootdowns
   0,8% (  1,0)           ifplugd : hrtimer_start_range_ns (hrtimer_wakeup)
   0,7% (  0,9)                 X : queue_delayed_work (delayed_work_timer_fn)

while for acpi_idle:
Cn                Avg residency
C0 (cpu occupata)      ( 2,1%)
polling           0,0ms ( 0,0%)
C1 halt           0,1ms ( 0,0%)
C2               11,9ms (14,7%)
C3               12,1ms (83,2%)
P-states (frequencies)
  1,60 Ghz     0,0%
  1333 Mhz     0,0%
  1066 Mhz     0,3%
   800 Mhz    99,7%
Wakeups-from-idle per second : 81,2     interval: 15,0s
no ACPI power usage estimate available
Top causes for wakeups:
  60,3% ( 92,3)     <kernel core> : hrtimer_start_range_ns (tick_sched_timer)
  12,4% ( 18,9)       <interrupt> : extra timer interrupt
   5,9% (  9,0)      <kernel IPI> : Rescheduling interrupts
   5,6% (  8,6)       <interrupt> : acpi
   3,4% (  5,2)       <interrupt> : eth0
   2,7% (  4,1)     <kernel core> : hrtimer_start (tick_sched_timer)
   1,6% (  2,4)                 X : __mod_timer (i915_hangcheck_elapsed)
   1,3% (  2,0)           lxpanel : hrtimer_start_range_ns (hrtimer_wakeup)
   1,2% (  1,8)           lxpanel : __mod_timer (process_timeout)
   1,1% (  1,7)        lxterminal : hrtimer_start_range_ns (hrtimer_wakeup)
   0,7% (  1,0)           ifplugd : hrtimer_start_range_ns (hrtimer_wakeup)
   0,6% (  0,9)                 X : queue_delayed_work (delayed_work_timer_fn)
   0,3% (  0,5)     <kernel core> : enqueue_task_rt (sched_rt_period_timer)
   0,3% (  0,5)      <kernel IPI> : TLB shootdowns

This may be unrelated, but I noticed that compared with 2.6.34, the
load average immediately after boot is higher for 2.6.35.4 (and
decreases more slowly). This gives a higher multiplier in the menu
governor, so the residency numbers for 2.6.34 with acpi_idle are again
different:
Cn                Avg residency
C0 (cpu occupata)      ( 3,2%)
polling           0,0ms ( 0,0%)
C1 halt           0,1ms ( 0,0%)
C2                7,9ms (10,5%)
C3               11,7ms (86,3%)
P-states (frequencies)
  1,60 Ghz     0,0%
  1333 Mhz     0,0%
  1066 Mhz     0,9%
   800 Mhz    99,1%
Wakeups-from-idle per second : 87,1     interval: 15,0s
no ACPI power usage estimate available
Top causes for wakeups:
  67,1% (130,0)     <kernel core> : hrtimer_start_range_ns (tick_sched_timer)
   8,7% ( 16,9)       <interrupt> : extra timer interrupt
   6,5% ( 12,5)      <kernel IPI> : Rescheduling interrupts
   4,5% (  8,7)       <interrupt> : acpi
   2,3% (  4,5)     <kernel core> : hrtimer_start (tick_sched_timer)
   1,9% (  3,7)       <interrupt> : eth0
   1,4% (  2,7)                 X : __mod_timer (i915_hangcheck_elapsed)
   1,0% (  2,0)           lxpanel : hrtimer_start_range_ns (hrtimer_wakeup)
   0,9% (  1,8)           lxpanel : __mod_timer (process_timeout)
   0,9% (  1,7)        lxterminal : hrtimer_start_range_ns (hrtimer_wakeup)
   0,5% (  1,0)           ifplugd : hrtimer_start_range_ns (hrtimer_wakeup)
   0,4% (  0,8)       <interrupt> : ehci_hcd:usb1, uhci_hcd:usb2,
i915@pci:0000:00:02.0
   0,4% (  0,7)       <interrupt> : ata_piix
   0,4% (  0,7)                 X : queue_delayed_work (delayed_work_timer_fn)
The numbers for 2.6.34 look more sensible (avg residency in C2 << avg
residency in C3), so it may be good to re-evaluate the factors in menu
governor.

Thanks,
Corrado

---
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
