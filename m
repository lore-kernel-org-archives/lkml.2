Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab1DLVAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 17:00:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49380 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485Ab1DLVAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 17:00:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Ko5vpg1JoOCzrwnOo7CPKvHl2ND/IyYUEhoYydYDPiJzCPnqUMCnloCduOf2LjWi/b
         EjsZ5CTxoRoQmL2OlEYocJgvp2KR19wI+SrwrpzJsQTmecSDiyIah5J40HwB245CJkmh
         ur3bNfzo0OfBRf8pEmtRpmb1mdfNqL8V9cuNQ=
Date: Wed, 13 Apr 2011 00:00:45 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, behlendorf1@llnl.gov, oleg@redhat.com
Subject: [PATCH] remove abs64()
Message-ID: <20110412210045.GA19901@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need no stinking abs64() given some GCC extensions
(especially __builtin_choose_expr()).

One abs() implementation is better than two abs() implementations.

New abs() doesn't expand type needlessly.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/gpu/drm/drm_irq.c |    4 ++--
 include/linux/kernel.h    |   43 +++++++++++++++++++++----------------------
 lib/div64.c               |    2 +-
 3 files changed, 24 insertions(+), 25 deletions(-)

--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -154,7 +154,7 @@ static void vblank_disable_and_save(struct drm_device *dev, int crtc)
 	 * available. In that case we can't account for this and just
 	 * hope for the best.
 	 */
-	if ((vblrc > 0) && (abs64(diff_ns) > 1000000)) {
+	if ((vblrc > 0) && (abs(diff_ns) > 1000000)) {
 		atomic_inc(&dev->_vblank_count[crtc]);
 		smp_mb__after_atomic_inc();
 	}
@@ -1290,7 +1290,7 @@ bool drm_handle_vblank(struct drm_device *dev, int crtc)
 	 * e.g., due to spurious vblank interrupts. We need to
 	 * ignore those for accounting.
 	 */
-	if (abs64(diff_ns) > DRM_REDUNDANT_VBLIRQ_THRESH_NS) {
+	if (abs(diff_ns) > DRM_REDUNDANT_VBLIRQ_THRESH_NS) {
 		/* Store new timestamp in ringbuffer. */
 		vblanktimestamp(dev, crtc, vblcount + 1) = tvblank;
 
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -143,28 +143,27 @@ extern int _cond_resched(void);
 
 #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
 
-/*
- * abs() handles unsigned and signed longs, ints, shorts and chars.  For all
- * input types abs() returns a signed long.
- * abs() should not be used for 64-bit types (s64, u64, long long) - use abs64()
- * for those.
- */
-#define abs(x) ({						\
-		long ret;					\
-		if (sizeof(x) == sizeof(long)) {		\
-			long __x = (x);				\
-			ret = (__x < 0) ? -__x : __x;		\
-		} else {					\
-			int __x = (x);				\
-			ret = (__x < 0) ? -__x : __x;		\
-		}						\
-		ret;						\
-	})
-
-#define abs64(x) ({				\
-		s64 __x = (x);			\
-		(__x < 0) ? -__x : __x;		\
-	})
+#define abs(x)								\
+({									\
+	typeof(x) _x = (x);						\
+									\
+	__builtin_choose_expr(						\
+		__builtin_types_compatible_p(typeof(_x), signed char),	\
+		(unsigned char)({ _x < 0 ? -_x : _x; }),		\
+	__builtin_choose_expr(						\
+		__builtin_types_compatible_p(typeof(_x), short),	\
+		(unsigned short)({ _x < 0 ? -_x : _x; }),		\
+	__builtin_choose_expr(						\
+		__builtin_types_compatible_p(typeof(_x), int),		\
+		(unsigned int)({ _x < 0 ? -_x : _x; }),			\
+	__builtin_choose_expr(						\
+		__builtin_types_compatible_p(typeof(_x), long),		\
+		(unsigned long)({ _x < 0 ? -_x : _x; }),		\
+	__builtin_choose_expr(						\
+		__builtin_types_compatible_p(typeof(_x), long long),	\
+		(unsigned long long)({ _x < 0 ? -_x : _x; }),		\
+	_x)))));							\
+})
 
 #ifdef CONFIG_PROVE_LOCKING
 void might_fault(void);
--- a/lib/div64.c
+++ b/lib/div64.c
@@ -121,7 +121,7 @@ s64 div64_s64(s64 dividend, s64 divisor)
 {
 	s64 quot, t;
 
-	quot = div64_u64(abs64(dividend), abs64(divisor));
+	quot = div64_u64(abs(dividend), abs(divisor));
 	t = (dividend ^ divisor) >> 63;
 
 	return (quot ^ t) - t;
