Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab2GASVw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:21:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47006 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756012Ab2GASQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:42 -0400
Message-Id: <20120701172011.796151020@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:42 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [ 36/48] drm/i915: rip out the PM_IIR WARN
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 58bf8062d0b293b8e1028e5b0342082002886bd4 upstream.

After banging my head against this for the past few months, I still
don't see how this could possible race under the premise that once an
irq bit is masked in PM_IMR and reset in PM_IIR it won't show up again
until we unmask it in PM_IMR.

Still, we have reports of this being seen in the wild. Now Bspec has
this little bit of lovely language in the PMIIR register:

Public SNB Docs, Vol3Part2, 2.5.14 "PMIIR":

"For each bit, the IIR can store a second pending interrupt if two or
more of the same interrupt conditions occur before the first condition
is cleared. Upon clearing the interrupt, the IIR bit will momentarily
go low, then return high to indicate there is another interrupt
pending."

Now if we presume that PMIMR only prevent new interrupts from being
queued, we could easily end up masking an interrupt and clearing it,
but the 2nd pending interrupt setting the bit in PMIIR right away
again. Which leads, the next time the irq handler runs, to hitting the
WARN.

Also, no bad side effects of this have ever been reported. And we've
tracked down our issues with the gpu turbo getting stuck to bogus
interrupt generation limits in th RPLIMIT register.

So let's just rip out this WARN as bogus and call it a day. The only
shallow thing here is that this 2-deep irq queue in the hw makes you
wonder how racy the windows irq handler is ...

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=42907
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_irq.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index b1fe0ed..ed3224c 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -412,7 +412,6 @@ static void gen6_queue_rps_work(struct drm_i915_private *dev_priv,
 	 */
 
 	spin_lock_irqsave(&dev_priv->rps_lock, flags);
-	WARN(dev_priv->pm_iir & pm_iir, "Missed a PM interrupt\n");
 	dev_priv->pm_iir |= pm_iir;
 	I915_WRITE(GEN6_PMIMR, dev_priv->pm_iir);
 	POSTING_READ(GEN6_PMIMR);


