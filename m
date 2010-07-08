Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab0GHPTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 11:19:05 -0400
Received: from mail.lippert-at.com ([62.80.22.186]:22859 "EHLO
	domex.lippertembedded.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752865Ab0GHPTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 11:19:03 -0400
X-Greylist: delayed 914 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jul 2010 11:19:03 EDT
Message-ID: <4C35E906.6000804@LiPPERTEmbedded.de>
Date: Thu, 08 Jul 2010 17:04:38 +0200
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andres Salomon <dilinger@collabora.co.uk>
CC: Jordan Crouse <jordan@cosmicpenguin.net>, linux-geode@lists.infradead.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] cs5535-mfgpt: reuse timers that have never been set up
References: <4B4C4B86.7090509@LiPPERTEmbedded.de> <20100118103430.6480d1a8@mycelium.queued.net> <4B5D98ED.6090301@LiPPERTEmbedded.de>
In-Reply-To: <4B5D98ED.6090301@LiPPERTEmbedded.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jul 2010 15:04:39.0730 (UTC) FILETIME=[E3548120:01CB1EAE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cs5535-mfgpt: reuse timers that have never been set up

The MFGPT hardware may be set up only once, therefore cs5535_mfgpt_free_timer()
didn't re-set the timer's "avail" bit.  However if a timer is freed before it
has actually been in use then it may be made available again.

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
---

Hi Andres,

Jens wrote:
> Andres wrote:
>> Jens wrote:
>>> cs5535_mfgpt_init() doesn't free up the timer in the error path
>>
>> Yeah, we can't really free the timer, unfortunately.
>> It actually might not be a bad idea to reverse the code so that the
>> IRQ allocation happens first, since we can clean that up if mfgpt
>> allocation fails.
>
> [...] I guess for reversing the order we'd have to split both
> cs5535_mfgpt_alloc_timer() and cs5535_mfgpt_setup_irq() into two parts [...]
> Maybe cs5535_mfgpt_free_timer() can be made more intelligent to set
> mfgpt->avail again if the hardware isn't actually in a non-reversible state
> yet [...]

As you can see I did just that. What do you think?

Cheers,
Jens

--- linux-2.6.35-rc4/drivers/misc/cs5535-mfgpt.c
+++ mfgpt_reuse_timers/drivers/misc/cs5535-mfgpt.c
@@ -211,6 +211,17 @@
  */
 void cs5535_mfgpt_free_timer(struct cs5535_mfgpt_timer *timer)
 {
+	unsigned long flags;
+	uint16_t val;
+
+	/* timer can be made available again only if never set up */
+	val = cs5535_mfgpt_read(timer, MFGPT_REG_SETUP);
+	if (!(val & MFGPT_SETUP_SETUP)) {
+		spin_lock_irqsave(&timer->chip->lock, flags);
+		__set_bit(timer->nr, timer->chip->avail);
+		spin_unlock_irqrestore(&timer->chip->lock, flags);
+	}
+
 	kfree(timer);
 }
 EXPORT_SYMBOL_GPL(cs5535_mfgpt_free_timer);
_

