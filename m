Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab1FOPRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 11:17:42 -0400
Received: from 184-106-247-128.static.cloud-ips.com ([184.106.247.128]:33015
	"EHLO cloud01.chad-versace.us" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753026Ab1FOPRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 11:17:40 -0400
Date: Wed, 15 Jun 2011 08:16:54 -0700
From: Ben Widawsky <ben@bwidawsk.net>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Eric Anholt <eric@anholt.net>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>
Subject: Re: [Intel-gfx] [PATCH 3.0-rc3] i915: Fix gen6 (SNB) GPU stalling
Message-ID: <20110615151654.GA31881@snipes.kumite>
Mail-Followup-To: Daniel J Blueman <daniel.blueman@gmail.com>,
	Eric Anholt <eric@anholt.net>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>
References: <1308070307-2630-1-git-send-email-daniel.blueman@gmail.com>
 <20110615044359.GA27884@snipes.kumite>
 <BANLkTin1fqKMzutfOyLNegOGOuSQu-4jpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin1fqKMzutfOyLNegOGOuSQu-4jpA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 01:04:51PM +0800, Daniel J Blueman wrote:
> On 15 June 2011 12:43, Ben Widawsky <ben@bwidawsk.net> wrote:
> > On Wed, Jun 15, 2011 at 12:51:47AM +0800, Daniel J Blueman wrote:
> >> On 14 June 2011 13:23, Eric Anholt <eric@anholt.net> wrote:
> >> > On Tue, 14 Jun 2011 12:18:36 +0800, Daniel J Blueman <daniel.blueman@gmail.com> wrote:
> >> >> Hi Eric,
> >> >>
> >> >> The frequent ~1.5s pauses I hit with SNB hardware in the gnome3 UI (eg
> >> >> whenever you hit the top-left of the screen to show all windows) are
> >> >> nicely addressed by your recent wake patch [1] (ported to -rc3). Thus
> >> >> I see no 'missed IRQ' kernel messages.
> >> >>
> >> >> As this addresses a significant usability regression, are you happy to
> >> >> add it to the 3.0-rc queue? I think it has very good value in -stable
> >> >> also (assuming correctness). What do you think?
> >> >
> >> > This one had significant performance impacts, and later hacks in this
> >> > series worked around the problem to approximately the same level of
> >> > success with less impact, and we don't actually have a justification of
> >> > why any of them work. ?We were still hoping to come up with some clue,
> >> > and haven't yet.
> >>
> >> True; that is quite heavy handed delay looping.
> >>
> >> It's a pity the usual Intel font didn't make it to the programmer's
> >> reference manuals. Anyway, unmasking the blitter user interrupt in the hardware
> >> status mask register addresses the root cause. Out of reset it's FFFFFFFFh,
> >> so we don't need to read it here.
> >>
> >> It would be good to get this into -rc4. -stable probably needs some additional
> >> tweaks.
> >>
> >> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
> >> ---
> >> ?drivers/gpu/drm/i915/i915_irq.c | ? ?6 ++++++
> >> ?1 files changed, 6 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
> >> index b9fafe3..9a98c1b 100644
> >> --- a/drivers/gpu/drm/i915/i915_irq.c
> >> +++ b/drivers/gpu/drm/i915/i915_irq.c
> >> @@ -1827,6 +1827,12 @@ int ironlake_irq_postinstall(struct drm_device *dev)
> >> ? ? ? ? ? ? ? ironlake_enable_display_irq(dev_priv, DE_PCU_EVENT);
> >> ? ? ? }
> >>
> >> + ? ? if (IS_GEN6(dev))
> >> + ? ? ? ? ? ? /* allow blitter user interrupt to generate a MSI write from
> >> + ? ? ? ? ? ? ? ?the ISR */
> >> + ? ? ? ? ? ? I915_WRITE(GEN6_BLITTER_HWSTAM,
> >> + ? ? ? ? ? ? ? ? ? ? 0xffffffff & ~GEN6_BLITTER_USER_INTERRUPT);
> >> +
> >> ? ? ? return 0;
> >> ?}
> >>
> >
> > I wish the docs said that that this hwstam unmasked MI_USER_INTERRUPTS
> > parsed by the Blitter Command Parser, instead of the Render Command
> > parser.
> >
> > I was just about to write an email about how this is just making the
> > same interrupt happen twice, when I realized that the docs make no
> > sense, and this must be a copy-paste doc bug.
> >
> > This patch sounds good to me. Two small comments:
> > 1. The HWSTAM is touched in preinstall already, why not move this there?
> > 2. I'd prefer you read the register even though as you say it isn't
> > necessary. It just makes the code self-documented by doing it that way.
> 
> The render HWSTAM is tweaked in preinstall, but we need to tweak the
> blitter HWSTAM (new to gen6).
> 
> To me, it makes sense to reset the blitter HWSTAM register to what the
> driver expects, in case anything before the i915 module loads and
> adjusts it for a particular purpose (including debug); the render
> HWSTAM is set this way too. I could add a comment to both perhaps?

Well on that note, the docs clearly state only 1 bit can be unmasked at
a time. Not sure if that applies to masking as well, but if it does,
that would be not good.

I'm fine with a comment. Seeing the current masking doesn't make it
clear to me what is happening/why. Not sure I understand the reason for
saving the read is in this case.

> 
> Updating the blitter HWSTAM in the postinstall was a marginally safer
> choice, as there'll not be any potential race with a blitter user
> interrupt getting emitted before we're ready (which wouldn't have been
> tested), but the risk is probably so low that it could just go into
> the preinstall.
> 
> What do you think?

I think there is no risk since this command could only be executed if
the driver was up. I'd just like all HWSTAM writes in a single place. I
don't have any preference which place.

> 
> Daniel
Ben
