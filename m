Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab1FPDp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 23:45:28 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46602 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab1FPDp1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 23:45:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dqgqcLC66sIyyqf1Bj4ObZgWgp1P4tlgKr/0vqLYXq0z+9ww7HAGOTmLXJMMhmdcZU
         IJ2I1WZnnHKOzzx6i4exGcS6tLjEhm9IGYPphs2qWaz4b3SPo/7/Wmrr8lqWg9V40dia
         /Rrf9j96zloYS8xBAdwm26YsOaCppR3TG4C3Q=
MIME-Version: 1.0
In-Reply-To: <87sjrbkq2h.fsf@eliezer.anholt.net>
References: <1308070307-2630-1-git-send-email-daniel.blueman@gmail.com>
	<20110615044359.GA27884@snipes.kumite>
	<BANLkTin1fqKMzutfOyLNegOGOuSQu-4jpA@mail.gmail.com>
	<87sjrbkq2h.fsf@eliezer.anholt.net>
Date: Thu, 16 Jun 2011 11:45:26 +0800
Message-ID: <BANLkTin_DqRJNXdVO3FTs6c59oKaAyV1zw@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 3.0-rc3] i915: Fix gen6 (SNB) GPU stalling
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Eric Anholt <eric@anholt.net>
Cc: Ben Widawsky <ben@bwidawsk.net>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 June 2011 00:38, Eric Anholt <eric@anholt.net> wrote:
> On Wed, 15 Jun 2011 13:04:51 +0800, Daniel J Blueman <daniel.blueman@gmail.com> wrote:
>> The render HWSTAM is tweaked in preinstall, but we need to tweak the
>> blitter HWSTAM (new to gen6).
>
> This still doesn't *really* make sense -- HWSTAM is supposed to be
> masking updates to the status page's copy of the IIR, which we never
> read, and not be involved in masking updates to the MMIO I[IS]R.  So it
> seems to me that this is just happening to get lucky and serialize in
> the hardware for the way that we do actually read IIR (through MMIO).
> And hey, we should be using the status page copy instead of MMIO some
> day anyway, so that's more reason to do this patch even if we don't like
> workarounds.

I see we're checking only the MMIO IIR in the interrupt handler.
Perhaps we should come up with a way to prove that we're not
immediately seeing the correct state in the MMIO IIR when the
interrupt handler is fired without the unmasking. We could also check
if we get only one interrupt bit set (ie the interrupt occurred for
what we wanted and not something else) when we issue a
MI_USER_INTERRUPT to the blitter ring, to see if there is some
unexpected behaviour on gen6.

What do you think?

Also, perhaps I add a comment into the patch to show it's a workaround, right?

>> To me, it makes sense to reset the blitter HWSTAM register to what the
>> driver expects, in case anything before the i915 module loads and
>> adjusts it for a particular purpose (including debug); the render
>> HWSTAM is set this way too. I could add a comment to both perhaps?
>>
>> Updating the blitter HWSTAM in the postinstall was a marginally safer
>> choice, as there'll not be any potential race with a blitter user
>> interrupt getting emitted before we're ready (which wouldn't have been
>> tested), but the risk is probably so low that it could just go into
>> the preinstall.
>
> The GPU is idle before our driver shows up, so there's no risk (there's
> a bunch of leftover paranoia in the driver from the DRI1 days, none of
> which ever made much sense).
-- 
Daniel J Blueman
