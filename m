Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab1CNOEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 10:04:48 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:55144 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752644Ab1CNOEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 10:04:46 -0400
Message-ID: <4D7E204E.7010303@stericsson.com>
Date: Mon, 14 Mar 2011 15:03:58 +0100
From: Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Rob Clark <robdclark@gmail.com>
Cc: Alex Deucher <alexdeucher@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Jimmy RUBIN <jimmy.rubin@stericsson.com>,
        Dan JOHANSSON <dan.johansson@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH 09/10] MCDE: Add build files and bus
References: <F45880696056844FA6A73F415B568C6953604E802E@EXDCVYMBSTM006.EQ1STM.local>	<201011251747.48365.arnd@arndb.de>	<C832F8F5D375BD43BFA11E82E0FE9FE0082586F430@EXDCVYMBSTM005.EQ1STM.local>	<201011261224.59490.arnd@arndb.de>	<AANLkTinSb-9=xzX3LfZVYcKiDt5Qkm=qV6CiFGUyq+fC@mail.gmail.com>	<20101205112813.GB12542@viiv.ffwll.ch> <AANLkTi=B=_3tHXgG02pQA=zE=i8TOz0BZ=Pe9ZZwGLh3@mail.gmail.com>
In-Reply-To: <AANLkTi=B=_3tHXgG02pQA=zE=i8TOz0BZ=Pe9ZZwGLh3@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2011 04:59 PM, Rob Clark wrote:
> On Sun, Dec 5, 2010 at 5:28 AM, Daniel Vetter<daniel@ffwll.ch>  wrote:
>    
>> On Sat, Dec 04, 2010 at 04:34:22PM -0500, Alex Deucher wrote:
>>      
>>> This doesn't seem that different from the graphics chips we support
>>> with kms.  I don't think it would require much work to use KMS.  One
>>> thing we considered, but never ended up implementing was a generic
>>> overlay API for KMS.  Most PC hardware still has overlays, but we
>>> don't use them much any more on the desktop side.  It may be
>>> worthwhile to design an appropriate API for them for these type of
>>> hardware.
>>>        
>> Just fyi about a generic overlay api: I've looked a bit into this when
>> doing the intel overlay support and I think adding special overlay crtcs
>> that can be attached real crtcs gives a nice clean api. We could the reuse
>> the existing framebuffer/pageflipping api to get the buffers to the
>> overlay engine.
>>      
> btw, has there been any further thought/discussion on this topic..
> I've been experimenting with a drm driver interface on the OMAP SoC.
> It is working well now for framebuffer type usage (mode setting,
> virtual framebuffer spanning multiple diplays, and those types of
> xrandr things)..  the next step that I've started thinking about is
> overlay (or underlay.. the z-order is flexible) support..
>
> I was thinking in a similar direction (ie. a special, or maybe not so
> special, sort of crtc) and came across this thread, so I thought I'd
> resurrect the topic.
>
> In our case, most of the CRTCs in our driver could be used either with
> (A)RGB buffers as a traditional framebuffer, or with a few different
> formats of YUV as video under/overlays.  So if you had one display
> attached, you might only use one CRTC for traditional GUI/gfx layer,
> and the rest are available for video.  If you had two displays, then
> you'd steal one of the video CRTCs and use it for the gfx layer on the
> second display.  And so on.
>
>    
We have similar HW and are also interested in finding some common ground 
for overlays in KMS. Just as you describe, we have no hard connection 
between a CRTC and output. Instead we only have overlays. Normal gfx use 
case is then of course one of these overlays dedicated to one display. 
And when adding video overlays, we also prefer YUV "underlays" with 
fullscreen ARGB gfx on top.

The problem with mapping this to the CRTCs in KMS today, is that there 
is no differentiation between framebuffer width/height and crt 
width/height. And of course YUV formats and fb position etc are missing.

One advantage of the set CRTC ioctl is that all information needed to 
switch mode is contained in one atomic set mode ioctl. So we have to 
think about if we want a new more advanced set crtc including overlay 
config. Or if we want to split mode setup into several requests. And 
then we must decide if multiple setup ioctls will need some type of 
"commit" to get the atomic mode switch we have today. For example I 
don't want to have to do a set_crtc enabling blending without overlay 
being setup. It should be just as glitch free as KMS is today.
> Rough thinking:
> + add some 'caps' to the CRTC to indicate whether it can handle YUV,
> ARGB, scaling
> + add an x/y offset relative to the encoder (as opposed to the
> existing x/y offset relative to the framebuffer)
> + add a z-order parameter
>
>    
Exactly what I would like to have. Especially the caps for scaling, 
since we have one HW that can't do scaling.
> Not sure about intel hw if it is supporting clip-rects.. if so, maybe
> need to add something about that.  In our case we jut put the video
> behind the gfx layer and use the alpha channel in the gfx framebuffer
> to clip/blend rather than using clip-rects.
>
>    
If this is common ground, I would like to have one clip rect per 
CRTC/overlay to enable framebuffers larger than overlay viewport. That 
makes it easier to reuse a large buffer for multiple 
overlays/framebuffers without having to stress memory management driver. 
But this is just a "nice to have" feature. Maybe this can be mapped to 
stride/start address mappings on HW without clip rect. But that will 
probably include alignment requirements on position and size.
>> The real pain starts when we want format discovery from userspace with all
>> the alignement/size/layout constrains. Add in tiling support and its
>> almost impossible to do in a generic way. But also for kms userspace needs
>> to know these constrains (implemented for generic use in libkms). I favor
>> such an approach for overlays, too (if it ever happens) - i.e. a few
>> helpers in libkms that allocate an appropriate buffer for a given format
>> and size and returns the buffer, strides and offsets for the different
>> planes.
>>      
> hmm, I guess I know about the OMAP display subsystem, and it's overlay
> formats/capabilities.. but not enough about other hw to say anything
> intelligent here.  But I guess even if we ignore the format of the
> data in the buffer, at least the APIs to setup/attach overlay CRTCs at
> various positions could maybe be something we can start with as a
> first step.  At least standardizing this part seems like a good first
> step.  But I'm definitely interested if someone has some ideas.
>
>    

Yes, so we could try and find some common ground and add support for 
that. But still enable drivers to extend that with the features where we 
find no common ground. Just as GEM doesn't provide allocation ioctl, 
only free.

And in the end we have to see if the common ground is enough to actually 
build an application on. If not, there's not much use for a partial 
common API. Maybe that's why there's no overlay API in KMS tiday?

Maybe vendor libkms can be used to fill in the gaps?

/BR
/Marcus

