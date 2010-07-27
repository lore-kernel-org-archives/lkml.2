Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab0G0KqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 06:46:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:35323 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906Ab0G0KqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 06:46:08 -0400
Date: Tue, 27 Jul 2010 10:45:50 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, oleg@redhat.com, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, oleg@redhat.com,
        jolsa@redhat.com
In-Reply-To: <1279068988-21864-2-git-send-email-johnstul@us.ibm.com>
References: <1279068988-21864-2-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/clocksource] x86: Fix vtime/file timestamp inconsistencies
Message-ID: <tip-8c73626ab28527b7eb7f3061c027fbfe530c488c@git.kernel.org>
Git-Commit-ID: 8c73626ab28527b7eb7f3061c027fbfe530c488c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 27 Jul 2010 10:45:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c73626ab28527b7eb7f3061c027fbfe530c488c
Gitweb:     http://git.kernel.org/tip/8c73626ab28527b7eb7f3061c027fbfe530c488c
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Tue, 13 Jul 2010 17:56:18 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 27 Jul 2010 12:40:53 +0200

x86: Fix vtime/file timestamp inconsistencies

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
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
LKML-Reference: <1279068988-21864-2-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
