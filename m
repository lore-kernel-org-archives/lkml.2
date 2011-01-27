Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab1A0MFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 07:05:44 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:60819 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754637Ab1A0MFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 07:05:42 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 27 Jan 2011 13:06:03 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ping Cheng <pingc@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>, Chris Bagwell <chris@cnpbagwell.com>,
        Rafi Rubin <rafi@seas.upenn.edu>, Stephane Chatty <chatty@lii-enac.fr>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] input: mt: Add method to extract the MT slot state
Message-ID: <20110127120603.GB15626@polaris.bitmath.org>
References: <1296124547-3323-1-git-send-email-benjamin.tissoires@enac.fr>
 <1296124547-3323-2-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296124547-3323-2-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.192.164
X-Scan-Result: No virus found in message 1PiQbJ-0004MB-5H.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PiQbJ-0004MB-5H 515efe5b33b7557dcd905b0a4c7fa4ba
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

On Thu, Jan 27, 2011 at 11:35:46AM +0100, Benjamin Tissoires wrote:
> This patch adds the function input_mt_get_abs_value(), which may be

Ehm, input_mt_get_absinfo?

> used to extract the current state of the MT slots.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

I had rather re-add this myself, thanks.

> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> ---
>  drivers/input/input-mt.c |   32 ++++++++++++++++++++++++++++++++
>  include/linux/input/mt.h |    1 +
>  2 files changed, 33 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
> index c48c81f..5b95e38 100644
> --- a/drivers/input/input-mt.c
> +++ b/drivers/input/input-mt.c
> @@ -168,3 +168,35 @@ void input_mt_report_pointer_emulation(struct input_dev *dev, bool use_count)
>  	}
>  }
>  EXPORT_SYMBOL(input_mt_report_pointer_emulation);
> +
> +/**
> + * input_mt_get_absinfo - retrieve MT state variables from a device slot
> + * @dev: input device which state is being queried
> + * @code: ABS code to retrieve
> + * @slot: slot to retrieve from
> + *
> + * Return the ABS state of the given MT slot. If code is not an MT
> + * event, the corresponding ABS event is returned.
> + *
> + * This function may be called by anyone interested in extracting the
> + * current MT state. Used by evdev handlers.
> + */
> +struct input_absinfo input_mt_get_absinfo(struct input_dev *dev, unsigned int code, int slot)

Why return the struct? Give it a pointer instead, so the return value
can be used for errors.

Also, I wonder about the usefulness of extracting the absinfo here -
only the value depends on the slot argument, and absinfo does not
require the same lock protection. Why not keep the layout from the
original patch?

> +{
> +	unsigned int mtmap = code > ABS_MT_FIRST ? code - ABS_MT_FIRST : 0;

Should rather return -EINVAL on bad argument.

> +	unsigned long flags;
> +	struct input_absinfo retval;
> +
> +	spin_lock_irqsave(&dev->event_lock, flags);
> +	if (!mtmap)
> +		retval = dev->absinfo[code];
> +	else if (slot >= 0 && slot < dev->mtsize) {
> +		retval = dev->absinfo[code];
> +		retval.value = dev->mt[slot].abs[mtmap];

Please use input_mt_get_value().

> +	} else
> +		retval.value = 0;
> +	spin_unlock_irqrestore(&dev->event_lock, flags);
> +
> +	return retval;
> +}
> +EXPORT_SYMBOL(input_mt_get_absinfo);
> diff --git a/include/linux/input/mt.h b/include/linux/input/mt.h
> index b3ac06a..a71a27f 100644
> --- a/include/linux/input/mt.h
> +++ b/include/linux/input/mt.h
> @@ -54,4 +54,5 @@ void input_mt_report_slot_state(struct input_dev *dev,
>  void input_mt_report_finger_count(struct input_dev *dev, int count);
>  void input_mt_report_pointer_emulation(struct input_dev *dev, bool use_count);
>  
> +struct input_absinfo input_mt_get_absinfo(struct input_dev *dev, unsigned int code, int slot);
>  #endif

Thanks,
Henrik
