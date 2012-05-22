Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab2EVU7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 16:59:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab2EVU7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 16:59:04 -0400
Date: Tue, 22 May 2012 13:59:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, Matthew Garrett <mjg@redhat.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Lars-Peter Clausen <lars@metafoo.de>, Axel Lin <axel.lin@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-fbdev@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-omap@vger.kernel.org
Subject: Re: [PATCH] backlight: initialize  struct backlight_properties
 properly
Message-Id: <20120522135902.90253d07.akpm@linux-foundation.org>
In-Reply-To: <1337585085-4891-1-git-send-email-corentin.chary@gmail.com>
References: <1337585085-4891-1-git-send-email-corentin.chary@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012 09:24:35 +0200
Corentin Chary <corentin.chary@gmail.com> wrote:

> In all these files, the .power field was never correctly initialized.
> 
> ...
>
> --- a/drivers/gpu/drm/i915/intel_panel.c
> +++ b/drivers/gpu/drm/i915/intel_panel.c
> @@ -342,6 +342,7 @@ int intel_panel_setup_backlight(struct drm_device *dev)
>  	else
>  		return -ENODEV;
>  
> +	memset(&props, 0, sizeof(props));

This code is all still quite fragile.  What happens if we add a new
field to backlight_properties?  We need to go edit a zillion drivers?

There are two ways of fixing this:

a) write and use

void backlight_properties_init(struct backlight_properties *props,
				int type, int max_brightness, etc);

   or

b) edit all sites to do

	struct backlight_properties bl_props = {
		.type = BACKLIGHT_RAW,
		.max_brighness = intel_panel_get_max_backlight(dev),
		.power = FB_BLANK_UNBLANK,
	};

they're largely equivalent - the struct will be zeroed out and
then certain fields will be initialised.  a) is a bit better because
some future field may not want the all-zeroes pattern (eg, a spinlock).

But they're both better than what we have now!
