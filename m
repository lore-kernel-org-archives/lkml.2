Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab1IRQOa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 12:14:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44213 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab1IRQO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 12:14:28 -0400
MIME-Version: 1.0
In-Reply-To: <201109180112.15896.laurent.pinchart@ideasonboard.com>
References: <1316088425.11294.78.camel@lappyti>
	<CADnq5_NnzLtJmSzOgyppnBtv96DRTJ71u6ZSrs56KJ-F5CC-mw@mail.gmail.com>
	<4E724659.5080709@gmx.de>
	<201109180112.15896.laurent.pinchart@ideasonboard.com>
Date: Sun, 18 Sep 2011 11:14:26 -0500
X-Google-Sender-Auth: 4viq0LqF4OP8gH-cadeo6zFETJI
Message-ID: <CAF6AEGs0vkL2HLWcihX-h8JPiEVj5nHjzdWie1oUaoDibEONHg@mail.gmail.com>
Subject: Re: Proposal for a low-level Linux display framework
From: Rob Clark <rob.clark@linaro.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linaro-dev@lists.linaro.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Archit Taneja <archit@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 17, 2011 at 6:12 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi everybody,
>
> On Thursday 15 September 2011 20:39:21 Florian Tobias Schandinat wrote:
>> On 09/15/2011 05:52 PM, Alex Deucher wrote:
>> >
>> > Please don't claim that the DRM developers do not want to cooperate.
>> > I realize that people have strong opinions about existing APIs, put
>> > there has been just as much, if not more obstinacy from the v4l and fb
>> > people.
>>
>> Well, I think it's too late to really fix this thing. We now have 3 APIs in
>> the kernel that have to be kept. Probably the best we can do now is figure
>> out how we can reduce code duplication and do extensions to those APIs in
>> a way that they are compatible with each other or completely independent
>> and can be used across the APIs.
>
> Sorry for jumping late into the discussion. Let me try to shed some new light
> on this.
>
> I've been thinking about the DRM/KMS/FB/V4L APIs overlap for quite some time
> now. All of them have their share of issues, historical nonsense and unique
> features. I don't think we can pick one of those APIs today and decide to drop
> the others, but we certainly need to make DRM, KMS, FB and V4L interoperable
> at various levels. The alternative is to keep ignoring each other and let the
> market decice.

I think we need to differentiate between V4L camera, and display..

MC and subdev stuff clearly seem to be the way to go for complex
camera / imaging subsystems.  But that is a very different problem
domain from GPU+display.  We need to stop blurring the two topics.

> Thinking that the market could pick something like OpenMAX
> scares me, so I'd rather find a good compromise and move forward.
>
> Disclaimer: My DRM/KMS knowledge isn't as good as my FB and V4L knowledge, so
> please feel free to correct my mistakes.
>
> All our video-related APIs started as solutions to different problems. They
> all share an important feature: they assume that the devices they control is
> more or less monolithic. For that reason they expose a single device to
> userspace, and mix device configuration and data transfer on the same device
> node.
>
> This shortcoming became painful in V4L a couple of years ago. When I started
> working on the OMAP3 ISP (camera) driver I realized that trying to configure a
> complex hardware pipeline without exposing its internals to userspace
> applications wouldn't be possible. DRM, KMS and FB ran into the exact same
> problem, just more recently, as showed by various RFCs ([1], [2]).

But I do think that overlays need to be part of the DRM/KMS interface,
simply because flipping still needs to be synchronized w/ the GPU.  I
have some experience using V4L for display, and this is one (of
several) broken aspects of that.

