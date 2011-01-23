Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab1AWNBK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 08:01:10 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:50248 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750895Ab1AWNA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 08:00:58 -0500
Date: Sun, 23 Jan 2011 14:00:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arthur Taylor <art@ified.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] New console keyboard mode OFF
Message-ID: <20110123130052.GA1529@ucw.cz>
References: <AANLkTimqzWuGUvMo+8znuVbYocsnsJe7Heo+xY5jRrXv@mail.gmail.com>
 <20110111143417.GD22390@atrey.karlin.mff.cuni.cz>
 <AANLkTi=CqG+3aJ2yYgsMEdzQp=1Fsph-MPS5StXAVgm0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=CqG+3aJ2yYgsMEdzQp=1Fsph-MPS5StXAVgm0@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2011-01-13 03:01:48, Arthur Taylor wrote:
> > Seems very sane. Of course it all depends what a patch looks like...
> >                                                                        Pavel
> 
> Well the simple method is only 9 lines.

Cool. I guess you want to sign it off, and send it with
gregkh/akpm/alan cc-ed....

							Pavel

> diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
> index e95d787..6dd3c68 100644
> --- a/drivers/tty/vt/keyboard.c
> +++ b/drivers/tty/vt/keyboard.c
> @@ -654,7 +654,8 @@ static void k_spec(struct vc_data *vc, unsigned
> char value, char up_flag)
>  	if (value >= ARRAY_SIZE(fn_handler))
>  		return;
>  	if ((kbd->kbdmode == VC_RAW ||
> -	     kbd->kbdmode == VC_MEDIUMRAW) &&
> +	     kbd->kbdmode == VC_MEDIUMRAW ||
> +	     kbd->kbdmode == VC_OFF) &&
>  	     value != KVAL(K_SAK))
>  		return;		/* SAK is allowed even in raw mode */
>  	fn_handler[value](vc);
> @@ -1295,7 +1296,7 @@ static void kbd_keycode(unsigned int keycode,
> int down, int hw_raw)
>  	if (rc == NOTIFY_STOP)
>  		return;
> 
> -	if (raw_mode && type != KT_SPEC && type != KT_SHIFT)
> +	if ((raw_mode || kbd->kbdmode == VC_OFF) && type != KT_SPEC && type
> != KT_SHIFT)
>  		return;
> 
>  	(*k_handler[type])(vc, keysym & 0xff, !down);
> diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
> index 6b68a0f..b498b2e 100644
> --- a/drivers/tty/vt/vt_ioctl.c
> +++ b/drivers/tty/vt/vt_ioctl.c
> @@ -688,6 +688,9 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
>  			kbd->kbdmode = VC_UNICODE;
>  			compute_shiftstate();
>  			break;
> +		  case K_OFF:
> +			kbd->kbdmode = VC_OFF;
> +			break;
>  		  default:
>  			ret = -EINVAL;
>  			goto out;
> diff --git a/include/linux/kbd_kern.h b/include/linux/kbd_kern.h
> index 506ad20..4b0761c 100644
> --- a/include/linux/kbd_kern.h
> +++ b/include/linux/kbd_kern.h
> @@ -50,11 +50,12 @@ struct kbd_struct {
>  #define VC_CAPSLOCK	2	/* capslock mode */
>  #define VC_KANALOCK	3	/* kanalock mode */
> 
> -	unsigned char kbdmode:2;	/* one 2-bit value */
> +	unsigned char kbdmode:3;	/* one 3-bit value */
>  #define VC_XLATE	0	/* translate keycodes using keymap */
>  #define VC_MEDIUMRAW	1	/* medium raw (keycode) mode */
>  #define VC_RAW		2	/* raw (scancode) mode */
>  #define VC_UNICODE	3	/* Unicode mode */
> +#define VC_OFF		4	/* disabled mode */
> 
>  	unsigned char modeflags:5;
>  #define VC_APPLIC	0	/* application key mode */
> diff --git a/include/linux/kd.h b/include/linux/kd.h
> index 15f2853..c36d847 100644
> --- a/include/linux/kd.h
> +++ b/include/linux/kd.h
> @@ -81,6 +81,7 @@ struct unimapinit {
>  #define		K_XLATE		0x01
>  #define		K_MEDIUMRAW	0x02
>  #define		K_UNICODE	0x03
> +#define		K_OFF		0x04
>  #define KDGKBMODE	0x4B44	/* gets current keyboard mode */
>  #define KDSKBMODE	0x4B45	/* sets current keyboard mode */

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
