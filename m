Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab1LWNT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 08:19:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50721 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021Ab1LWNT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:19:56 -0500
Date: Fri, 23 Dec 2011 05:19:15 -0800
From: tip-bot for Vladimir Zapolskiy <vladimir.zapolskiy@nokia.com>
Message-ID: <tip-55205c916e179e09773d98d290334d319f45ac6b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        vladimir.zapolskiy@nokia.com, will.deacon@arm.com,
        robert.richter@amd.com, oprofile-list@lists.sourceforge.net,
        stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        oprofile-list@lists.sourceforge.net, robert.richter@amd.com,
        vladimir.zapolskiy@nokia.com, will.deacon@arm.com, stable@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111222151540.GB16765@erda.amd.com>
References: <20111222151540.GB16765@erda.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] oprofile, arm/sh: Fix oprofile_arch_exit()
  linkage issue
Git-Commit-ID: 55205c916e179e09773d98d290334d319f45ac6b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 23 Dec 2011 05:19:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55205c916e179e09773d98d290334d319f45ac6b
Gitweb:     http://git.kernel.org/tip/55205c916e179e09773d98d290334d319f45ac6b
Author:     Vladimir Zapolskiy <vladimir.zapolskiy@nokia.com>
AuthorDate: Thu, 22 Dec 2011 16:15:40 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 23 Dec 2011 11:58:34 +0100

oprofile, arm/sh: Fix oprofile_arch_exit() linkage issue

This change fixes a linking problem, which happens if oprofile
is selected to be compiled as built-in:

  `oprofile_arch_exit' referenced in section `.init.text' of
  arch/arm/oprofile/built-in.o: defined in discarded section
  `.exit.text' of arch/arm/oprofile/built-in.o

The problem is appeared after commit 87121ca504, which
introduced oprofile_arch_exit() calls from __init function. Note
that the aforementioned commit has been backported to stable
branches, and the problem is known to be reproduced at least
with 3.0.13 and 3.1.5 kernels.

Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@nokia.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: oprofile-list <oprofile-list@lists.sourceforge.net>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/20111222151540.GB16765@erda.amd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/arm/oprofile/common.c |    2 +-
 arch/sh/oprofile/common.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index c074e66..4e0a371 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -116,7 +116,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	return oprofile_perf_init(ops);
 }
 
-void __exit oprofile_arch_exit(void)
+void oprofile_arch_exit(void)
 {
 	oprofile_perf_exit();
 }
diff --git a/arch/sh/oprofile/common.c b/arch/sh/oprofile/common.c
index b4c2d2b..e4dd5d5 100644
--- a/arch/sh/oprofile/common.c
+++ b/arch/sh/oprofile/common.c
@@ -49,7 +49,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	return oprofile_perf_init(ops);
 }
 
-void __exit oprofile_arch_exit(void)
+void oprofile_arch_exit(void)
 {
 	oprofile_perf_exit();
 	kfree(sh_pmu_op_name);
@@ -60,5 +60,5 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	ops->backtrace = sh_backtrace;
 	return -ENODEV;
 }
-void __exit oprofile_arch_exit(void) {}
+void oprofile_arch_exit(void) {}
 #endif /* CONFIG_HW_PERF_EVENTS */
