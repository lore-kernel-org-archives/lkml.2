Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812Ab2INPnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 11:43:06 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64889 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859Ab2INPnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 11:43:02 -0400
Date: Fri, 14 Sep 2012 17:43:30 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Bobby Powers <bobbypowers@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, daniel@ffwll.ch
Subject: Re: [Intel-gfx] [pull] drm-intel-next
Message-ID: <20120914154330.GA5799@phenom.ffwll.local>
Mail-Followup-To: Bobby Powers <bobbypowers@gmail.com>,
	Dave Airlie <airlied@gmail.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20120913141841.GC5693@phenom.ffwll.local>
 <CAArOQ2UahPkBw9dxX7YQqGzDz6r0QgigjtEVoDTF6pS4=KQ-4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAArOQ2UahPkBw9dxX7YQqGzDz6r0QgigjtEVoDTF6pS4=KQ-4w@mail.gmail.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 09:55:58AM -0400, Bobby Powers wrote:
> This tree gives me recursive dependency problems, which ends up
> removing a big (& important) part of my .config:
> 
> [bpowers@fina linux]$ git reset --hard drm-intel-next-2012-09-09
> HEAD is now at e04190e drm/fb helper: don't call
> drm_helper_connector_dpms directly
> [bpowers@fina linux]$ git status
> # On branch master
> # Your branch and 'origin/master' have diverged,
> # and have 207 and 323 different commits each, respectively.
> #
> nothing to commit (working directory clean)
> [bpowers@fina linux]$ make oldconfig
> scripts/kconfig/conf --oldconfig Kconfig
> drivers/gpu/drm/udl/Kconfig:1:error: recursive dependency detected!
> drivers/gpu/drm/udl/Kconfig:1:	symbol DRM_UDL depends on USB_ARCH_HAS_HCD
> drivers/usb/Kconfig:76:	symbol USB_ARCH_HAS_HCD depends on USB_SUPPORT
> drivers/usb/Kconfig:58:	symbol USB_SUPPORT is selected by DRM_USB
> drivers/gpu/drm/Kconfig:22:	symbol DRM_USB is selected by DRM_UDL
> #
> # configuration written to .config
> #

That's an issue with Dave Airlie's udl code I'd say - the drm-intel-next
tree here simply includes a few drm-next patches already. Dave?
-Daniel

