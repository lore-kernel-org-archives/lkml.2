Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab1BBW6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:58:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47231 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab1BBW6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:58:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=mj/rVXdQsm/QeTsEbG1FPy37T4tAJKAC9q0ZOToo1L3lKEXOKxnZRH539/JTFSq8ni
         pNVLMIESB2dCP4GBOhwSm6vk0U3jQodaibi/BylkE1fm2XIImFhOm462FVC+Os6fBTGf
         4fG9rx6If3x+M+n5uz9ipaTV/XQC7n2YgUYZE=
Date: Wed, 2 Feb 2011 14:58:42 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Duncan Laurie <dlaurie@chromium.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: serio - clear serio event queue after sysfs
 driver rebind
Message-ID: <20110202225842.GA25306@core.coreip.homeip.net>
References: <1290467390-25302-1-git-send-email-dlaurie@chromium.org>
 <20101127084153.GC28745@core.coreip.homeip.net>
 <AANLkTik1TE9zgKaiLQZ=1uFgMyZt43xp8VJBWfxdVyMY@mail.gmail.com>
 <20101208051211.GB4140@core.coreip.homeip.net>
 <20110201092126.GC17706@core.coreip.homeip.net>
 <AANLkTiknhubSN37ChYebWxd9Wx=R4dN38ETdZv2BZYee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTiknhubSN37ChYebWxd9Wx=R4dN38ETdZv2BZYee@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 02:41:38PM -0800, Duncan Laurie wrote:
> On Tue, Feb 1, 2011 at 1:21 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Tue, Dec 07, 2010 at 09:12:11PM -0800, Dmitry Torokhov wrote:
> >> On Mon, Nov 29, 2010 at 01:37:35PM -0800, Duncan Laurie wrote:
> >> > On Sat, Nov 27, 2010 at 12:41 AM, Dmitry Torokhov
> >> > <dmitry.torokhov@gmail.com> wrote:
> >> > > Hi Duncan,
> >> > >
> >> > > On Mon, Nov 22, 2010 at 03:09:50PM -0800, Duncan Laurie wrote:
> >> > >> When rebinding a serio driver via sysfs drvctl interface it is possible for
> >> > >> an interrupt to trigger after the disconnect of the existing driver and
> >> > >> before the binding of the new driver.  This will cause the serio interrupt
> >> > >> handler to queue a rescan event which will disconnect the new driver
> >> > >> immediately after it is attached.
> >> > >>
> >> > >> This change clears the serio event queue after processing the drvctl
> >> > >> request but before releasing the serio mutex, which will clear any queued
> >> > >> rescans before they can get processed.
> >> > >>
> >> > >> Reproduction involves issuing a rebind of device port from psmouse driver
> >> > >> to serio_raw driver while generating input to trigger interrupts.  Then
> >> > >> checking to see if the corresponding i8042/serio4/driver is correctly
> >> > >> attached to the serio_raw driver instead of psmouse.
> >> > >>
> >> > >> Signed-off-by: Duncan Laurie <dlaurie@chromium.org>
> >> > >> ---
> >> > >>  drivers/input/serio/serio.c |    1 +
> >> > >>  1 files changed, 1 insertions(+), 0 deletions(-)
> >> > >>
> >> > >> diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
> >> > >> index 405bf21..a66307e 100644
> >> > >> --- a/drivers/input/serio/serio.c
> >> > >> +++ b/drivers/input/serio/serio.c
> >> > >> @@ -454,6 +454,7 @@ static ssize_t serio_rebind_driver(struct device *dev, struct device_attribute *
> >> > >>               serio_disconnect_port(serio);
> >> > >>               error = serio_bind_driver(serio, to_serio_driver(drv));
> >> > >>               put_driver(drv);
> >> > >> +             serio_remove_pending_events(serio);
> >> > >
> >> > > Hmm, makes sense, although should we limit events being removed to
> >> > > rescan events only?
> >> > >
> >> >
> >> >
> >> > That seems reasonable.  It would mean adding a new function or a
> >> > parameter to the existing serio_remove_pending_events function, do you
> >> > have a preference?
> >> >
> >>
> >> I wonder if a boolean parameter (rescan_only) would not be the best
> >> option.
> >>
> >
> > Hi Duncan,
> >
> > I eneded up with the following patch, could you please try and see if
> > it still works for you?
> >
> 
> 
> Hi Dmitry,
> 
> I tested the patch on a CR-48 device (which is where I was seeing the
> problem because we switch to serio_raw at boot for the trackpad) and
> it does fix the problem.
> 
> Thanks for sending this, it had slipped off my todo list.
> 

Great, thank you for testing.

-- 
Dmitry
