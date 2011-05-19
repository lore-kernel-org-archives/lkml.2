Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab1ESNZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:25:19 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:45832 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755173Ab1ESNZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:25:18 -0400
X-AuditID: 1209190f-b7c4dae0000007bd-fa-4dd51a3f5405
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH] x86-64: Add time to vDSO
Date: Thu, 19 May 2011 09:24:48 -0400
Message-Id: <8f0d3bec51be8d9a2c37bac5aeb64c35cb387640.1305811184.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsUixCmqrWsvddXX4MNOPYuLbRfZLPquHGW3
	OHLtO7vF5V1z2Cy2XGpmtdi8aSqzxY8Nj1kd2D2uPOXwuNX2h9lj/s6PjB47Z91l99i0qpPN
	4925c+wenzfJBbBHcdmkpOZklqUW6dslcGUcbulmKngmWnFza3ID4zXBLkYODgkBE4ntt5y6
	GDmBTDGJC/fWs3UxcnEICexjlNg3fRorhLOBUeL+/YVQznImib7vnewgLWwCKhIdSx8wgdgi
	AjUSu199ZAGxmQXKJL5Peg8WFxbQlJi6CqSZg4NFQFXiwxlvkDCvQJDEmY9z2CA2K0hcuTKP
	ZQIjzwJGhlWMsim5Vbq5iZk5xanJusXJiXl5qUW6Jnq5mSV6qSmlmxjBwSXJv4Px20GlQ4wC
	HIxKPLwV3Fd8hVgTy4orcw8xSnIwKYnybhS76ivEl5SfUpmRWJwRX1Sak1p8iFGCg1lJhLeT
	AyjHm5JYWZValA+TkuZgURLnnSWp7iskkJ5YkpqdmlqQWgSTleHgUJLgbZMEahQsSk1PrUjL
	zClBSDNxcIIM5wEabgtSw1tckJhbnJkOkT/FqMsx9fbvA4xCLHn5ealS4rwxIEUCIEUZpXlw
	c2BJ4RWjONBbwrzFIFU8wIQCN+kV0BImoCWy+6+ALClJREhJNTBahS79fWVbydtk5Tb27eXC
	t1enXzB++ClC5Mmxf095qoztltmsn/rLS2nJ+e83jG5+KmM9Mfviq60sYj0+P7TfHOT12aqk
	lBOeybM3aRZngUg4+5+tL8pUP61L7l43JTg+8Ae7VMrW3h7hE9JxER580jOOvJVg0qqp45it
	Gi8guuOFTcbimvtKLMUZiYZazEXFiQClWUeU5QIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only fast implementation of time(2) we expose is through the
vsyscall page and we want to get userspace to stop using the
vsyscall page.  So make it available through the vDSO as well.

This is essentially a cut-n-paste job.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---

[Some cc's dropped from original thread because they probably only cared
 about the rdtsc stuff.]

This applies on top of my rdtsc patchkit.  It might apply without it
but it certainly won't work because it needs the new VVAR macro.

It survives light testing.  The return value of the new time function agrees
with glibc's time(2) and it takes about 3ns to call on Sandy Bridge.
(glibc's function takes twice as long I haven't tried to figure out why.)

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

