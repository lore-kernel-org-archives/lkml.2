Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab2LDTMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 14:12:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54386 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab2LDTMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 14:12:18 -0500
Date: Tue, 4 Dec 2012 11:10:57 -0800
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-8d4516904b39507458bee8115793528e12b1d8dd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, joseph.salisbury@canonical.com,
        nwarmuth@t-online.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, nwarmuth@t-online.de,
        joseph.salisbury@canonical.com
In-Reply-To: <alpine.LFD.2.02.1211231033230.2701@ionos>
References: <alpine.LFD.2.02.1211231033230.2701@ionos>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] watchdog: Fix CPU hotplug regression
Git-Commit-ID: 8d4516904b39507458bee8115793528e12b1d8dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 04 Dec 2012 11:11:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d4516904b39507458bee8115793528e12b1d8dd
Gitweb:     http://git.kernel.org/tip/8d4516904b39507458bee8115793528e12b1d8dd
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 4 Dec 2012 18:59:34 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Dec 2012 19:56:59 +0100

watchdog: Fix CPU hotplug regression

Norbert reported:
"3.7-rc6 booted with nmi_watchdog=0 fails to suspend to RAM or
 offline CPUs. It's reproducable with a KVM guest and physical
 system."

The reason is that commit bcd951cf(watchdog: Use hotplug thread
infrastructure) missed to take this into account. So the cpu offline
code gets stuck in the teardown function because it accesses non
initialized data structures.

Add a check for watchdog_enabled into that path to cure the issue.

Reported-and-tested-by: Norbert Warmuth <nwarmuth@t-online.de>
Tested-by: Joseph Salisbury <joseph.salisbury@canonical.com>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1211231033230.2701@ionos
Link: http://bugs.launchpad.net/bugs/1079534
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/watchdog.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index dd4b80a..c8c21be 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -368,6 +368,9 @@ static void watchdog_disable(unsigned int cpu)
 {
 	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
 
+	if (!watchdog_enabled)
+		return;
+
 	watchdog_set_prio(SCHED_NORMAL, 0);
 	hrtimer_cancel(hrtimer);
 	/* disable the perf event */
