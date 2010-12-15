Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968Ab0LOAV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 19:21:56 -0500
Received: from adelie.canonical.com ([91.189.90.139]:55815 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482Ab0LOAVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 19:21:54 -0500
Message-ID: <4D080A13.6050601@canonical.com>
Date: Tue, 14 Dec 2010 16:21:39 -0800
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Henrik Rydberg <rydberg@euromail.se>, Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Alternative approach to MT_TOOL_ENVELOPE
References: <1292361672-2581-1-git-send-email-chase.douglas@canonical.com> <20101214221241.GA11519@core.coreip.homeip.net>
In-Reply-To: <20101214221241.GA11519@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 02:12 PM, Dmitry Torokhov wrote:
> Hi Chase,
> 
> On Tue, Dec 14, 2010 at 01:21:08PM -0800, Chase Douglas wrote:
>> Hello all,
>>
>> I was left somewhat dissatisfied by the MT_TOOL_ENVELOPE addition, so I decided
>> to try to propose a different solution for the problem. As a recap, the problem
>> can best be defined by Synaptics hardware that provide two touch coordinates
>> (X1, Y1) and (X2, Y2). Unfortunately, the real touches may be at (X1, Y2) and
>> (X2, Y1). Further, three touches may be recognized, but only two coordinates are
>> reported.
>>
>> Following this are four patches. The first merely reverts the MT_TOOL_ENVELOPE
>> addition. The second adds documentation for evdev codes to the Documentation
>> directory. It was hastily created, so it has some ommissions and may have some
>> mistakes. My hope is that we keep this or a similar document up to date whenever
>> non-obvious codes are added to evdev.
> 
> This is great, thank you.

I've found a few formatting issues, so don't apply it quite yet.

>> The third patch adds the following EV_ABS
>> codes:
>>
>> ABS_RECT_MIN_X
>> ABS_RECT_MIN_Y
>> ABS_RECT_MAX_X
>> ABS_RECT_MAX_Y
>>
>> The purpose of these codes is to provide for devices that at best report a
>> rectangular bounding box of touches. Instead of using the MT evdev protocol,
>> this approach uses ST protocol semantics.
>>
>> Finally, the last patch adds support for the above codes to the synaptics
>> driver.
>>
>> It is my belief that this is a better interface than MT_TOOL_ENVELOPE for the
>> following reasons:
>>
>> * The code meanings are more readily graspable from the names
>> * The codes behave with ST semantics, which is useful because we likely cannot
>>   split properties like pressure and orientation among the touches
>> * ST semantics are easier to comprehend than MT semantics, and MT isn't required
>>   to solve this problem
>> * The codes provide only the max and min values, none in between. This is in
>>   contrast with MT_TOOL_ENVELOPE, which provides all touches as presented by the
>>   hardware. However, we don't trust all the coordinate pairings, so providing
>>   faulty pairings may induce incorrect userspace usage of the events.
>> * A clear distinction is made here that full multitouch devices should use the
>>   MT protocol, while lesser devices should use the ST protocol.
>>
> 
> No, I do not agree with this proposal. This would introduce new _axes_
> (with potentially different min, max, resolution, etc) for the working
> surface of the devices instead of merely saying that the device may
> report more than simple singular contact within the standard axes.
> 
> I believe that MT protocol _is_ the correct vehicle to transmit semi-MT
> device state to userspace.
> 
> As to reporting more than 2 contacts with MT_TOOL_ENVELOPE - I think we
> should not do that. Instead we should only report 2 outermost points of
> the bounding rectangle as MT_TOOL_ENVELOPE and convey number of contacts
> with BTN_TOOL_xxxTAP (so up to 4 contacts, at least for now).

I gave this some more thought, and I was close to accepting it with
documentation of the above restrictions. Then I thought of how the
following two devices would be presented to userspace:

1. A real MT device supporting up to 2 touches (e.g. a bamboo touch)
  - ABS_{X,Y}, BTN_TOUCH, BTN_TOOL_FINGER, and BTN_TOOL_DOUBLETAP for ST
  - ABS_MT_SLOT, ABS_MT_TRACKING_ID, ABS_MT_POSITION_{X,Y}, ABS_MT_TOOL_TYPE

2. A partial MT device using MT_TOOL_ENVELOPE (e.g. synaptics MT)
  - ABS_{X,Y}, BTN_TOUCH, BTN_TOOL_FINGER, and BTN_TOOL_DOUBLETAP for ST
  - ABS_MT_SLOT, ABS_MT_TRACKING_ID, ABS_MT_POSITION_{X,Y}, ABS_MT_TOOL_TYPE

Note that they are identical! The range of values for each axis would be
identical too. The only way to tell the two apart would be to watch for
the ABS_MT_TOOL_TYPE axis. If the tool type stays MT_TOOL_FINGER when
both slots are active, it's a real MT device. If the tool type switches
to MT_TOOL_ENVELOPE, it's a partial MT device.

This means in userspace we cannot determine the full capabilities of the
device until at least two fingers touch it. This presents a challenge to
user space software like X and a gesture recognizer. In the former case,
the device properties would need to be changed, and X clients may need
to watch the device properties to ensure they are handling devices
correctly. No one does this yet because no input devices have ever
needed to be mutable. In the recognizer case, a partial MT device cannot
perform some rotation gestures. Gesture clients will need to know
whether a rotation gesture is possible on a given device.

Further, another issue I see is that this conflates boundary boxes of
input touches with tool type. How do we denote the tool type of a
partial MT device when MT_TOOL_ENVELOPE is taking up the
ABS_MT_TOOL_TYPE property? Or do we want to codify MT_TOOL_ENVELOPE to
mean a bounding box of *only* finger touches? If the latter, that's just
piling even more constraints on an evdev code name that doesn't give a
hint of any of these complexities. We can document this all, but I have
a hard time thinking this is the best way forward.

I understand that more new ABS_* axes may be undesirable, but it feels
the best approach to me. However, I would be ok with MT slots approaches
as long as they are well defined and do not introduce problems
highlighted above.

Thanks,

-- Chase
