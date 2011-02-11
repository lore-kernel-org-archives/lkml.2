Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab1BKRz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 12:55:58 -0500
Received: from smtp-out.google.com ([216.239.44.51]:31144 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429Ab1BKRz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 12:55:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=aaG0z4X6afh8zXSVrDDwmAITVUbVx2B+zphRRPsXD4DoLUJdd1oHOwxnUvIpRZI6Um
         //MA7Ar/nFFWmao8wINw==
MIME-Version: 1.0
In-Reply-To: <20110211100439.GA1938@polaris.bitmath.org>
References: <1297381370-16388-1-git-send-email-tlambert@chromium.org>
	<20110211100439.GA1938@polaris.bitmath.org>
Date: Fri, 11 Feb 2011 09:55:53 -0800
X-Google-Sender-Auth: O-pjaKn8L2aRVhY9g_WgfeJ8KYM
Message-ID: <AANLkTikM3G5+KYXGe4hBL7LHg1-W0-dgN7jOGA2fbLvZ@mail.gmail.com>
Subject: Re: [PATCH] Input: fixed EVIOCGRAB iterative grab/release.
From: Terry Lambert <tlambert@chromium.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

I'm in the middle of cutting down my failure case right now, so I
should be able to provide a stand-alone test case shortly.  This is my
top priority at work right now.

And you are correct about the race.  This is about back-to-back
operations of a tool in a script, on a relatively slow machine with
obstinate hardware, and a grabby Xorg driver (it's the closed source
one, so I can't make it non-grabby).  So technically a stress test.

You noted the evdev->mutex; the idempotence of the call for the two
pointer clears will be preserved by the mutex, so no one is going to
get in under it while it's grabbed in the evdev_* layer, and not
grabbed in the input_*_device layer, and get unhappy.

So at worst it's a no-op change that scratches my particularly weird itch here.

PS: I supposed this use of the mutex is worthy of a comment in the
code?  Any guidance?

-- Terry

On Fri, Feb 11, 2011 at 2:04 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Terry,
>
>> Fixed order of calls in evdev_ungrab to allow iterative use of
>> code which grabs and releases input event devices.
>>
>> Signed-off-by: Terry Lambert <tlambert@chromium.org>
>> ---
>>  drivers/input/evdev.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
>> index c8471a2..0bac8da 100644
>> --- a/drivers/input/evdev.c
>> +++ b/drivers/input/evdev.c
>> @@ -160,9 +160,9 @@ static int evdev_ungrab(struct evdev *evdev, struct evdev_client *client)
>>       if (evdev->grab != client)
>>               return  -EINVAL;
>>
>> +     input_release_device(&evdev->handle);
>>       rcu_assign_pointer(evdev->grab, NULL);
>>       synchronize_rcu();
>> -     input_release_device(&evdev->handle);
>
> I imagine the current code could lead to a race situation if there
> were no other locks involved. However, evdev_ungrab() is always called
> under evdev->mutex. As Dmitry hinted, grabbing "usually works", so
> perhaps you could device a tiny program which reproduces the problem?
>
> Thanks,
> Henrik
>
