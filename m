Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab1GFWQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 18:16:18 -0400
Received: from adelie.canonical.com ([91.189.90.139]:50769 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab1GFWQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 18:16:17 -0400
Message-ID: <4E14DEA9.1060908@canonical.com>
Date: Wed, 06 Jul 2011 15:16:09 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Henrik Rydberg <rydberg@euromail.se>, Daniel Kurtz <djkurtz@chromium.org>,
        rubini@cvml.unipv.it, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, derek.foreman@collabora.co.uk,
        daniel.stone@collabora.co.uk, olofj@chromium.org
Subject: Re: [PATCH 09/12] Input: synaptics - add image sensor support
References: <CAGS+omAzKe5frVYuV2MPXBTugKD1xNZCHsaz53H+tDO7EWw8xQ@mail.gmail.com> <20110705192759.GA29549@polaris.bitmath.org> <CAGS+omDzg-xADYxKQmWy1KRhJ=n9pn9XR_HMc01xqCSDSLa5UA@mail.gmail.com> <20110706174503.GA5695@core.coreip.homeip.net> <20110706184759.GA3389@polaris.bitmath.org> <20110706185832.GA6086@core.coreip.homeip.net> <20110706193120.GA3884@polaris.bitmath.org> <20110706200056.GB6086@core.coreip.homeip.net> <20110706202049.GA4077@polaris.bitmath.org> <4E14D22D.8050108@canonical.com> <20110706213658.GA9409@core.coreip.homeip.net>
In-Reply-To: <20110706213658.GA9409@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2011 02:36 PM, Dmitry Torokhov wrote:
> On Wed, Jul 06, 2011 at 02:22:53PM -0700, Chase Douglas wrote:
>> On 07/06/2011 01:20 PM, Henrik Rydberg wrote:
>>>>> To me, it seems we do need a little bit of extra information to
>>>>> determine this new type of device.
>>>>
>>>> I think we already have all we need (see above).
>>>
>>> I concur. So, to conclude:
>>>
>>> a) The improved synaptics behavior can be achieved by simply using
>>> MT-B plus BTN_TOOL_*.
>>>
>>> b) Userspace should check BTN_TOOL_* for any discrepancies between the
>>> maximum number of available slots (always two in this case) and the
>>> maximum number of fingers reported (BTN_TOOL_TRIPLETAP etc). Extra
>>> actions may then be taken to support more fingers than slots.
>>>
>>> c) The semi-mt flag is only used to signal that the two points sent
>>> via MT-B are the corners of a bounding box.
>>
>> This isn't quite enough. If we don't set the semi-mt flag or any other
>> new flag, then we'll have slots that become inconsistent when touches
>> are added or removed. For example, start with two touches being tracked
>> correctly. Now, add a touch. The second slot will now get the data of
>> the third touch, which is in a different location. You haven't changed
>> the tracking_id though, so it looks like the same touch. This is
>> incorrect behavior. Or, you could change the tracking_id, but that
>> implies that a touch was lifted and another was placed. This is also
>> incorrect behavior.
> 
> The tracking ID needs to be changed as we start trackign and reporting
> new touch. We could see that the old touch was not removed from the fact
> that total number of finger reported increased.

The evdev protocol is discrete, not continuous, so it's theoretically
possible that one touch could end at the same time that another begins.
IIRC, the time resolution of some MT devices makes this completely
possible, perhaps to the point that it would be trival to make this
happen in a few seconds of trying.

I think the MT-B protocol has only ever used tracking_id for signalling
touch begin and touch end, where the id goes from -1 to something else
and vice versa. Maybe the protocol could be "extended" by saying that a
transition from one valid id to another means there is inconsistent
touch state, but the old touch hasn't necessarily ended and the new
touch hasn't necessarily started at this point in time.

I'm not sure this is any easier than flagging these as bad devices
because now we need to watch tracking ID changes on top of touch count
changes. From someone who has attempted to implement semi-mt in X
synaptics, adding more complexity here should be avoided at all cost :).

>> We need to tell userspace that this is a messed up device that can't
>> accurately track touch locations across touch up/down boundaries. Once
>> userspace sees this, it can act appropriately when it sees a transition
>> from BTN_TOOL_DOUBLETAP to BTN_TOOL_TRIPLETAP, for example. This is how
>> we handle transitions in the uTouch stack for semi-mt devices.
>>
>> Perhaps a clean implementation would be to keep semi-mt as a flag
>> stating that there will only ever be two slots, the 0th will be the
>> minimum (x,y) of the bounding box and the 1st will be the maximum. Then,
>> we add a flag like NO_TOUCH_TRANSITION_TRACKING that would be set on
>> both semi-mt and these new devices that denote the slot data may
>> transition from one physical touchpoint to another when the number of
>> touches changes.
>>
>> We could leave this up to userspace and have it detect a
>> NO_TOUCH_TRANSITION_TRACKING device based on the fact that the max slots
>> is less than the max fingers, but I would argue here that a more clear
>> protocol is a better protocol.
> 
> I'll ask this - how much realistically do we care about 3+ finger
> transitions in context of these particular devices? This is a touchpad
> so as long as basic 2 finger gestures work (zoom, pinch, 2-finger
> scroll) with Synaptics X driver we should be fine. I do not want to add
> all kinds of custom flags to the protocol to deal with this generation
> of touchpads.

I've given up on trying to send semi-mt data through the proposed XInput
2.1 multitouch protocol. I think the best option is to send all this
data as valuators of a single touch (a touch and not a traditional
pointer event due to the multitouch/gesture semantics). Thus, we should
be focusing on what is possible in the gesture realm since we have
thrown full multiouch out the window for these devices.

With these devices we can support one touch drag, two touch pinch,
rotate, and zoom, and 1-5 touch tap. For these to work, we need to know
the number of touches at any given time, the locations of the two
touches when only two touches are active, and some representative
location for the 1 and 3-5 touch cases.

I am sitting here writing possible solutions trying to come up with sane
ways to handle all this, but every 5 minutes I erase what I came up with
and start over because you only see the problems once you've analysed
every scenario. I can't see any way to cater for these devices aside
from: handle them as single touch because they suck, or something
similar to what has been described in the past few hours.

> It sounds to me like latest generation of Synaptocs protocol is a dud
> and hopefully they will fix it to something more flexible in the next
> generationof chips...

We can only hope. In the meantime, it looks like Google is pushing to
use these devices on reference designs for Chrome OS, and big vendors
like Dell are perfectly happy to ship Ubuntu with the 100 times worse
(because we don't know their protocol) ALPS devices. Waiting for sanity
to win out seems like a lost cause to me :(.

-- Chase
