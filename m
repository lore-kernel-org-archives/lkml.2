Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab2ICM7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 08:59:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63512 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab2ICM7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 08:59:05 -0400
MIME-Version: 1.0
In-Reply-To: <1346528835-363-21-git-send-email-rydberg@euromail.se>
References: <1346528835-363-1-git-send-email-rydberg@euromail.se>
	<1346528835-363-21-git-send-email-rydberg@euromail.se>
Date: Mon, 3 Sep 2012 14:59:03 +0200
X-Google-Sender-Auth: hbMOdWeokPYhQZ2SZ08cRNdJae4
Message-ID: <CAN+gG=FwXaSWN_AYnU7Vpxn4GcWYG3Bf100P0QD_8cQfEnGc7A@mail.gmail.com>
Subject: Re: [PATCH 20/20] HID: hid-multitouch: Add missing contact count detection
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 1, 2012 at 9:47 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Some devices report the number of contacts via the CONTACTCOUNT usage,
> rather than using the CONTACTMAX feature. Without this patch, such
> devices will be capped to ten fingers, the default maximum. Fixes a
> long-standing regression on 3M and similar panels.
>
> Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Since this patch looks like it could be backported as-is: In 3.6,
> maxcontacts may be modified after the slots have been initialized,
> leaving the patch harmless but ineffective.
>
>  drivers/hid/hid-multitouch.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index eee19c9..2fc5335 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -388,6 +388,8 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>                         td->last_field_index = field->index;
>                         return 1;
>                 case HID_DG_CONTACTCOUNT:
> +                       if (td->maxcontacts < field->logical_maximum + 1)
> +                               td->maxcontacts = field->logical_maximum + 1;

Hi Henrik,

Unfortunately, this is not working. We have bad devices that present either:
- a null logical_maximum (some Stantum do) -> the value 1 is assigned
to maxcontacts, and the device is turned into a mono touch....
- an obviously wrong value (with respect to the current state of the
devices) -> Quanta devices report 255 there.... and they support only
2 touches....

And of course, 3M decided to stop sending 60 touches on their recent
devices: we have here a 0x506 device that present a contact_count of
max 60, a maximum contact feature of max 60, but whatever I'm doing,
it does not want to send more than 10 touches....

Cheers,
Benjamin

>                         td->last_field_index = field->index;
>                         return 1;
>                 case HID_DG_CONTACTMAX:
> --
> 1.7.12
>
