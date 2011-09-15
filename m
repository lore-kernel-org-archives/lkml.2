Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934390Ab1IOScw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 14:32:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64691 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934209Ab1IOScv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 14:32:51 -0400
MIME-Version: 1.0
In-Reply-To: <1316107275.23214.99.camel@deskari>
References: <1316088425.11294.78.camel@lappyti>
	<yunboul7sx7.fsf@aiko.keithp.com>
	<1316100594.23214.65.camel@deskari>
	<yun8vpp7qk7.fsf@aiko.keithp.com>
	<1316107275.23214.99.camel@deskari>
Date: Thu, 15 Sep 2011 13:32:49 -0500
X-Google-Sender-Auth: g6A0Wbhd-P23c5q1hBGnAa9fIq0
Message-ID: <CAF6AEGtPouKEBgrgF_jP+idOtPUJ4iO7wwOADbJ-k4h2mWRVXw@mail.gmail.com>
Subject: Re: Proposal for a low-level Linux display framework
From: Rob Clark <rob@ti.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Keith Packard <keithp@keithp.com>, linux-fbdev@vger.kernel.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Archit Taneja <archit@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 12:21 PM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On Thu, 2011-09-15 at 10:50 -0500, Keith Packard wrote:
>> On Thu, 15 Sep 2011 18:29:54 +0300, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
>>
>> > 1) It's part of DRM, so it doesn't help fb or v4l2 drivers. Except if
>> > the plan is to make DRM the core Linux display framework, upon which
>> > everything else is built, and fb and v4l2 are changed to use DRM.
>>
>> I'd like to think we could make DRM the underlying display framework;
>> it already exposes an fb interface, and with overlays, a bit more of the
>> v4l2 stuff is done as well. Certainly eliminating three copies of mode
>> setting infrastructure would be nice...
>
> Ok, sounds good to me. We (as in OMAP display people) are already
> planning to take DRM into use, so no problem there.
>
>> > But even if it was done like that, I see that it's combining two
>> > separate things: 1) the lower level HW control, and 2) the upper level
>> > buffer management, policies and userspace interfaces.
>>
>> Those are split between the DRM layer and the underlying device driver,
>> which provides both kernel (via fb) and user space interfaces.
>
> I'm not so familiar with DRM, but with device driver you mean a driver
> for the the hardware which handles display output (gfx cards or whatever
> it is on that platform)?

I think he is more referring to the DRM core and the individual device drivers..

We are (AFAIK) unique in having a two layer driver, where the DRM part
is more of a wrapper (for the KMS parts)... but I see that as more of
a transition thing.. eventually we should be able to merge it all into
the DRM layer.

> If so, it sounds good. That quite well matches what omapdss driver does
> currently for us. But we still have semi-complex omapdrm between omapdss
> and the standard drm layer.
>
> Rob, would you say omapdrm is more of a DRM wrapper for omapdss than a
> real separate entity? If so, then we could possibly in the future (when
> nobody else uses omapdss) change omapdss to support DRM natively. (or
> make omapdrm support omap HW natively, which ever way =).

Yeah, I think eventually it would make sense to merge all into one.
Although I'm not sure about how best to handle various different
custom DSI panels..

BR,
-R


>> > 2) It's missing the panel driver part. This is rather important on
>> > embedded systems, as the panels often are not "dummy" panels, but they
>> > need things like custom initialization, sending commands to adjust
>> > backlight, etc.
>>
>> We integrate the panel (and other video output) drivers into the device
>> drivers. With desktop chips, they're not easily separable. None of the
>> desktop output drivers are simple; things like DisplayPort require link
>> training, and everyone needs EDID. We share some of that code in the DRM
>> layer today, and it would be nice to share even more.
>
> I don't think we speak of similar panel drivers. I think there are two
> different drivers here:
>
> 1) output drivers, handles the output from the SoC / gfx card. For
> example DVI, DisplayPort, MIPI DPI/DBI/DSI.
>
> 2) panel drivers, handles panel specific things. Each panel may support
> custom commands and features, for which we need a dedicated driver. And
> this driver is not platform specific, but should work with any platform
> which has the output used with the panel.
>
> As an example, DSI command mode displays can be quite complex:
>
> DSI bus is a half-duplex serial bus, and while it's designed for
> displays you could use it easily for any communication between the SoC
> and the peripheral.
>
> The panel could have a feature like content adaptive backlight control,
> and this would be configured via the DSI bus, sending a particular
> command to the panel (possibly by first reading something from the
> panel). The panel driver would accomplish this more or less the same way
> one uses, say, i2c, so it would use the platform's DSI support to send
> and receive packets.
>
> Or a more complex scenario (but still a realistic scenario, been there,
> done that) is sending the image to the panel in multiple parts, and
> between each part sending configuration commands to the panel. (and
> still getting it done in time so we avoid tearing).
>
> And to complicate things more, there are DSI bus features like LP mode
> (low power, basically low speed mode) and HS mode (high speed), virtual
> channel IDs, and whatnot, which each panel may need to be used in
> particular manner. Some panels may require initial configuration done in
> LP, or configuration commands sent to a certain virtual channel ID.
>
> The point is that we cannot have standard "MIPI DSI command mode panel
> driver" which would work for all DSI cmd mode panels, but we need (in
> the worst case) separate driver for each panel.
>
> The same goes to lesser extent for other panels also. Some are
> configured via i2c or spi.
>
>  Tomi
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
