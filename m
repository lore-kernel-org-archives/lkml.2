Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab0DCWds (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 18:33:48 -0400
Received: from isilmar.linta.de ([213.133.102.198]:55853 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753730Ab0DCWdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 18:33:43 -0400
Date: Sun, 4 Apr 2010 00:33:28 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: A few questions and issues with dynticks, NOHZ and powertop
Message-ID: <20100403223328.GA4507@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Dmitry Torokhov <dtor@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey!

Before I'm off hiding some Easter eggs, here are some questions and
issues related to "dynticks", NOHZ, and powertop:

1) single-CPU systems, SMP-capable kernel and RCU 
2) dual-core CPU[*] and select_nohz_load_balancer()
3) USB, autosuspend failure, excessive ticks
4) SynPS/2 touchpad and hundreds of IRQs per second
5) powertop: 1 + 1 = 1


1) single-CPU systems, SMP-capable kernel and RCU

CONFIG_TREE_RCU=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FAST_NO_HZ=y

Booting a SMP-capable kernel with "nosmp", or manually offlining one CPU
(or -- though I haven't tested it -- booting a SMP-capable kernel on a
system with merely one CPU) means that in up to about half of the calls to
tick_nohz_stop_sched_tick() are aborted due to rcu_needs_cpu(). This is
quite strange to me: AFAIK, RCU is an excellent tool for SMP, but not really
needed for UP? And all updates seem to be local to the CPU anyway.
Therefore, I'd presume that rcu_needs_cpu() should return 0 on
one-CPU-systems. Or could RCU switch between TINY_RCU on UP and TREE_RCU on
SMP (using alternatives or whatever)?


2) dual-core CPU[*] and select_nohz_load_balancer()
[*] (Intel(R) Core(TM)2 Duo CPU T7250)

# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
CONFIG_SCHED_HRTICK=y

CONFIG_SCHED_MC is igored, as mc_capable() returns 0 on a one-socket,
dual-core system. Quite surprisingly, even under moderate load (~98.0% idle)
while writing this bugreport, up to half of the calls to
tick_nohz_stop_sched_tick() are aborted due to select_nohz_load_balancer(1):

		if (atomic_read(&nohz.load_balancer) == -1) {
			/* make me the ilb owner */
			if (atomic_cmpxchg(&nohz.load_balancer, -1, cpu) == -1)
				return 1;

I'm not really sure, but I guess this is caused by the following phenomenon
under minor load but still, every once in a while, parallel work for both
CPUs:

CPU #0					CPU #1

<active>				<active>
<idle>					<active>
  tick_nohz_stop_sched_tick(1)		<active>
   select_nohz_load_balancer(1)		<active>
    => becomes ilb owner		<idle>
   => tick is not stopped		 tick_nohz_stop_sched_tick(1)
  => CPU goes to sleep for 1 tick	  => as it isn't the ILB owner, tick
  <sleep for 1 tick>			     is stopped	.
  ---> scheduler_tick()			  <sleeeeeeeep>
  tick_nohz_stop_sched_tick(0)
<still idle>
  tick_nohz_stop_sched_tick(1)
   select_nohz_load_balancer(1)
    => is ilb owner, all CPUs idle,
       may go to sleep.

If both CPUs have hardly anything to do, letting the _active_ CPU do ilb
allows us to enter deep sleep states earlier, and longer:

current ILB model (* = ILB)

	tick ---------- tick -------- tick ----- IRQ
CPU0:   active|IDLE(C2)--|*|IDLE (C3)             |
CPU1:   active....| IDLE (C3)                     |
core:   .......???| C2   |           C3           |

ILB-by-active-CPU-on-light-load:

	tick ---------- tick -------- tick ----- IRQ
CPU0:   active|IDLE(C3)                           |
CPU1:   active....*| IDLE (C3)                    |
core:   .......????|               C3             |


3) USB: built-in UHCI and a built-in 0a5c:2101 Broadcom Corp. A-Link
BlueUsbA2 Bluetooth module; built-in EHCI and a built-in 0ac8:c302 Z-Star
Microelectronics Corp. Vega USB 2.0 Camera.

usbcore.autosuspend is enabled (= 2), of course.

Recent USB suspend statistics
Active  Device name
100.0%	USB device  7-1 : BCM92045NMD (Broadcom Corp)
100.0%	USB device  1-2 : Vega USB 2.0 Camera. (Vimicro Corp.)
100.0%	USB device usb7 : UHCI Host Controller (Linux 2.6.34-rc3 uhci_hcd)
100.0%	USB device usb1 : EHCI Host Controller (Linux 2.6.34-rc3 ehci_hcd)

Booting into /bin/bash on a SMP kernel booted with "nosmp" leads to ~ 10
wakeups per second; disabling the cursor helps halfway (~ 5 wakeups); and
manually unbinding the USB host drivers from the USB host devices finally
lead to ~ 1.1 wakeups per second. What's keeping USB from suspending these
unused devices here?


4) SynPS/2 touchpad: 
Why does moving the touchpad lead to sooo many IRQs? I can't look as fast
as the mouse pointer seems to get new data:
  62,5% (473,1)       <interrupt> : PS/2 keyboard/mouse/touchpad 


5) powertop and hrtimer_start_range_ns (tick_sched_timer) on a SMP kernel
booted with "nosmp":

Wakeups-from-idle per second :  9.9     interval: 15.0s
...
  48.5% (  9.4)     <kernel core> : hrtimer_start (tick_sched_timer) 
  26.1% (  5.1)     <kernel core> : cursor_timer_handler (cursor_timer_handler) 
  20.6% (  4.0)     <kernel core> : usb_hcd_poll_rh_status (rh_timer_func) 
   1.0% (  0.2)     <kernel core> : arm_supers_timer (sync_supers_timer_fn) 
   0.7% (  0.1)       <interrupt> : ata_piix 
   ...

Accoding to http://www.linuxpowertop.org , the count in the brackets is how
many wakeups per seconds were caused by one source. Adding all _except_
  48.5% (  9.4)     <kernel core> : hrtimer_start (tick_sched_timer)
up leads to the 9.9; adding also the 9.4 leads to 19.3 wakeups-from-idle per
second. However, http://www.linuxpowertop.org says:

>  "Should "Wakeups-from-idle per second" equal the sum of the
>  wakeups/second/core listed on the "Top causes for wakeups" list?
>
>  It should be higher, since there are some causes for wakeups that are nearly
>  impossible to detect by software."


Best, and Happy Easter,

	Dominik
