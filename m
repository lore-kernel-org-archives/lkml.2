Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab1FPLtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:49:22 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:41132
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756300Ab1FPLtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:49:19 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de p5GBnC7R029206
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [2.6.39] drm/i915: blank screen on Lenovo Ideapad U160
In-Reply-To: <gi4o3q2plu.fsf@karga.hank.lab> (Dirk Gouders's message of "Thu,
	16 Jun 2011 09:38:05 +0200")
References: <gi1uzevjl4.fsf@mx10.gouders.net>
	<alpine.DEB.2.00.1105311406210.5012@localhost6.localdomain6>
	<gitycau362.fsf@mx10.gouders.net> <giei3eoeic.fsf@mx10.gouders.net>
	<gi1uyx8m2f.fsf_-_@mx10.gouders.net>
	<20110615115903.685acba0@jbarnes-desktop>
	<giips6lr5a.fsf@mx10.gouders.net>
	<20110615144132.074167f3@jbarnes-desktop>
	<giei2ulpl1.fsf@mx10.gouders.net>
	<20110615150737.79cd5de7@jbarnes-desktop>
	<gi4o3q2plu.fsf@karga.hank.lab>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Thu, 16 Jun 2011 13:49:11 +0200
Message-ID: <gizkli0zew.fsf@karga.hank.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Thu, 16 Jun 2011 13:49:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> writes:

> Jesse Barnes <jbarnes@virtuousgeek.org> writes:
>
>> On Thu, 16 Jun 2011 00:03:38 +0200
>> Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> wrote:
>>
>>> Jesse Barnes <jbarnes@virtuousgeek.org> writes:
>>> 
>>> > Oh is this not an LVDS panel?  I'm curious which of the port disables
>>> > is at fault in your config then.  If you have an eDP panel, it would
>>> > likely be the PCH_DP_D write.  It could be a side effect of the
>>> > PANEL_UNLOCK_REGS write as well though, can you try commenting each of
>>> > those out?
>>> 
>>> Yes, you are right.  Commenting out a single line helps:
>>> 
>>> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
>>> index 81a9059..ed95cbf 100644
>>> --- a/drivers/gpu/drm/i915/intel_display.c
>>> +++ b/drivers/gpu/drm/i915/intel_display.c
>>> @@ -1356,7 +1356,7 @@ static void intel_disable_pch_ports(struct drm_i915_private *dev_priv,
>>>         u32 reg, val;
>>>  
>>>         val = I915_READ(PCH_PP_CONTROL);
>>> -       I915_WRITE(PCH_PP_CONTROL, val | PANEL_UNLOCK_REGS);
>>> +       //I915_WRITE(PCH_PP_CONTROL, val | PANEL_UNLOCK_REGS);
>>>  
>>>         disable_pch_dp(dev_priv, pipe, PCH_DP_B);
>>>         disable_pch_dp(dev_priv, pipe, PCH_DP_C);
>>
>> Ok interesting, that means one of the locked regs we're trying to write
>> later is the real culprit for this issue... those include the LVDS reg
>> and the panel timing regs.  I'll see if I can figure out which one
>> might be the problem.
>
> Thanks a lot for your help.
>
> Perhaps this information is helpful: with the above change, a trace is
> generated during boot:
>
> ------------[ cut here ]------------
> WARNING: at drivers/gpu/drm/i915/intel_display.c:1020 ironlake_crtc_disable+0x65
> 4/0x124c()
> Hardware name: 08946MG
> PCH LVDS enabled on transcoder A, should be disabled
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 3.0.0-rc3-00055-gada9c93-dirty #6
> Call Trace:
>  [<ffffffff8103e052>] ? warn_slowpath_common+0x78/0x8c
>  [<ffffffff8103e107>] ? warn_slowpath_fmt+0x45/0x4a
>  [<ffffffff812d517a>] ? ironlake_crtc_disable+0x654/0x124c
>  [<ffffffff812ea90d>] ? intel_panel_set_backlight+0x3e/0x2b7
>  [<ffffffff812c55a7>] ? intel_crtc_dpms+0x38/0xfd
>  [<ffffffff812c2d49>] ? intel_crtc_disable+0x1a/0x4f
>  [<ffffffff8127c93b>] ? drm_helper_disable_unused_functions+0xd0/0xfb
>  [<ffffffff812dbab9>] ? intel_modeset_init+0x1500/0x15c0
>  [<ffffffff81297388>] ? i915_driver_load+0xc0d/0x13d9
>  [<ffffffff812865d8>] ? drm_get_minor+0x22b/0x288
>  [<ffffffff81288206>] ? drm_get_pci_dev+0x149/0x253
>  [<ffffffff814d4fc2>] ? _raw_spin_lock_irqsave+0x16/0x34
>  [<ffffffff812096c5>] ? local_pci_probe+0x49/0x95
>  [<ffffffff81209aa9>] ? pci_device_probe+0xc4/0xf3
>  [<ffffffff812fd902>] ? driver_sysfs_add+0x66/0x8d
>  [<ffffffff812fdb90>] ? driver_probe_device+0xa8/0x138
>  [<ffffffff812fdc6f>] ? __driver_attach+0x4f/0x6f
>  [<ffffffff812fdc20>] ? driver_probe_device+0x138/0x138
>  [<ffffffff812fce89>] ? bus_for_each_dev+0x47/0x72
>  [<ffffffff812fd515>] ? bus_add_driver+0xae/0x1fe
>  [<ffffffff817fe14d>] ? drm_core_init+0x121/0x121
>  [<ffffffff812fe0f4>] ? driver_register+0x8d/0xf5
>  [<ffffffff817fe14d>] ? drm_core_init+0x121/0x121
>  [<ffffffff81209cff>] ? __pci_register_driver+0x50/0xbb
>  [<ffffffff817fe14d>] ? drm_core_init+0x121/0x121
>  [<ffffffff810002e5>] ? do_one_initcall+0x78/0x12b
>  [<ffffffff817d9b3f>] ? kernel_init+0xa8/0x126
>  [<ffffffff814db414>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff817d9a97>] ? start_kernel+0x337/0x337
>  [<ffffffff814db410>] ? gs_change+0xb/0xb
> ---[ end trace bb2314f7f28ba213 ]---

Some redundant information, but if I change one line at another place
in the i915 code (whithout the above modification) the result is more
satisfactory on my machine, because in that case the display even works
after I close and reopen the lid:

diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
index 927442a..ebb67ae 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -267,7 +267,7 @@ static int intel_bios_ssc_frequency(struct drm_device *dev,
        case 4:
                return alternate ? 100 : 96;
        default:
-               return alternate ? 100 : 120;
+               return alternate ? 120 : 100;
        }
 }

Dirk
