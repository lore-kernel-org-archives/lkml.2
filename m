Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab1A1WAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 17:00:22 -0500
Received: from smtp-out.google.com ([216.239.44.51]:47814 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab1A1WAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 17:00:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Rp71YXaQxG/kbaMBG08EJHC6tM7ahC7LwgbN3CuxrfeIxf883A3iFS667pLeKyRbL1
         hM0SHLSL8//fnF4O7BzA==
Date: Fri, 28 Jan 2011 14:00:07 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Chris Wilson <chris@chris-wilson.co.uk>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Arnd Bergmann <arnd@arndb.de>,
        Jiri Olsa <jolsa@redhat.com>, Chris Clayton <chris2553@googlemail.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
Subject: Re: [PATCH] drm/i915,agp/intel: Do not clear stolen entries
In-Reply-To: <849307$b9dvii@azsmga001.ch.intel.com>
Message-ID: <alpine.LSU.2.00.1101281347200.1759@sister.anvils>
References: <20110123011221.GB1805@nowhere> <1295780472-8475-1-git-send-email-chris@chris-wilson.co.uk> <20110123175945.GA1760@nowhere> <alpine.LSU.2.00.1101232246380.3691@sister.anvils> <849307$b9dvii@azsmga001.ch.intel.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, this is now abount vblank or scanout rather than stolen entries.

On Mon, 24 Jan 2011, Chris Wilson wrote:
> On Sun, 23 Jan 2011 23:40:41 -0800 (PST), Hugh Dickins <hughd@google.com> wrote:
> 
> > On this laptop I'm typing from (GM965 with KMS), I've had no trouble
> > getting X up; but when typing in one of the xterms, typed characters
> > often stop echoing, until I shift to a different window, whereupon
> > they appear.  This condition cleared (for a while) by switching to
> > VESA fb console and back; no such problem observed on that console.
> > 
> > Does that sound familiar?  I have no evidence whatever that i915 is
> > to blame here.  Several times I tried bisecting last week, but each
> > attempt ended up in a nonsensical place, because the effect does not
> > occur to order.  So I'd sometimes mark a bisection point as good when
> > I guess it must actually have been bad.  Perhaps it's a matter of
> > timing or an uninitialized variable.  But while I'm here, worth asking
> > if that behaviour sounds like anything you might be responsible for?
> 
> Sounds suspiciously like the batch buffer is not being dispatched and
> flushed to the scanout. A very similar bug was recently fixed for
> xf86-video-intel 2.14.0 which was causing deferred output. 

I made a more patient bisection during the week, on x86_64 which
seemed more consistent than i386, and this time it converged sensibly:
to commit 0af7e4dff50454905092d468e91c1ef92e10e6b4
drm/i915: Add support for precise vblank timestamping (v2)

Which kindly notes in its commit message:
    This code has been only tested on a HP-Mini Netbook with
    Atom processor and Intel 945GME gpu. The codepath for
    (IS_G4X(dev) || IS_GEN5(dev) || IS_GEN6(dev)) gpu's
    has not been tested so far due to lack of hardware.
so not surprising that it doesn't work on GM965.

I'm now running with this silly revert:

--- a/drivers/gpu/drm/i915/i915_drv.c	2011-01-18 22:04:29.000000000 -0800
+++ b/drivers/gpu/drm/i915/i915_drv.c	2011-01-24 19:35:51.000000000 -0800
@@ -674,8 +674,8 @@ static struct drm_driver driver = {
 	.device_is_agp = i915_driver_device_is_agp,
 	.enable_vblank = i915_enable_vblank,
 	.disable_vblank = i915_disable_vblank,
-	.get_vblank_timestamp = i915_get_vblank_timestamp,
-	.get_scanout_position = i915_get_crtc_scanoutpos,
+	.get_vblank_timestamp = NULL /* i915_get_vblank_timestamp */,
+	.get_scanout_position = NULL /* i915_get_crtc_scanoutpos */,
 	.irq_preinstall = i915_driver_irq_preinstall,
 	.irq_postinstall = i915_driver_irq_postinstall,
 	.irq_uninstall = i915_driver_irq_uninstall,

which makes 2.6.38-rc usable; though I do believe that I've seen
the same issue (unflushed text) occur a couple of times since, much
too rare to bisect or get upset by, but indicative of some remaining bug.

Hugh
