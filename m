Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142Ab1FWRa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:30:26 -0400
Received: from mail.windriver.com ([147.11.1.11]:65433 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932619Ab1FWRaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:30:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 058/247] x86, mtrr: Avoid MTRR reprogramming on BP during boot on UP platforms
Date: Thu, 23 Jun 2011 13:25:57 -0400
Message-Id: <1308850146-15061-17-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850146-15061-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850146-15061-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f7448548a9f32db38f243ccd4271617758ddfe2c upstream.

Markus Kohn ran into a hard hang regression on an acer aspire
1310, when acpi is enabled. git bisect showed the following
commit as the bad one that introduced the boot regression.

	commit d0af9eed5aa91b6b7b5049cae69e5ea956fd85c3
	Author: Suresh Siddha <suresh.b.siddha@intel.com>
	Date:   Wed Aug 19 18:05:36 2009 -0700

	    x86, pat/mtrr: Rendezvous all the cpus for MTRR/PAT init

Because of the UP configuration of that platform,
native_smp_prepare_cpus() bailed out (in smp_sanity_check())
before doing the set_mtrr_aps_delayed_init()

Further down the boot path, native_smp_cpus_done() will call the
delayed MTRR initialization for the AP's (mtrr_aps_init()) with
mtrr_aps_delayed_init not set. This resulted in the boot
processor reprogramming its MTRR's to the values seen during the
start of the OS boot. While this is not needed ideally, this
shouldn't have caused any side-effects. This is because the
reprogramming of MTRR's (set_mtrr_state() that gets called via
set_mtrr()) will check if the live register contents are
different from what is being asked to write and will do the actual
write only if they are different.

BP's mtrr state is read during the start of the OS boot and
typically nothing would have changed when we ask to reprogram it
on BP again because of the above scenario on an UP platform. So
on a normal UP platform no reprogramming of BP MTRR MSR's
happens and all is well.

However, on this platform, bios seems to be modifying the fixed
mtrr range registers between the start of OS boot and when we
double check the live registers for reprogramming BP MTRR
registers. And as the live registers are modified, we end up
reprogramming the MTRR's to the state seen during the start of
the OS boot.

During ACPI initialization, something in the bios (probably smi
handler?) don't like this fact and results in a hard lockup.

We didn't see this boot hang issue on this platform before the
commit d0af9eed5aa91b6b7b5049cae69e5ea956fd85c3, because only
the AP's (if any) will program its MTRR's to the value that BP
had at the start of the OS boot.

Fix this issue by checking mtrr_aps_delayed_init before
continuing further in the mtrr_aps_init(). Now, only AP's (if
any) will program its MTRR's to the BP values during boot.

Addresses https://bugzilla.novell.com/show_bug.cgi?id=623393

  [ By the way, this behavior of the bios modifying MTRR's after the start
    of the OS boot is not common and the kernel is not prepared to
    handle this situation well. Irrespective of this issue, during
    suspend/resume, linux kernel will try to reprogram the BP's MTRR values
    to the values seen during the start of the OS boot. So suspend/resume might
    be already broken on this platform for all linux kernel versions. ]

Reported-and-bisected-by: Markus Kohn <jabber@gmx.org>
Tested-by: Markus Kohn <jabber@gmx.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Thomas Renninger <trenn@novell.com>
Cc: Rafael Wysocki <rjw@novell.com>
Cc: Venkatesh Pallipadi <venki@google.com>
LKML-Reference: <1296694975.4418.402.camel@sbsiddha-MOBL3.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/cpu/mtrr/main.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 79556bd..e253288 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -763,13 +763,21 @@ void set_mtrr_aps_delayed_init(void)
 }
 
 /*
- * MTRR initialization for all AP's
+ * Delayed MTRR initialization for all AP's
  */
 void mtrr_aps_init(void)
 {
 	if (!use_intel())
 		return;
 
+	/*
+	 * Check if someone has requested the delay of AP MTRR initialization,
+	 * by doing set_mtrr_aps_delayed_init(), prior to this point. If not,
+	 * then we are done.
+	 */
+	if (!mtrr_aps_delayed_init)
+		return;
+
 	set_mtrr(~0U, 0, 0, 0);
 	mtrr_aps_delayed_init = false;
 }
-- 
1.7.4.4

