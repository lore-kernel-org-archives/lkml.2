Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1F2L03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 07:26:29 -0400
Received: from smtp-out.google.com ([74.125.121.67]:9400 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab1F2L0X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 07:26:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=TaZsGOZRh8iVhLHTyHyknpJfNPXbs++mHpwOEe7+qsTRxZhTuD15qBE2mQpbmG/BK
	uEdTJOv9uZHyTW93ERdTQ==
MIME-Version: 1.0
In-Reply-To: <4E0AFF53.5090501@canonical.com>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
 <1309324042-22943-11-git-send-email-djkurtz@chromium.org> <4E0AF84D.6050702@canonical.com>
 <20110629100759.GE2403@fooishbar.org> <4E0AFF53.5090501@canonical.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 29 Jun 2011 19:26:00 +0800
X-Google-Sender-Auth: NYO-hxeLLuOwNl-NZxKbDXCzxBk
Message-ID: <CAGS+omDYShd8iq7=9qbWM__dH7mfVFQFnuJ0k6KNRR_Hg0JP2g@mail.gmail.com>
Subject: Re: [PATCH 10/12] Input: synaptics - decode AGM packet types
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Daniel Stone <daniel@fooishbar.org>, dmitry.torokhov@gmail.com,
        rydberg@euromail.se, rubini@cvml.unipv.it, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, derek.foreman@collabora.co.uk,
        daniel.stone@collabora.co.uk, olofj@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel, Chase,

On Wed, Jun 29, 2011 at 6:32 PM, Chase Douglas
<chase.douglas@canonical.com> wrote:
> On 06/29/2011 11:07 AM, Daniel Stone wrote:
>> Hi Chase,
>>
>> On Wed, Jun 29, 2011 at 11:02:53AM +0100, Chase Douglas wrote:
>>> In the older "profile" devices, we got essentially the bounding box of
>>> all touches. This allows us to detect pinch gestures between the two
>>> most extreme touches when there are three touches on the touchpad.
>>
>> This isn't necessarily true for all pads.  If you look at Derek's
>> patchset from a couple of weeks ago, it was for a profile sensor which
>> had the same reporting behaviour.  Internally, the touchpad could track
>> many fingers, but would always report the first (in SGM packet) and most
>> recent (in AGM packet) fingers.  You could fake a bounding-box
>> calculation, but it would be the bounding box of fingers 0 and n, rather
>> than the bounding box of all fingers.
>
> Are we really sure that Derek's trackpad was a profile device? I mean
> *really* sure. Because if Synaptics is putting out two different devices
> that are identical in protocol but behave differently, then that's a
> *big* problem for us gesture developers :).
>
> I would be surprised if a profile device were providing the first and
> third touch locations as opposed to the bounding box because then
> there's no difference between it and this new "image sensor" device type.

I agree with Chase, the 0:n box behavior sounds more like image sensor
than profile sensor.
However, as I just mentioned in the previous email, I have looked at a
profile sensor that tries to report first and second finger positions,
not a bounding box.
In any case, the result is:
You end up computing (usually) a 0:1 "bounding box", with n >= 2
fingers on the pad.
I say usually because it is pretty easy to confuse the finger tracking
of a profile sensor.

>>> The above description makes it sound like we will no longer have a
>>> bounding box of touches. According to the description, if I put four
>>> fingers down in a square formation and then touch a fifth finger in the
>>> middle of the square, I will only see the locations of one corner and
>>> the middle of the square. This would make meaningful gesture detection
>>> beyond two touches nearly impossible. Is this really how the touchpad
>>> works, or is the above description not quite right?
>>
>> Yes, I believe that's how the touchpad works.  It would be nice to get
>> all fingers, but unfortunately PS/2 doesn't give us enough bandwidth to
>> do that.
>
> If this is true for these new image devices, then we'll need to set a
> different property bit other than SEMI_MT (maybe FIRST_LAST_MT? I'm not
> good with names :). I'm thinking we should disable gesture support for
> these trackpads in uTouch when there are more than two touches because
> we can't be sure what is going on in any meaningful way. The bounding
> box is more useful than this, which is really sad.
>
> -- Chase

This is exactly what this patch set does by defining the T5R2 property.

It is very challenging to support any 3+ finger gestures with a
touchpad that only reports two fingers... whether it is semi-mt or
T5R2.
You must always make an assumption about where those hidden fingers are.
But, that's a problem for userspace... :)

-Daniel
