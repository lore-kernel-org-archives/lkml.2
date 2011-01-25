Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1AYMLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 07:11:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:51591 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab1AYMLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:11:08 -0500
Message-Id: <0d30dc$krt8da@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,373,1291622400"; 
   d="scan'208";a="700359091"
Date: Tue, 25 Jan 2011 12:11:04 +0000
To: Knut Petersen <Knut_Petersen@t-online.de>
Subject: Re: [BUG/REGRESSION] DRM / i915 / 2.6.37 and 2.6.38-rc*: DVI output gets disabled/reenabled under load
Cc: jesse.barnes@intel.com, linux-kernel@vger.kernel.org
References: <4D3DC997.5040605@t-online.de> <0d30dc$krk6f6@orsmga001.jf.intel.com> <4D3EB90C.9020901@t-online.de>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <4D3EB90C.9020901@t-online.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011 12:50:36 +0100, Knut Petersen <Knut_Petersen@t-online.de> wrote:
> Am 24.01.2011 20:13, schrieb Chris Wilson:
> > On Mon, 24 Jan 2011 19:48:55 +0100, Knut Petersen <Knut_Petersen@t-online.de> wrote:
> >   
> >> On an AOpen i915GMm-HFS I see the following problem:
> >> The LCD panel connected to DVI-1 gets disabled and then reenabled
> >> under high system load (e.g. -j 15 kernel compile) if I am working on the
> >> framebuffer console (no problems in X).
> >>     
> > DVI detection is essentially retrieving the EDID by bitbanging on the DDC.
> > This is timing sensitive and I suspect that is being interrupted by the
> > system activity causing the EDID data to be returned corrupted. Is that
> > supported by any warnings in dmesg? Does increasing the drm.debug level to
> > 0x6 reveal any more significant information?
> >
> >   
> 
> KERNEL 2.6.36.3
> ==============
> Attached to this msg is LOG 2.6.36.3. Everything looks fine, every 10
> seconds
> an additional message group is added. No distortions.
> 
> KERNEL 2.6.38-rc2
> ================
> 
> LOG-2.6.38-rc2 is different. The kernel is a pure kernel 2.6.38-rc2 with one
> exception: I changed  DRM_OUTPUT_POLL_PERIOD  to 3*HZ to increase
> error probability.
> 
> At log time [  678.598641]  you can see the status change of the VGA-2
> connector (there is no physical VGA-2 connector on that mobo).

I'm interested in knowing where the extra VGA-2 comes from. The only
thing that comes to mind is a secondary function on the SDVO and knowing
why that is unstable. Can you attach the complete drm.debug logs for
2.6.36 and 2.6.38 so I can see the initialisation order of the connectors.

> After that a hotplug event is generated. Ok, that could be reasonable,
> but as
> you see the other connectors are also affected by that event. I cannot
> tell the
> exact moment, but during processing that hotplug event there is a period
> with
> no (or maybe a distorted) signal on the DVI-1 connector.
> 
> Both logs where taken on a busy system doing a make -j 15 kernel compile,
> debuglevel 15, framebuffer console, no X running.
> 
> I admit that I had not the time to study the code and hardware
> references in detail,
> but a few questions / thoughts come to my mind.
> 
> 1: I suspect that it is not a timing problem because only VGA-2 (no
> physical connector)
> is affected. The status of VGA-1 and DVI-1 (with physical connectors) 
> seems to
> be absolutely stable. Guess: Maybe a hardware problem like missing
> termination ?
> There are  few systems with 2 real VGA connectors ... there could be
> more systems with
> that problem if my guess is right.

Yeah, I suspect we have a spurious and unstable detection of the VGA-2,
which is revealing other issues. But I wonder if it is a DVI-I connection
coupled to an additional DVI/CRT encoder...
 
> 2: We should not care if connector status changes between "unknown" and
> "disconnected". We should only care about status changes from/to "connected"
> and generate hotplug events only in that case. That should solve my
> problem and
> would break nothing. Am I right?

That's a good suggestion and a patch should be discussed on
dri-devel@lists.freedesktop.org in case there is some subtlety that's been
overlooked.

> 3: It's wrong that a status change on one connector generates a hotplug
> event
> that affects all connectors ...

Userspace probes all attached connectors on receiving a hotplug event. Go
userspace! Yes, there is room for improvement!

Right and it's also surprising that the DVI comes and goes...

> I think LOG-2.6.38-rc2 shows a sign of an additional bug
> ===========================================
> [  681.527815] [drm:drm_target_preferred], found mode 1280x1024
> [  681.531482] [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
> 
> Is 4096x4096 really reasonable? I don't think so, at least not for my
> hardware.

Yes, gen3 supports a maximum (square) framebuffer of 4096x4096. X works
for me with such a virtual screen size (i.e. panning).

The complication comes in that the 3D pipeline is limited to 2048x2048
coordinates. X tiles, mesa does not and uses software instead. Baring
bugs, it should work.

If you do have a crash with a recent driver, let me know!
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
