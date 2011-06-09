Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab1FIVZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 17:25:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:19694 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241Ab1FIVZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 17:25:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,343,1304319600"; 
   d="scan'208";a="12182403"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Borislav Petkov" <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
        "Avi Kivity" <avi@redhat.com>
Subject: [RFC] reworked machine check recovery patches
Date: Thu, 09 Jun 2011 14:25:38 -0700
Message-Id: <4df13a522720782e51@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the in-kernel recovery path for memory errors. Still
no change to the eventual reporting mechanism (mcelog vs. perf).

Lots of changes based on feedback from the previous set of
discussions.  Big stuff:

0) Scaled back on ambitions - just worry about recovery from
   memory errors while executing in user mode. Adding recovery
   for some kernel cases is deferred to some future date.

1) Took Seto-san's "mce_gather_info()" patch in place of the
   one to just move mce_get_rip() around. Added an expanded
   comment to explain that we need to collect all this information
   to make decisions about severity for errors we find when scanning
   the machine check banks.  The rest of Seto-san's patches to
   make the severity table easier to read look interesting.

2) Ingo pointed me the the user-return-notifier code as an alternative
   to TIF_MCE_NOTIFY.  Part 7 uses return notifiers to cover the
   existing use of this TIF bit (Avi: Thanks for the review)

3) Take the newly freed TIF_MCE_NOTIFY bit and use it to implement
   an extension in part 8 to make a "per-task" user notifier.

3) Re-implement the recovery path using the task_return_notifier ...
   this gets rid of the "mce_error_pfn" field that was used in the
   previous implementation that was so obnoxious.

N.B. both the existing parts and my extensions to the user return
notifiers are not NMI safe because they use ordinary Linux lists.
If this seems to be a worthwhile direction, this deficiency can
be fixed using Ying's NMI safe single linked lists.  Ditto the
hacky "allocator" of task_notify structures in mce_action_required().
Just a proof of concept ... should be replaced with a more
generic NMI safe allocator.

-Tony

0001-MCE-fixes-for-mce-severity-table
0002-MCE-save-most-severe-error-information
0003-MCE-introduce-mce_gather_info
0004-MCE-Move-ADDR-MISC-reading-code-into-common-function
0005-MCE-Mask-out-address-mask-bits-below-address-granual
0006-HWPOISON-Handle-hwpoison-in-current-process
0007-MCE-replace-mce.c-use-of-TIF_MCE_NOTIFY-with-user_re
0008-NOTIFIER-Take-over-TIF_MCE_NOTIFY-and-implement-task
0009-MCE-run-through-processors-with-more-severe-problems
0010-MCE-Add-Action-Required-support


 arch/x86/Kconfig                          |    1 +
 arch/x86/include/asm/thread_info.h        |    8 +-
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   37 +++-
 arch/x86/kernel/cpu/mcheck/mce.c          |  339 ++++++++++++++++++++++-------
 arch/x86/kernel/signal.c                  |    7 +-
 include/linux/sched.h                     |    3 +
 include/linux/user-return-notifier.h      |   14 ++
 kernel/fork.c                             |    1 +
 kernel/user-return-notifier.c             |   36 +++
 mm/memory-failure.c                       |   28 ++-
 10 files changed, 369 insertions(+), 105 deletions(-)

Andi Kleen (3):
      MCE: Move ADDR/MISC reading code into common function
      MCE: Mask out address mask bits below address granuality
      HWPOISON: Handle hwpoison in current process

Hidetoshi Seto (1):
      MCE: introduce mce_gather_info()

Tony Luck (6):
      MCE: fixes for mce severity table
      MCE: save most severe error information
      MCE: replace mce.c use of TIF_MCE_NOTIFY with user_return_notifier
      NOTIFIER: Take over TIF_MCE_NOTIFY and implement task return notifier
      MCE: run through processors with more severe problems first
      MCE: Add Action-Required support

