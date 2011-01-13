Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab1AMGDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 01:03:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46130 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab1AMGDp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 01:03:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vllpCrkZshE0jWy+JcF3ZWajztKHEvpYtD69ayU354XiDlGBU9UT6jxj45l/FkwvBc
         h5G4j5sLIDS2mVV7q81k1BOvytpHwX5X3DQ+917lDGQ6gGLF6psu7NMfgUvUIFUnBlQi
         rGDwSP5jGa8kjwIRsk8rZ5qnw6pmyP+MGv4zc=
MIME-Version: 1.0
In-Reply-To: <20110112221443.GA574@alchark-u3s>
References: <20110112221443.GA574@alchark-u3s>
Date: Thu, 13 Jan 2011 07:03:43 +0100
X-Google-Sender-Auth: U2Qv6yoELKjBYSQ9nOvW13bbxxQ
Message-ID: <AANLkTimRVSB13X67vz_qg_CpTg1J2fNz5A0Oweq3MZp1@mail.gmail.com>
Subject: Re: [PATCH] fbdev: Implement simple blanking in pseudocolor modes for vt8500lcdfb
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexey Charkov <alchark@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 23:14, Alexey Charkov <alchark@gmail.com> wrote:
> Implement simple blanking in pseudocolor modes for vt8500lcdfb
>
> This follows the style of some other in-tree drivers by just setting
> the hardware palette colors to all black. True Color modes are not
> affected, but this at least allows to run xf86-video-fbdev without
> errors due to blanking being unimplemented.

Hmm, I seemed to remember this was handled at the generic level if no .fb_blank
implementation was present? That's why e.g. vesafb and macfb don't
have an fb_blank
implementation, while people run/ran X on them for sure.

[ looking in the code and its history ]

According to full-history-linux, it was removed by:

ommit ca2efeeb715e9fc0f12e57b54ba43ee1e1e50524
Author: Antonino Daplas <adaplas@hotpop.com>
Date:   Sun Nov 7 04:05:04 2004 -0800

    [PATCH] fbcon: "Do not touch hardware if vc_mode != KD_TEXT: fix

    Sigh, this patch uncovered a can of worms.  I tested different combinations,
    those with/without xxxfb_blank implementation, framebuffers in directcolor
    or truecolor, etc. I find that there is a problem unblanking if the hardware
    has no xxxfb_blank() implementation, and also that the generic fb_blank() in
    fbmem.c is problematic with drivers in directcolor or pseudocolor mode when
    called by an fb application such as X.

    Display blanking is implemented in three ways:

        1. using the drivers blanking implementation - info->fbops->fb_blank()
        2. clearing the screen with the console erase character - fbcon_blank()
        3. setting the color map to all black - fb_blank()

    The third method is problematic for these reasons:

        - Setting the colormap to all black will not work in truecolor mode
        - In directcolor or pseudocolor, it will overwrite the fb application's
          color map, producing wrong colors.

    So, remove the generic implementation in fb_blank() and just return -EINVAL
    if there is no hardware implementation.  This will be only used by apps doin
    an FBIO_BLANK ioctl, and is a more robust approach.

    Other changes:

    - Consolidated all tests and created an inlined helper function to check if
      the framebuffer console is inactive or not.
    - fix unblanking if driver has no xxxfb_blank() hook.

    I'm probably missing a few more things, but this patch should be generally
    correct. Please apply after the entire patch series to avoid rejects.

    Signed-off-by: Antonino Daplas <adaplas@pol.net>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
