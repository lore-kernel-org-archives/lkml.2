Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab0CUHYj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 03:24:39 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62877 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab0CUHYh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 03:24:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S71WaqyIkOrzLBF3hyXkED6BNWy7E7oYzVcSVy4AESFM47Y/N42r7G8tlipOMPx99X
         y7OK984w3K4Lxo5eZueRfXJsEI6g8jpkDpl6IkR+n8NNIMA4ggKh3vSNAuI6SeVicGgd
         +tgvQ/VAsjX7J1ju8B8vSvJWglfmb2g8plKhY=
MIME-Version: 1.0
In-Reply-To: <20100320170415.6ee219c8@neptune.home>
References: <20100320170014.440959a8@neptune.home>
	 <20100320170415.6ee219c8@neptune.home>
Date: Sun, 21 Mar 2010 15:24:36 +0800
Message-ID: <45a44e481003210024l2c66938fp9436d34f6473f811@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] hid: add framebuffer support to PicoLCD device
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bruno,

On Sun, Mar 21, 2010 at 12:04 AM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
> Add framebuffer support to PicoLCD device with use of deferred-io.
>
> Only changed areas of framebuffer get sent to device in order to
> save USB bandwidth and especially resources on PicoLCD device or
> allow higher refresh rate for a small area.

Interesting work. One minor comment, defio doesn't currently guarantee
that it is "changed areas". Just that it is "written" pages which
typically equates to "changed" but does not guarantee this.

>
> Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
> ---
>  drivers/hid/Kconfig       |    7 +-
>  drivers/hid/hid-picolcd.c |  454 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 460 insertions(+), 1 deletions(-)

It is customary for framebuffer drivers to live in drivers/video. This
is the first one I've reviewed that is outside of it. Is there a good
reason for this one to be outside of it? If so, could you put it in
the comments.

>
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 7097f0a..a474bcd 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -230,6 +230,11 @@ config HID_PETALYNX
>  config HID_PICOLCD
>        tristate "PicoLCD (graphic version)"
>        depends on USB_HID
> +       select FB_DEFERRED_IO if FB
> +       select FB_SYS_FILLRECT if FB
> +       select FB_SYS_COPYAREA if FB
> +       select FB_SYS_IMAGEBLIT if FB
> +       select FB_SYS_FOPS if FB

I think all of that "if FB" stuff looks odd, it would disappear if it
were in the right Kconfig.

> +/* Framebuffer visual structures */
> +static const struct fb_fix_screeninfo picolcdfb_fix = {
> +       .id          = PICOLCDFB_NAME,
> +       .type        = FB_TYPE_PACKED_PIXELS,
> +       .visual      = FB_VISUAL_MONO01,

Interesting choice. Out of curiosity, which fb client application are
you testing/using this with?

> +       /*
> +        * Translate the XBM format screen_base into the format needed by the
> +        * PicoLCD. See display layout above.
> +        * Do this one tile after the other and push those tiles that changed.
> +        */

I think screen_base is in standard fb format, which you've specified
as MONO01 above. When you say, XBM format, in the above comment is it
exactly the same?

Thanks,
jaya
