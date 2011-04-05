Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab1DEPdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:33:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:14810 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab1DEPdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:33:17 -0400
Message-Id: <b9dded$iivmhh@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,304,1299484800"; 
   d="scan'208";a="623893069"
Date: Tue, 05 Apr 2011 16:32:54 +0100
To: Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] drm/i915: Disable all outputs early, before KMS takeover
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        keith.packard@intel.com, danie.vettel@ffwll.ch
References: <BANLkTins76X1mOFepqXEQjMEh_hd4Vgw1Q@mail.gmail.com> <1302014055-13708-1-git-send-email-chris@chris-wilson.co.uk> <BANLkTinvN_M8FXWc5p8Hy=Z_hSxvHSne4g@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <BANLkTinvN_M8FXWc5p8Hy=Z_hSxvHSne4g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011 18:11:37 +0300, Pekka Enberg <penberg@kernel.org> wrote:
> Hi Chris,
> 
> On Tue, Apr 5, 2011 at 5:34 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > If the outputs are active and continuing to access the GATT when we
> > teardown the PTEs, then there is a potential for us to hang the GPU.
> > The hang tends to be a PGTBL_ER with either an invalid host access or
> > an invalid display plane fetch.
> >
> > v2: Reorder IRQ initialisation to defer until after GEM is setup.
> >
> > Reported-by: Pekka Enberg <penberg@kernel.org>
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Tested-by: Daniel Vetter <daniel.vetter@ffwll.ch> (855GM)
> 
> I no longer get a blank screen after boot but flicker got more
> aggressive during boot (it calms down after I've logged in). I see
> tons of these in dmesg that don't appear with 2.6.39-rc1:

Well the PGTBL_ER is still there. I'm thinking it might worth a check to
see if that is asserted even before we start...

> [   10.175843] [drm:intel_update_fbc],
> [   10.183100] [drm:i915_driver_irq_handler], pipe A underrun
> [   10.185085] [drm:i915_driver_irq_handler], pipe A underrun
> [   10.186082] [drm:i915_driver_irq_handler], pipe A underrun
> [   10.187087] [drm:i915_driver_irq_handler], pipe A underrun
> [   10.189082] [drm:i915_driver_irq_handler], pipe A underrun
> [   10.190085] [drm:i915_driver_irq_handler], pipe A underrun

If I'm understanding the dmesg correctly, then these start even before we
setup the first crtc.

Whether that means we're not completely disabling all outputs or that we
set a register incorrectly I don't know. Comparing an intel_reg_dumper
with and without the patch applied might give a clue if it is a register
that is set differently due to the reordering.

The other question is of course whether you see those in 2.6.39-rc1 as
well... Probably not since they will correspond with the increased
flicker.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
