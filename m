Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab1KWPal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:30:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46077 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582Ab1KWPai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:30:38 -0500
Date: Wed, 23 Nov 2011 16:31:54 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Daniel Vetter <daniel@ffwll.ch>, rajesh.sankaran@intel.com,
        Keith Packard <keithp@keithp.com>, Matthew Garrett <mjg@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: By default, enable RC6 on IVB and SNB when
 reasonable
Message-ID: <20111123153154.GF3864@phenom.ffwll.local>
Mail-Followup-To: David Woodhouse <dwmw2@infradead.org>,
	rajesh.sankaran@intel.com, Keith Packard <keithp@keithp.com>,
	Matthew Garrett <mjg@redhat.com>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <1321684889-18691-1-git-send-email-keithp@keithp.com>
 <20111122201531.GD5547@srcf.ucam.org>
 <861uszfrah.fsf@sumi.keithp.com>
 <20111123102643.GB3864@phenom.ffwll.local>
 <1322056914.15493.158.camel@shinybook.infradead.org>
 <20111123143931.GE3864@phenom.ffwll.local>
 <1322060623.15493.168.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322060623.15493.168.camel@shinybook.infradead.org>
X-Operating-System: Linux phenom 3.1.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 03:03:43PM +0000, David Woodhouse wrote:
> On Wed, 2011-11-23 at 15:39 +0100, Daniel Vetter wrote:
> > At least for the dmar+gfx+semaphores hang I can reproduce, just disabling
> > dmar with intel_iommu=igfx_off is not good enough and iirc the same holds
> > for the dmar+rc6 hangs reported. 
> 
> Um... let me restate that for clarity (and partly for Rajesh's benefit).
> 
> The DMAR associated with the integrated graphics is *disabled*.
> Turned off. Not active. Ever.
> 
> You have a problem when you enable the *other* DMAR units in the system,
> which should not be affecting the graphics device in any way.
> 
> When you do this, you see 'hangs' with semaphores and RC6. Is there a
> better description of these 'hangs' somewhere? Is the hardware
> completely locked?
> 
> These hangs go away when you disable the DMAR units. Again, that is the
> *other* DMAR units in the system that have nothing to do with graphics.
> 
> While I'm getting quite used to DMAR-related errata, this one does make
> me stop and think 'wtf?'. It just seems so incongruous that disabling an
> *unrelated* IOMMU would make the problem go away, and it makes me wonder
> if it's actually a timing-related issue which is always there, but
> something about the use of DMAR for network/disk/etc. makes it more
> likely to trigger?
> 
> We definitely need the hardware folks to get to the bottom of this one.

Ok, let me document the recipe I use to hang my box here. It's about the
dmar+semaphores hang I can reproduce, so might be slightly different in
the actual cause than the dmar+rc6 bug (for that one we only have bug
reports talking about hard freezing requiring power cycling).

- Grab a GT2+ mobile snb (both my and the only other reporters machine
  fits this, so maybe it matters). pci rev 09 (i.e. first production
  silicon).
- Install fc15 with the kde4 spin. I can't reproduce it with any other
  userspace than kde4.
- Grab latest d-i-f from Keith and latest userspace graphics code (to
  avoid hitting any other snb hangs we've tracked down meanwhile).
- Compile kernel with dmar and enable VT-d in the bios.
- Login into the systems with gdm, the machine usually dies within a few
  seconds (while kde4 loads). If that's not good enough, a few minutes of
  light desktop usage will kill it.
- Wait 2 minutes for the stuck-in-atomic detection logic to kick in and
  grab the backtrace over netconsole. Notice that the kernel is stuck
  trying to flush the dmar tlb cache (that's how I managed to track it
  down to a dmar interaction). Backtrace almost identical to the dmar
  issue on ilk. I've lost the backtrace, if you want I can regrab it.

Things I've tried that don't work around the issue:
- Disable dmar for the igfx with intel_iommu=igfx_off
- Apply the ilk workaround (i.e. synchronous dmar tlb flushes + gpu idling
  while flushing).

Things that work:
- Disabling semaphores.
- Disabling dmar in either the bios or on the cmdline with intel_iommu=off

All reporters that tried confirmed that igfx_off is not good enough, only
fully disabling dmar (for both the semaphores and the rc6 related hangs).

Things that look interesting:
- ppgtt support (i.e. using per-proces pagetables on the gfx instead of
  the global gtt) seems to paper over the issue for the original reporter
  of the semaphore related hangs.  Unfortunately not for me, gpu still
  hangs (but doesn't take down the entire system with it). I've not yet
  investigated this one closely. Fyi, the windows driver uses ppgtt
  unconditionally on snb. Also, ppgtt seems to have no effect for at least
  one report of dmar related rc6 hangs.

Cheers, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
