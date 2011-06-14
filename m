Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab1FNQwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 12:52:12 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62588 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1FNQwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 12:52:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Kds+YzBpv0fWx1iENogoUFzrJOhLuC1oeqYtTmXGTCZ0k9Wzx1NECzWvmszRu6BatD
         KuoMtuzfg9zQGUKQSOQSVJkZbIpotyGiQk9TMQR2SF/lfW+CkmD7E6kta4Re5+mgB6Id
         2OeF9hmY6SFZuCmsbubuT73ZoiVNvE5EeYecQ=
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Eric Anholt <eric@anholt.net>
Cc: Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [PATCH 3.0-rc3] i915: Fix gen6 (SNB) GPU stalling
Date: Wed, 15 Jun 2011 00:51:47 +0800
Message-Id: <1308070307-2630-1-git-send-email-daniel.blueman@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 June 2011 13:23, Eric Anholt <eric@anholt.net> wrote:
> On Tue, 14 Jun 2011 12:18:36 +0800, Daniel J Blueman <daniel.blueman@gmail.com> wrote:
>> Hi Eric,
>>
>> The frequent ~1.5s pauses I hit with SNB hardware in the gnome3 UI (eg
>> whenever you hit the top-left of the screen to show all windows) are
>> nicely addressed by your recent wake patch [1] (ported to -rc3). Thus
>> I see no 'missed IRQ' kernel messages.
>>
>> As this addresses a significant usability regression, are you happy to
>> add it to the 3.0-rc queue? I think it has very good value in -stable
>> also (assuming correctness). What do you think?
>
> This one had significant performance impacts, and later hacks in this
> series worked around the problem to approximately the same level of
> success with less impact, and we don't actually have a justification of
> why any of them work.  We were still hoping to come up with some clue,
> and haven't yet.

True; that is quite heavy handed delay looping.

It's a pity the usual Intel font didn't make it to the programmer's
reference manuals. Anyway, unmasking the blitter user interrupt in the hardware
status mask register addresses the root cause. Out of reset it's FFFFFFFFh,
so we don't need to read it here.

It would be good to get this into -rc4. -stable probably needs some additional
tweaks.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
---
 drivers/gpu/drm/i915/i915_irq.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index b9fafe3..9a98c1b 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -1827,6 +1827,12 @@ int ironlake_irq_postinstall(struct drm_device *dev)
 		ironlake_enable_display_irq(dev_priv, DE_PCU_EVENT);
 	}
 
+	if (IS_GEN6(dev))
+		/* allow blitter user interrupt to generate a MSI write from
+		   the ISR */
+		I915_WRITE(GEN6_BLITTER_HWSTAM,
+			0xffffffff & ~GEN6_BLITTER_USER_INTERRUPT);
+
 	return 0;
 }
 
-- 
1.7.4.1

