Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab1GEFI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 01:08:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14356 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab1GEFIX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 01:08:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=xhlfOF64gaZYdbhIfP8GajB7mXA8Icl2TFegX+CbX8tRl6qZGanTHzk2hGADxojwb
	uW6UNtomMu/cIwcGUZF4Q==
MIME-Version: 1.0
In-Reply-To: <20110704214220.GE23915@polaris.bitmath.org>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
 <1309324042-22943-10-git-send-email-djkurtz@chromium.org> <20110704214220.GE23915@polaris.bitmath.org>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Tue, 5 Jul 2011 13:08:00 +0800
X-Google-Sender-Auth: VgVawwhwJONbPijhZrnl9PRpI2w
Message-ID: <CAGS+omAzKe5frVYuV2MPXBTugKD1xNZCHsaz53H+tDO7EWw8xQ@mail.gmail.com>
Subject: Re: [PATCH 09/12] Input: synaptics - add image sensor support
To: Henrik Rydberg <rydberg@euromail.se>
Cc: dmitry.torokhov@gmail.com, chase.douglas@canonical.com,
        rubini@cvml.unipv.it, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, derek.foreman@collabora.co.uk,
        daniel.stone@collabora.co.uk, olofj@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Tue, Jul 5, 2011 at 5:42 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Daniel,
>
>> Synaptics makes (at least) two kinds of touchpad sensors:
>>  * Older pads use a profile sensor that could only infer the location
>>    of individual fingers based on the projection of their profiles
>>    onto row and column sensors.
>>  * Newer pads use an image sensor that can track true finger position
>>    using a two-dimensional sensor grid.
>>
>> Both sensor types support an "Advanced Gesture Mode":
>>  When multiple fingers are detected, the touchpad sends alternating
>>  "Advanced Gesture Mode" (AGM) and "Simple Gesture Mode" (SGM)
>>  packets.
>>  The AGM packets have w=2, and contain reduced resolution finger data
>>  The SGM packets have w={0,1} and contain full resolution finger data
>>
>> Profile sensors try to report the "upper" (larger y value) finger in
>>  the SGM packet, and the lower (smaller y value) in the AGM packet.
>>  However, due to the nature of the profile sensor, they easily get
>>  confused when fingers cross, and can start reporting the x-coordinate
>>  of one with the y-coordinate of the other.  Thus, for profile
>>  sensors, "semi-mt" was created, which reports a "bounding box"
>>  created by pairing min and max coordinates of the two pairs of
>>  reported fingers.
>>
>> Image sensors can report the actual coordinates of two of the fingers
>>  present.  This patch detects if the touchpad is an image sensor and
>>  reports finger data using the MT-B protocol.
>>
>> NOTE: This patch only adds partial support for 2-finger gestures.
>>       The proper interpretation of the slot contents when more than
>>       two fingers are present is left to later patches.  Also,
>>       handling of 'number of fingers' transitions is incomplete.
>>
>> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
>
> I guess the real question here is: do the following patches really
> help? Creating additional logic to band-aid yet another special case,
> which still does not give full MT support, seems to create more
> problems than it solves. If the code was needed to ensure proper five
> finger support to userspace, then maybe one could live with
> it. However, as it stands, keeping the semi-mt behavior also for the
> slightly better devices may not be such a bad idea, after all.
>
> _Iff_ the whole series can be formulated as true protocol B support
> (no special flags, please), and _iff_ it helps to use software finger
> tracking for less than four fingers, then please do tell, and we can
> add that part to the input core to simplify the synaptics
> implementation a bit.

Image sensors and profile sensors behave differently.  However, even
the image sensors do not allow true MT-B, since they only report 2
fingers.  Hence, it makes sense to add a property to distinguish the 3
cases.

This implementation addresses the following issues:

  (1) Improves handling of the 2-finger case.  Image sensors due allow
true MT-B for two finger case.  This, for example, allows detecting
whether the click in a click+drag is happening in bottom right or
bottom left quadrant of the pad.

  (2) Helps improve handling of number-of-fingers transitions.  Most
of the complexity of the synaptics driver comes with dealing with the
complicated way that the protocol handles number-of-fingers
transitions.  Just ignoring them with semi-mt could cause lots of
jumpy behavior as the transitions are mapped to bounding boxes whose
coordinates jump around.  Thus, this implementation tries to notify
userspace of finger transition by 'rolling slots' when necessary.
What I mean is, if the driver deduces that a given slot may not
contain the same finger as a previous report, it releases it (sets its
tracking_id = -1), and reestablishes the slot with a new tracking_id
when it is more confident that it is now tracking a new finger.

  (3) Properly decode the "AGM_CONTACT" packet type.  4- and 5- finger
gestures may never be supported, however, I think it is still a good
idea to detect and parse these packets properly in the kernel driver,
and leave policy to userspace.  I'm open to alternative suggestions
for ways to represent this to userspace.  The idea in this patch set
is to reuse the MT-B plumbing as much as possible, but use the device
property to mark the fact that the interpretation of the resulting
slots is somewhat different.

A bare minimum patchset might do:
   (1) Do true MT-B for two fingers
   (2) Improved number-of-finger tracking for just the 2-finger case.
(Keep tracking finger 1 when finger 2 is removed, and vice versa)
   (3) Properly parse, but don't use, AGM_CONTACT packets

We can then argue about what to do with 3+ fingers :).

Thanks,
Daniel

>
> Thanks.
> Henrik
>
