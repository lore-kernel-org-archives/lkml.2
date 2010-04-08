Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab0DHQff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 12:35:35 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:54028 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758686Ab0DHQfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 12:35:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Pdv0XLwHMDLM8APpRw3GqJtbZNQxEewUbPY/EiJG0qOP33tD348IiVzk7Q2tZYRVASTcT/57wePQo3AwDB44vYjvKr9L7PdCv/ivNiWfcVs/NCZ4JMsZJ92om+PxkSk7;
Date: Thu, 8 Apr 2010 09:35:35 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Karsten Wiese <fzuuzf@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Eric Anholt <eric@anholt.net>
Subject: Re: [RFC PATCH] drm/i915: Don't touch PORT_HOTPLUG_EN in
 intel_dp_detect()
Message-ID: <20100408093535.691d5846@virtuousgeek.org>
In-Reply-To: <201003272248.34294.fzuuzf@googlemail.com>
References: <201003272248.34294.fzuuzf@googlemail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Mar 2010 22:48:33 +0100
Karsten Wiese <fzuuzf@googlemail.com> wrote:

> PORT_HOTPLUG_EN has allready been setup in i915_driver_irq_postinstall(),
> when intel_dp_detect() runs.
> 
> Delete the DP[BCD]_HOTPLUG_INT_EN defines, they are not referenced anymore.
> 
> I found this while searching for a fix for
>         https://bugzilla.redhat.com/show_bug.cgi?id=528312
> 
> Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
> ---
> See also 
> "drm/i915: only enable hotplug for detected outputs"
> b01f2c3a4a37d09a47ad73ccbb46d554d21cfeb0
> 
>  drivers/gpu/drm/i915/i915_reg.h |    3 ---
>  drivers/gpu/drm/i915/intel_dp.c |   10 ----------
>  2 files changed, 0 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
> index ab1bd2d..92f440d 100644
> --- a/drivers/gpu/drm/i915/i915_reg.h
> +++ b/drivers/gpu/drm/i915/i915_reg.h
> @@ -854,11 +854,8 @@
>  /* Hotplug control (945+ only) */
>  #define PORT_HOTPLUG_EN                0x61110
>  #define   HDMIB_HOTPLUG_INT_EN                 (1 << 29)
> -#define   DPB_HOTPLUG_INT_EN                   (1 << 29)
>  #define   HDMIC_HOTPLUG_INT_EN                 (1 << 28)
> -#define   DPC_HOTPLUG_INT_EN                   (1 << 28)
>  #define   HDMID_HOTPLUG_INT_EN                 (1 << 27)
> -#define   DPD_HOTPLUG_INT_EN                   (1 << 27)
>  #define   SDVOB_HOTPLUG_INT_EN                 (1 << 26)
>  #define   SDVOC_HOTPLUG_INT_EN                 (1 << 25)
>  #define   TV_HOTPLUG_INT_EN                    (1 << 18)
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
> index 439506c..7a3b5c8 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -1179,16 +1179,6 @@ intel_dp_detect(struct drm_connector *connector)
>         if (IS_IRONLAKE(dev))
>                 return ironlake_dp_detect(connector);
> 
> -       temp = I915_READ(PORT_HOTPLUG_EN);
> -
> -       I915_WRITE(PORT_HOTPLUG_EN,
> -              temp |
> -              DPB_HOTPLUG_INT_EN |
> -              DPC_HOTPLUG_INT_EN |
> -              DPD_HOTPLUG_INT_EN);
> -
> -       POSTING_READ(PORT_HOTPLUG_EN);
> -
>         switch (dp_priv->output_reg) {
>         case DP_B:
>                 bit = DPB_HOTPLUG_INT_STATUS;
> --
> 

Yeah, looks like we already cover this with the hotplug_supported_mask
setup we do here, so we should be able to drop these bits.

So assuming it's been tested with a real DP output + hotplug:

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
