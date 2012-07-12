Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162360Ab2GLWp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:45:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162323Ab2GLWps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:45:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 176/187] drm/i915: rip out the PM_IIR WARN
Date: Thu, 12 Jul 2012 15:35:32 -0700
Message-Id: <20120712191539.608543998@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_irq.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -440,7 +440,6 @@ static void gen6_queue_rps_work(struct d
 	 */
 
 	spin_lock_irqsave(&dev_priv->rps_lock, flags);
-	WARN(dev_priv->pm_iir & pm_iir, "Missed a PM interrupt\n");
 	dev_priv->pm_iir |= pm_iir;
 	I915_WRITE(GEN6_PMIMR, dev_priv->pm_iir);
 	POSTING_READ(GEN6_PMIMR);


