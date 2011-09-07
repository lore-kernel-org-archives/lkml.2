Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1IGCeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 22:34:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:22494 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab1IGCeE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 22:34:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=BF0hvQJSgOsjH/PuK/51Rur4eV6v3J1NhqoTGRJSAwldnrzTBFn9W48HfJWUk7YGQ
	8oy/2kJnY4UC+mXHhu3hw==
MIME-Version: 1.0
In-Reply-To: <4E66749A.10009@canonical.com>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw>
 <1313632629-23603-3-git-send-email-jj_ding@emc.com.tw> <20110818074756.GE10093@core.coreip.homeip.net>
 <4E5FCE58.9060906@canonical.com> <87sjobk711.fsf@emc.com.tw>
 <4E665249.2040602@canonical.com> <20110906173649.GA7419@core.coreip.homeip.net>
 <4E6660D7.9040800@canonical.com> <20110906182016.GB7419@core.coreip.homeip.net>
 <4E66749A.10009@canonical.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 7 Sep 2011 10:33:40 +0800
X-Google-Sender-Auth: YIo2e0Hz6l77x7W_-JpX8Vk4mq8
Message-ID: <CAGS+omCWQk+mTXnYZRCWhH2wWrn5PfhEv414isN_r=NKAdcs1g@mail.gmail.com>
Subject: Re: [PATCH 2/6] Input: elantech - use firmware provided x, y ranges
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, JJ Ding <jj_ding@emc.com.tw>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 7, 2011 at 3:29 AM, Chase Douglas
<chase.douglas@canonical.com> wrote:
>
> On 09/06/2011 11:20 AM, Dmitry Torokhov wrote:
> > On Tue, Sep 06, 2011 at 11:05:11AM -0700, Chase Douglas wrote:
> >> On 09/06/2011 10:36 AM, Dmitry Torokhov wrote:
> >>> On Tue, Sep 06, 2011 at 10:03:05AM -0700, Chase Douglas wrote:
> >>>> On 09/04/2011 08:22 PM, JJ Ding wrote:
> >>>>> Hi Chase,
> >>>>>
> >>>>> On Thu, 01 Sep 2011 11:26:32 -0700, Chase Douglas <chase.douglas@canonical.com> wrote:
> >>>>>> On 08/18/2011 12:47 AM, Dmitry Torokhov wrote:
> >>>>>>> On Thu, Aug 18, 2011 at 09:57:05AM +0800, JJ Ding wrote:
> >>>>>>>> +
> >>>>>>>> +              i = (etd->fw_version > 0x020800 &&
> >>>>>>>> +                   etd->fw_version < 0x020900) ? 1 : 2;
> >>>>>>>> +              *x_max = (etd->capabilities[1] - i) * 64;
> >>>>>>>> +              *y_max = (etd->capabilities[2] - i) * 64;
> >>>>>>>> +              *y_2ft_max = (*y_max - i) * 64 / 4;
> >>>>>>>
> >>>>>>> Hmm, we should have the same range for ST and MT data and scale MT data
> >>>>>>> if it has lower resolution to match ST.
> >>>>>>
> >>>>>> I saw this go by a while back and it made sense to me at the time.
> >>>>>> However, I've had some thoughts that give me pause.
> >>>>>>
> >>>>>> Seth Forshee has been working on getting a semi-mt driver for ALPS
> >>>>>> devices. The ALPS devices have an interesting mechanism for providing
> >>>>>> multitouch data, but it boils down to having a resolution of only 15
> >>>>>> values in the X axis and 11 in the Y axis (it looks possible to
> >>>>>> extrapolate and get double the resolution, but my point will remain).
> >>>>>>
> >>>>>> Let's take the X synaptics module as an example of the repercussions of
> >>>>>> in-kernel axis scaling. The X synaptics module translates two touch
> >>>>>> drags into scroll events. Synaptics will want to use the highest
> >>>>>> resolution axis for generating scroll events. If both the MT and ST axes
> >>>>>> have the same resolution, it might pick the MT axes for scrolling. On
> >>>>>> ALPS devices with in-kernel axis scaling that would be a bad choice.
> >>>>> I don't know about the ALPS devices, but since we already report
> >>>>> ABS_MT_POSITION_{X,Y} with elantech v2, we have to do the scaling in
> >>>>> kernel anyway to adhere to multitouch protocol. So I would say it is
> >>>>> still more appropriate to have the same resolution for ST and MT with
> >>>>> respect to elantech v2. Maybe ALPS should be considered an exception to this?
> >>>>
> >>>> The multitouch protocol doesn't require scaling of axes to match, at
> >>>> least not according to the protocol documentation.
> >>>>
> >>>> I see that the current code scales the coordinates for v2, but it's only
> >>>> half-resolution. That's not a huge deal since the resolution of modern
> >>>> touchpads is very high. We could leave it scaled to not break abi, if
> >>>> that was a concern. However, with new devices it makes sense to state
> >>>> the ranges in terms of what the device actually supports. Otherwise,
> >>>> we're just masking out useful data that userspace could be using.
> >>>>
> >>>
> >>> I disagree. I believe that ST and MT ranges reported for the same
> >>> working surface should match, especially since many devices derive ST
> >>> data from MT.
> >>>
> >>> As far as devices that have ranges 0-15 in MT mode - I am not sure how
> >>> useful such MT steam anyway and if we are better of just ignore them
> >>> (maybe just use the data to report number of fingers on the surface but
> >>> otherwise use standard ST protocol).
> >>
> >> The MT data could still be useful for pinch to zoom or potentially
> >> rotate (though most low res devices probably are only semi-mt). I don't
> >> want to forsake pinch to zoom just because we can't pass on the
> >> resolution of MT data properly.
> >
> > How would userspace know that MT data should only be used for gestures
> > but nothign else? By examining range? What is the "too small range"
> > then? It would be different for different devices. I do not want
> > userspace portions of the drivers to turn into unmanageble collection of
> > quirks.
>
> I wasn't suggesting that it have a big switch that enables or disables
> gestures. I just want userspace to be able to figure out whether ST or
> MT data would be better for a given task. If the range of the ST and MT
> axes could provide this data, then it makes sense to do so. The test
> wouldn't be like "is MT range big enough", it would be "is MT range
> better than ST or vice versa".
>
> However, Henrik pointed out that some devices report ranges that aren't
> representative of how accurate or precise they really are. That
> invalidates this approach.
>
> > Some hardware is just hopeless... And pinch to zoom is cute but hardly
> > most used function on a laptop (as opposed to phone/tablet), I'd just
> > leave it be.
>
> Just because a piece of hardware is imprecise does not mean it is
> useless for gestures. Sure, it may not work that great for precision
> zooming, but it would be good enough for threshold matching. The Unity
> window manager uses these thresholds to fire actions like spread (or
> "expose" in OS X terms).
>
> -- Chase

As far as I can tell, when the pad reports exactly 2 fingers, it
reports them both with half the resolution with which it would report
a single finger (in the 1 finger or 3 fingers cases).

It sounded like Chase was recommending to report "ST" at full
resolution and "MT" at half resolution.  Thus, if there is 1 finger,
we would throw away 1 bit for the MT report.  If there were 2 fingers,
we would inflate the ST reported finger by one bit.

I prefer the original behavior of this patch, which just always
reports ST and MT using the ST scale.

-Daniel
