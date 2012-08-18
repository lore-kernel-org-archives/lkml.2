Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab2HRKEa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 06:04:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59751 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab2HRKE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 06:04:28 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20120817232956.GG4039@herton-Z68MA-D2H-B3>
References: <20120817030243.807605523@decadent.org.uk>
	<20120817030248.892667316@decadent.org.uk>
	<20120817232956.GG4039@herton-Z68MA-D2H-B3>
Date: Sat, 18 Aug 2012 12:04:27 +0200
Message-ID: <CAKMK7uGYgJvWs-BYoPUwNjcmM8xFYJZhpBpyetYzoj_4br5XwA@mail.gmail.com>
Subject: Re: [ 32/37] drm/i915: correctly order the ring init sequence
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jani Nikula <jani.nikula@intel.com>,
        Yang Guang <guang.a.yang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 1:29 AM, Herton Ronaldo Krzesinski
<herton.krzesinski@canonical.com> wrote:
> On Fri, Aug 17, 2012 at 04:03:15AM +0100, Ben Hutchings wrote:
>> 3.2-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Daniel Vetter <daniel.vetter@ffwll.ch>
>>
>> commit 0d8957c8a90bbb5d34fab9a304459448a5131e06 upstream.
>>
>> We may only start to set up the new register values after having
>> confirmed that the ring is truely off. Otherwise the hw might lose the
>> newly written register values. This is caught later on in the init
>> sequence, when we check whether the register writes have stuck.
>>
>> Reviewed-by: Jani Nikula <jani.nikula@intel.com>
>> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=50522
>> Tested-by: Yang Guang <guang.a.yang@intel.com>
>> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> [...]
>
> With this commit on 3.2, i915 fails to initialize on a G41 based machine
> I have here:
>
> [   36.894261] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   36.894265] i915 0000:00:02.0: setting latency timer to 64
> [   36.933118] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
> [   36.933121] [drm] MTRR allocation failed.  Graphics performance may suffer.
> [   36.933467] i915 0000:00:02.0: irq 42 for MSI/MSI-X
> [   36.933471] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [   36.933472] [drm] Driver supports precise vblank timestamp query.
> [   36.933498] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [   36.969669] [drm:init_ring_common] *ERROR* render ring initialization failed ctl 0001f001 head 00001074 tail 00000000 start 00001000
> [   36.969763] vga_switcheroo: disabled
> [   36.969765] [drm:i915_driver_load] *ERROR* failed to init modeset
> [   36.987444] i915 0000:00:02.0: PCI INT A disabled
> [   36.987453] i915: probe of 0000:00:02.0 failed with error -5
>
> Taking a look at it, I suspected of a timing issue, especially looking at
> this commit, which isn't on 3.2:
>
> commit f01db988ef6f6c70a6cc36ee71e4a98a68901229
> Author: Sean Paul <seanpaul@chromium.org>
> Date:   Fri Mar 16 12:43:22 2012 -0400
>
>     drm/i915: Add wait_for in init_ring_common
>
> And picking it made the issue go away, so the extra delay helped and is needed
> with 0d8957c8a90bbb5d34fab9a304459448a5131e06 applied here.

Good catch, I've forgotten to check whether all the recent ring_init
patches have gone  through cc: stable. For the stable team, please
pick up both patches:

f01db988ef6f6c70a6cc36ee71e4a98a68901229 and
0d8957c8a90bbb5d34fab9a304459448a5131e06

Note that all kernels that need f01db backported also need
b7884eb45ec98c0d34c7f49005ae9d4b4b4e38f6 (to fix a regression
introduce by the former).

Yeah, the ring init sequence is a fickle beast :( but I'm pretty sure
with these three patches, stable kernels should be up to date and have
all the latest fixes.

Yours, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
