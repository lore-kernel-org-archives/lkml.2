Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab1IMVAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 17:00:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932731Ab1IMU7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 16:59:09 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, ying.huang@intel.com
Cc: LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        avi@redhat.com, jeremy@goop.org, Don Zickus <dzickus@redhat.com>
Subject: [V4][PATCH 0/6] x86, nmi: new NMI handling routines
Date: Tue, 13 Sep 2011 16:58:23 -0400
Message-Id: <1315947509-6429-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had the pleasure of hosting Robert Richter this week at Red Hat.  One of
the issues he wanted to talk with me about was having the NMI handling 
routines execute all the NMI handlers for each NMI mainly for his AMD IBS
work.  But he also brought up another good point that because of the way NMIs
work, it is possible to lose them if multiple NMIs happen at the same time.

As a result, we sat around and discussed how we could go about executing
all the nmi handlers for each NMI to ensure that we would not lose any events.

We decided the best way to do this would be to have the NMI handlers break
away from the notifier routines and create our own.  This would allow us to
execute all the handlers without hacking up the notifier stuff and easily
track the number of events processed at a higher level to deal with the new
problemm of extra NMIs.

I spent some time hacking and came up with this patch.  I tested it on my
core2quad machine trying to enable all the NMI handler I could, mainly
perf and kgdb (and oprofile too when perf was disabled).  Everything seems
to work correctly.  If people are ok with this approach, I'll try and test
this on more machines.

More details about the patch are in the individual changelogs.

Don Zickus (6):
  x86, nmi: split out nmi from traps.c
  x86, nmi: create new NMI handler routines
  x86, nmi: wire up NMI handlers to new routines
  x86, nmi:  add in logic to handle multiple events and unknown NMIs
  x86, nmi: track NMI usage stats
  x86, nmi: print out NMI stats in /proc/interrupts

 arch/x86/include/asm/nmi.h              |   39 ++--
 arch/x86/include/asm/reboot.h           |    2 +-
 arch/x86/kernel/Makefile                |    2 +-
 arch/x86/kernel/apic/hw_nmi.c           |   27 +--
 arch/x86/kernel/apic/x2apic_uv_x.c      |   20 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   20 +-
 arch/x86/kernel/cpu/mcheck/mce.c        |    3 -
 arch/x86/kernel/cpu/perf_event.c        |   60 +----
 arch/x86/kernel/crash.c                 |    5 +-
 arch/x86/kernel/irq.c                   |    2 +
 arch/x86/kernel/kgdb.c                  |   60 +++-
 arch/x86/kernel/nmi.c                   |  473 +++++++++++++++++++++++++++++++
 arch/x86/kernel/reboot.c                |   23 +-
 arch/x86/kernel/traps.c                 |  155 ----------
 arch/x86/oprofile/nmi_int.c             |   40 +--
 arch/x86/oprofile/nmi_timer_int.c       |   28 +--
 drivers/acpi/apei/ghes.c                |   22 +-
 drivers/char/ipmi/ipmi_watchdog.c       |   32 +--
 drivers/watchdog/hpwdt.c                |   23 +--
 19 files changed, 613 insertions(+), 423 deletions(-)
 create mode 100644 arch/x86/kernel/nmi.c

-- 
1.7.6

