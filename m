Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab0LHFMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 00:12:20 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:62173 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab0LHFMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 00:12:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=MVbh1B+iiPQBPkDO1YNidJKKovUTSGRM5520p52le1zeWCYCtnEcMfsUqETD8ngdM+
         e8i0wk2aoJNPX8MQs9GSooLcNKC+XI5kcFF0KmHzwB8tn7WFrQj/65rTAggjy7u/j94J
         7AB3j0LKV34rPCl0JWfXzHfQMXgtxrZlQ5VxU=
Date: Tue, 7 Dec 2010 21:12:11 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Duncan Laurie <dlaurie@chromium.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: serio - clear serio event queue after sysfs
 driver rebind
Message-ID: <20101208051211.GB4140@core.coreip.homeip.net>
References: <1290467390-25302-1-git-send-email-dlaurie@chromium.org>
 <20101127084153.GC28745@core.coreip.homeip.net>
 <AANLkTik1TE9zgKaiLQZ=1uFgMyZt43xp8VJBWfxdVyMY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik1TE9zgKaiLQZ=1uFgMyZt43xp8VJBWfxdVyMY@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 01:37:35PM -0800, Duncan Laurie wrote:
> On Sat, Nov 27, 2010 at 12:41 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > Hi Duncan,
> >
> > On Mon, Nov 22, 2010 at 03:09:50PM -0800, Duncan Laurie wrote:
> >> When rebinding a serio driver via sysfs drvctl interface it is possible for
> >> an interrupt to trigger after the disconnect of the existing driver and
> >> before the binding of the new driver.  This will cause the serio interrupt
> >> handler to queue a rescan event which will disconnect the new driver
> >> immediately after it is attached.
> >>
> >> This change clears the serio event queue after processing the drvctl
> >> request but before releasing the serio mutex, which will clear any queued
> >> rescans before they can get processed.
> >>
> >> Reproduction involves issuing a rebind of device port from psmouse driver
> >> to serio_raw driver while generating input to trigger interrupts.  Then
> >> checking to see if the corresponding i8042/serio4/driver is correctly
> >> attached to the serio_raw driver instead of psmouse.
> >>
> >> Signed-off-by: Duncan Laurie <dlaurie@chromium.org>
> >> ---
> >>  drivers/input/serio/serio.c |    1 +
> >>  1 files changed, 1 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
> >> index 405bf21..a66307e 100644
> >> --- a/drivers/input/serio/serio.c
> >> +++ b/drivers/input/serio/serio.c
> >> @@ -454,6 +454,7 @@ static ssize_t serio_rebind_driver(struct device *dev, struct device_attribute *
> >>               serio_disconnect_port(serio);
> >>               error = serio_bind_driver(serio, to_serio_driver(drv));
> >>               put_driver(drv);
> >> +             serio_remove_pending_events(serio);
> >
> > Hmm, makes sense, although should we limit events being removed to
> > rescan events only?
> >
> 
> 
> That seems reasonable.  It would mean adding a new function or a
> parameter to the existing serio_remove_pending_events function, do you
> have a preference?
> 

I wonder if a boolean parameter (rescan_only) would not be the best
option.

Thanks.

-- 
Dmitry
