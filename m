Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab2GXOXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:23:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42111 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab2GXOW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:22:59 -0400
Date: Tue, 24 Jul 2012 07:22:44 -0700
From: tip-bot for Darren Hart <dvhart@linux.intel.com>
Message-ID: <tip-b6070a8d9853eda010a549fa9a09eb8d7269b929@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dvhart@linux.intel.com, davej@redhat.com, tglx@linutronix.de,
        dan.carpenter@oracle.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, tglx@linutronix.de, davej@redhat.com,
        dan.carpenter@oracle.com
In-Reply-To: <dc59890338fc413606f04e5c5b131530734dae3d.1342809673.git.dvhart@linux.intel.com>
References: <dc59890338fc413606f04e5c5b131530734dae3d.1342809673.git.dvhart@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] futex:
  Test for pi_mutex on fault in futex_wait_requeue_pi()
Git-Commit-ID: b6070a8d9853eda010a549fa9a09eb8d7269b929
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 24 Jul 2012 07:22:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b6070a8d9853eda010a549fa9a09eb8d7269b929
Gitweb:     http://git.kernel.org/tip/b6070a8d9853eda010a549fa9a09eb8d7269b929
Author:     Darren Hart <dvhart@linux.intel.com>
AuthorDate: Fri, 20 Jul 2012 11:53:29 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 24 Jul 2012 16:02:56 +0200

futex: Test for pi_mutex on fault in futex_wait_requeue_pi()

If fixup_pi_state_owner() faults, pi_mutex may be NULL. Test
for pi_mutex != NULL before testing the owner against current
and possibly unlocking it.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/dc59890338fc413606f04e5c5b131530734dae3d.1342809673.git.dvhart@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index e2b0fb9..05018bf 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2370,7 +2370,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 	 * fault, unlock the rt_mutex and return the fault to userspace.
 	 */
 	if (ret == -EFAULT) {
-		if (rt_mutex_owner(pi_mutex) == current)
+		if (pi_mutex && rt_mutex_owner(pi_mutex) == current)
 			rt_mutex_unlock(pi_mutex);
 	} else if (ret == -EINTR) {
 		/*
