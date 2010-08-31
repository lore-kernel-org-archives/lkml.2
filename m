Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab0IAAKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 20:10:16 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:57243 "HELO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752248Ab0IAAKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 20:10:15 -0400
Subject: Re: [PATCH 1/6 v2] HID: magicmouse: don't allow hidinput to
 initialize the device
From: Michael Poole <mdpoole@troilus.org>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Henrik Rydberg <rydberg@euromail.se>,
        Tejun Heo <tj@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1283280068-12285-1-git-send-email-chase.douglas@canonical.com>
References: <1283280068-12285-1-git-send-email-chase.douglas@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 19:45:54 -0400
Message-ID: <1283298354.13785.2.camel@graviton>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 14:41 -0400, Chase Douglas wrote:
> From: Chase Douglas <chase.douglas@ubuntu.com>
> 
> The driver listens only for raw events from the device. If we allow
> the hidinput layer to initialize, we can hit NULL pointer dereferences
> in the hidinput layer because disconnecting only removes the hidinput
> devices from the hid device while leaving the hid fields configured.
> 
> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> ---
> Note that this mimics what the hid-picolcd module does.

Thanks, this approach makes sense to me.

Acked-by: Michael Poole <mdpoole@troilus.org>

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
>  	if (ret) {
>  		dev_err(&hdev->dev, "magicmouse hw start failed\n");
>  		goto err_free;
>  	}
>  
> -	/* we are handling the input ourselves */
> -	hidinput_disconnect(hdev);
> -
>  	report = hid_register_report(hdev, HID_INPUT_REPORT, TOUCH_REPORT_ID);
>  	if (!report) {
>  		dev_err(&hdev->dev, "unable to register touch report\n");


