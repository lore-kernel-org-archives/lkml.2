Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab2AEPWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:22:12 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:50421 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab2AEPWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:22:10 -0500
Date: Thu, 5 Jan 2012 16:24:08 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: "Airlie, Dave" <airlied@linux.ie>,
        Intel drivers <Intel-gfx@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PULL] drm-intel-next
Message-ID: <20120105152408.GD3831@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	"Airlie, Dave" <airlied@linux.ie>,
	Intel drivers <Intel-gfx@lists.freedesktop.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <86y5tmkeia.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86y5tmkeia.fsf@sumi.keithp.com>
X-Operating-System: Linux phenom 3.2.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 07:35:41PM -0800, Keith Packard wrote:
> 
> Here are the rest of the 3.3 pending changes.
> 
> This has a bunch of small bug fixes and overlay plane support for i915.
> 
> The following changes since commit 7a7e8734ac3235efafd34819b27fbdf5417e6d60:
> 
>   Merge branch 'drm-radeon-testing' of ../drm-radeon-next into drm-core-next (2012-01-03 09:45:12 +0000)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/keithp/linux drm-intel-next

I'm not happy with Eric's missed IRQ workaround because
- it's incomplete, the BSD ring is similarly affected by these issues like
  the blitter ring, but not handled by his patches.
- it does a busy-loop wait until the gpu signals completion - in normal
  useage this can easily be a few msecs, especially since now semaphores
  are enabled by defailt on Ivybridge. With offscreen benchmarking it can
  easily reach seconds. This is imo unacceptable.

Furthermore
- Chris Wilson proposed an alternative approach quite a bit before these
  patches have been created that combines the irq signalling path with a
  short timer as a backup. This works really well because we only rarely
  miss irqs. See
  Message-Id: <1323978198-3501-1-git-send-email-chris@chris-wilson.co.uk>
- Meanwhile I've discovered a magic set of tricks that seem to completely
  solve missed irq issues on both ivb and snb. This would render all this
  ducttape irrelevant.

Imo the minimal right thing to do is to revert the patch "drm/i915: Make
the fallback IRQ wait not sleep". This will regress piglit throughput (and
anything else stupid enough to crazily ping-pong between the gpu and cpu)
quite a bit, but honestly that's not something our userbase cares about.

I'd also like to express my frustration with the general -next process for
drm/i915:
- This drm-intel-next tree is less than 24h ours old (if you look at when
  it showed up at an official place where both our QA and the community
  can pick it up and test it). I fear we'll ship yet another disaster like
  the stack eating bug the vt-d/ilk w/a patch caused with an unbounded
  recursion. Our QA actually caught it in testing, but there was simply
  not enough time to fix things up before the buggy code landed in -linus.
- Because the drm-intel-next merge cycle started so late there has simply
  not been enough time to include quite a few bugfixes for serious issues
  like 20s delays in intial modeset, userspace-triggerable kernel OOPSes
  and deadlocks and reproducible hard hw hangs. For most of these there
  are testcases in intel-gpu-tools, and these issues span the entire set
  of hw generations drm/i915 currently supports. But this late it's imo
  no longer advisible to merge them, so we'll ship 3.3 with a bunch of
  known (and sometimes longstanding) serious issues that have fixes.

Yours, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
