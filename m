Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab0EWXrt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 19:47:49 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:59933 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab0EWXrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 19:47:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=grKqOLJPlZy+QVNncZeTo36BEoRFJlHi/nxJvlQqJfgh0YsPYms0XwKByjdHFw4EOe
         7vi1ydt2aQgMuUFqMRxVVwdADCJSL0LPAJTCvbzdqGuEcDiLHbzSB+aVgBz3kcWv4f4V
         eQqklQl6q0gks+MkFMJQH0nY1p4fUsYeRa90o=
MIME-Version: 1.0
In-Reply-To: <4BF9ABC7.9090208@euromail.se>
References: <1274567437-2818-1-git-send-email-rydberg@euromail.se>
	 <1274567437-2818-2-git-send-email-rydberg@euromail.se>
	 <20100523102413.2fee3f4c.rdunlap@xenotime.net>
	 <4BF9ABC7.9090208@euromail.se>
Date: Sun, 23 May 2010 16:47:47 -0700
Message-ID: <AANLkTimQIIPiah962ar_TRZvJZpqCFvh-KLXxakbUHmZ@mail.gmail.com>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev4)
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 23, 2010 at 3:27 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Randy Dunlap wrote:
> [...]
>>> +Protocol Usage
>>> +--------------
>>> +
>>> +Contact details are sent sequentially as separate packets of ABS_MT
>>> +events. Only the ABS_MT events are recognized as part of a contact
>>> +packet. Since these events are ignored by current single-touch (ST)
>>> +applications, the MT protocol can be implemented on top of the ST protocol
>>> +in an existing driver.
>>> +
>>> +Drivers for type A devices mark the end of a packet by calling the
>>
>> end?

Since Randy brought this question up, I feel the urge to say
something.  I know there are X drivers and clients using the type A
format so I am not suggesting that we need to change this format.

What I am thinking is that we only need one SYN_ call for both _MT_
and regular data combined, which is a call to input_sync() at the end
of the whole packet. The SYN_MT_ can be replaced by the following
example, which I think is more "client-friendly". This solution is
based on the fact that the major difference between type A and type B
is whether we need to filter the data or not:

ABS_MT_RANDOM 0
ABS_MT_POSITION_X x[0]
ABS_MT_POSITION_Y y[0]
ABS_MT_ RANDOM 1
ABS_MT_POSITION_X x[1]
ABS_MT_POSITION_Y y[1]
SYN_REPORT

input_set_abs_params(input_dev, ABS_MT_RANDOM, 0, 2, 0, 0);

would tell the clients that they can expect two random touches.


>>> +The end of a multi-touch transfer is marked by calling the usual
>>
>> The end method is done for Types A and B, right?
>
> How about this line instead?
>
> All drivers mark the end of a multi-touch transfer by calling the usual

If we use ABS_MT_RANDOM, there would be only one SYN_ event for the
whole packet at the end, regardless of what kind of data is included
before the SYN_ event.

Basically, ABS_MT_RANDOM indicates a non-filtered and non-tracked MT_
event; ABS_MT_SLOT indicates a filtered and tracked MT_ event/slot.

With all this said, I don't have a preference for type A since I do
not need it for my driver. Just to be active in the group if you
wonder if there is any positive rationale :).

Ping