> To fix this issue, the V4L community developed a new API called the Media
> Controller [3]. In a nutshell, the MC aims at
>
> - exposing the device topology to userspace as an oriented graph of entities
> connected with links through pads
>
> - controlling the device topology from userspace by enabling/disabling links
>
> - giving userspace access to per-entity controls
>
> - configuring formats at individual points in the pipeline from userspace.
>
> The MC API solves the first two problems. The last two require help from V4L
> (which has been extended with new MC-aware ioctls), as MC is media-agnostic
> and can't thus configure video formats.
>
> To support this, the V4L subsystem exposes an in-kernel API based around the
> concept of sub-devices. A single high-level hardware device is handled by
> multiple sub-devices, possibly controlled by different drivers. For instance,
> in the OMAP3-based N900 digital camera, the OMAP3 ISP is made of 8 sub-devices
> (all controlled by the OMAP3 ISP driver), and the two sensors, flash
> controller and lens controller all have their own sub-device, each of them
> controlled by its own driver.
>
> All this infrastructure exposes the devices a the graph showed in [4] to
> applications, and the V4L sub-device API can be used to set formats at
> individual pads. This allows controlling scaling, cropping, composing and
> other video-related operations on the pipeline.
>
> With the introduction of the media controller architecture, I now see V4L as
> being made of three parts.
>
> 1. The V4L video nodes streaming API, used to manage video buffers memory, map
> it to userspace, and control video streaming (and data transfers).
>
> 2. The V4L sub-devices API, used to control parameters on individual entities
> in the graph and configure formats.
>
> 3. The V4L video nodes formats and control API, used to perform the same tasks
> as the V4L sub-devices API for drivers that don't support the media controller
> API, or to provide support for pure V4L applications with drivers that support
> the media controller API.
>
> V4L is made of those three parts, but I believe it helps to think about them
> individually. With today's (and tomorrow's) devices, DRM, KMS and FB are in a
> situation similar to what V4L experienced a couple of years ago. They need to
> give control of complex pipelines to userspace, and I believe this should be
> done by (logically) splitting DRM, KMS and FB into a pipeline control part and
> a data flow part, as we did with V4L.
>
> Keeping the monolithic device model and handling pipeline control without
> exposing the pipeline topology would in my opinion be a mistake. Even if this
> could support today's hardware, I don't think it would be future-proof. I
> would rather see the DRM, KMS and FB topologies being exposed to applications
> by implementing the MC API in DRM, KMS and FB drivers. I'm working on a proof
> of concept for the FB sh_mobile_lcdc driver and will post patches soon.
> Something similar can be done for DRM and KMS.
>
> This would leave us with the issue of controlling formats and other parameters
> on the pipelines. We could keep separate DRM, KMS, FB and V4L APIs for that,
> but would it really make sense ? I don't think so. Obviously I would be happy
> to use the V4L API, as we already have a working solution :-) I don't see that
> as being realistic though, we will probably need to create a central graphics-
> related API here (possibly close to what we already have in V4L if it can
> fulfil everybody's needs).
>
> To paraphrase Alan, in my semi-perfect world vision the MC API would be used
> to expose hardware pipelines to userspace, a common graphics API would be used
> to control parameters on the pipeline shared by DRM, KMS, FB and V4L, the
> individual APIs would control subsystem-specific parameters and DRM, KMS, FB
> and V4L would be implemented on top of this to manage memory, command queues
> and data transfers.

I guess in theory it would be possible to let MC iterate the
plane->crtc->encoder->connector topology.. I'm not entirely sure what
benefit that would bring, other than change for the sake of change.

V4L and DRM are very different APIs designed to solves very different
problems.  The KMS / mode-setting part may look somewhat similar to
something you can express w/ a camera-like graph of nodes.  But the
memory management is very different.  And display updates (like page
flipping) need to be synchronized w/ GPU rendering.. etc.  Trying to
fit V4L here, just seems like trying to force a square peg in a round
hole.  You'd have to end up morphing V4L so much that in the end it
looks like DRM.  And that might not be the right thing for cameras.

So V4L for camera, DRM for gpu/display.  Those are the two APIs we need.

BR,
-R

> Am I looking too far in the future ?
>
> [1] http://www.mail-archive.com/intel-gfx@lists.freedesktop.org/msg04421.html
> [2] http://www.mail-archive.com/linux-samsung-
> soc@vger.kernel.org/msg06292.html
> [3] http://linuxtv.org/downloads/v4l-dvb-apis/media_common.html
> [4] http://www.ideasonboard.org/media/omap3isp.ps
>
> --
> Regards,
>
> Laurent Pinchart
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
