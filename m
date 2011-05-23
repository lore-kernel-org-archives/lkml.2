Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030837Ab1EWVya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 17:54:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:51328 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177Ab1EWVy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 17:54:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,258,1304319600"; 
   d="scan'208";a="3529584"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Ingo Molnar" <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>,
        "Andi Kleen" <andi@firstfloor.org>, "Borislav Petkov" <bp@alien8.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>
Subject: [RFC 0/9] mce recovery for Sandy Bridge server
Date: Mon, 23 May 2011 14:54:27 -0700
Message-Id: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a nine-part patch series to implement "AR=1" recovery
that will be available on high-end Sandy Bridge server processors.
In this case the process detects an uncorrectable memory error
while doing an instruction of data fetch that is about to be
consumed.  This is in contrast to the recoverable errors on
Nehalem and Westmere that were out of immediate execution context
(patrol scrubber and cache line write-back).

The code is based on work done by Andi last year and published in
the "mce/action-required" branch of his mce git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git
Thus he gets author credit on 6 out of 9 patches (but I'll take
the blame for all of them).

The first eight patches are mostly cleanups and minor new bits
that are needed by part 9 where the interesting stuff happens.

For the "in context" case, we must not return from the machine
check handler (in the data fetch case we'd re-execute the fetch
and take another machine check, in the instruction fetch case
we actually don't have a precise IP to return to).  We use the
TIF_MCE_NOTIFY task flag bit to ensure that we don't return to
the user context - but we also need to keep track of the memory
address where the fault occurred. The h/w only gives us the physical
address which we must keep track of ... to do so we have added
"mce_error_pfn" to the task structure - this feels odd, but it
is an attribute of the task (e.g. this task may be migrated to
another processor before we get to look at TIF_MCE_NOTIFY and
head to do_notify_resume() to process it).

Andi's recovery code can also handle a few cases where the
error is detected while running kernel code (when copying
data to/from a user process) - but the TIF_MCE_NOTIFY method
doesn't actually ever get to this code (since the entry_64.S code
only checks TIF_MCE_NOTIFY on return to userspace). I'd
appreciate any ideas on how to handle this. Perhaps we could
do good things when CONFIG_PREEMPT=y (it seems probable that
any error in a non-preemtible section of kernel code is going
to be fatal).

-Tony

 arch/x86/include/asm/mce.h                |    3 +-
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   37 +++-
 arch/x86/kernel/cpu/mcheck/mce.c          |  286 ++++++++++++++++++++++++-----
 arch/x86/kernel/signal.c                  |    2 +-
 include/linux/init_task.h                 |    7 +
 include/linux/sched.h                     |    3 +
 mm/memory-failure.c                       |   28 ++--
 7 files changed, 300 insertions(+), 66 deletions(-)

Andi Kleen (6):
      MCE: Always retrieve mce rip before calling no_way_out
      MCE: Move ADDR/MISC reading code into common function
      MCE: Mask out address mask bits below address granuality
      HWPOISON: Handle hwpoison in current process
      MCE: Pass registers to work handlers
      MCE: Add Action-Required support

Tony Luck (3):
      mce: fixes for mce severity table
      mce: save most severe error information
      mce: run through processors with more severe problems first

