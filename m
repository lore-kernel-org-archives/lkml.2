Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab1CDGxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 01:53:33 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:47100 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab1CDGxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 01:53:32 -0500
Message-ID: <3e6f092bd0aa54fd6b9eb524f6c87ecf.squirrel@webmail.greenhost.nl>
In-Reply-To: <AANLkTimLBo4REwrCJfy3U_z-SJ8uoOurO7c66D5RpZRh@mail.gmail.com>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
    <20110216192658.GA7225@blimp.localdomain>
    <20110217221329.GA3332@x61.home>
    <3f792aaf90cf0b3d49be21baa2682d5d.squirrel@webmail.greenhost.nl>
    <AANLkTik20vCMhXqjxkoebZ1cWFb0zQLP5OZvVx4GWMPb@mail.gmail.com>
    <AANLkTik3ECs5z5td6GYuDExrc74_18mC-bk-hsq4e1+i@mail.gmail.com>
    <AANLkTik9XHcDUbPTPh6t--TwQompeQBY9TNuuBRk++-6@mail.gmail.com>
    <20110222130440.21a27714@jbarnes-desktop>
    <20110222223120.GA3567@x61.home>
    <AANLkTimLBo4REwrCJfy3U_z-SJ8uoOurO7c66D5RpZRh@mail.gmail.com>
Date: Fri, 4 Mar 2011 07:53:15 +0100 (CET)
Subject: Re: [PATCH] fix backlight brightness on intel LVDS panel after 
     reopening lid
From: "Indan Zupancic" <indan@nul.nu>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>,
        "Alex Riesen" <raa.lkml@gmail.com>,
        "DRI mailing list" <dri-devel@lists.freedesktop.org>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Tino Keitel" <tino.keitel@tikei.de>, stable@kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: aaa3b708a984912a81ea67a52d88c378
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, February 23, 2011 02:09, Linus Torvalds wrote:
> On Tue, Feb 22, 2011 at 2:31 PM, Tino Keitel <tino.keitel@tikei.de> wrote:
>>
>> I just tried 2.6.38-rc6 on my ThinkPad X61s without any other DRM
>> related patches, and my backlight issue is gone.
>
> I applied Indan's fix in -rc6 (commit 951f3512dba5), since it had
> several testers and seemed to simplify the code nicely too.

Sadly, as so often in life, it's not correct. At this point I'm not sure
if it's better to revert that patch and add a correct one, or to just
fix it up. The end result is the same I suppose. I've also found more
documentation, namely: ACPI_IGD_OpRegion_Spec.pdf, which has the ASLE
stuff in intel_opregion.c, and VOL_1_graphics_core.pdf, which mentions
LBPC (I was looking at 3 before). Apparently the undocumented stuff
the old code did was correct. What I don't understand is how BIOS
makers could know about those bits.

The good side is that that big warning in my patch description is
invalid, something else was going on: The BIOS used LBPC to set and
restore brightness, while the driver only used BLC_PWM_CTL after my
patch.

All credits to Intel for making something simple as backlight control
as stupid and complex as possible:

- It has two registers to control brightness, sometimes one is used,
sometimes the other, sometimes both, and it's unknown what the BIOS
uses, and it's undefined what registers are restored by the BIOS after
reboot/resume.

- When using ACPI and ASLE, the kernel requests a brightness change
via a standard ACPI method, which in turns lets the BIOS generate an
ASLE interrupt, which is handled by the driver. The brightness to set
is between 0 and 255, and the driver is supposed to store the current
brightness in another register. That register stores the brightness in
percentages, which is used by the BIOS to restore brightness. How it
does that is undefined, so it can use either register. So the BIOS
obviously knows how to change the brightness, and it's still seemed
like a good idea to bother the driver with it. The ASLE interface is
a mess.

All in all, after my patch, systems using ASLE and a BIOS storing
the brightness in LBPC stopped working. The reason it works without
ASLE is because the brightness is never changed by the driver, the
backlight is only enabled or disabled.

I'd love to clean up the whole backlight mess, but it's too late in
the RC cycle to do that.

So please revert my patch and apply Takashi Iwai's, which fixes the
most immediate bug without changing anything else. This should go
in stable too.

>From f6b8a45b9544072e6ddbb944a4c03a9ec8cbca3a Mon Sep 17 00:00:00 2001 From: Takashi
Iwai <tiwai@suse.de>
Date: Mon, 21 Feb 2011 14:19:27 +0100
Subject: [PATCH] drm/i915: Fix calculation of backlight value in combined mode

The commit a95735569312f2ab0c80425e2cd1e5cb0b4e1870
    drm/i915: Refactor panel backlight controls
causes a regression for GM45 that is using the combined mode for
controlling the backlight brightness.  The commit introduced a wrong bit shift for
computing the current backlight level.

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=672946
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=34524

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: <stable@kernel.org>
---
 drivers/gpu/drm/i915/intel_panel.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -176,7 +176,6 @@
 			val &= ~1;
 			pci_read_config_byte(dev->pdev, PCI_LBPC, &lbpc);
 			val *= lbpc;
-			val >>= 1;
 		}
 	}


