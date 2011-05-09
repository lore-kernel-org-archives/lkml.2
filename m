Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab1EIIu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 04:50:57 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:39489 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753735Ab1EIIuz (ORCPT
	<rfc822;groupwise-jlee@novell.com:6:1>);
	Mon, 9 May 2011 04:50:55 -0400
Message-Id: <4DC8378A020000230002C5A8@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Mon, 09 May 2011 02:50:50 -0600
From: "Joey Lee" <jlee@novell.com>
To: <melchior.franz@gmail.com>
Cc: <chris@chris-wilson.co.uk>, <dri-devel@lists.freedesktop.org>,
        "Joey Lee" <JLee@novell.com>, "Michael Chang" <MChang@novell.com>,
        <tiwai@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: i915/kms/backlight-combo mode problem
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com>
 <201105072222.41807@rk-nord.at>
 <4DC72A34020000230002C541@novprvlin0050.provo.novell.com>
 <201105081605.46617@rk-nord.at>
In-Reply-To: <201105081605.46617@rk-nord.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Cc. Michael Chang for he is our i915 expert.

Hi Melchior, 

於 日，2011-05-08 於 16:05 +0200，Melchior FRANZ 提到：
> 
> > Does it work to you direct control brightness by access
> > by /sys/class/backlight/acer-wmi/brightness ?
> 
> No. A number written to this virtual file is accepted and remembered,
> but it doesn't actually change the brightness. It takes setpci to do
> that. 
> 

I thought the video driver still is the KEY component for backlight
issues, need fix the problem in video driver first.

> 
>  
> > As I remember, use setpci to control brightness is not recommended
> > because BIOS or ACPI will also touch brightness level. That will be
> > better control brightness by the function that was provided by BIOS. 
> > e.g. ACPI or WMI interface, or direct control by EC.
> 
> Well, sounds plausible. And I wouldn't do it if it weren't the only
> way at the moment.  :-)
> 
> 
> 
> > That means that will be better fix your Fn key control brightness like
> > before, you just need press Fn key to change brightness and don't need
> > have any workaround.
> 
> OK. I have added a lot of debug messages to intel_panel.c yesterday.
> All it told me was that it seems to work correctly wiht acpi_osi=Linux.
> Except that it doesn't actually change the brightness. Without acpi_osi
> the functions aren't called at all and none of my messages showed up.
> 

I traced _Q event in your DSDT, when acpi_osi=Linux, it run the Intel
OpRegion logic for change brightness. And, finally, intel_opregion will
access the function the were provided by intel_panel. So, the problem
still back to intel_panel.

After discuss with Michael chang, we thought there have problem in your
brightness level after add combination mode:

vi driver/gpu/drm/i915/intel_panel.c

void intel_panel_set_backlight(struct drm_device *dev, u32 level)
{
        struct drm_i915_private *dev_priv = dev->dev_private;
        u32 tmp;

        DRM_DEBUG_DRIVER("set backlight PWM = %d\n", level);

        if (HAS_PCH_SPLIT(dev))
                return intel_pch_panel_set_backlight(dev, level);

        if (is_backlight_combination_mode(dev)){
                u32 max = intel_panel_get_max_backlight(dev);
                u8 lbpc;

                lbpc = level * 0xfe / max + 1;
                level /= lbpc;			/* maybe the level changed by lbpc */
                pci_write_config_byte(dev->pdev, PCI_LBPC, lbpc);
        }

        tmp = I915_READ(BLC_PWM_CTL);
        if (IS_PINEVIEW(dev)) {
                tmp &= ~(BACKLIGHT_DUTY_CYCLE_MASK - 1);
                level <<= 1;
        } else
                tmp &= ~BACKLIGHT_DUTY_CYCLE_MASK;
        I915_WRITE(BLC_PWM_CTL, tmp | level);
}

We need to know some run time value when intel_panel_set_backlight call by funciton key.
Please help to apply the attached debug patch to intel_panel.c then attached dmesg.

> 
> 
> > Looks like current status is we try to fix bko#31522 but the patch
> > causes your brightness no work by press Fn key even with acpi_osi=Linux.
> > Does it right?
> 
> The history is: with acpi_osi=Linux everything worked with 2.6.38-rc8.
> With 2.6.38 the screen stayed black. The patch that only ignored lbpc=0
> worked (IIRC) including key adjustment. Later patches broke keys.
> 
> 
> 
> > 	replace acpi_osi=Linux by acpi_osi="!Windows 2006"
> > 
> > Does it also works to you for backlight control?
> 
> No, doesn't work.
> 

We can test the acpi_osi="!Windows 2006" again after we fix the i915's
problem.


Thank's
Joey Lee

The following is debug patch, and please add kernel parameter
drm.debug=0x02 :

diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index f8f86e5..f62dbd9 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -236,17 +236,22 @@ void intel_panel_set_backlight(struct drm_device *dev, u32 level)
 		u32 max = intel_panel_get_max_backlight(dev);
 		u8 lbpc;
 
+		DRM_DEBUG_DRIVER("set backlight max = % 		lbpc = level * 0xfe / max + 1;
+		DRM_DEBUG_DRIVER("set backlight lbpc = %d\n", lbpc);
 		level /= lbpc;
 		pci_write_config_byte(dev->pdev, PCI_LBPC, lbpc);
 	}
 
 	tmp = I915_READ(BLC_PWM_CTL);
+	DRM_DEBUG_DRIVER("set backlight tmp(1) = %d\n", tmp);
 	if (IS_PINEVIEW(dev)) {
 		tmp &= ~(BACKLIGHT_DUTY_CYCLE_MASK - 1);
 		level <<= 1;
 	} else
 		tmp &= ~BACKLIGHT_DUTY_CYCLE_MASK;
+	DRM_DEBUG_DRIVER("set backlight tmp(2) = %d\n", tmp);
+	DRM_DEBUG_DRIVER("set backlight level = %d\n", level);
 	I915_WRITE(BLC_PWM_CTL, tmp | level);
 }
 


