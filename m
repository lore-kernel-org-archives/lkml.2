Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab1BBWl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:41:59 -0500
Received: from smtp-out.google.com ([74.125.121.67]:44434 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab1BBWl5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:41:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=koj8lACORKaZNfbrR2hxWqw9vloPJyO/dmFSNi3FF9Oxpcu2qlvRWrLeHz3Ss7OJCj
         FjOZA06FKwJ3qjpe8AkQ==
MIME-Version: 1.0
In-Reply-To: <20110201092126.GC17706@core.coreip.homeip.net>
References: <1290467390-25302-1-git-send-email-dlaurie@chromium.org>
 <20101127084153.GC28745@core.coreip.homeip.net> <AANLkTik1TE9zgKaiLQZ=1uFgMyZt43xp8VJBWfxdVyMY@mail.gmail.com>
 <20101208051211.GB4140@core.coreip.homeip.net> <20110201092126.GC17706@core.coreip.homeip.net>
From: Duncan Laurie <dlaurie@chromium.org>
Date: Wed, 2 Feb 2011 14:41:38 -0800
X-Google-Sender-Auth: V-dee9Jp5hMXV_0F4-aXditN1yE
Message-ID: <AANLkTiknhubSN37ChYebWxd9Wx=R4dN38ETdZv2BZYee@mail.gmail.com>
Subject: Re: [PATCH] Input: serio - clear serio event queue after sysfs driver rebind
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 1:21 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Tue, Dec 07, 2010 at 09:12:11PM -0800, Dmitry Torokhov wrote:
>> On Mon, Nov 29, 2010 at 01:37:35PM -0800, Duncan Laurie wrote:
>> > On Sat, Nov 27, 2010 at 12:41 AM, Dmitry Torokhov
>> > <dmitry.torokhov@gmail.com> wrote:
>> > > Hi Duncan,
>> > >
>> > > On Mon, Nov 22, 2010 at 03:09:50PM -0800, Duncan Laurie wrote:
>> > >> When rebinding a serio driver via sysfs drvctl interface it is possible for
>> > >> an interrupt to trigger after the disconnect of the existing driver and
>> > >> before the binding of the new driver.  This will cause the serio interrupt
>> > >> handler to queue a rescan event which will disconnect the new driver
>> > >> immediately after it is attached.
>> > >>
>> > >> This change clears the serio event queue after processing the drvctl
>> > >> request but before releasing the serio mutex, which will clear any queued
>> > >> rescans before they can get processed.
>> > >>
>> > >> Reproduction involves issuing a rebind of device port from psmouse driver
>> > >> to serio_raw driver while generating input to trigger interrupts.  Then
>> > >> checking to see if the corresponding i8042/serio4/driver is correctly
>> > >> attached to the serio_raw driver instead of psmouse.
>> > >>
>> > >> Signed-off-by: Duncan Laurie <dlaurie@chromium.org>
>> > >> ---
>> > >>  drivers/input/serio/serio.c |    1 +
>> > >>  1 files changed, 1 insertions(+), 0 deletions(-)
>> > >>
>> > >> diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
>> > >> index 405bf21..a66307e 100644
>> > >> --- a/drivers/input/serio/serio.c
>> > >> +++ b/drivers/input/serio/serio.c
>> > >> @@ -454,6 +454,7 @@ static ssize_t serio_rebind_driver(struct device *dev, struct device_attribute *
>> > >>               serio_disconnect_port(serio);
>> > >>               error = serio_bind_driver(serio, to_serio_driver(drv));
>> > >>               put_driver(drv);
>> > >> +             serio_remove_pending_events(serio);
>> > >
>> > > Hmm, makes sense, although should we limit events being removed to
>> > > rescan events only?
>> > >
>> >
>> >
>> > That seems reasonable.  It would mean adding a new function or a
>> > parameter to the existing serio_remove_pending_events function, do you
>> > have a preference?
>> >
>>
>> I wonder if a boolean parameter (rescan_only) would not be the best
>> option.
>>
>
> Hi Duncan,
>
> I eneded up with the following patch, could you please try and see if
> it still works for you?
>


Hi Dmitry,

I tested the patch on a CR-48 device (which is where I was seeing the
problem because we switch to serio_raw at boot for the trackpad) and
it does fix the problem.

Thanks for sending this, it had slipped off my todo list.

-duncan
