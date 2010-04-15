Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab0DOXZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:25:40 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:63981 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab0DOXZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:25:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YBWf/MlwELiad+DEGl90u6xGjzOU11/GvsWv7PuHaFD8zZWQE2ApbkTBQ7Sdo8gwmR
         kYS2uiDh0GwBbGfdU+U576j84jIR+8SIP5xV1a0tT4cy6wx1ToWQtLQRzx/qIoJv1Led
         kiryLDxrSxoArYQsJqxCGJFoyofXgZ1ZvTwI8=
Date: Thu, 15 Apr 2010 16:25:25 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: introduce MT event slots
Message-ID: <20100415232523.GA18263@core.coreip.homeip.net>
References: <1270685590-2204-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270685590-2204-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Thu, Apr 08, 2010 at 02:13:10AM +0200, Henrik Rydberg wrote:
> With the rapidly increasing number of intelligent multi-contact and
> multi-user devices, the need to send digested, filtered information
> from a set of different sources within the same device is imminent.
> This patch adds the concept of slots to the MT protocol. The slots
> enumerate a set of identified sources, such that all MT events
> can be passed independently and selectively per identified source.
> 
> The protocol works like this: Instead of sending a SYN_MT_REPORT
> event immediately after the contact data, one sends a SYN_MT_SLOT
> event immediately before the contact data. The input core will only
> emit events for the slots corresponding to the contacts that have
> changed. It is assumed that the same slot is used for the duration
> of an initiated contact.
> 

I see the reason for doing this however I would like to hold off
applying it till we get a couple of users and prove that the scheme
works well for them.

> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/input/input.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/input.h |   26 ++++++++++++++++++++
>  2 files changed, 88 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index afd4e2b..217e976 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -181,6 +181,22 @@ static void input_stop_autorepeat(struct input_dev *dev)
>  #define INPUT_PASS_TO_DEVICE	2
>  #define INPUT_PASS_TO_ALL	(INPUT_PASS_TO_HANDLERS | INPUT_PASS_TO_DEVICE)
>  
> +static void input_handle_mt_event(struct input_dev *dev,
> +				  unsigned int code, int value)
> +{
> +	int oldval = dev->mt[dev->slot].abs[code];

A temp for dev->mt[dev->slot] might be nice.

>  
> +/**
> + * struct input_mt_slot - represents the state of an MT input slot
> + * @abs: current values from absolute axes for this slot
> + */
> +struct input_mt_slot {
> +	int abs[ABS_MAX + 1];
> +};

It would be nice to use abs[ABS_MT_MAX - ABS_MT_TOUCH_MAJOR] to save
some memory.

-- 
Dmitry
