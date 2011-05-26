Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab1EZWHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 18:07:06 -0400
Received: from host1743200242118.direcway.com ([174.32.118.242]:60921 "EHLO
	aexorsyst.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab1EZWHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 18:07:04 -0400
From: "John Z. Bohach" <jzb2@aexorsyst.com>
To: linux-kernel@vger.kernel.org
Subject: __raw_notify_call_chain() stops in kernel_power_off path BUT ONLY with nfsroot
Date: Thu, 26 May 2011 15:04:17 -0700
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105261504.17243.jzb2@aexorsyst.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To try to duplicate this, boot an nfsroot-ed machine into run-level 1, 
and run 'halt -n -d -f -p'.

I'm debugging why the machine will not physically remove power on a 
power down path, and I've traced it to __raw_notify_call_chain() which 
simply calls notify_call_chain() to do the work.

I'm running Linux version 2.6.36.1 and the code path I've traced with 
added printk()'s is the following (with some uninteresting paths not 
listed):

(This code is in kernel/sys.c and kernel/notifier.c and a few other 
arch.-specific places)

kernel_power_off()
  ...
  disable_nonboot_cpus()
    _cpu_down()
      ...
      cpu_die()
      cpu_notify_nofail()
        cpu_notify()
          ...
          __cpu_notify()
            __raw_notifier_call_chain()
              notifier_call_chain()
            ?? strange second call from unknown location to:
              __raw_notifier_call_chain()
            then it just stops...

Machine does not hang as I can see NFS timeout messages after a few 
minutes (probably interrupt context), but no further printk's are 
manifest, and system stays in this state until physically reset and is 
unresponsive.

Two additional pieces of information:

1)  there is a single return from one of the __raw_notifier_call_chain() 
invocations, likely the second one (but no evidence to this effect), 
which I can see due to printk() 
immediately before 'return' statement at the end of the 
__raw_notifier_call_chain() function.

2) more interesting, with the same kernel and same rootfs booted from a 
local harddisk, the path continues, with a 'return' from the other 
__raw_notifier_call_chain() function, and this code path continues 
normally until the machine is powered down via 
acpi_enter_sleep_state(S5) acpi code.

Since this code works on local disk, it should work on nfsroot.  I think 
the question that needs an answer is

What is different about the notifier list when root=/dev/nfsroot vs. 
localdisk or is there some other interrupt-based issue going on away 
from my prying eyes...?

Other question, is why are there two CONSECUTIVE entries to 
__raw_notifier_call_chain() EVEN IN the working case without a return() 
of some sort in between?  Is it a dual-cpu issue?  Is this code running 
on both CPUs?  Its a dual-cpu AMD machine...I ask because the source 
code does not appear recursive and I'm just wondering if that is an 
issue even though it works most of the time (i.e., is the real bug that 
it works when it shouldn't due to some strange alignment of the stars 
that is not present with nfsroot, but that is a just random thought).

Thanks,
John Z. Bohach
