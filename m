Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab0HWC2k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 22:28:40 -0400
Received: from webmail.ict.ac.cn ([159.226.39.7]:53305 "EHLO ict.ac.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751371Ab0HWC2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 22:28:37 -0400
X-Greylist: delayed 1243 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Aug 2010 22:28:36 EDT
Message-ID: <4C71D37D.4030202@loongson.cn>
Date: Mon, 23 Aug 2010 09:48:45 +0800
From: =?GB2312?B?x8ez5w==?= <qiaochong@loongson.cn>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Francisco Jerez <currojerez@riseup.net>
CC: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] vt: Fix console corruption on driver hand-over.
References: <1282491444-25364-1-git-send-email-currojerez@riseup.net>
In-Reply-To: <1282491444-25364-1-git-send-email-currojerez@riseup.net>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes,I have tested this patch,it can work and also fix the bug
02f0777a0d6560eb995aade34a1b82f95c0452da mentioned.

Francisco Jerez Ð´µÀ:
> After 02f0777a0d6560eb995aade34a1b82f95c0452da "vc_origin" is no
> longer reset to the screen buffer before calling the con_init() hook
> of the new console driver.
>
> If the old driver wasn't using a fixed scanout buffer (e.g. the case
> of vgacon) "vc_origin" may be a pointer to a VRAM location, and its
> contents aren't guaranteed to be preserved after calling con_deinit()
> on the old driver and con_init() on the new driver, i.e. the
> subsequent console resize may fill the framebuffer with garbage.
>
> It can be reproduced in the transition from vgacon to the nouveau
> framebuffer driver: in that case the legacy VGA aperture "vc_origin"
> points to becomes unreadable after fbcon_init().
>
> This patch reverts the mentioned commit. To avoid the problem it
> intended to fix, stop using "vc_scr_end" in vc_do_resize() to
> calculate how many rows we have to copy (actually the code looks
> simpler this way without the help of "vc_scr_end").
>
> Signed-off-by: Francisco Jerez <currojerez@riseup.net>
> Cc: qiaochong <qiaochong@loongson.cn>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Alan Cox <alan@linux.intel.com>
> ---
>  drivers/char/vt.c |   15 ++++-----------
>  1 files changed, 4 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/char/vt.c b/drivers/char/vt.c
> index c734f9b..62bd073 100644
> --- a/drivers/char/vt.c
> +++ b/drivers/char/vt.c
> @@ -905,22 +905,16 @@ static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
>  			 * bottom of buffer
>  			 */
>  			old_origin += (old_rows - new_rows) * old_row_size;
> -			end = vc->vc_scr_end;
>  		} else {
>  			/*
>  			 * Cursor is in no man's land, copy 1/2 screenful
>  			 * from the top and bottom of cursor position
>  			 */
>  			old_origin += (vc->vc_y - new_rows/2) * old_row_size;
> -			end = old_origin + (old_row_size * new_rows);
>  		}
> -	} else
> -		/*
> -		 * Cursor near the top, copy contents from the top of buffer
> -		 */
> -		end = (old_rows > new_rows) ? old_origin +
> -			(old_row_size * new_rows) :
> -			vc->vc_scr_end;
> +	}
> +
> +	end = old_origin + old_row_size * min(old_rows, new_rows);
>  
>  	update_attr(vc);
>  
> @@ -3074,8 +3068,7 @@ static int bind_con_driver(const struct consw *csw, int first, int last,
>  
>  		old_was_color = vc->vc_can_do_color;
>  		vc->vc_sw->con_deinit(vc);
> -		if (!vc->vc_origin)
> -			vc->vc_origin = (unsigned long)vc->vc_screenbuf;
> +		vc->vc_origin = (unsigned long)vc->vc_screenbuf;
>  		visual_init(vc, i, 0);
>  		set_origin(vc);
>  		update_attr(vc);
>   

