Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab0K0Hzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 02:55:39 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54025 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0K0Hzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 02:55:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oEM4CsVjx0np8QrniRnmsBSEcPQDpq7E6wE9bxwvS2JEyIduV/NaCczHUwNAzFEs/k
         D/y/fsmqVfvAwwSUq9pOWWxK04N3bTwTVKp/obbi4QXKItrkz7CAY+s0scsQ28vNFj0C
         0kQoktmMZUTOQu87vianEZDpQsDrKE8DCrHq0=
Date: Fri, 26 Nov 2010 23:55:28 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Yan Li <yan.i.li@intel.com>
Cc: linux-input@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        jian-feng.ding@intel.com, linux-kernel@vger.kernel.org,
        meego-kernel@lists.meego.com,
        Christopher Heiny <christopherheiny@gmail.com>
Subject: Re: [PATCH] Input: Lenovo S10-3t's touchpad support
Message-ID: <20101127075528.GA28667@core.coreip.homeip.net>
References: <aefc1833eeede37ae6ea4a9ddeaa602eb7d31101.1290823698.git.yan.i.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aefc1833eeede37ae6ea4a9ddeaa602eb7d31101.1290823698.git.yan.i.li@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yan,

On Sat, Nov 27, 2010 at 11:56:59AM +0800, Yan Li wrote:
> This is for kernel bug #18122 and MeeGo bug #4807.
> 
> Current code detects Clickpad by checking the 8 and 20 bits of 0x0c
> cap. However, the code returns true if either of those bits is 1,
> while it should only return true when both are 1. This has lead to the
> touchpad on Lenovo S10-3t be mistakenly recognized as Clickpad and its
> BTN_LEFT and BTN_RIGHT blocked.
> 
> So far we've found that the S10-3ts are shipped with two slightly
> different models of touchpads, of which the 0x0c cap is either
> 0x5a0400 or 0x4a0500. They are not Clickpad and return BTN_LEFT and
> BTN_RIGHT normally.

Hmm, this is weird. According to my data:

>> Treat it as a two-bit field.
>>   0x00 == not a clickpad
>>   0x01 == 1 button clickpad
>>   0x02 == 2 button clickpad
>>   0x03 == reserved

Moreover, Takashi's HP returns 0x5a 0x04 0x00 in response to 0x0c query
and _is_ a clickpad.

Christopher, was there any more updates to the protocol by any chance?

> 
> This patch fixed this issue by checking both sign bits are 1. Tested
> on my S10-3t and worked well.
> 
> Signed-off-by: Yan Li <yan.i.li@intel.com>
> ---
>  drivers/input/mouse/synaptics.h |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
> index 613a365..0c1083c 100644
> --- a/drivers/input/mouse/synaptics.h
> +++ b/drivers/input/mouse/synaptics.h
> @@ -51,7 +51,11 @@
>  #define SYN_EXT_CAP_REQUESTS(c)		(((c) & 0x700000) >> 20)
>  #define SYN_CAP_MULTI_BUTTON_NO(ec)	(((ec) & 0x00f000) >> 12)
>  #define SYN_CAP_PRODUCT_ID(ec)		(((ec) & 0xff0000) >> 16)
> -#define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100100)
> +/* Synaptics' ClickPad has both 8th and 20th bits set in the 0x0c
> + * cap. Other models (like those shipped with Lenovo S10-3t) may have
> + * either one of them set but not both, and they are *not* ClickPad
> + * although they look similar. */
> +#define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100100 == 0x100100)

In C comparison operators have higher precedence than bitwise ones. Your
expression reduces to ((ex0c) & 1) which is not correct. The proper
expression would be:

#define SYN_CAP_CLICKPAD(ex0c)		(((ex0c) & 0x100100) == 0x100100)

but it really contradicts the data I have...

Thanks.

-- 
Dmitry
