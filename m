Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab2LRVYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 16:24:12 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:59969 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab2LRVYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 16:24:08 -0500
Date: Tue, 18 Dec 2012 22:24:05 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Shawn Nematbakhsh <shawnn@chromium.org>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atkbd: Fix multi-char scancode handling on reconnect.
In-Reply-To: <1355530643-8177-1-git-send-email-shawnn@chromium.org>
Message-ID: <alpine.LNX.2.00.1212182222560.14788@swampdragon.chaosbits.net>
References: <1355530643-8177-1-git-send-email-shawnn@chromium.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2012, Shawn Nematbakhsh wrote:

> On resume from suspend there is a possibility for multi-byte scancodes
> to be handled incorrectly. atkbd_reconnect disables the processing of
> scancodes in software by calling atkbd_disable, but the keyboard may
> still be active because no disconnect command was sent. Later, software
> handling is re-enabled. If a multi-byte scancode sent from the keyboard
> straddles the re-enable, only the latter byte(s) will be handled.
> 
> In practice, this leads to cases where multi-byte break codes (ex. "e0
> 4d" - break code for right-arrow) are misread as make codes ("4d" - make
> code for numeric 6), leading to one or more unwanted, untyped characters
> being interpreted.
> 
> The solution implemented here involves sending command f5 (reset
> disable) to the keyboard prior to disabling software handling of codes.
> Later, the command to re-enable the keyboard is sent only after we are
> prepared to handle scancodes.
> 
> Signed-off-by: Shawn Nematbakhsh <shawnn@chromium.org>
> ---
>  drivers/input/keyboard/atkbd.c |   26 ++++++++++++++++++++++++--
>  1 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
> index add5ffd..da49e8b 100644
> --- a/drivers/input/keyboard/atkbd.c
> +++ b/drivers/input/keyboard/atkbd.c
> @@ -844,6 +844,24 @@ static int atkbd_activate(struct atkbd *atkbd)
>  }
>  
>  /*
> + * atkbd_deactivate() resets and disables the keyboard from sending
> + * keystrokes.
> + */
> +static int atkbd_deactivate(struct atkbd *atkbd)

Why bother with a return type when you never check it anyway?
I'd say, either check for the 0/-1 you return and do something sensible or 
just let it return void.

> +{
> +	struct ps2dev *ps2dev = &atkbd->ps2dev;
> +
> +	if (ps2_command(ps2dev, NULL, ATKBD_CMD_RESET_DIS)) {
> +		dev_err(&ps2dev->serio->dev,
> +			"Failed to deactivate keyboard on %s\n",
> +			ps2dev->serio->phys);
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
>   * atkbd_cleanup() restores the keyboard state so that BIOS is happy after a
>   * reboot.
>   */
> @@ -1199,6 +1217,9 @@ static int atkbd_reconnect(struct serio *serio)
>  
>  	mutex_lock(&atkbd->mutex);
>  
> +	if (atkbd->write)
> +		atkbd_deactivate(atkbd);
> +
>  	atkbd_disable(atkbd);
>  
>  	if (atkbd->write) {
> @@ -1208,8 +1229,6 @@ static int atkbd_reconnect(struct serio *serio)
>  		if (atkbd->set != atkbd_select_set(atkbd, atkbd->set, atkbd->extra))
>  			goto out;
>  
> -		atkbd_activate(atkbd);
> -
>  		/*
>  		 * Restore LED state and repeat rate. While input core
>  		 * will do this for us at resume time reconnect may happen
> @@ -1224,6 +1243,9 @@ static int atkbd_reconnect(struct serio *serio)
>  	}
>  
>  	atkbd_enable(atkbd);
> +	if (atkbd->write)
> +		atkbd_activate(atkbd);
> +
>  	retval = 0;
>  
>   out:
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

