Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab1AKRSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 12:18:16 -0500
Received: from relais.videotron.ca ([24.201.245.36]:11218 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab1AKRSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 12:18:13 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 11 Jan 2011 12:18:12 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: John Stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] clocks_calc_mult_shift(): rename minsec argument according to
 actual usage
Message-id: <alpine.LFD.2.00.1101111207140.17086@xanadu.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The minsec argument to clocks_calc_mult_shift() is misnamed. It is used 
to clamp the magnitude of the mult factor so that a multiplication with 
any value in the given range won't overflow a 64 bit result.  Let's 
rename it to match the actual usage.

Signed-off-by: Nicolas Pitre <nicolas.pitre@linaro.org>

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c18d7ef..8588abc 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -113,7 +113,7 @@ EXPORT_SYMBOL_GPL(timecounter_cyc2time);
  * @shift:	pointer to shift variable
  * @from:	frequency to convert from
  * @to:		frequency to convert to
- * @minsec:	guaranteed runtime conversion range in seconds
+ * @maxsec:	guaranteed runtime conversion range in seconds
  *
  * The function evaluates the shift/mult pair for the scaled math
  * operations of clocksources and clockevents.
@@ -122,7 +122,7 @@ EXPORT_SYMBOL_GPL(timecounter_cyc2time);
  * NSEC_PER_SEC == 1GHz and @from is the counter frequency. For clock
  * event @to is the counter frequency and @from is NSEC_PER_SEC.
  *
- * The @minsec conversion range argument controls the time frame in
+ * The @maxsec conversion range argument controls the time frame in
  * seconds which must be covered by the runtime conversion with the
  * calculated mult and shift factors. This guarantees that no 64bit
  * overflow happens when the input value of the conversion is
@@ -131,7 +131,7 @@ EXPORT_SYMBOL_GPL(timecounter_cyc2time);
  * factors.
  */
 void
-clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec)
+clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 maxsec)
 {
 	u64 tmp;
 	u32 sft, sftacc= 32;
@@ -140,7 +140,7 @@ clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec)
 	 * Calculate the shift factor which is limiting the conversion
 	 * range:
 	 */
-	tmp = ((u64)minsec * from) >> 32;
+	tmp = ((u64)maxsec * from) >> 32;
 	while (tmp) {
 		tmp >>=1;
 		sftacc--;
