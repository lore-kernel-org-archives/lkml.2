Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab2GSRen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 13:34:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36215 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2GSRek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 13:34:40 -0400
Message-ID: <50084529.2030001@canonical.com>
Date: Thu, 19 Jul 2012 10:34:33 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120620 Thunderbird/14.0
MIME-Version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
CC: =?UTF-8?B?IkNodW5nLVlpaCBXYW5nICjnjovltIfmh78pIg==?= 
	<cywang@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, JJ Ding <dgdunix@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Input: synaptics - use firmware data for Cr-48
References: <1342606923-9997-1-git-send-email-cywang@chromium.org> <5006D86C.7030208@canonical.com> <CAM2ehZbftDja6CBGjhL3Jp+30DtYJj+8_4e=_wWcj3pCDGD7AA@mail.gmail.com> <500832D7.4040805@canonical.com> <CAGS+omA-PwoM=U3xP_Gtadaow9SGt555NPWor_-HuvVE8-R3MQ@mail.gmail.com>
In-Reply-To: <CAGS+omA-PwoM=U3xP_Gtadaow9SGt555NPWor_-HuvVE8-R3MQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2012 10:05 AM, Daniel Kurtz wrote:
> On Fri, Jul 20, 2012 at 12:16 AM, Chase Douglas
> <chase.douglas@canonical.com> wrote:
>>
>> On 07/18/2012 08:02 PM, Chung-Yih Wang (王崇懿) wrote:
>>>
>>> Hi Chase,
>>>
>>>      Thanks for your great comments. You are right, it is impossible to
>>> get  correct finger tracking if both fingers are moving. However, we
>>> think it still worth to have the firmware tracking of the fingers as
>>> they could perform well for most one-stationary-one-moving cases. This
>>> will be good enough for the one-stationary-one-moving gestures we want
>>> to provide on Cr-48. And that's why we want to make the patch specific
>>> to Cr-48.
>>
>>
>> Can you provide more details on what you are attempting to accomplish?
>
> The Cr-48 profile sensor is also a Clickpad.  Thus, one of the most
> common user gestures is to click the pad with one finger (to start a
> selection) and then swipe a second (almost always "upper") finger
> across the pad to extend the selection (or move a selected object).
>
> The semi-mt approach is breaking down when the swiping finger moves
> horizontally and "crosses over top" of a lower "stationary" finger.
> For example, if a user clicks their finger in the bottom center of the
> pad, and while using a second finger to horizontally extend a
> selection, the fingers cross in the X direction.
>
> As the moving finger approaches the same X coordinate as the
> stationary finger, the reported position of the bottom finger will
> start to move significantly towards the upper finger due to a
> "pulling" affect of the profile sensor.  Thus, that bottom, stationary
> finger starts to move towards the finger that is actually moving.
> Eventually, when the moving finger gets close enough to the stationary
> finger, the reported X coordinate of the two fingers becomes the same
> - the two fingers' reported X coordinates "merge".  As the moving
> finger continues to move towards, over and past the lower finger, the
> reported position of the two fingers moves together, until the moving
> finger gets significantly far enough away (in X) from the lower
> finger, at which point the lower finger's reported position starts
> moving back to its actual position.
>
> Due to this effect, when using semi-mt, it is very difficult to know
> at which point the "finger pattern" of the bounding box changes; in
> other words, when the fingers change from "BottomLeft / TopRight" to
> "BottomRight / TopLeft".  It can be approximated by assuming that the
> "finger pattern" changes when the merged X coordinate passes over the
> original starting point of the bottom finger.  However, this
> approximation only holds when the bottom finger is perfectly
> stationary.  In the real world, the bottom finger rolls/wiggles or
> otherwise moves, causing the actual crossing point to change.  Or, as
> is also likely, the lower finger is already being pulled when the
> upper finger starts moving, so its reported position is already not at
> the correct crossing point.  Thus, using semi-mt with this profile
> sensor clickpad, we have not been able to generate smooth pointer
> motion when an upper finger crosses a lower finger.
>
> What we found, though, is that the firmware does do a much better job
> of tracking such horizontal crosses.  Therefore, we would like to get
> this raw data from the kernel.  It is trivial for userspace to convert
> the raw finger position data to a bounding box format for use with
> other gestures.
>
> In any case, we really aren't that familiar with how other "synaptics
> semi-mt-compatible" touchpads work.  Using this patch may or may not
> be better than semi-mt.  Or, their firmware may or may not follow the
> same "always report upper finger in sgm" rule (we have seen other
> Synaptics trackpads that do "always report oldest finger in sgm").
> This is why we chose to isolate this change to just one hardware type,
> so that the change, which improves the experience of a Cr-48 user, has
> no deleterious affect on users of any other hardware.
>
> If others try this method with their hardware and it works for them,
> then great!   We would be happy to help review additional patches that
> extend it to additional systems.

Ok, that's very helpful to know, thanks for providing such a detailed 
response!

So the problem is that you want to support the kernel providing two 
touches, but the touch locations are only valid if they do not cross in 
the Y axis. That's a very nuanced property of the device, one that is 
only specific to certain touchpads from one manufacturer.

I understand the usefulness of this functionality, but I also worry 
about proliferating the number of properties for devices (there are only 
32 bits we can use, IIRC). I see four options off the top of my head:

* Don't do anything, leave it as SEMI_MT. Obviously this would suck, but 
it is an option.

* Make the trackpad advertise itself as *not* SEMI_MT. This would be 
broken, however, if the user performs a rotation where the touches cross 
in the Y axis. I feel this is plain wrong according to the stated 
protocol documentation and previous behavior, so I don't want to do this.

* Add a new device property (INVALID_Y_AXIS_CROSSING?) that describes 
the exact behavior of this device. I would be ok with this if everyone 
else is, but only because proper clickpad behavior (which I consider 
very importand) is broken without this knowledge.

* Leave the device as SEMI_MT, but provide the real locations, and allow 
userspace to determine the device vendor/model/etc. If userspace knows 
that a specific device behaves in a specific way, it can do its own 
quirking handling. Given the specificity of this behavior to only some 
devices of one brand, this would be my suggested resolution to the issue.

-- Chase
