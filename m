Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab1LLLv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 06:51:26 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:45184 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab1LLLvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 06:51:25 -0500
X-Auth-Info: NeZnNNiTVCIenv4W0ckVvv1z6Aoh/hpRQHGZhfCUlp0=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        "Artem S. Tashkinov" <t.artem@mailcity.com>,
        Dave Jones <davej@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2] procfs: do not confuse jiffies with cputime64_t
References: <m28vmi7ip3.fsf@igel.home> <201112120922.13633.arnd@arndb.de>
X-Yow: I love FRUIT PICKERS!!
Date: Mon, 12 Dec 2011 12:51:19 +0100
In-Reply-To: <201112120922.13633.arnd@arndb.de> (Arnd Bergmann's message of
	"Mon, 12 Dec 2011 09:22:13 +0000")
Message-ID: <m21usavwi0.fsf_-_@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_{idle,iowait}_time are supposed to return cputime64_t values, not
jiffies.  Add usecs_to_cputime64 for this.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
---
 arch/ia64/include/asm/cputime.h    |    1 +
 arch/powerpc/include/asm/cputime.h |    2 ++
 fs/proc/stat.c                     |    4 ++--
 include/asm-generic/cputime.h      |    1 +
 4 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/include/asm/cputime.h b/arch/ia64/include/asm/cputime.h
index 6073b18..5a274af 100644
--- a/arch/ia64/include/asm/cputime.h
+++ b/arch/ia64/include/asm/cputime.h
@@ -60,6 +60,7 @@ typedef u64 cputime64_t;
  */
 #define cputime_to_usecs(__ct)		((__ct) / NSEC_PER_USEC)
 #define usecs_to_cputime(__usecs)	((__usecs) * NSEC_PER_USEC)
+#define usecs_to_cputime64(__usecs)	usecs_to_cputime(__usecs)
 
 /*
  * Convert cputime <-> seconds
diff --git a/arch/powerpc/include/asm/cputime.h b/arch/powerpc/include/asm/cputime.h
index 33a3580..fa3f921 100644
--- a/arch/powerpc/include/asm/cputime.h
+++ b/arch/powerpc/include/asm/cputime.h
@@ -150,6 +150,8 @@ static inline cputime_t usecs_to_cputime(const unsigned long us)
 	return ct;
 }
 
+#define usecs_to_cputime64(us)		usecs_to_cputime(us)
+
 /*
  * Convert cputime <-> seconds
  */
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 2a30d67..0855e6f 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -32,7 +32,7 @@ static cputime64_t get_idle_time(int cpu)
 		idle = kstat_cpu(cpu).cpustat.idle;
 		idle = cputime64_add(idle, arch_idle_time(cpu));
 	} else
-		idle = nsecs_to_jiffies64(1000 * idle_time);
+		idle = usecs_to_cputime64(idle_time);
 
 	return idle;
 }
@@ -46,7 +46,7 @@ static cputime64_t get_iowait_time(int cpu)
 		/* !NO_HZ so we can rely on cpustat.iowait */
 		iowait = kstat_cpu(cpu).cpustat.iowait;
 	else
-		iowait = nsecs_to_jiffies64(1000 * iowait_time);
+		iowait = usecs_to_cputime64(iowait_time);
 
 	return iowait;
 }
diff --git a/include/asm-generic/cputime.h b/include/asm-generic/cputime.h
index 62ce682..12a1764 100644
--- a/include/asm-generic/cputime.h
+++ b/include/asm-generic/cputime.h
@@ -40,6 +40,7 @@ typedef u64 cputime64_t;
  */
 #define cputime_to_usecs(__ct)		jiffies_to_usecs(__ct)
 #define usecs_to_cputime(__msecs)	usecs_to_jiffies(__msecs)
+#define usecs_to_cputime64(__msecs)	nsecs_to_jiffies64((__msecs) * 1000)
 
 /*
  * Convert cputime to seconds and back.
-- 
1.7.8


-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
