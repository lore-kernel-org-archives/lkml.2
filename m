Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1EJD3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 23:29:07 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55387 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab1EJD3G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 23:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mWLCgbDD4puj02XNMM681C1fGWV8Ppn5/IlemjlWFbBuHCe6D2g5BpdW4TP72JVlon
         I6zeQkTEc8g/pVJ0HjxfLTK28PklCjYZbkjEbE/8xNdmt0r4C3wSAbVh0XW76o5YPba/
         b/IIM/oE2HThDWjgbeblU4C1Y+Wx6W7Nf1Pe0=
MIME-Version: 1.0
In-Reply-To: <BANLkTimtvAWeS-t3bWjJmdVtyaPDw2uWDA@mail.gmail.com>
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com>
	<201105081605.46617@rk-nord.at>
	<4DC8378A020000230002C5A8@novprvlin0050.provo.novell.com>
	<201105091208.10379@rk-nord.at>
	<BANLkTimtvAWeS-t3bWjJmdVtyaPDw2uWDA@mail.gmail.com>
Date: Tue, 10 May 2011 11:29:04 +0800
X-Google-Sender-Auth: 3xrVqzlyX6PBGvhfA23-YexE-AE
Message-ID: <BANLkTi=hUBrKnbrF+Q_ZOxdUPVSOUYUm2Q@mail.gmail.com>
Subject: Re: i915/kms/backlight-combo mode problem
From: Michael Chang <mchang@novell.com>
To: Melchior FRANZ <melchior.franz@gmail.com>
Cc: Joey Lee <jlee@novell.com>, chris@chris-wilson.co.uk,
        dri-devel@lists.freedesktop.org, tiwai@suse.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Melchior,

Could you please try this patch and get the log ? We wonder why
is_backlight_combination_mode () returns false. We all knew that it
returns true during booting (and takashi's fix works to fix the
blackscreen for you) and it's unlikely to become false afterward.
Perhaps it was changed wrongly ..

I speculate that if it returns true matters because it would touch the
LPBC register and your problem might get fixed.

Thanks in advance. :)

diff --git a/drivers/gpu/drm/i915/intel_panel.c
b/drivers/gpu/drm/i915/intel_panel.c
index a06ff07..8f14bfa 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -116,12 +116,21 @@ static int Melchior(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;

-	if (INTEL_INFO(dev)->gen >= 4)
-		return I915_READ(BLC_PWM_CTL2) & BLM_COMBINATION_MODE;
+	if (INTEL_INFO(dev)->gen >= 4) {

-	if (IS_GEN2(dev))
-		return I915_READ(BLC_PWM_CTL) & BLM_LEGACY_MODE;
+		int ret = I915_READ(BLC_PWM_CTL2) & BLM_COMBINATION_MODE;
+		DRM_DEBUG_DRIVER("BLM_COMBINATION_MODE = %d\n", ret);
+		return ret;
+	}
+
+	if (IS_GEN2(dev)) {

+		int ret = I915_READ(BLC_PWM_CTL) & BLM_LEGACY_MODE;
+		DRM_DEBUG_DRIVER("BLM_LEGACY_MODE = %d\n", ret);
+		return ret;
+	}
+	
+	DRM_DEBUG_DRIVER("Do nothing, return false\n");
 	return 0;
 }


