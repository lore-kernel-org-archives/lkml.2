Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab0GNA4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 20:56:33 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54136 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab0GNA4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 20:56:30 -0400
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Jiri Olsa <jolsa@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 01/11] x86: Fix vtime/file timestamp inconsistencies
Date: Tue, 13 Jul 2010 17:56:18 -0700
Message-Id: <1279068988-21864-2-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1279068988-21864-1-git-send-email-johnstul@us.ibm.com>
References: <1279068988-21864-1-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to vtime calling vgettimeofday(), its possible that an application
could call  time();create("stuff",O_RDRW);  only to see the file's
creation timestamp to be before the value returned by time.

A similar way to reproduce the issue is to compare the vsyscall time()
with the syscall time(), and observe ordering issues.

The modified test case from Oleg Nesterov below can illustrate this:

int main(void)
{
	time_t sec1,sec2;
	do {
		sec1 = time(&sec2);
		sec2 = syscall(__NR_time, NULL);
	} while (sec1 <= sec2);

	printf("vtime: %d.000000\n", sec1);
	printf("time: %d.000000\n", sec2);
	return 0;
}

The proper fix is to make vtime use the same time value as
current_kernel_time() (which is exported via update_vsyscall) instead of
vgettime().

Thanks to Jiri Olsa for bringing up the issue and catching bugs in
earlier verisons of this fix.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

CC: Jiri Olsa <jolsa@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/vsyscall_64.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 1c0c6ab..dce0c3c 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -169,13 +169,18 @@ int __vsyscall(0) vgettimeofday(struct timeval * tv, struct timezone * tz)
  * unlikely */
 time_t __vsyscall(1) vtime(time_t *t)
 {
-	struct timeval tv;
+	unsigned seq;
 	time_t result;
 	if (unlikely(!__vsyscall_gtod_data.sysctl_enabled))
 		return time_syscall(t);
 
-	vgettimeofday(&tv, NULL);
-	result = tv.tv_sec;
+	do {
+		seq = read_seqbegin(&__vsyscall_gtod_data.lock);
+
+		result = __vsyscall_gtod_data.wall_time_sec;
+
+	} while (read_seqretry(&__vsyscall_gtod_data.lock, seq));
+
 	if (t)
 		*t = result;
 	return result;
-- 
1.6.0.4

