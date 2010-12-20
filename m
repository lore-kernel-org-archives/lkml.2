Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab0LTF3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 00:29:34 -0500
Received: from relais.videotron.ca ([24.201.245.36]:59747 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab0LTF3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 00:29:33 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 20 Dec 2010 00:29:32 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] clarify a usage constraint for cnt32_to_63()
In-reply-to: <AANLkTik8Jd4Q4xVZqTCw=gMP6z_ZLv=nn+zN2tVLfi1M@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1012200017280.10437@xanadu.home>
References: <alpine.LFD.2.00.1012142219240.10437@xanadu.home>
 <AANLkTik8Jd4Q4xVZqTCw=gMP6z_ZLv=nn+zN2tVLfi1M@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cnt32_to_63 algorithm relies on proper counter data evaluation
ordering to work properly. This was missing from the provided
documentation.

Let's augment the documentation with the missing usage constraint and
fix the only instance that got it wrong.

Signed-off-by: Nicolas Pitre <nico@fluxnic.net>
Cc: David Howells <dhowells@redhat.com>
---

On Sun, 19 Dec 2010, Linus Torvalds wrote:

> On Tue, Dec 14, 2010 at 7:44 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> >
> > Let's augment the documentation with the missing usage constraint and
> > fix the only instance that got it wrong.
> 
> Hmm. In the meantime, mn10300 seems to have changed its get_cycles()
> to count up like a normal architecture.
> 
> So I _think_ the nm10300 part of the patch should now look like the
> attached. Untested. I'd like to get an ack from David or at least
> somebody who compiles (and preferably tests) mn10300. And then
> preferably a re-send of the whole patch.

Your call.  I think that the mn10300 change looks trivial enough to be 
"safe".  So here's the whole patch after the mn10300 update.

Alternatively, you could remove the mn10300 part and commit only the 
cnt32_to_63 documentation part as this is what I really care about, and 
then the mn10300 fix could come separately from those people who can 
test it.

diff --git a/arch/mn10300/kernel/time.c b/arch/mn10300/kernel/time.c
index f860a34..75da468 100644
--- a/arch/mn10300/kernel/time.c
+++ b/arch/mn10300/kernel/time.c
@@ -40,21 +40,17 @@ unsigned long long sched_clock(void)
 		unsigned long long ll;
 		unsigned l[2];
 	} tsc64, result;
-	unsigned long tsc, tmp;
+	unsigned long tmp;
 	unsigned product[3]; /* 96-bit intermediate value */
 
 	/* cnt32_to_63() is not safe with preemption */
 	preempt_disable();
 
-	/* read the TSC value
-	 */
-	tsc = get_cycles();
-
-	/* expand to 64-bits.
+	/* expand the tsc to 64-bits.
 	 * - sched_clock() must be called once a minute or better or the
 	 *   following will go horribly wrong - see cnt32_to_63()
 	 */
-	tsc64.ll = cnt32_to_63(tsc) & 0x7fffffffffffffffULL;
+	tsc64.ll = cnt32_to_63(get_cycles()) & 0x7fffffffffffffffULL;
 
 	preempt_enable();
 
diff --git a/include/linux/cnt32_to_63.h b/include/linux/cnt32_to_63.h
index 7605fdd..e3d8bf2 100644
--- a/include/linux/cnt32_to_63.h
+++ b/include/linux/cnt32_to_63.h
@@ -61,13 +61,31 @@ union cnt32_to_63 {
  *
  * 2) this code must not be preempted for a duration longer than the
  *    32-bit counter half period minus the longest period between two
- *    calls to this code.
+ *    calls to this code;
  *
  * Those requirements ensure proper update to the state bit in memory.
  * This is usually not a problem in practice, but if it is then a kernel
  * timer should be scheduled to manage for this code to be executed often
  * enough.
  *
+ * And finally:
+ *
+ * 3) the cnt_lo argument must be seen as a globally incrementing value,
+ *    meaning that it should be a direct reference to the counter data which
+ *    can be evaluated according to a specific ordering within the macro,
+ *    and not the result of a previous evaluation stored in a variable.
+ *
+ * For example, this is wrong:
+ *
+ *	u32 partial = get_hw_count();
+ *	u64 full = cnt32_to_63(partial);
+ *	return full;
+ *
+ * This is fine:
+ *
+ *	u64 full = cnt32_to_63(get_hw_count());
+ *	return full;
+ *
  * Note that the top bit (bit 63) in the returned value should be considered
  * as garbage.  It is not cleared here because callers are likely to use a
  * multiplier on the returned value which can get rid of the top bit