> 
> 
> I've attached my config & the diff between what is attached and the
> result of make oldconfig.  Let me know if there is any other info that
> would help, or if I'm just doing something boneheaded.  Thanks!
> 
> yours,
> Bobby
> 
> On Thu, Sep 13, 2012 at 10:18 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> > Hi Dave,
> >
> > The big ticket item here is the new i915 modeset infrastructure.
> > Shockingly it didn't not blow up all over the place (i.e. I've managed to
> > fix the ugly issues before merging). 1-2 smaller corner cases broke, but
> > we have patches. Also, there's tons of patches on top of this that clean
> > out cruft and fix a few bugs that couldn't be fixed with the crtc helper
> > based stuff. So more stuff to come ;-)
> >
> > Also a few other things:
> > - Tiny fix in the fb helper to go through the official dpms interface
> >   instead of calling the crtc helper code.
> > - forcewake code frobbery from Ben, code should be more in-line with
> >   what Windows does now.
> > - fixes for the render ring flush on hsw (Paulo)
> > - gpu frequency tracepoint
> > - vlv forcewake changes to better align it with our understanding of the
> >   forcewake magic.
> > - a few smaller cleanups
> >
> > Cheers, Daniel
> >
> >
> > The following changes since commit d7c3b937bdf45f0b844400b7bf6fd3ed50bac604:
> >
> >   drm/i915: Remove __GFP_NO_KSWAPD (2012-08-27 17:11:38 +0200)
> >
> > are available in the git repository at:
> >
> >   git://people.freedesktop.org/~danvet/drm-intel tags/drm-intel-next-2012-09-09
> >
> > for you to fetch changes up to e04190e0ecb236c51af181c18c545ea076fb9cca:
> >
> >   drm/fb helper: don't call drm_helper_connector_dpms directly (2012-09-08 00:51:15 +0200)
> >
> > ----------------------------------------------------------------
> >
> > Ben Widawsky (5):
> >       drm/i915: Extract forcewake ack timeout
> >       drm/i915: use cpu_relax() in wait_for_atomic
> >       drm/i915: Change forcewake timeout to 2ms
> >       drm/i915: Never read FORCEWAKE
> >       drm/i915: Enable some sysfs stuff without CONFIG_PM
> >
> > Chris Wilson (1):
> >       drm/i915: Convert remaining debugfs iterators over rings to for_each_ring()
> >
> > Daniel Vetter (66):
> >       drm/ips: move drps/ips/ilk related variables into dev_priv->ips
> >       drm/i915: add a tracepoint for gpu frequency changes
> >       drm/i915: align vlv forcewake with common lore
> >       drm/i915: differ error message between forcwake timeouts
> >       drm/i915: add crtc->enable/disable vfuncs insted of dpms
> >       drm/i915: rip out crtc prepare/commit indirection
> >       drm/i915: add direct encoder disable/enable infrastructure
> >       drm/i915/hdmi: convert to encoder->disable/enable
> >       drm/i915/tv: convert to encoder enable/disable
> >       drm/i915/lvds: convert to encoder disable/enable
> >       drm/i915/dp: convert to encoder disable/enable
> >       drm/i915/crt: convert to encoder disable/enable
> >       drm/i915/sdvo: convert to encoder disable/enable
> >       drm/i915/dvo: convert to encoder disable/enable
> >       drm/i915: convert dpms functions of dvo/sdvo/crt
> >       drm/i915: rip out encoder->disable/enable checks
> >       drm/i915: clean up encoder_prepare/commit
> >       drm/i915: copy&paste drm_crtc_helper_set_config
> >       drm/i915: call set_base directly
> >       drm/i915: inline intel_best_encoder
> >       drm/i915: copy&paste drm_crtc_helper_set_mode
> >       drm/i915: simplify intel_crtc_prepare_encoders
> >       drm/i915: rip out encoder->prepare/commit
> >       drm/i915: call crtc functions directly
> >       drm/i915: WARN when trying to enabled an unused crtc
> >       drm/i915: Add interfaces to read out encoder/connector hw state
> >       drm/i915/dp: implement get_hw_state
> >       drm/i915/hdmi: implement get_hw_state
> >       drm/i915/tv: implement get_hw_state
> >       drm/i915/lvds: implement get_hw_state
> >       drm/i915/crt: implement get_hw_state
> >       drm/i915/sdvo: implement get_hw_state
> >       drm/i915/dvo: implement get_hw_state
> >       drm/i915: read out the modeset hw state at load and resume time
> >       drm/i915: check connector hw/sw state
> >       drm/i915: rip out intel_crtc->dpms_mode
> >       drm/i915: rip out intel_dp->dpms_mode
> >       drm/i915: ensure the force pipe A quirk is actually followed
> >       drm/i915: introduce struct intel_set_config
> >       drm/i915: extract modeset config save/restore code
> >       drm/i915: extract intel_set_config_compute_mode_changes
> >       drm/i915: extract intel_set_config_update_output_state
> >       drm/i915: implement crtc helper semantics relied upon by the fb helper
> >       drm/i915: don't update the fb base if there is no fb
> >       drm/i915: convert pointless error checks in set_config to BUGs
> >       drm/i915: don't save all the encoder/crtc state in set_config
> >       drm/i915: stage modeset output changes
> >       drm/i915: push crtc->fb update into pipe_set_base
> >       drm/i915: remove crtc disabling special case
> >       drm/i915: move output commit and crtc disabling into set_mode
> >       drm/i915: extract adjusted mode computation
> >       drm/i915: use staged outuput config in tv->mode_fixup
> >       drm/i915: use staged outuput config in lvds->mode_fixup
> >       drm/i915: compute masks of crtcs affected in set_mode
> >       drm/i915: implement new set_mode code flow
> >       drm/i915: push commit_output_state past crtc disabling
> >       drm/i915: s/intel_encoder_disable/intel_encoder_noop
> >       drm/i915: WARN if the pipe won't turn off
> >       drm/i915: switch the load detect code to the staged modeset config
> >       drm/i915: push commit_output_state past the crtc/encoder preparing
> >       drm/i915: disable all crtcs at suspend time
> >       drm/i915: no longer call drm_helper_resume_force_mode
> >       drm/i915: add tons of modeset state checks
> >       drm/i915: improve modeset state checking after dpms calls
> >       Merge the modeset-rework, basic conversion into drm-intel-next
> >       drm/fb helper: don't call drm_helper_connector_dpms directly
> >
> > Jani Nikula (2):
> >       drm/i915: only enable sdvo hotplug irq if needed
> >       drm/i915: fix sdvo hotplug support check and activation
> >
> > Paulo Zanoni (3):
> >       drm/i915: add gen7_render_ring_flush
> >       drm/i915: add workarounds directly to gen6_render_ring_flush
> >       drm/i915: add workarounds to gen7_render_ring_flush
> >
> > --
> > Daniel Vetter
> > Software Engineer, Intel Corporation
> > +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> > _______________________________________________
> > Intel-gfx mailing list
> > Intel-gfx@lists.freedesktop.org
> > http://lists.freedesktop.org/mailman/listinfo/intel-gfx




-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
