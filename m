Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab1LUT7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 14:59:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1LUT7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 14:59:20 -0500
Date: Wed, 21 Dec 2011 11:59:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        "Artem S. Tashkinov" <t.artem@mailcity.com>,
        Dave Jones <davej@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [resend PATCH for 3.2] procfs: do not confuse jiffies with
 cputime64_t
Message-Id: <20111221115919.6beac46f.akpm@linux-foundation.org>
In-Reply-To: <20111221100334.GD27137@tiehlicka.suse.cz>
References: <m28vmi7ip3.fsf@igel.home>
	<201112120922.13633.arnd@arndb.de>
	<m21usavwi0.fsf_-_@igel.home>
	<20111212124333.GC14720@tiehlicka.suse.cz>
	<m2wra2uedy.fsf_-_@igel.home>
	<20111212131218.GD14720@tiehlicka.suse.cz>
	<20111221100334.GD27137@tiehlicka.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011 11:03:34 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> Hmm, it seems that this bugfix (for 3.2) stalled. I guess that it is
> primarily because it is multiarch fix.
> I am sorry to bother you Andrew but could we push this through you,
> please?
> 
> The full patch for reference:
> ---
> >From 1fca39b21f3b344c90c30d98db6dcdcdc6815797 Mon Sep 17 00:00:00 2001
> From: Andreas Schwab <schwab@linux-m68k.org>
> Date: Mon, 12 Dec 2011 14:07:53 +0100
> Subject: [PATCH] procfs: do not confuse jiffies with cputime64_t
> 
> get_{idle,iowait}_time are supposed to return cputime64_t values, not
> jiffies.  Add usecs_to_cputime64 for this.

This makes a huge mess when mixed with Martin's "cputime: add sparse
checking and cleanup" in linux-next.  I think I got it fixed up but it
needs careful checking - I don't _think_ I needed to add more __force
thingies.  The version against today's linux-next is below.

(I did party tricks with this so I could carry the against-mainline and
against-next versions in the same tree).


Also, in include/asm-generic/cputime.h we have:

#define usecs_to_cputime64(__msecs)	nsecs_to_jiffies64((__msecs) * 1000)

But it would be neater to have used nsecs_to_cputime64(), surely.


Also, the changelog still sucks

From: Andreas Schwab <schwab@linux-m68k.org>
Subject: procfs: do not confuse jiffies with cputime64_t

get_{idle,iowait}_time are supposed to return cputime64_t values, not
jiffies.  Add usecs_to_cputime64 for this.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Artem S. Tashkinov" <t.artem@mailcity.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/cputime.h    |    1 +
 arch/powerpc/include/asm/cputime.h |    2 ++
 arch/s390/include/asm/cputime.h    |    2 ++
 fs/proc/stat.c                     |    4 ++--
 include/asm-generic/cputime.h      |    1 +
 5 files changed, 8 insertions(+), 2 deletions(-)

diff -puN arch/ia64/include/asm/cputime.h~reapply-procfs-do-not-confuse-jiffies-with-cputime64_t arch/ia64/include/asm/cputime.h
--- a/arch/ia64/include/asm/cputime.h~reapply-procfs-do-not-confuse-jiffies-with-cputime64_t
+++ a/arch/ia64/include/asm/cputime.h
@@ -50,6 +50,7 @@ typedef u64 __nocast cputime64_t;
 	((__force u64)(__ct) / NSEC_PER_USEC)
 #define usecs_to_cputime(__usecs)	\
 	(__force cputime_t)((__usecs) * NSEC_PER_USEC)
+#define usecs_to_cputime64(__usecs)	usecs_to_cputime(__usecs)
 
 /*
  * Convert cputime <-> seconds
diff -puN arch/powerpc/include/asm/cputime.h~reapply-procfs-do-not-confuse-jiffies-with-cputime64_t arch/powerpc/include/asm/cputime.h
--- a/arch/powerpc/include/asm/cputime.h~reapply-procfs-do-not-confuse-jiffies-with-cputime64_t
+++ a/arch/powerpc/include/asm/cputime.h
@@ -134,6 +134,8 @@ static inline cputime_t usecs_to_cputime
 	return (__force cputime_t) ct;
 }
 
+#define usecs_to_cputime64(us)		usecs_to_cputime(us)
+
 /*
  * Convert cputime <-> seconds
  */
diff -puN arch/s390/include/asm/cputime.h~reapply-procfs-do-not-confuse-jiffies-with-cputime64_t arch/s390/include/asm/cputime.h
--- a/arch/s390/include/asm/cputime.h~reapply-procfs-do-not-confuse-jiffies-with-cputime64_t
+++ a/arch/s390/include/asm/cputime.h
@@ -72,6 +72,8 @@ static inline cputime_t usecs_to_cputime
 	return (__force cputime_t)(m * 4096ULL);
 }
 
+#define usecs_to_cputime64(m)		usecs_to_cputime(m)
+
 /*
  * Convert cputime to milliseconds and back.
  */
diff -puN fs/proc/stat.c~reapply-procfs-do-not-confuse-jiffies-with-cputime64_t fs/proc/stat.c
--- a/fs/proc/stat.c~reapply-procfs-do-not-confuse-jiffies-with-cputime64_t
+++ a/fs/proc/stat.c
@@ -31,7 +31,7 @@ static u64 get_idle_time(int cpu)
 		idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
 		idle += arch_idle_time(cpu);
 	} else
-		idle = nsecs_to_jiffies64(1000 * idle_time);
+		idle = usecs_to_cputime64(idle_time);
 
 	return idle;
 }
@@ -44,7 +44,7 @@ static u64 get_iowait_time(int cpu)
 		/* !NO_HZ so we can rely on cpustat.iowait */
 		iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
 	else
-		iowait = nsecs_to_jiffies64(1000 * iowait_time);
+		iowait = usecs_to_cputime64(iowait_time);
 
 	return iowait;
 }
diff -puN include/asm-generic/cputime.h~reapply-procfs-do-not-confuse-jiffies-with-cputime64_t include/asm-generic/cputime.h
--- a/include/asm-generic/cputime.h~reapply-procfs-do-not-confuse-jiffies-with-cputime64_t
+++ a/include/asm-generic/cputime.h
@@ -27,6 +27,7 @@ typedef u64 __nocast cputime64_t;
 	jiffies_to_usecs(cputime_to_jiffies(__ct));
 #define usecs_to_cputime(__msecs)	\
 	jiffies_to_cputime(usecs_to_jiffies(__msecs));
+#define usecs_to_cputime64(__msecs)	nsecs_to_jiffies64((__msecs) * 1000)
 
 /*
  * Convert cputime to seconds and back.
_
.
