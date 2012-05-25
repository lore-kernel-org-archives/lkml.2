Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab2EYL6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 07:58:43 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55712 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2EYL6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 07:58:41 -0400
Date: Fri, 25 May 2012 14:00:00 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [pull] drm-intel-fixes for 3.5
Message-ID: <20120525120000.GE4726@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20120524155624.GD5078@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524155624.GD5078@phenom.ffwll.local>
X-Operating-System: Linux phenom 3.4.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 05:56:24PM +0200, Daniel Vetter wrote:
> Hi Dave,
> 
> A set of fixes for 3.5:
> - Fixes for regressions in 3.5: fix spurious gmbus NAK, fix module unload,
>   fix pch pll asserts.
> - Fix up eDP panel power sequencing - turns out we need to keep vdd on
>   while switching everything off.
> - Reject doubleclocked modes on dp.
> - Fixup sdvo interlaced handling. It never worked, but the missing bits
>   are just a tiny patch.
> - Re-add some accidentally killed tv modes, also re-add
>   a vblank wait in the tv detect code that we've lost somewhere around
>   2.6.36.
> - Preliminary ducttape for gpu turbo on snb+ - we're working the hw guys
>   to figure out what's missing, because this code /should/ be the same the
>   windows driver does. But that usually takes a while ...
> - Fixup turbo for media workloads on snb+.
> - And a no-lvds quirk.

As dicussed on irc I've smashed 3 more patches onto this:
- Shut up the noisy rps turbo message.
- Don't complain about unbinding pinned buffers any more - we now use that
  check intentionally.
- Limit broadwater/crestline (i.e. vintage i965g/gm) to DMA32 for shmfs.
  Note that this requires, like gma500 the improved shmfs code to make it
  really tight. But otoh the only a few indirect states can't be above 4G,
  so this should be sufficient in all but the most contrived cases.

Yours, Daniel


The following changes since commit f15b4ca2ccbc0a4661c35a744d254e1e32dd1e15:

  Merge tag 'drm-intel-next-2012-05-20' of git://people.freedesktop.org/~danvet/drm-intel into drm-core-next (2012-05-21 08:17:42 +0100)

are available in the git repository at:


  git://people.freedesktop.org/~danvet/drm-intel drm-intel-fixes

for you to fetch changes up to ef12dab779acdb907eb4c3fa723e1c6f035ee13c:

  drm/i915: tune down the noise of the RP irq limit fail (2012-05-25 10:29:15 +0200)

----------------------------------------------------------------
Chris Wilson (4):
      drm/i915: Always update RPS interrupts thresholds along with frequency
      drm/i915: Fix PCH PLL assertions to not assume CRTC:PLL relationship
      drm/i915: Limit page allocations to lowmem (dma32) for i965
      drm/i915: Remove the error message for unbinding pinned buffers

Daniel Vetter (7):
      drm/i915: be more careful when returning -ENXIO in gmbus transfer
      drm/i915: fix module unload since error_state rework
      drm/i915: properly handle interlaced bit for sdvo dtd conversion
      drm/i915: enable vdd when switching off the eDP panel
      drm/i915: wait for a vblank to pass after tv detect
      drm/i915: reject doubleclocked cea modes on dp
      drm/i915: tune down the noise of the RP irq limit fail

Jan-Benedict Glaw (1):
      drm/i915: no lvds quirk for HP t5740e Thin Client

Jesse Barnes (1):
      drm/i915: always use RPNSWREQ for turbo change requests

Rodrigo Vivi (1):
      drm/i915: Adding TV Out Missing modes.

 drivers/gpu/drm/i915/i915_debugfs.c    |    2 +
 drivers/gpu/drm/i915/i915_gem.c        |   16 +++++---
 drivers/gpu/drm/i915/i915_irq.c        |   37 ++++--------------
 drivers/gpu/drm/i915/intel_display.c   |   56 ++++++++++++++++------------
 drivers/gpu/drm/i915/intel_dp.c        |   24 +++++++-----
 drivers/gpu/drm/i915/intel_i2c.c       |   21 ++++++-----
 drivers/gpu/drm/i915/intel_lvds.c      |    8 ++++
 drivers/gpu/drm/i915/intel_pm.c        |   64 ++++++++++++++++++++++----------
 drivers/gpu/drm/i915/intel_sdvo.c      |   12 ++++--
 drivers/gpu/drm/i915/intel_sdvo_regs.h |    5 +++
 drivers/gpu/drm/i915/intel_tv.c        |   53 ++++++++++++++++++++++++++
 11 files changed, 197 insertions(+), 101 deletions(-)
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
