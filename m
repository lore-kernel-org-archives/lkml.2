Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab0IASBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 14:01:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54528 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab0IASBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 14:01:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ICaP804lg9hCAKe4+UrfZAndpwThha0w7tx2+HORpssGvAbRkIeCvGkynQTi8hxAE0
         CdOu25JLvjFIi+qhI5V2G0Lsh2IE7+Go4ScyjqZGTWHMtt2xkcmwd2eJXmTVJHAfs1nh
         gOqrN9o9PSbAD6k64ZoNQMa5pHIj6dqATHPkM=
Message-ID: <4C7E94F6.9050806@gmail.com>
Date: Wed, 01 Sep 2010 20:01:26 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: Jiri Kosina <jkosina@suse.cz>, Michael Poole <mdpoole@troilus.org>,
        Henrik Rydberg <rydberg@euromail.se>, Tejun Heo <tj@kernel.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7 v3] HID: magicmouse: don't allow hidinput to initialize
 the device
References: <1283306184-28833-1-git-send-email-chase.douglas@canonical.com> <1283306184-28833-2-git-send-email-chase.douglas@canonical.com>
In-Reply-To: <1283306184-28833-2-git-send-email-chase.douglas@canonical.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2010 03:56 AM, Chase Douglas wrote:
> From: Chase Douglas <chase.douglas@ubuntu.com>
> 
> The driver listens only for raw events from the device. If we allow
> the hidinput layer to initialize, we can hit NULL pointer dereferences
> in the hidinput layer because disconnecting only removes the hidinput
> devices from the hid device while leaving the hid fields configured.
> 
> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> Acked-by: Michael Poole <mdpoole@troilus.org>
> ---
>  drivers/hid/hid-magicmouse.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
> index 319b0e5..d38b529 100644
> --- a/drivers/hid/hid-magicmouse.c
> +++ b/drivers/hid/hid-magicmouse.c
> @@ -404,15 +404,20 @@ static int magicmouse_probe(struct hid_device *hdev,
>  		goto err_free;
>  	}
>  
> -	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
> +	/* When registering a hid device, one of hidinput, hidraw, or hiddev
> +	 * subsystems must claim the device. We are bypassing hidinput due to
> +	 * our raw event processing, and hidraw and hiddev may not claim the
> +	 * device. We get around this by telling hid_hw_start that input has
> +	 * claimed the device already, and then flipping the bit back.
> +	 */
> +	hdev->claimed = HID_CLAIMED_INPUT;
> +	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT & ~HID_CONNECT_HIDINPUT);
> +	hdev->claimed &= ~HID_CLAIMED_INPUT;

This looks weird. Is there any past discussion about why you cannot use
hidinput and you have to do all the input bits yourself while cheating
this very weird way?

thanks,
-- 
js
