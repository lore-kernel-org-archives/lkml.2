Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab0KZPGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:06:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:40164 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262Ab0KZPBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:01:42 -0500
Date: Fri, 26 Nov 2010 15:01:06 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, jason.wessel@windriver.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, jason.wessel@windriver.com,
        a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de,
        mingo@elte.hu, dzickus@redhat.com
In-Reply-To: <1290462923-30734-1-git-send-email-dzickus@redhat.com>
References: <1290462923-30734-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, perf, nmi: Disable perf if counters are not accessible
Message-ID: <tip-33c6d6a7ad0ffab9b1b15f8e4107a2af072a05a0@git.kernel.org>
Git-Commit-ID: 33c6d6a7ad0ffab9b1b15f8e4107a2af072a05a0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 15:01:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  33c6d6a7ad0ffab9b1b15f8e4107a2af072a05a0
Gitweb:     http://git.kernel.org/tip/33c6d6a7ad0ffab9b1b15f8e4107a2af072a05a0
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Mon, 22 Nov 2010 16:55:23 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Nov 2010 15:00:57 +0100

x86, perf, nmi: Disable perf if counters are not accessible

In a kvm virt guests, the perf counters are not emulated.  Instead they
return zero on a rdmsrl. The perf nmi handler uses the fact that crossing
a zero means the counter overflowed (for those counters that do not have
specific interrupt bits). Therefore on kvm guests, perf will swallow all
NMIs thinking the counters overflowed.

This causes problems for subsystems like kgdb which needs NMIs to do its
magic. This problem was discovered by running kgdb tests.

The solution is to write garbage into a perf counter during the
initialization and hopefully reading back the same number.  On kvm
guests, the value will be read back as zero and we disable perf as
a result.

Reported-by: Jason Wessel <jason.wessel@windriver.com>
Patch-inspired-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <1290462923-30734-1-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ed63101..6d75b91 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -381,6 +381,20 @@ static void release_pmc_hardware(void) {}
 
 #endif
 
+static bool check_hw_exists(void)
+{
+	u64 val, val_new = 0;
+	int ret = 0;
+
+	val = 0xabcdUL;
+	ret |= checking_wrmsrl(x86_pmu.perfctr, val);
+	ret |= rdmsrl_safe(x86_pmu.perfctr, &val_new);
+	if (ret || val != val_new)
+		return false;
+
+	return true;
+}
+
 static void reserve_ds_buffers(void);
 static void release_ds_buffers(void);
 
@@ -1372,6 +1386,12 @@ void __init init_hw_perf_events(void)
 
 	pmu_check_apic();
 
+	/* sanity check that the hardware exists or is emulated */
+	if (!check_hw_exists()) {
+		pr_cont("Broken PMU hardware detected, software events only.\n");
+		return;
+	}
+
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
 	if (x86_pmu.quirks)
