Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab0ELM6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 08:58:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41105 "EHLO mx2.suse.de"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753611Ab0ELM6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 08:58:33 -0400
Date: Wed, 12 May 2010 14:58:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       mdpoole@troilus.org
Subject: Re: [PATCH] HID:magicmouse: This fixes a connection problem with
 the magicmouse.
In-Reply-To: <1273595363-4020-1-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1005121456150.28092@pobox.suse.cz>
References: <1273595363-4020-1-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010, Justin P. Mattock wrote:

> With the latest HEAD, I've noticed that I needed to add: HIDRAW=y in 
> order for my apple magicmouse to connect. After receiving some posts, it 
> seems this it not the case(HIDRAW just relays HID events to userspace).
> 
> The bisect results of this issue resulted in commit: HID:magicmouse: fix 
> oops after device removal. 
> (hash:28918c211d86b6eeb70182c523800c7bc442960c)
> 
> After examining this commit, I've noticed that HID_CONNECT_DEFAULT has 
> also an entry in there of HID_CONNECT_HIDINPUT, not sure what "~" means,

~ is zeroing out the HID_CONENCT_HIDINPUT bits from the connect mask, as 
magicmouse driver is handling the input itself.

> before HID_CONNECT_HIDINPUT, but after removing
> this(correct me if I'm wrong)"double" definition, 
> I'm able to have my magicmouse connect without the 
> need of HIDRAW, and also this in dmesg:
> 
> magicmouse 0005:05AC:030D.0004: claimed by neither input, hiddev nor hidraw
> magicmouse 0005:05AC:030D.0004: magicmouse hw start failed
> 
> and as well as the crash that the above commit fixes when waking
> up from suspend(mouse connects perfectly upon wakeup).
> 
> Please have a look, and if this works, take it
> if theres another solution let me know.
> (so I can enjoy the power of the magicmouse!!).
> 
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/hid/hid-magicmouse.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
> index 0d471fc..0de5e96 100644
> --- a/drivers/hid/hid-magicmouse.c
> +++ b/drivers/hid/hid-magicmouse.c
> @@ -354,7 +354,7 @@ static int magicmouse_probe(struct hid_device *hdev,
>  		goto err_free;
>  	}
>  
> -	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT & ~HID_CONNECT_HIDINPUT);
> +	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);

This is not particularly right, as we'll end up having dangling input 
device.

The problem is, that when HIDRAW is not set, hid_hw_start() returns ENODEV 
as no subsystem has claimed the device, and probe routine bails out. Which 
is not what we want.

Does the testing patch below fix the problems you are seeing?



diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 0d471fc..f10d56a 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -354,12 +354,15 @@ static int magicmouse_probe(struct hid_device *hdev,
 		goto err_free;
 	}
 
-	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT & ~HID_CONNECT_HIDINPUT);
+	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (ret) {
 		dev_err(&hdev->dev, "magicmouse hw start failed\n");
 		goto err_free;
 	}
 
+	/* we are handling the input ourselves */
+	hidinput_disconnect(hdev);
+
 	report = hid_register_report(hdev, HID_INPUT_REPORT, TOUCH_REPORT_ID);
 	if (!report) {
 		dev_err(&hdev->dev, "unable to register touch report\n");

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
