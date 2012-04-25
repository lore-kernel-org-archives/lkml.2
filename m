Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246Ab2DYNxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:53:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44529 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209Ab2DYNxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:53:32 -0400
Date: Wed, 25 Apr 2012 06:53:19 -0700
From: tip-bot for Sasha Levin <levinsasha928@gmail.com>
Message-ID: <tip-625056b65ee9a8b4caf42136e0c844c15e6ec54f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, levinsasha928@gmail.com, hpa@zytor.com,
        mingo@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <1331848040-1676-1-git-send-email-levinsasha928@gmail.com>
References: <1331848040-1676-1-git-send-email-levinsasha928@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] hung task debugging:
  Inject NMI when hung and going to panic
Git-Commit-ID: 625056b65ee9a8b4caf42136e0c844c15e6ec54f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Apr 2012 06:53:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  625056b65ee9a8b4caf42136e0c844c15e6ec54f
Gitweb:     http://git.kernel.org/tip/625056b65ee9a8b4caf42136e0c844c15e6ec54f
Author:     Sasha Levin <levinsasha928@gmail.com>
AuthorDate: Thu, 15 Mar 2012 17:47:20 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 25 Apr 2012 12:39:25 +0200

hung task debugging: Inject NMI when hung and going to panic

Send an NMI to all CPUs when a hung task is detected and the hung
task code is configured to panic. This gives us a fairly uptodate
snapshot of all CPUs in the system.

This lets us get stack trace of all CPUs which makes life easier
trying to debug a deadlock, and the NMI doesn't change anything
since the next step is a kernel panic.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1331848040-1676-1-git-send-email-levinsasha928@gmail.com
[ extended the changelog a bit ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/hung_task.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index c21449f..6df6149 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -108,8 +108,10 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)
 
 	touch_nmi_watchdog();
 
-	if (sysctl_hung_task_panic)
+	if (sysctl_hung_task_panic) {
+		trigger_all_cpu_backtrace();
 		panic("hung_task: blocked tasks");
+	}
 }
 
 /*
