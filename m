Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab1H2QyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:54:04 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:22119 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab1H2QyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:54:01 -0400
Date: Mon, 29 Aug 2011 18:53:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Cheng Renquan <crquan@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nir Tzachar <nir.tzachar@gmail.com>
Subject: Re: [RFC] nconf bug fixes and improvements
Message-ID: <20110829165359.GA8872@merkur.ravnborg.org>
References: <CAH5vBdKxbaKDrA2gAj5CoDYShN+5dnfu6Bmd=4+oV-XmnYQnFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH5vBdKxbaKDrA2gAj5CoDYShN+5dnfu6Bmd=4+oV-XmnYQnFA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cheng.

On Mon, Aug 29, 2011 at 02:09:59AM -0700, Cheng Renquan wrote:
> bug fixes:
> 1) char dialog_input_result[256]; is not enough for config item like:
>    CONFIG_EXTRA_FIRMWARE="iwlwifi-100-5.ucode iwlwifi-1000-3.ucode
> iwlwifi-3945-2.ucode iwlwifi-4965-2.ucode iwlwifi-5000-1.ucode
> iwlwifi-5000-2.ucode iwlwifi-5150-2.ucode iwlwifi-6000-4.ucode
> iwlwifi-6000g2a-5.ucode iwlwifi-6000g2b-5.ucode iwlwifi-6050-4.ucode
> iwlwifi-6050-5.ucode radeon/CEDAR_me.bin radeon/CEDAR_pfp.bin
> radeon/CEDAR_rlc.bin radeon/CYPRESS_me.bin radeon/CYPRESS_pfp.bin
> radeon/CYPRESS_rlc.bin radeon/JUNIPER_me.bin radeon/JUNIPER_pfp.bin
> radeon/JUNIPER_rlc.bin radeon/R600_rlc.bin radeon/R700_rlc.bin
> radeon/REDWOOD_me.bin radeon/REDWOOD_pfp.bin radeon/REDWOOD_rlc.bin"
> 
>    the original nconf just stack overflow / crashed when dealing with
> longer than 256 bytes strings; Since the original menuconfig also just
> uses a fixed length buffer [MAX_LEN=2048] which works for the years,
> here I just append a 0 make it work in the easiest way; if required,
> it could also be changed to a dynamically allocated buffer;
> 
>    char dialog_input_result[MAX_LEN + 1];

Please do not repeat errors from the past.
Fix this to allocate the string so we handle strings of
unlimited length.

> 2) memmove's 3rd argument should be len-cursor_position+1, the
> original len+1 may cause segment fault in theory;
>  				memmove(&result[cursor_position+1],
>  						&result[cursor_position],
> -						len+1);
> +						len-cursor_position+1);
Looks OK - but I did not check in detail.

> 
> 3) typo:
> 
> -				mvprintw(0, 0, "unknow key: %d\n", res);
> +				mvprintw(0, 0, "unknown key: %d\n", res);
> 
ACK

> 
> improvement:
> 1) its original conf_string doesn't work with longer string values
> (longer than its dialog box width), not at all
>    (or may work in an invisible way if anyone has tried that)
>    Here I added a new variable cursor_form_win to record that new state:
>    cursor of the input box; and make it fun:
>    when you move cursor to almost left/right edge, it auto adjust text
> to center, by half prompt box width;
Sounds resonable - but did not try it.

> 
> 2) Remove KEY_UP as RIGHT and KEY_DOWN as LEFT,
Why?
>    Add Home/End to locate the string begin/end;
OK
>    Emacs-like key bind (C-a/C-e as Home/End, C-f/C-b as forward/backward);
No other part of nconf is emacs-lke - so please no.

> --- /mnt/static/usr/src/linux-3.0-gentoo-r1/scripts/kconfig/nconf.gui.c	2011-07-21
> 19:17:23.000000000 -0700
> +++ /mnt/dynamic/usr/src/linux-3.0-gentoo-r1/scripts/kconfig/nconf.gui.c	2011-08-28
> 18:00:56.441862565 -0700
> @@ -367,7 +367,15 @@ int dialog_inputbox(WINDOW *main_window,
>  	int i, x, y;
>  	int res = -1;
>  	int cursor_position = strlen(init);
> +	int cursor_form_win;
> 
> +	if (strlen(init) +80 > result_len) {
No hardcoded number please. And be consistent with use of spaces.

> +		(void) attrset(attributes[FUNCTION_HIGHLIGHT] | A_BLINK);
> +		mvprintw(0, 0, "result_len(%d) not enough to contain
> init_strlen(%d) in %s:%d:%s\n",
> +			 result_len, strlen(init),
> +			 __FILE__, __LINE__, __func__);
> +		flash();
> +	}
What is the purpose of this statement - does not look clear to me.

Did not look at the rest of the patch - awiting a split-up version.

	Sam
