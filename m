Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966185Ab2B2AjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 19:39:23 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39753 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965411Ab2B2AjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 19:39:21 -0500
Date: Tue, 28 Feb 2012 16:39:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Igor Murzov <intergalactic.anonymous@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Igor Murzov <e-mail@date.by>, "Sergey V." <sftp.mtuci@gmail.com>
Subject: Re: [RFC][PATCH 2/2] ACPI video: Don't start video device until its
 associated input device has been reigstered
Message-ID: <20120229003915.GA11111@core.coreip.homeip.net>
References: <20120229035142.31016e6f@garik>
 <20120229035518.306c57a8@garik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120229035518.306c57a8@garik>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 03:55:18AM +0400, Igor Murzov wrote:
> From 202f25d44b1cf871697c88a6a3a8d854674db4d8 Mon Sep 17 00:00:00 2001
> From: Igor Murzov <e-mail@date.by>
> Date: Mon, 27 Feb 2012 21:57:59 +0400
> Subject: [PATCH 2/2] ACPI video: Don't start video device until its
>  associated input device has been reigstered

> 
> ---
>  drivers/acpi/video.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index 1bc6370..b9e114c 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -1659,9 +1659,6 @@ static int acpi_video_bus_add(struct acpi_device *device)
>  	error = acpi_video_bus_get_devices(video, device);
>  	if (error)
>  		goto err_free_video;
> -	error = acpi_video_bus_start_devices(video);
> -	if (error)
> -		goto err_put_video;
>  
>  	video->input = input = input_allocate_device();
>  	if (!input) {
> @@ -1703,13 +1700,18 @@ static int acpi_video_bus_add(struct acpi_device *device)
>  	if (error)
>  		goto err_free_input_dev;
>  
> +	error = acpi_video_bus_start_devices(video);
> +	if (error)
> +		goto err_unregister_pm_notifier;
> +

Registered input device should be unregistered with
input_unregister_device(), not input_free_device(). Your change breaks
this.

Also, notify() will not be called until acpi_video_bus_add() completes
so current code should be perfectly fine.

>  	return 0;
>  
> + err_unregister_pm_notifier:
> +	unregister_pm_notifier(&video->pm_nb);
>   err_free_input_dev:
>  	input_free_device(input);
>   err_stop_video:
>  	acpi_video_bus_stop_devices(video);
> - err_put_video:
>  	acpi_video_bus_put_devices(video);
>  	kfree(video->attached_array);
>   err_free_video:
> -- 
> 1.7.5.1
> 

Thanks.

-- 
Dmitry