2011/5/9 Michael Chang <mchang@novell.com>:
>
> From the log, it looks like is_backlight_combination_mode is evaluated false
> which contradicts with the topic we are discussed. Regardless of the
> combination_mode, the log seems to work ..  weird.
>
> 2011/5/9 Melchior FRANZ <melchior.franz@gmail.com>
>>
>> * Joey Lee -- Monday 09 May 2011:
>> > The following is debug patch, and please add kernel parameter
>> > drm.debug=0x02 :
>>
>> The result is with acpi_osi=Linux:
>>
>>
>> boot phase:
>> [    3.310274] [drm:intel_panel_get_backlight], get backlight val = 2890
>> [    3.310280] [drm:intel_panel_get_backlight], get backlight PWM = 2890
>> [    3.310615] [drm:intel_panel_get_backlight], get backlight val = 2890
>> [    3.310617] [drm:intel_panel_get_backlight], get backlight PWM = 2890
>> [    3.310619] [drm:intel_panel_set_backlight], set backlight PWM = 0
>> [    3.310622] [drm:intel_panel_set_backlight], set backlight tmp(1) =
>> 189401930
>> [    3.310624] [drm:intel_panel_set_backlight], set backlight tmp(2) =
>> 189399040
>> [    3.310626] [drm:intel_panel_set_backlight], set backlight level = 0
>>
>> [    3.641522] [drm:intel_panel_set_backlight], set backlight PWM = 2890
>> [    3.641525] [drm:intel_panel_set_backlight], set backlight tmp(1) =
>> 189399040
>> [    3.641527] [drm:intel_panel_set_backlight], set backlight tmp(2) =
>> 189399040
>> [    3.641529] [drm:intel_panel_set_backlight], set backlight level = 2890
>>
>> [   11.410563] video LNXVIDEO:01: Restoring backlight state
>>
>>
>>
>> brightness up:
>>   [no output]
>>
>>
>>
>> brightness down:
>> [  152.697127] [drm:intel_panel_get_max_backlight], max backlight PWM =
>> 2890
>> [  152.697136] [drm:intel_panel_set_backlight], set backlight PWM = 283
>> [  152.697141] [drm:intel_panel_set_backlight], set backlight tmp(1) =
>> 189401930
>> [  152.697146] [drm:intel_panel_set_backlight], set backlight tmp(2) =
>> 189399040
>> [  152.697150] [drm:intel_panel_set_backlight], set backlight level = 283
>>
>> [  166.720631] [drm:intel_panel_get_max_backlight], max backlight PWM =
>> 2890
>> [  166.720640] [drm:intel_panel_set_backlight], set backlight PWM = 578
>> [  166.720645] [drm:intel_panel_set_backlight], set backlight tmp(1) =
>> 189399323
>> [  166.720649] [drm:intel_panel_set_backlight], set backlight tmp(2) =
>> 189399040
>> [  166.720654] [drm:intel_panel_set_backlight], set backlight level = 578
>>
>> [  178.091776] [drm:intel_panel_get_max_backlight], max backlight PWM =
>> 2890
>> [  178.091784] [drm:intel_panel_set_backlight], set backlight PWM = 861
>> [  178.091789] [drm:intel_panel_set_backlight], set backlight tmp(1) =
>> 189399618
>> [  178.091793] [drm:intel_panel_set_backlight], set backlight tmp(2) =
>> 189399040
>> [  178.091797] [drm:intel_panel_set_backlight], set backlight level = 861
>>
>> [  188.888370] [drm:intel_panel_get_max_backlight], max backlight PWM =
>> 2890
>> [  188.888379] [drm:intel_panel_set_backlight], set backlight PWM = 1156
>> [  188.888383] [drm:intel_panel_set_backlight], set backlight tmp(1) =
>> 189399901
>> [  188.888388] [drm:intel_panel_set_backlight], set backlight tmp(2) =
>> 189399040
>> [  188.888392] [drm:intel_panel_set_backlight], set backlight level = 1156
>>
>> [  196.411657] [drm:intel_panel_get_max_backlight], max backlight PWM =
>> 2890
>> [  196.411665] [drm:intel_panel_set_backlight], set backlight PWM = 1439
>> [  196.411670] [drm:intel_panel_set_backlight], set backlight tmp(1) =
>> 189400196
>> [  196.411674] [drm:intel_panel_set_backlight], set backlight tmp(2) =
>> 189399040
>> [  196.411678] [drm:intel_panel_set_backlight], set backlight level = 1439
>>
>> [  201.256229] [drm:intel_panel_get_max_backlight], max backlight PWM =
>> 2890
>> [  201.256238] [drm:intel_panel_set_backlight], set backlight PWM = 1734
>> [  201.256243] [drm:intel_panel_set_backlight], set backlight tmp(1) =
>> 189400479
>> [  201.256247] [drm:intel_panel_set_backlight], set backlight tmp(2) =
>> 189399040
>> [  201.256252] [drm:intel_panel_set_backlight], set backlight level = 1734
>>
>> [  206.939838] [drm:intel_panel_get_max_backlight], max backlight PWM =
>> 2890
>> [  206.939846] [drm:intel_panel_set_backlight], set backlight PWM = 2017
>> [  206.939851] [drm:intel_panel_set_backlight], set backlight tmp(1) =
>> 189400774
>> [  206.939856] [drm:intel_panel_set_backlight], set backlight tmp(2) =
>> 189399040
>> [  206.939860] [drm:intel_panel_set_backlight], set backlight level = 2017
>>
>> [  213.779732] [drm:intel_panel_get_max_backlight], max backlight PWM =
>> 2890
>> [  213.779740] [drm:intel_panel_set_backlight], set backlight PWM = 2312
>> [  213.779744] [drm:intel_panel_set_backlight], set backlight tmp(1) =
>> 189401057
>> [  213.779749] [drm:intel_panel_set_backlight], set backlight tmp(2) =
>> 189399040
>> [  213.779753] [drm:intel_panel_set_backlight], set backlight level = 2312
>>
>> [  222.583806] [drm:intel_panel_get_max_backlight], max backlight PWM =
>> 2890
>> [  222.583814] [drm:intel_panel_set_backlight], set backlight PWM = 2595
>> [  222.583819] [drm:intel_panel_set_backlight], set backlight tmp(1) =
>> 189401352
>> [  222.583824] [drm:intel_panel_set_backlight], set backlight tmp(2) =
>> 189399040
>> [  222.583828] [drm:intel_panel_set_backlight], set backlight level = 2595
>>
>> [  229.345860] [drm:intel_panel_get_max_backlight], max backlight PWM =
>> 2890
>> [  229.345870] [drm:intel_panel_set_backlight], set backlight PWM = 2595
>> [  229.345874] [drm:intel_panel_set_backlight], set backlight tmp(1) =
>> 189401635
>> [  229.345879] [drm:intel_panel_set_backlight], set backlight tmp(2) =
>> 189399040
>> [  229.345883] [drm:intel_panel_set_backlight], set backlight level = 2595
>>
>>
>>
>> brightness up:
>> [  240.594464] [drm:intel_panel_get_max_backlight], max backlight PWM =
>> 2890
>> [  240.594474] [drm:intel_panel_set_backlight], set backlight PWM = 2312
>> [  240.594479] [drm:intel_panel_set_backlight], set backlight tmp(1) =
>> 189401635
>> [  240.594483] [drm:intel_panel_set_backlight], set backlight tmp(2) =
>> 189399040
>> [  240.594487] [drm:intel_panel_set_backlight], set backlight level = 2312
>>
>> [  240.816722] [drm:intel_panel_get_max_backlight], max backlight PWM =
>> 2890
>> [  240.816730] [drm:intel_panel_set_backlight], set backlight PWM = 2017
>> [  240.816734] [drm:intel_panel_set_backlight], set backlight tmp(1) =
>> 189401352
>> [  240.816739] [drm:intel_panel_set_backlight], set backlight tmp(2) =
>> 189399040
>> [  240.816743] [drm:intel_panel_set_backlight], set backlight level = 2017
>>
>> [  240.999973] [drm:intel_panel_get_max_backlight], max backlight PWM =
>> 2890
>> [  240.999981] [drm:intel_panel_set_backlight], set backlight PWM = 1734
>> [  240.999985] [drm:intel_panel_set_backlight], set backlight tmp(1) =
>> 189401057
>> [  240.999990] [drm:intel_panel_set_backlight], set backlight tmp(2) =
>> 189399040
>> [  240.999994] [drm:intel_panel_set_backlight], set backlight level = 1734
>>
>> [  241.212456] [drm:intel_panel_get_max_backlight], max backlight PWM =
>> 2890
>> [  241.212464] [drm:intel_panel_set_backlight], set backlight PWM = 1439
>> [  241.212469] [drm:intel_panel_set_backlight], set backlight tmp(1) =
>> 189400774
>> [  241.212473] [drm:intel_panel_set_backlight], set backlight tmp(2) =
>> 189399040
>> [  241.212478] [drm:intel_panel_set_backlight], set backlight level = 1439
>>
>> [  241.395611] [drm:intel_panel_get_max_backlight], max backlight PWM =
>> 2890
>> [  241.395619] [drm:intel_panel_set_backlight], set backlight PWM = 1156
>> [  241.395624] [drm:intel_panel_set_backlight], set backlight tmp(1) =
>> 189400479
>> [  241.395628] [drm:intel_panel_set_backlight], set backlight tmp(2) =
>> 189399040
>> [  241.395633] [drm:intel_panel_set_backlight], set backlight level = 1156
>>
>> [  242.039460] [drm:intel_panel_get_max_backlight], max backlight PWM =
>> 2890
>> [  242.039470] [drm:intel_panel_set_backlight], set backlight PWM = 283
>> [  242.039475] [drm:intel_panel_set_backlight], set backlight tmp(1) =
>> 189400196
>> [  242.039479] [drm:intel_panel_set_backlight], set backlight tmp(2) =
>> 189399040
>> [  242.039484] [drm:intel_panel_set_backlight], set backlight level = 283
>>
>> [  242.044495] [drm:intel_panel_get_max_backlight], max backlight PWM =
>> 2890
>> [  242.044502] [drm:intel_panel_set_backlight], set backlight PWM = 283
>> [  242.044507] [drm:intel_panel_set_backlight], set backlight tmp(1) =
>> 189399323
>> [  242.044511] [drm:intel_panel_set_backlight], set backlight tmp(2) =
>> 189399040
>> [  242.044515] [drm:intel_panel_set_backlight], set backlight level = 283
>>
>> [  242.077032] [drm:intel_panel_get_max_backlight], max backlight PWM =
>> 2890
>> [  242.077038] [drm:intel_panel_set_backlight], set backlight PWM = 0
>> [  242.077043] [drm:intel_panel_set_backlight], set backlight tmp(1) =
>> 189399323
>> [  242.077047] [drm:intel_panel_set_backlight], set backlight tmp(2) =
>> 189399040
>> [  242.077052] [drm:intel_panel_set_backlight], set backlight level = 0
>>
>> m.
>
>
