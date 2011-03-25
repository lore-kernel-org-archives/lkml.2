Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab1CYLwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:52:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:38339 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab1CYLwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:52:08 -0400
Date: Fri, 25 Mar 2011 11:51:47 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        gorcunov@openvz.org, ming.m.lin@intel.com, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, ming.m.lin@intel.com, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <4D8BAB49.3080701@openvz.org>
References: <4D8BAB49.3080701@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: P4 PMU - Read proper MSR register to catch unflagged overflows
Message-ID: <tip-242214f9c1eeaae40eca11e3b4d37bfce960a7cd@git.kernel.org>
Git-Commit-ID: 242214f9c1eeaae40eca11e3b4d37bfce960a7cd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 25 Mar 2011 11:51:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  242214f9c1eeaae40eca11e3b4d37bfce960a7cd
Gitweb:     http://git.kernel.org/tip/242214f9c1eeaae40eca11e3b4d37bfce960a7cd
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Thu, 24 Mar 2011 23:36:25 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 24 Mar 2011 21:40:01 +0100

perf, x86: P4 PMU - Read proper MSR register to catch unflagged overflows

The read of a proper MSR register was missed and instead of
counter the configration register was tested (it has
ARCH_P4_UNFLAGGED_BIT always cleared) leading to unknown NMI
hitting the system. As result the user may obtain "Dazed and
confused, but trying to continue" message. Fix it by reading a
proper MSR register.

When an NMI happens on a P4, the perf nmi handler checks the
configuration register to see if the overflow bit is set or not
before taking appropriate action.  Unfortunately, various P4
machines had a broken overflow bit, so a backup mechanism was
implemented.  This mechanism checked to see if the counter
rolled over or not.

A previous commit that implemented this backup mechanism was
broken. Instead of reading the counter register, it used the
configuration register to determine if the counter rolled over
or not. Reading that bit would give incorrect results.

This would lead to 'Dazed and confused' messages for the end
user when using the perf tool (or if the nmi watchdog is
running).

The fix is to read the counter register before determining if
the counter rolled over or not.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Lin Ming <ming.m.lin@intel.com>
LKML-Reference: <4D8BAB49.3080701@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 3769ac8..d3d7b59 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -777,6 +777,7 @@ static inline int p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
 	 * the counter has reached zero value and continued counting before
 	 * real NMI signal was received:
 	 */
+	rdmsrl(hwc->event_base, v);
 	if (!(v & ARCH_P4_UNFLAGGED_BIT))
 		return 1;
 
