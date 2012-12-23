Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab2LWKzg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 05:55:36 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43220 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab2LWKzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 05:55:33 -0500
Date: Sun, 23 Dec 2012 11:55:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Alex Deucher <alexander.deucher@amd.com>, dri-devel@lists.freedesktop.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
Message-ID: <20121223105527.GA6230@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alex Deucher <alexdeucher@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	dri-devel@lists.freedesktop.org,
	lkml <linux-kernel@vger.kernel.org>
References: <20121222203547.GA5319@liondog.tnic>
 <CADnq5_MJzNdWVCauZj5Z7Monmsy4gWeYP3gJaPUPwHEgqhqOYw@mail.gmail.com>
 <20121223002507.GA12121@liondog.tnic>
 <CADnq5_Oe=_nOrsgUZvPc82F5CFAWecx=Uiqn0CAeK+YG3ns3AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADnq5_Oe=_nOrsgUZvPc82F5CFAWecx=Uiqn0CAeK+YG3ns3AA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2012 at 07:42:16PM -0500, Alex Deucher wrote:
> Does booting with radeon.wb=0 help?

Right, this param specification somehow didn't work here:

[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-rc1 root=/dev/sda1 ro vga=0 log_bug_len=10M resume=/dev/sda2 no_console_suspend ignore_loglevel hpet=force radeon.wb=0
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-rc1 root=/dev/sda1 ro vga=0 log_bug_len=10M resume=/dev/sda2 no_console_suspend ignore_loglevel hpet=force radeon.wb=0

[ … ]

[    6.910104] radeon: `0' invalid for parameter `wb'

[ … ]

[   28.191072] radeon: `0' invalid for parameter `wb'

although the whole driver blubber didn't appear on the console fterwards
aso something got turned off allright.

Then, I went and tried "radeon.no_wb" where the driver blubber appeared
but AGP writeback was still enabled:

[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-rc1 root=/dev/sda1 ro vga=0 log_bug_len=10M resume=/dev/sda2 no_console_suspend ignore_loglevel hpet=force radeon.no_wb
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-rc1 root=/dev/sda1 ro vga=0 log_bug_len=10M resume=/dev/sda2 no_console_suspend ignore_loglevel hpet=force radeon.no_wb

[ … ]

[    6.382636] [drm] radeon kernel modesetting enabled.
[    6.384915] radeon 0000:02:00.0: VRAM: 512M 0x0000000000000000 - 0x000000001FFFFFFF (512M used)
[    6.384981] radeon 0000:02:00.0: GTT: 512M 0x0000000020000000 - 0x000000003FFFFFFF
[    6.388137] [drm] radeon: 512M of VRAM memory ready
[    6.388181] [drm] radeon: 512M of GTT memory ready.
[    6.388509] radeon 0000:02:00.0: irq 42 for MSI/MSI-X
[    6.388570] radeon 0000:02:00.0: radeon: using MSI.
[    6.388705] [drm] radeon: irq initialized.
[    6.567811] radeon 0000:02:00.0: WB enabled
				    ^^^^^^^^^^

[    6.567856] radeon 0000:02:00.0: fence driver on ring 0 use gpu addr 0x0000000020000c00 and cpu addr 0xffff8802243e5c00
[    6.567922] radeon 0000:02:00.0: fence driver on ring 3 use gpu addr 0x0000000020000c0c and cpu addr 0xffff8802243e5c0c
[    6.601247] [drm] Radeon Display Connectors
[    6.602427] [drm] radeon: power management initialized
[    6.722544] fbcon: radeondrmfb (fb0) is primary device
[    6.945065] radeon 0000:02:00.0: fb0: radeondrmfb frame buffer device
[    6.945100] radeon 0000:02:00.0: registered panic notifier
[    6.945159] [drm] Initialized radeon 2.27.0 20080528 for 0000:02:00.0 on minor 0

At this point, I got tired of this experimenting and went and took the
big hammer :-):

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 49b06590001e..00214312db23 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -307,6 +307,11 @@ int radeon_wb_init(struct radeon_device *rdev)
                rdev->wb.use_event = true;
        }
 
+       if (rdev->wb.enabled) {
+               pr_err("%s: disable the goddam WB: radeon_no_wb: %d\n", __func__, radeon_no_wb);
+               rdev->wb.enabled = false;
+       }
+
        dev_info(rdev->dev, "WB %sabled\n", rdev->wb.enabled ? "en" : "dis");
 
        return 0;


[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-rc1+ root=/dev/sda1 ro vga=0 log_bug_len=10M resume=/dev/sda2 no_console_suspend ignore_loglevel hpet=force radeon.no_wb no_wb
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-rc1+ root=/dev/sda1 ro vga=0 log_bug_len=10M resume=/dev/sda2 no_console_suspend ignore_loglevel hpet=force radeon.no_wb no_wb

[    6.562905] [drm] radeon kernel modesetting enabled.
[    6.565106] radeon 0000:02:00.0: VRAM: 512M 0x0000000000000000 - 0x000000001FFFFFFF (512M used)
[    6.565172] radeon 0000:02:00.0: GTT: 512M 0x0000000020000000 - 0x000000003FFFFFFF
[    6.567696] [drm] radeon: 512M of VRAM memory ready
[    6.567742] [drm] radeon: 512M of GTT memory ready.
[    6.568068] radeon 0000:02:00.0: irq 42 for MSI/MSI-X
[    6.568130] radeon 0000:02:00.0: radeon: using MSI.
[    6.568269] [drm] radeon: irq initialized.
[    6.684920] radeon_wb_init: disable the goddam WB: radeon_no_wb: 0
[    6.684967] radeon 0000:02:00.0: WB disabled
				    ^^^^^^^^^^^

[    6.685011] radeon 0000:02:00.0: fence driver on ring 0 use gpu addr 0x0000000020000c00 and cpu addr 0xffff880221ea3c00
[    6.685077] radeon 0000:02:00.0: fence driver on ring 3 use gpu addr 0x0000000020000c0c and cpu addr 0xffff880221ea3c0c
[    6.722367] [drm] Radeon Display Connectors
[    6.723548] [drm] radeon: power management initialized
[    6.843185] fbcon: radeondrmfb (fb0) is primary device
[    7.066368] radeon 0000:02:00.0: fb0: radeondrmfb frame buffer device
[    7.066402] radeon 0000:02:00.0: registered panic notifier
[    7.066462] [drm] Initialized radeon 2.27.0 20080528 for 0000:02:00.0 on minor 0

Ok, I hope I turned off the proper WB thing (I'm assuming you meant the
radeon_no_wb parameter).

And I'm running with it now, will report what happens.

Btw, I'm no GPU guy but why does radeon_wb_init() do all that memory
allocation and cleaning if wb can be disabled with a parameter?
Shouldn't it be checking the parameter, ->family, etc setting first and
only do the allocations when rdev->wb.enabled remains true?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
