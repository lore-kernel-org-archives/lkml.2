Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab2GSRFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 13:05:55 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:54853 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab2GSRFx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 13:05:53 -0400
MIME-Version: 1.0
In-Reply-To: <500832D7.4040805@canonical.com>
References: <1342606923-9997-1-git-send-email-cywang@chromium.org>
 <5006D86C.7030208@canonical.com> <CAM2ehZbftDja6CBGjhL3Jp+30DtYJj+8_4e=_wWcj3pCDGD7AA@mail.gmail.com>
 <500832D7.4040805@canonical.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Fri, 20 Jul 2012 01:05:30 +0800
X-Google-Sender-Auth: itUsv1TZIUp8QSMOcAR822291WQ
Message-ID: <CAGS+omA-PwoM=U3xP_Gtadaow9SGt555NPWor_-HuvVE8-R3MQ@mail.gmail.com>
Subject: Re: [PATCH v2] Input: synaptics - use firmware data for Cr-48
To: Chase Douglas <chase.douglas@canonical.com>
Cc: =?UTF-8?B?IkNodW5nLVlpaCBXYW5nICjnjovltIfmh78pIg==?= 
	<cywang@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, JJ Ding <dgdunix@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 12:16 AM, Chase Douglas
<chase.douglas@canonical.com> wrote:
>
> On 07/18/2012 08:02 PM, Chung-Yih Wang (王崇懿) wrote:
>>
>> Hi Chase,
>>
>>     Thanks for your great comments. You are right, it is impossible to
>> get  correct finger tracking if both fingers are moving. However, we
>> think it still worth to have the firmware tracking of the fingers as
>> they could perform well for most one-stationary-one-moving cases. This
>> will be good enough for the one-stationary-one-moving gestures we want
>> to provide on Cr-48. And that's why we want to make the patch specific
>> to Cr-48.
>
>
> Can you provide more details on what you are attempting to accomplish?

The Cr-48 profile sensor is also a Clickpad.  Thus, one of the most
common user gestures is to click the pad with one finger (to start a
selection) and then swipe a second (almost always "upper") finger
across the pad to extend the selection (or move a selected object).

The semi-mt approach is breaking down when the swiping finger moves
horizontally and "crosses over top" of a lower "stationary" finger.
For example, if a user clicks their finger in the bottom center of the
pad, and while using a second finger to horizontally extend a
selection, the fingers cross in the X direction.

As the moving finger approaches the same X coordinate as the
stationary finger, the reported position of the bottom finger will
start to move significantly towards the upper finger due to a
"pulling" affect of the profile sensor.  Thus, that bottom, stationary
finger starts to move towards the finger that is actually moving.
Eventually, when the moving finger gets close enough to the stationary
finger, the reported X coordinate of the two fingers becomes the same
- the two fingers' reported X coordinates "merge".  As the moving
finger continues to move towards, over and past the lower finger, the
reported position of the two fingers moves together, until the moving
finger gets significantly far enough away (in X) from the lower
finger, at which point the lower finger's reported position starts
moving back to its actual position.

Due to this effect, when using semi-mt, it is very difficult to know
at which point the "finger pattern" of the bounding box changes; in
other words, when the fingers change from "BottomLeft / TopRight" to
"BottomRight / TopLeft".  It can be approximated by assuming that the
"finger pattern" changes when the merged X coordinate passes over the
original starting point of the bottom finger.  However, this
approximation only holds when the bottom finger is perfectly
stationary.  In the real world, the bottom finger rolls/wiggles or
otherwise moves, causing the actual crossing point to change.  Or, as
is also likely, the lower finger is already being pulled when the
upper finger starts moving, so its reported position is already not at
the correct crossing point.  Thus, using semi-mt with this profile
sensor clickpad, we have not been able to generate smooth pointer
motion when an upper finger crosses a lower finger.

What we found, though, is that the firmware does do a much better job
of tracking such horizontal crosses.  Therefore, we would like to get
this raw data from the kernel.  It is trivial for userspace to convert
the raw finger position data to a bounding box format for use with
other gestures.

In any case, we really aren't that familiar with how other "synaptics
semi-mt-compatible" touchpads work.  Using this patch may or may not
be better than semi-mt.  Or, their firmware may or may not follow the
same "always report upper finger in sgm" rule (we have seen other
Synaptics trackpads that do "always report oldest finger in sgm").
This is why we chose to isolate this change to just one hardware type,
so that the change, which improves the experience of a Cr-48 user, has
no deleterious affect on users of any other hardware.

If others try this method with their hardware and it works for them,
then great!   We would be happy to help review additional patches that
extend it to additional systems.

-Daniel

> The only thing you can't do easily with semi-mt is:
>
> * Rotations (but the hardware can't do it anyway, so this is moot)
> * Pinch directions at 45 degree angles (i.e. (pinch up and left, down and
> right) or (pinch down and left, up and right))
>
> You should be able to do everything else with semi-mt, such as pinch
> horizontally vs pinch vertically, movement, etc.
>
> The pinch directions at 45 degree angles could be possible with the Cr-48
> trackpad, but I would want to know that there's a real use case for it
> before undertaking an effort to support it.
>
> -- Chase
