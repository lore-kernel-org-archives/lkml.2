Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab1GFXaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 19:30:21 -0400
Received: from adelie.canonical.com ([91.189.90.139]:55665 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab1GFXaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 19:30:20 -0400
Message-ID: <4E14F004.5010408@canonical.com>
Date: Wed, 06 Jul 2011 16:30:12 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Subject: Re: [PATCH 09/12] Input: synaptics - add image sensor support
References: <CAGS+omDzg-xADYxKQmWy1KRhJ=n9pn9XR_HMc01xqCSDSLa5UA@mail.gmail.com> <20110706174503.GA5695@core.coreip.homeip.net> <20110706184759.GA3389@polaris.bitmath.org> <20110706185832.GA6086@core.coreip.homeip.net> <20110706193120.GA3884@polaris.bitmath.org> <20110706200056.GB6086@core.coreip.homeip.net> <20110706202049.GA4077@polaris.bitmath.org> <4E14D22D.8050108@canonical.com> <20110706213658.GA9409@core.coreip.homeip.net> <4E14DEA9.1060908@canonical.com> <20110706223521.GA4335@polaris.bitmath.org>
In-Reply-To: <20110706223521.GA4335@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2011 03:35 PM, Henrik Rydberg wrote:
>> The evdev protocol is discrete, not continuous, so it's theoretically
>> possible that one touch could end at the same time that another begins.
>> IIRC, the time resolution of some MT devices makes this completely
>> possible, perhaps to the point that it would be trival to make this
>> happen in a few seconds of trying.
>>
>> I think the MT-B protocol has only ever used tracking_id for signalling
>> touch begin and touch end, where the id goes from -1 to something else
>> and vice versa. Maybe the protocol could be "extended" by saying that a
>> transition from one valid id to another means there is inconsistent
>> touch state, but the old touch hasn't necessarily ended and the new
>> touch hasn't necessarily started at this point in time.
> 
> The in-flight change of tracking id is actually part of the design; it
> makes the protocol independent of sample rate. If a particular
> tracking id is no longer found in any slot, that touch has ended.

Ok. I agree that this is the best way to handle things.

It does mean that we can't just change tracking_ids when the number of
touches changes, so that option is out.

>> I'm not sure this is any easier than flagging these as bad devices
>> because now we need to watch tracking ID changes on top of touch count
>> changes. From someone who has attempted to implement semi-mt in X
>> synaptics, adding more complexity here should be avoided at all cost :).
> 
> The information available in the proposition suffices to determine
> what the device is. Surely the method of transferring that information
> will not have any impact on the extra code required.

My (unstated) question was: is watching tracking_id transitions
reasonable for noting inconsistent touch changes when the number of
touches changes, or should we have a way to tell if a device is broken
and we must assume touch state inconsistency when the finger count
changes. Given your reply above that we cannot repurpose valid
tracking_id -> valid tracking_id transitions as a means of denoting
touch state inconsistency, that leaves us with the latter option.

You're right that the information available from the axes is enough to
tell if the device is broken (i.e. if max finger count > max slot count).

Ancillary to this is the question of whether we should depend on the
userspace side knowing this hidden meaning, or if we should state it up
front by setting a separate flag in the properties bits. I really don't
want to leave this up to userspace developers having to figure out or
dive into kernel code to determine what is going on, so I'm in favor of
having an explicit (documented!) property flag for these devices. Why
have property bits if you aren't going to use them :).

>>> I'll ask this - how much realistically do we care about 3+ finger
>>> transitions in context of these particular devices? This is a touchpad
>>> so as long as basic 2 finger gestures work (zoom, pinch, 2-finger
>>> scroll) with Synaptics X driver we should be fine. I do not want to add
>>> all kinds of custom flags to the protocol to deal with this generation
>>> of touchpads.
>>
>> I've given up on trying to send semi-mt data through the proposed XInput
>> 2.1 multitouch protocol. I think the best option is to send all this
>> data as valuators of a single touch (a touch and not a traditional
>> pointer event due to the multitouch/gesture semantics). Thus, we should
>> be focusing on what is possible in the gesture realm since we have
>> thrown full multiouch out the window for these devices.
>>
>> With these devices we can support one touch drag, two touch pinch,
>> rotate, and zoom, and 1-5 touch tap. For these to work, we need to know
>> the number of touches at any given time, the locations of the two
>> touches when only two touches are active, and some representative
>> location for the 1 and 3-5 touch cases.
> 
> Right, and we do, so there is no problem there, is there?

Agreed, there is no problem if we go with the assumption that for these
devices the touch slot data is inconsistent on touch count changes.

I am satisfied with the approach that's been laid out, the only point of
contention is whether userspace must infer touch state inconsistency on
touch count changes by looking at max fingers and max slots, or if we
provide this detail as a device property.

-- Chase
