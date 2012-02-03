Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab2BCWZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 17:25:29 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:37311 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753614Ab2BCWZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 17:25:28 -0500
Message-ID: <4F2C5EC8.8090203@metafoo.de>
Date: Fri, 03 Feb 2012 23:25:12 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 2/3] apple_bl: Rework in advance of gmux backlight support
References: <1328300884-21551-1-git-send-email-seth.forshee@canonical.com> <1328300884-21551-3-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1328300884-21551-3-git-send-email-seth.forshee@canonical.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2012 09:28 PM, Seth Forshee wrote:
> Make it easier to support backlights without a fixed I/O range, and
> remove use of global variables to allow having multiple backlights
> concurrently.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/video/backlight/apple_bl.c |  163 +++++++++++++++++++-----------------
>  1 files changed, 85 insertions(+), 78 deletions(-)
> 
> diff --git a/drivers/video/backlight/apple_bl.c b/drivers/video/backlight/apple_bl.c
> index 66d5bec..e65b459 100644
> --- a/drivers/video/backlight/apple_bl.c
> +++ b/drivers/video/backlight/apple_bl.c
> @@ -27,39 +27,30 @@
>  #include <linux/pci.h>
>  #include <linux/acpi.h>
> [...]
> + */
> +static int apple_bl_get_brightness(struct backlight_device *bd)
> +{
> +	struct apple_bl_data *bl_data = bl_get_data(bd);
> +	return bl_data->get_brightness(bl_data);
> +}
> +
> +static int apple_bl_update_status(struct backlight_device *bd)
> +{
> +	struct apple_bl_data *bl_data = bl_get_data(bd);
> +
> +	bl_data->set_brightness(bl_data, bd->props.brightness);
> +	return 0;
> +}
> +
> +static const struct backlight_ops apple_bl_ops = {
> +	.get_brightness = apple_bl_get_brightness,
> +	.update_status = apple_bl_update_status,
>  };

Adding this extra indirection here isn't so nice and isn't necessary either.
Just define one set of backlight ops for the intel case and one for the nvidia
case and use it accordingly when registering the backlight device.

