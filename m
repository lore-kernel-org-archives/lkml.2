Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab1CNWWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:22:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49356 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab1CNWWg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:22:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=g1jrwJooIMIpQgnWEJ3C5qyrUR15TlHlqiI2KeM+GAO4RxOaCMYm1fSDrg0tc+ZYe/
         u7/J3Qk6XIxAumZK0h0tA0tRL2HrxZbABdZ/rd+Qjcd4jf34tf7+h37cwVxfWZY3K38R
         Q4BQDPzqpfwIehMKJE+y4csmqv39VYrrO2MN0=
MIME-Version: 1.0
In-Reply-To: <AANLkTinug=6d6BKrZvA1HGZWNqgUNJKOBC3f8J5B_5oJ@mail.gmail.com>
References: <4D7CCFC3.7030906@fastmail.fm>
	<AANLkTinug=6d6BKrZvA1HGZWNqgUNJKOBC3f8J5B_5oJ@mail.gmail.com>
Date: Mon, 14 Mar 2011 18:22:34 -0400
Message-ID: <AANLkTik0nXX+WEwa2xZ9VV+yHwrWnx+tYNdZXPEjk=SO@mail.gmail.com>
Subject: Re: Radeon jittery post 2.6.35
From: Alex Deucher <alexdeucher@gmail.com>
To: Anders Eriksson <aeriksson@fastmail.fm>
Cc: airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, xorg-driver-ati@lists.x.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 6:20 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
> On Sun, Mar 13, 2011 at 10:08 AM, Anders Eriksson <aeriksson@fastmail.fm> wrote:
>>  Hi,
>>
>> I've found what I guess is a radeon (or drm/kms) regression post 2.6.35.
>> I've got my TV conneced to my RS690G over HDMI, and the display has
>> always been jittery after POST and at the GRUB screen. Pre-KMS, the X
>> server (or driver got it sorted), and when KMS started, the display
>> stabilized right after the kernel driver was initiated. However, post
>> 2.6.35, I see the jitter is back.
>>
>> I've spent the last month trying to bisect it, but pretty much failed.
>> It appears that versions closer to 2.6.38-rcX are more prone to display
>> jitter, while 2.6.36 or so can have many successful runs. It also
>> appears to be related to device power-on order, or so I've come to
>> believe; A stable display can turn jittery, just by power cycling the TV.
>>
>> I've uploaded a video of a 38-rc8 boot:
>> http://www.easy-share.com/1914220540/2.6.38-rc8_bad_x.mp4
>>
>> You'll see jitter at the POST screen and GRUB. When KMS kicks in it
>> stabilizes, and when Freevo starts X, it's back to jitter.
>
> Does plain X or gnome/kde jitter too or just freevo?

Does this patch help?

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c
b/drivers/gpu/drm/radeon/atombios_crtc.c
index 1d89259..a2bd944 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -524,7 +524,7 @@ static u32 atombios_adjust_pll(struct drm_crtc *crtc,
                if ((rdev->family == CHIP_RS600) ||
                    (rdev->family == CHIP_RS690) ||
                    (rdev->family == CHIP_RS740))
-                       pll->flags |= (/*RADEON_PLL_USE_FRAC_FB_DIV |*/
+                       pll->flags |= (RADEON_PLL_USE_FRAC_FB_DIV |
                                       RADEON_PLL_PREFER_CLOSEST_LOWER);

                if (ASIC_IS_DCE32(rdev) && mode->clock > 200000)
 /* range limits??? */


>
> Alex
>
>>
>> The jitter is always of the same kind. It looks like an old tv set which
>> loses sync. The contents on the display is, for a split second, placed
>> at the wrong part of the screen (vertically and to some extent
>> horizontally), and every 5-15 seconds or so, there is a big reset when
>> the TV tries to restart things (I guess). At the resets, thee is a loud
>> 'ping' in the nearby stereo too...
>>
>> During the bisect  (and a t 38-rc8) I've seen this both at the console
>> (post KMS) and in X, so I'm not sure where the error is. I hope some of
>> you can get a better idea of where to hunt for the bug by looking at the
>> video.
>>
>> -Anders
>>
>
