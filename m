Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab1GFVXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:23:01 -0400
Received: from adelie.canonical.com ([91.189.90.139]:48012 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365Ab1GFVXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:23:00 -0400
Message-ID: <4E14D22D.8050108@canonical.com>
Date: Wed, 06 Jul 2011 14:22:53 -0700
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
References: <1309324042-22943-10-git-send-email-djkurtz@chromium.org> <20110704214220.GE23915@polaris.bitmath.org> <CAGS+omAzKe5frVYuV2MPXBTugKD1xNZCHsaz53H+tDO7EWw8xQ@mail.gmail.com> <20110705192759.GA29549@polaris.bitmath.org> <CAGS+omDzg-xADYxKQmWy1KRhJ=n9pn9XR_HMc01xqCSDSLa5UA@mail.gmail.com> <20110706174503.GA5695@core.coreip.homeip.net> <20110706184759.GA3389@polaris.bitmath.org> <20110706185832.GA6086@core.coreip.homeip.net> <20110706193120.GA3884@polaris.bitmath.org> <20110706200056.GB6086@core.coreip.homeip.net> <20110706202049.GA4077@polaris.bitmath.org>
In-Reply-To: <20110706202049.GA4077@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2011 01:20 PM, Henrik Rydberg wrote:
>>> To me, it seems we do need a little bit of extra information to
>>> determine this new type of device.
>>
>> I think we already have all we need (see above).
> 
> I concur. So, to conclude:
> 
> a) The improved synaptics behavior can be achieved by simply using
> MT-B plus BTN_TOOL_*.
> 
> b) Userspace should check BTN_TOOL_* for any discrepancies between the
> maximum number of available slots (always two in this case) and the
> maximum number of fingers reported (BTN_TOOL_TRIPLETAP etc). Extra
> actions may then be taken to support more fingers than slots.
> 
> c) The semi-mt flag is only used to signal that the two points sent
> via MT-B are the corners of a bounding box.

This isn't quite enough. If we don't set the semi-mt flag or any other
new flag, then we'll have slots that become inconsistent when touches
are added or removed. For example, start with two touches being tracked
correctly. Now, add a touch. The second slot will now get the data of
the third touch, which is in a different location. You haven't changed
the tracking_id though, so it looks like the same touch. This is
incorrect behavior. Or, you could change the tracking_id, but that
implies that a touch was lifted and another was placed. This is also
incorrect behavior.

We need to tell userspace that this is a messed up device that can't
accurately track touch locations across touch up/down boundaries. Once
userspace sees this, it can act appropriately when it sees a transition
from BTN_TOOL_DOUBLETAP to BTN_TOOL_TRIPLETAP, for example. This is how
we handle transitions in the uTouch stack for semi-mt devices.

Perhaps a clean implementation would be to keep semi-mt as a flag
stating that there will only ever be two slots, the 0th will be the
minimum (x,y) of the bounding box and the 1st will be the maximum. Then,
we add a flag like NO_TOUCH_TRANSITION_TRACKING that would be set on
both semi-mt and these new devices that denote the slot data may
transition from one physical touchpoint to another when the number of
touches changes.

We could leave this up to userspace and have it detect a
NO_TOUCH_TRANSITION_TRACKING device based on the fact that the max slots
is less than the max fingers, but I would argue here that a more clear
protocol is a better protocol.

-- Chase
