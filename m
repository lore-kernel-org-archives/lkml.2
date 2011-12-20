Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab1LTPYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 10:24:38 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:40658 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1LTPYc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 10:24:32 -0500
MIME-Version: 1.0
In-Reply-To: <201112201619.43001.laurent.pinchart@ideasonboard.com>
References: <20111220163214.351b13b464c46f506f329b30@canb.auug.org.au>
	<201112201137.12003.laurent.pinchart@ideasonboard.com>
	<CAMuHMdU5iRf4HUS5i_ibJxvHGcszdF+ZXmwMCWsXvr4k8DjPHQ@mail.gmail.com>
	<201112201619.43001.laurent.pinchart@ideasonboard.com>
Date: Tue, 20 Dec 2011 16:24:30 +0100
X-Google-Sender-Auth: 7n-ZfCUKYqa_Ttp5n9ZByqJ60ho
Message-ID: <CAMuHMdVx+T8X3tkP+OVM-sxKLeJdsuz=0jBSxuNte_5JK4vTBQ@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the fbdev tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Tue, Dec 20, 2011 at 16:19, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Tuesday 20 December 2011 14:48:33 Geert Uytterhoeven wrote:
>> On Tue, Dec 20, 2011 at 11:37, Laurent Pinchart wrote:
>> > On Tuesday 20 December 2011 06:32:14 Stephen Rothwell wrote:
>> >> After merging the fbdev tree, today's linux-next build (powerpc
>> >> ppc64_defconfig) produced this warning:
>> >>
>> >> drivers/video/matrox/matroxfb_base.c:150:2: warning: braces around
>> >> scalar initializer [enabled by default]
>> >> drivers/video/matrox/matroxfb_base.c:150:2: warning: (near
>> >> initialization for 'vesafb_defined.colorspace') [enabled by default]
>> >> drivers/video/matrox/matroxfb_base.c:150:2: warning: excess elements in
>> >> scalar initializer [enabled by default]
>> >> drivers/video/matrox/matroxfb_base.c:150:2: warning: (near
>> >> initialization for 'vesafb_defined.colorspace') [enabled by default]
>> >> drivers/video/matrox/matroxfb_crtc2.c:596:3: warning: braces around
>> >> scalar initializer [enabled by default]
>> >> drivers/video/matrox/matroxfb_crtc2.c:596:3: warning: (near
>> >> initialization for 'matroxfb_dh_defined.colorspace') [enabled by
>> >> default]
>> >> drivers/video/matrox/matroxfb_crtc2.c:596:3: warning: excess elements in
>> >> scalar initializer [enabled by default]
>> >> drivers/video/matrox/matroxfb_crtc2.c:596:3: warning: (near
>> >> initialization for 'matroxfb_dh_defined.colorspace') [enabled by
>> >> default]
>> >>
>> >> Introduced by commit fb21c2f42879 ("fbdev: Add FOURCC-based format
>> >> configuration API").
>> >
>> > The following patch should fix the issue. Florian, are you fine with it,
>> > or would you rather modify the initializers to be name-based ?
>> >
>> > From 078987fc14dba806fc1bc628e3e5c371db3cf1b8 Mon Sep 17 00:00:00 2001
>> > From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> > Date: Tue, 20 Dec 2011 11:30:53 +0100
>> > Subject: [PATCH] fbdev: matroxfb: Fix compilation after fb_var_screeninfo
>> > change
>> >
>> > Commit fb21c2f42879 ("fbdev: Add FOURCC-based format configuration API")
>> > modified the layout of the fb_var_screeninfo structure. Update the
>> > static initializers in the matroxfb driver accordingly.
>> >
>> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> > ---
>> >  drivers/video/matrox/matroxfb_base.c  |    2 +-
>> >  drivers/video/matrox/matroxfb_crtc2.c |    2 +-
>> >  2 files changed, 2 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/video/matrox/matroxfb_base.c
>> > b/drivers/video/matrox/matroxfb_base.c index 44bf8d4..f98aad5 100644
>> > --- a/drivers/video/matrox/matroxfb_base.c
>> > +++ b/drivers/video/matrox/matroxfb_base.c
>> > @@ -147,7 +147,7 @@ static struct fb_var_screeninfo vesafb_defined = {
>> >        39721L,48L,16L,33L,10L,
>> >        96L,2L,~0,      /* No sync info */
>> >        FB_VMODE_NONINTERLACED,
>> > -       0, {0,0,0,0,0}
>> > +       0, 0, {0,0,0,0}
>>
>> All these zeroes should not be specified, the compiler will do the
>> right thing for
>> static variables anyway.
>>
>> Else they have to be updated manually everytime one of the reserved fields
>> is consumed for a new feature.
>
> I agree. Should I just remove them, or switch the structures to named
> initializers while I'm at it ?

I would just remove them. What do they buy you?

Even with named initializers

    .reserved = { 0, 0, 0, 0 }

will break once we consume one more reserved field, unless you write

    .reserved = { 0, }

to let the compiler handle it, but then you could just not specify the
field at all.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
