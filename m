Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340Ab1EIJf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 05:35:29 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:47279 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750704Ab1EIJf2 (ORCPT
	<rfc822;groupwise-jlee@novell.com:6:1>);
	Mon, 9 May 2011 05:35:28 -0400
Message-Id: <4DC841FD020000230002C5BF@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Mon, 09 May 2011 03:35:25 -0600
From: "Joey Lee" <jlee@novell.com>
To: <chris@chris-wilson.co.uk>, <melchior.franz@gmail.com>,
        <dri-devel@lists.freedesktop.org>, "Joey Lee" <JLee@novell.com>,
        "Michael Chang" <MChang@novell.com>, <tiwai@suse.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: i915/kms/backlight-combo mode problem
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com>
 <201105072222.41807@rk-nord.at>
 <4DC72A34020000230002C541@novprvlin0050.provo.novell.com>
 <201105081605.46617@rk-nord.at>
 <4DC8378A020000230002C5A8@novprvlin0050.provo.novell.com>
 <s5hpqns6yg5.wl%tiwai@suse.de>
In-Reply-To: <s5hpqns6yg5.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 一，2011-05-09 於 11:00 +0200，Takashi Iwai 提到：
> At Mon, 09 May 2011 02:50:50 -0600,
> Joey Lee wrote:
> > 
> > We need to know some run time value when intel_panel_set_backlight call by funciton key.
> 
> Yes, that'll help understanding.
> 
> > Please help to apply the attached debug patch to intel_panel.c then attached dmesg.
> 
> The patch has an obvious typo :)
> Also, we should track the value in intel_panel_get_backlight(), too.
> 
> 
> Takashi
> 

Thank's for Takashi's review and sorry for my typo. 
Follow Takashi's suggestion, I added a debug message in get_backlight,
the following is new debug patch:

diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index f8f86e5..9695840 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -199,6 +199,7 @@ u32 intel_panel_get_backlight(struct drm_device *dev)
 		val = I915_READ(BLC_PWM_CPU_CTL) & BACKLIGHT_DUTY_CYCLE_MASK;
 	} else {
 		val = I915_READ(BLC_PWM_CTL) & BACKLIGHT_DUTY_CYCLE_MASK;
+		DRM_DEBUG_DRIVER("get backlight val = %d\n", val);
 		if (IS_PINEVIEW(dev))
 			val >>= 1;
 
@@ -236,17 +237,22 @@ void intel_panel_set_backlight(struct drm_device *dev, u32 level)
 		u32 max = intel_panel_get_max_backlight(dev);
 		u8 lbpc;
 
+		DRM_DEBUG_DRIVER("set backlight max = %d\n", max);
 		lbpc = level * 0xfe / max + 1;
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
 


