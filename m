Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab1BCOKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 09:10:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:51310 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113Ab1BCOKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 09:10:31 -0500
Date: Thu, 3 Feb 2011 14:09:59 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        trenn@novell.com, suresh.b.siddha@intel.com, rjw@novell.com,
        tglx@linutronix.de, jabber@gmx.org, mingo@elte.hu, venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        trenn@novell.com, suresh.b.siddha@intel.com, rjw@novell.com,
        tglx@linutronix.de, jabber@gmx.org, venki@google.com, mingo@elte.hu
In-Reply-To: <1296694975.4418.402.camel@sbsiddha-MOBL3.sc.intel.com>
References: <1296694975.4418.402.camel@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mtrr: Avoid MTRR reprogramming on BP during boot on UP platforms
Message-ID: <tip-f7448548a9f32db38f243ccd4271617758ddfe2c@git.kernel.org>
Git-Commit-ID: f7448548a9f32db38f243ccd4271617758ddfe2c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 03 Feb 2011 14:10:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f7448548a9f32db38f243ccd4271617758ddfe2c
Gitweb:     http://git.kernel.org/tip/f7448548a9f32db38f243ccd4271617758ddfe2c
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 2 Feb 2011 17:02:55 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Feb 2011 12:10:38 +0100

x86, mtrr: Avoid MTRR reprogramming on BP during boot on UP platforms

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
Cc: stable@kernel.org # [v2.6.32+]
LKML-Reference: <1296694975.4418.402.camel@sbsiddha-MOBL3.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mtrr/main.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 01c0f3e..bebabec 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -793,13 +793,21 @@ void set_mtrr_aps_delayed_init(void)
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
