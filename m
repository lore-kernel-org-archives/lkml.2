Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab2BWRXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:23:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:42308 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab2BWRXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:23:01 -0500
Message-Id: <aefc95$3a3h8b@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="111265035"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: responsiveness: newer kernels causing lagging and blocking
To: stephan.baerwolf@tu-ilmenau.de, linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Buesch <mb@bu3sch.de>, Alex Deucher <alexdeucher@gmail.com>,
        Dave Airlie <airlied@redhat.com>
In-Reply-To: <4F4669B1.4020306@tu-ilmenau.de>
References: <4F4669B1.4020306@tu-ilmenau.de>
Date: Thu, 23 Feb 2012 17:21:16 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Feb 2012 17:30:41 +0100, Stephan Bärwolf <stephan.baerwolf@tu-ilmenau.de> wrote:
> Under various conditions linux since 2.6.39-rc1 laggs and blocks enormously the whole system.
> (For example while starting "winecfg" (on a thinkpad X220) and parallel moving the
> mousecursor you can observe a periodic blocking for some seconds)
> 
> After bisecting a little while, commit "4819d2e4310796c4e9eef674499af9b9caf36b5a"
> (" drm: Retry i2c transfer of EDID block after failure ") seems to be responsible.
> 
> Because function "drm_do_probe_ddc_edid" loops trying "i2c_transfer" it consumes a lot
> of time during errors. Reverting or changing "retries" from 5 to 1 extremly minimizes the
> problem to "not perceptible".
> It seems the locking within "i2c_transfer" slows everything down.
> So maybe it is possible to yield() before calling it?

As you can tell the issue is that we repeatedly attempt to do an
expensive retrieval of the EDID across a bit-banging i2c bus and keep
doing so in spite of failure. Intel is especially obnoxious in this
regard as we attempt to probe every connector described by the VBT, and
every non-existent connector results in a busy-spin until the query
times out. There are at least two ways we can mitigate this, the first
is to use GMBUS which is not as processor intensive as GPIO and can
detect the non-existent controller much quicker. The GMBUS
implementation needs some refinement to be a proper i2c citizen before
we can enable it again. The second is to break the loop for fatal errors,
which is addressed by

commit 9292f37e1f5c79400254dca46f83313488093825
Author: Eugeni Dodonov <eugeni.dodonov@intel.com>
Date:   Thu Jan 5 09:34:28 2012 -0200

    drm: give up on edid retries when i2c bus is not responding
    
    This allows to avoid talking to a non-responding bus repeatedly until we
    finally timeout after 15 attempts. We can do this by catching the -ENXIO
    error, provided by i2c_algo_bit:bit_doAddress call.
    
    Within the bit_doAddress we already try 3 times to get the edid data, so
    if the routine tells us that bus is not responding, it is mostly pointless
    to keep re-trying those attempts over and over again until we reach final
    number of retries.
    
    This change should fix https://bugs.freedesktop.org/show_bug.cgi?id=41059
    and improve overall edid detection timing by 10-30% in most cases, and by
    a much larger margin in case of phantom outputs (up to 30x in one worst
    case).
    
    Timing results for i915-powered machines for 'time xrandr' command:
    Machine 1: from 0.840s to 0.290s
    Machine 2: from 0.315s to 0.280s
    Machine 3: from +/- 4s to 0.184s
    
    Timing results for HD5770 with 'time xrandr' command:
    Machine 4: from 3.210s to 1.060s
    
    Reviewed-by: Chris Wilson <chris@hchris-wilson.co.uk>
    Reviewed-by: Keith Packard <keithp@keithp.com>
    Tested-by: Sean Finney <seanius@seanius.net>
    Tested-by: Soren Hansen <soren@linux2go.dk>
    Tested-by: Hernando Torque <sirius@sonnenkinder.org>
    Tested-by: Mike Lothian <mike@fireburn.co.uk>
    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=41059
    Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

in airlied/drm-next.

One mystery that has never been resolved is just why wine causes a flood
of xrandr/connection probes, and then there is still the underlying issue
that probing blocks the device and causes noticeable latency.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
