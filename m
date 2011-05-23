Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab1EWNdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:33:42 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:60841 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754929Ab1EWNdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:33:13 -0400
X-AuditID: 12074423-b7babae000007c6b-5a-4dda621aaa3e
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@amd64.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v5 7/8] x86-64: Add time to vDSO
Date: Mon, 23 May 2011 09:31:30 -0400
Message-Id: <bf963bac5207de4b29613f27c42705e4371812a8.1306156808.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306156808.git.luto@mit.edu>
References: <cover.1306156808.git.luto@mit.edu>
In-Reply-To: <cover.1306156808.git.luto@mit.edu>
References: <cover.1306156808.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsUixG6noiuVdMvX4NZGIYuLbRfZLPquHGW3
	OHLtO7vFxcZtLBZzzrewWOx7f5bN4vKuOWwWWy41s1ps3jSV2eJR31t2ix8bHrM6cHt0P/rE
	6HHlKYfHlpU3mTxutf1h9pi/8yOjx85Zd9k9Nq3qZPN4d+4cu8eJGb9ZPD5vkgvgiuKySUnN
	ySxLLdK3S+DKuHfXu2CyUEX/ktNMDYxP+LoYOTkkBEwkXi85xARhi0lcuLeerYuRi0NIYB+j
	xLEvu5kgnA2MEjca3jJDOM+YJK5N7wRrYRNQkehY+gDI5uAQERCSWHq3DqSGWWAts8S+7sVg
	NcICBhJrL75kA7FZBFQlvkx5yQJi8woESbxvesMCsVpB4sqVeWA2J1D9/N0nwWwhAX2JSUeX
	4hSfwCiwgJFhFaNsSm6Vbm5iZk5xarJucXJiXl5qka6ZXm5miV5qSukmRnAcuCjvYPxzUOkQ
	owAHoxIP72LNm75CrIllxZW5hxglOZiURHld4m/5CvEl5adUZiQWZ8QXleakFh9ilOBgVhLh
	bdC+4SvEm5JYWZValA+TkuZgURLnnSup7iskkJ5YkpqdmlqQWgSTleHgUJLgXZQINFSwKDU9
	tSItM6cEIc3EwQkynAdoeC9IDW9xQWJucWY6RP4Uoy7H1Nu/DzAKseTl56VKifPOAykSACnK
	KM2DmwNLX68YxYHeEuadCFLFA0x9cJNeAS1hAloi8fcmyJKSRISUVANjhaWsv6axi/gl067S
	5Gt3174xLN9/tUT3W7HR1RdVZfK/6nZdWr+6Jih7xzKeRsbK/8duh6wIUNvX3/HVQK2AoStH
	qdr4ocEc9f33P61PfX3Bro97mvXGhYvPbHtm6+npbqzgwfn/bXa4+x9ekb1/zhR6dq1T15qu
	yKYq+u/FHlXm/3ca5BiVWIozEg21mIuKEwEk1PTmOgMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only fast implementation of time(2) we expose is through the
vsyscall page and we want to get userspace to stop using the
vsyscall page.  So make it available through the vDSO as well.

This is essentially a cut-n-paste job.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/vdso/vclock_gettime.c |   35 ++++++++++++++++++++++++++++++++++-
 arch/x86/vdso/vdso.lds.S       |    2 ++
 2 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 28b2c00..e6e9f90 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -2,7 +2,7 @@
  * Copyright 2006 Andi Kleen, SUSE Labs.
  * Subject to the GNU Public License, v.2
  *
- * Fast user context implementation of clock_gettime and gettimeofday.
+ * Fast user context implementation of clock_gettime, gettimeofday, and time.
  *
  * The code should have no internal unresolved relocations.
  * Check with readelf after changing.
@@ -160,3 +160,36 @@ notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 }
 int gettimeofday(struct timeval *, struct timezone *)
 	__attribute__((weak, alias("__vdso_gettimeofday")));
+
+/* This will break when the xtime seconds get inaccurate, but that is
+ * unlikely */
+
+static __always_inline long time_syscall(long *t)
+{
+	long secs;
+	asm volatile("syscall"
+		     : "=a" (secs)
+		     : "0" (__NR_time), "D" (t) : "cc", "r11", "cx", "memory");
+	return secs;
+}
+
+notrace time_t __vdso_time(time_t *t)
+{
+	unsigned seq;
+	time_t result;
+	if (unlikely(!VVAR(vsyscall_gtod_data).sysctl_enabled))
+		return time_syscall(t);
+
+	do {
+		seq = read_seqbegin(&VVAR(vsyscall_gtod_data).lock);
+
+		result = VVAR(vsyscall_gtod_data).wall_time_sec;
+
+	} while (read_seqretry(&VVAR(vsyscall_gtod_data).lock, seq));
+
+	if (t)
+		*t = result;
+	return result;
+}
+int time(time_t *t)
+	__attribute__((weak, alias("__vdso_time")));
diff --git a/arch/x86/vdso/vdso.lds.S b/arch/x86/vdso/vdso.lds.S
index 81f2500..b96b267 100644
--- a/arch/x86/vdso/vdso.lds.S
+++ b/arch/x86/vdso/vdso.lds.S
@@ -23,6 +23,8 @@ VERSION {
 		__vdso_gettimeofday;
 		getcpu;
 		__vdso_getcpu;
+		time;
+		__vdso_time;
 	local: *;
 	};
 }
-- 
1.7.5.1

