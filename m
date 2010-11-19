Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab0KSUHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:07:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932167Ab0KSUHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:07:09 -0500
Date: Fri, 19 Nov 2010 12:05:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net,
        nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        lenb@kernel.org
Subject: Re: [PATCH 1/5] Backlight: Add backlight type
Message-Id: <20101119120523.15bc341c.akpm@linux-foundation.org>
In-Reply-To: <1290182036-30484-1-git-send-email-mjg@redhat.com>
References: <1290182036-30484-1-git-send-email-mjg@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010 10:53:52 -0500
Matthew Garrett <mjg@redhat.com> wrote:

> There may be multiple ways of controlling the backlight on a given machine.
> Allow drivers to expose the type of interface they are providing, making
> it possible for userspace to make appropriate policy decisions.
> 
> ...
>
>  60 files changed, 102 insertions(+), 0 deletions(-)

This patch has a pretty short half-life.

>
> ...
>
> --- a/include/linux/backlight.h
> +++ b/include/linux/backlight.h
> @@ -32,6 +32,12 @@ enum backlight_update_reason {
>  	BACKLIGHT_UPDATE_SYSFS,
>  };
>  
> +enum backlight_type {
> +	BACKLIGHT_RAW,
> +	BACKLIGHT_PLATFORM,
> +	BACKLIGHT_FIRMWARE,
> +};
> +
>  struct backlight_device;
>  struct fb_info;
>  
> @@ -62,6 +68,8 @@ struct backlight_properties {
>  	/* FB Blanking active? (values as for power) */
>  	/* Due to be removed, please use (state & BL_CORE_FBBLANK) */
>  	int fb_blank;
> +	/* Backlight type */
> +	enum backlight_type type;
>  	/* Flags used to signal drivers of state changes */
>  	/* Upper 4 bits are reserved for driver internal use */
>  	unsigned int state;

And if/when the half-life expires, we'll have drivers in-tree which
forget to set backlight_properties.type.  I haven't checked, but if
we're lucky they will default to "0".

What will be the runtime effects upon such unconverted drivers? 
Ideally we'd like them to continue to work OK, and to emit a runtime
warning.  In which case you'll need BACKLIGHT_RAW=1 so the unconverted
driver can be detected, warned about and fixed up by the core code.

