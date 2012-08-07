Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031218Ab2HGW4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:56:40 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51211 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031092Ab2HGWp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:45:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andreas Schwab <schwab@linux-m68k.org>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Hocko <mhocko@suse.cz>
Subject: [ 04/49] powerpc: Fix wrong divisor in usecs_to_cputime
Date: Tue,  7 Aug 2012 15:44:22 -0700
Message-Id: <20120807222027.257644855@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222026.848194739@linuxfoundation.org>
References: <20120807222026.848194739@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Schwab <schwab@linux-m68k.org>

commit 9f5072d4f63f28d30d343573830ac6c85fc0deff upstream.

Commit d57af9b (taskstats: use real microsecond granularity for CPU times)
renamed msecs_to_cputime to usecs_to_cputime, but failed to update all
numbers on the way.  This causes nonsensical cpu idle/iowait values to be
displayed in /proc/stat (the only user of usecs_to_cputime so far).

This also renames __cputime_msec_factor to __cputime_usec_factor, adapting
its value and using it directly in cputime_to_usecs instead of doing two
multiplications.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
Acked-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/cputime.h |    6 +++---
 arch/powerpc/kernel/time.c         |   10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/arch/powerpc/include/asm/cputime.h
+++ b/arch/powerpc/include/asm/cputime.h
@@ -126,11 +126,11 @@ static inline u64 cputime64_to_jiffies64
 /*
  * Convert cputime <-> microseconds
  */
-extern u64 __cputime_msec_factor;
+extern u64 __cputime_usec_factor;
 
 static inline unsigned long cputime_to_usecs(const cputime_t ct)
 {
-	return mulhdu(ct, __cputime_msec_factor) * USEC_PER_MSEC;
+	return mulhdu(ct, __cputime_usec_factor);
 }
 
 static inline cputime_t usecs_to_cputime(const unsigned long us)
@@ -143,7 +143,7 @@ static inline cputime_t usecs_to_cputime
 	sec = us / 1000000;
 	if (ct) {
 		ct *= tb_ticks_per_sec;
-		do_div(ct, 1000);
+		do_div(ct, 1000000);
 	}
 	if (sec)
 		ct += (cputime_t) sec * tb_ticks_per_sec;
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -168,13 +168,13 @@ EXPORT_SYMBOL_GPL(ppc_tb_freq);
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
 /*
  * Factors for converting from cputime_t (timebase ticks) to
- * jiffies, milliseconds, seconds, and clock_t (1/USER_HZ seconds).
+ * jiffies, microseconds, seconds, and clock_t (1/USER_HZ seconds).
  * These are all stored as 0.64 fixed-point binary fractions.
  */
 u64 __cputime_jiffies_factor;
 EXPORT_SYMBOL(__cputime_jiffies_factor);
-u64 __cputime_msec_factor;
-EXPORT_SYMBOL(__cputime_msec_factor);
+u64 __cputime_usec_factor;
+EXPORT_SYMBOL(__cputime_usec_factor);
 u64 __cputime_sec_factor;
 EXPORT_SYMBOL(__cputime_sec_factor);
 u64 __cputime_clockt_factor;
@@ -192,8 +192,8 @@ static void calc_cputime_factors(void)
 
 	div128_by_32(HZ, 0, tb_ticks_per_sec, &res);
 	__cputime_jiffies_factor = res.result_low;
-	div128_by_32(1000, 0, tb_ticks_per_sec, &res);
-	__cputime_msec_factor = res.result_low;
+	div128_by_32(1000000, 0, tb_ticks_per_sec, &res);
+	__cputime_usec_factor = res.result_low;
 	div128_by_32(1, 0, tb_ticks_per_sec, &res);
 	__cputime_sec_factor = res.result_low;
 	div128_by_32(USER_HZ, 0, tb_ticks_per_sec, &res);


