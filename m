Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab1GYCPf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 22:15:35 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:36048 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab1GYCPc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 22:15:32 -0400
MIME-Version: 1.0
In-Reply-To: <4E2CC6CC.5020204@gmail.com>
References: <alpine.LNX.2.00.1107242327030.7103@swampdragon.chaosbits.net>
	<4E2CC55B.5010307@gmail.com>
	<4E2CC6CC.5020204@gmail.com>
Date: Sun, 24 Jul 2011 22:15:30 -0400
Message-ID: <CACqU3MXoDAsVDs_X+g4ZvtFDY3iVRjQMxOOu8=s64VgUWS8vPg@mail.gmail.com>
Subject: Re: GMA500: ERROR: "__bad_udelay" undefined!
From: Arnaud Lacombe <lacombar@gmail.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org, Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 24, 2011 at 9:28 PM, Ryan Mallon <rmallon@gmail.com> wrote:
> On 25/07/11 11:22, Ryan Mallon wrote:
>>
>> On 25/07/11 07:37, Jesper Juhl wrote:
>>>
>>> Just got this when building the attached .config on x86_64 with gcc 4.6.1
>>> on up-to-date mainline git tree (head at
>>> b6844e8f64920cdee620157252169ba63afb0c89) :
>>>
>>>  ERROR: "__bad_udelay" [drivers/staging/gma500/psb_gfx.ko] undefined!
>>>  make[1]: *** [__modpost] Error 1
>>>
>>> I don't need gma500, so I've just disabled the driver to get around it
>>> but
>>> I thought some people might still like to know :)
>>>
>> __bad_udelay is a compile time check that constant udelays do not exceed a
>> certain threshold. For x86_64 it used to be n > 20000, now it is n / 20000
>> >= 1. The problem is in
>> drivers/staging/gma500/psb_intel_display.c:psb_init_wait_for_vblank, which
>> does udelay(20000) which under the old code would have been fine, but fails
>> the new __bad_udelay check.
>>
>> Possibly the udelay can just be converted to an mdelay?
>
> Here is the patch:
> ----
> A change to the constraints for the compile time check for __bad_udelay on
> some architectures caused breakage in the gma500 staging driver. Fix by
> replacing udelay with mdelay.
>
> Signed-off-by: Ryan Mallon <rmallon@gmail.com>
> ---
>
> diff --git a/drivers/staging/gma500/psb_intel_display.c
> b/drivers/staging/gma500/psb_intel_display.c
> index 4f47d09..09e378d 100644
> --- a/drivers/staging/gma500/psb_intel_display.c
> +++ b/drivers/staging/gma500/psb_intel_display.c
> @@ -331,7 +331,7 @@ static bool psb_intel_find_best_PLL(struct drm_crtc
> *crtc, int target,
>  void psb_intel_wait_for_vblank(struct drm_device *dev)
>  {
>        /* Wait for 20ms, i.e. one cycle at 50hz. */
> -       udelay(20000);
> +       mdelay(20);
>  }
>
same proposed by Stephen Rothwell in https://lkml.org/lkml/2011/7/24/162

 - Arnaud
