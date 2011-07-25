Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab1GYRhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 13:37:42 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:44541 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752078Ab1GYRhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 13:37:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=RoLu3lZ/OVuoUsRrN47rYCxRrl2q69hz9jiPtgKS0El3OCt13q0l3mYUEBGBNZHh45OPiKN4bYOObl4U19Klss0t2IcdBPEjSU5ouhFbMP3w07IqiWw9AGAkn+W204G2;
Date: Mon, 25 Jul 2011 10:37:32 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Hold struct_mutex during hotplug
 processing
Message-ID: <20110725103732.623d7b65@jbarnes-desktop>
In-Reply-To: <1311613829-4990-1-git-send-email-keithp@keithp.com>
References: <1311613829-4990-1-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jul 2011 10:10:29 -0700
Keith Packard <keithp@keithp.com> wrote:

> Hotplug detection is a mode setting operation and must hold the
> struct_mutex or risk colliding with other mode setting operations.
> 
> In particular, the display port hotplug function attempts to re-train
> the link if the monitor is supposed to be running when plugged back
> in. If that happens while mode setting is underway, the link will get
> scrambled, leaving it in an inconsistent state.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/i915_irq.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
> index 3b03f85..5fe8f28 100644
> --- a/drivers/gpu/drm/i915/i915_irq.c
> +++ b/drivers/gpu/drm/i915/i915_irq.c
> @@ -306,12 +306,15 @@ static void i915_hotplug_work_func(struct work_struct *work)
>  	struct drm_mode_config *mode_config = &dev->mode_config;
>  	struct intel_encoder *encoder;
>  
> +	mutex_lock(&dev_priv->dev->struct_mutex);
>  	DRM_DEBUG_KMS("running encoder hotplug functions\n");
>  
>  	list_for_each_entry(encoder, &mode_config->encoder_list, base.head)
>  		if (encoder->hot_plug)
>  			encoder->hot_plug(encoder);
>  
> +	mutex_unlock(&dev_priv->dev->struct_mutex);
> +
>  	/* Just fire off a uevent and let userspace tell us what to do */
>  	drm_helper_hpd_irq_event(dev);
>  }

yay, sounds like this will fix Andrew's problem and probably lots of
other random DP related failures.

Looks like the ->detect function is similarly protected at the call
site (though one level up in ->fill_modes), so it should be safe.
Looks like all the call sites in the link_status function are safe too.

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Let's get this one upstream asap.  Should probably be cc'd to
stable@kernel.org as well.

-- 
Jesse Barnes, Intel Open Source Technology Center
