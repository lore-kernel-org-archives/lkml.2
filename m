Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab1CLP7Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 10:59:25 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39865 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab1CLP7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 10:59:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Kn9tFxCPYUfGVUIsis/Zxy+dDD6Z9svQbRw1TlxE1XMDci0M3RMxXfTQpbkFF9MGa2
         MqNpyFSKJwZKHDTItwdwm4xgYQuM1x3kP6HDrAm31y0/dOXAn1NUSY3f1DZD6MfpsfVU
         Sy6gt6/Bw/SXJrb5Y6Um7MnmstoaByD7ToGu8=
MIME-Version: 1.0
In-Reply-To: <20101205112813.GB12542@viiv.ffwll.ch>
References: <F45880696056844FA6A73F415B568C6953604E802E@EXDCVYMBSTM006.EQ1STM.local>
	<201011251747.48365.arnd@arndb.de>
	<C832F8F5D375BD43BFA11E82E0FE9FE0082586F430@EXDCVYMBSTM005.EQ1STM.local>
	<201011261224.59490.arnd@arndb.de>
	<AANLkTinSb-9=xzX3LfZVYcKiDt5Qkm=qV6CiFGUyq+fC@mail.gmail.com>
	<20101205112813.GB12542@viiv.ffwll.ch>
Date: Sat, 12 Mar 2011 09:59:19 -0600
Message-ID: <AANLkTi=B=_3tHXgG02pQA=zE=i8TOz0BZ=Pe9ZZwGLh3@mail.gmail.com>
Subject: Re: [PATCH 09/10] MCDE: Add build files and bus
From: Rob Clark <robdclark@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Jimmy RUBIN <jimmy.rubin@stericsson.com>,
        Dan JOHANSSON <dan.johansson@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Marcus LORENTZON <marcus.xm.lorentzon@stericsson.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Daniel Vetter <daniel@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 5, 2010 at 5:28 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Sat, Dec 04, 2010 at 04:34:22PM -0500, Alex Deucher wrote:
>> This doesn't seem that different from the graphics chips we support
>> with kms.  I don't think it would require much work to use KMS.  One
>> thing we considered, but never ended up implementing was a generic
>> overlay API for KMS.  Most PC hardware still has overlays, but we
>> don't use them much any more on the desktop side.  It may be
>> worthwhile to design an appropriate API for them for these type of
>> hardware.
>
> Just fyi about a generic overlay api: I've looked a bit into this when
> doing the intel overlay support and I think adding special overlay crtcs
> that can be attached real crtcs gives a nice clean api. We could the reuse
> the existing framebuffer/pageflipping api to get the buffers to the
> overlay engine.

btw, has there been any further thought/discussion on this topic..
I've been experimenting with a drm driver interface on the OMAP SoC.
It is working well now for framebuffer type usage (mode setting,
virtual framebuffer spanning multiple diplays, and those types of
xrandr things)..  the next step that I've started thinking about is
overlay (or underlay.. the z-order is flexible) support..

I was thinking in a similar direction (ie. a special, or maybe not so
special, sort of crtc) and came across this thread, so I thought I'd
resurrect the topic.

In our case, most of the CRTCs in our driver could be used either with
(A)RGB buffers as a traditional framebuffer, or with a few different
formats of YUV as video under/overlays.  So if you had one display
attached, you might only use one CRTC for traditional GUI/gfx layer,
and the rest are available for video.  If you had two displays, then
you'd steal one of the video CRTCs and use it for the gfx layer on the
second display.  And so on.

Rough thinking:
+ add some 'caps' to the CRTC to indicate whether it can handle YUV,
ARGB, scaling
+ add an x/y offset relative to the encoder (as opposed to the
existing x/y offset relative to the framebuffer)
+ add a z-order parameter

Not sure about intel hw if it is supporting clip-rects.. if so, maybe
need to add something about that.  In our case we jut put the video
behind the gfx layer and use the alpha channel in the gfx framebuffer
to clip/blend rather than using clip-rects.


> The real pain starts when we want format discovery from userspace with all
> the alignement/size/layout constrains. Add in tiling support and its
> almost impossible to do in a generic way. But also for kms userspace needs
> to know these constrains (implemented for generic use in libkms). I favor
> such an approach for overlays, too (if it ever happens) - i.e. a few
> helpers in libkms that allocate an appropriate buffer for a given format
> and size and returns the buffer, strides and offsets for the different
> planes.

hmm, I guess I know about the OMAP display subsystem, and it's overlay
formats/capabilities.. but not enough about other hw to say anything
intelligent here.  But I guess even if we ignore the format of the
data in the buffer, at least the APIs to setup/attach overlay CRTCs at
various positions could maybe be something we can start with as a
first step.  At least standardizing this part seems like a good first
step.  But I'm definitely interested if someone has some ideas.

BR,
-R

> -Daniel
> --
> Daniel Vetter
> Mail: daniel@ffwll.ch
> Mobile: +41 (0)79 365 57 48
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
