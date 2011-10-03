Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab1JCJBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:01:15 -0400
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:56902 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab1JCJBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:01:03 -0400
X-SENDER-IP: [85.230.28.149]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhVcAM14iU5V5hyVPGdsb2JhbABCiSyeZhkBAQEBNzKBTAcBAQQBJxMcIwULCAMOOBQlChoTh3sCuFAOhjJhBJkTjA0
X-IronPort-AV: E=Sophos;i="4.68,478,1312149600"; 
   d="scan'208";a="486998646"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 3 Oct 2011 11:06:41 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: evdev - use monotonic clock for event timestamps
Message-ID: <20111003090641.GA5615@polaris.bitmath.org>
References: <1317624200-9762-1-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317624200-9762-1-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> Using wallclock time for event timestamps subjects inter-event timing to
> ntp and other clock adjustments.  This complicates userspace drivers
> that use these timestamps to calculate velocities, or while processing
> state transitions.
> 
> Instead, use the kernel monotonic clock for event timestamps, which is
> at least guaranteed never to go backwards.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/input/evdev.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index 4cf2534..118f936 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -94,8 +94,11 @@ static void evdev_event(struct input_handle *handle,
>  	struct evdev *evdev = handle->private;
>  	struct evdev_client *client;
>  	struct input_event event;
> +	struct timespec now;
>  
> -	do_gettimeofday(&event.time);
> +	getrawmonotonic(&now);
> +	event.time.tv_sec = now.tv_sec;
> +	event.time.tv_usec = now.tv_nsec/1000;
>  	event.type = type;
>  	event.code = code;
>  	event.value = value;
> -- 
> 1.7.3.1

Good thing per se, but reporting time relative to boot instead of
using real time, for all input events, may cause regression on some
obscure systems. Perhaps it is possible to improve on the desired
monotonicity in most cases, without such a drastic change.

Thanks,
Henrik
