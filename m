Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab1A1RdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 12:33:20 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40138 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab1A1RdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 12:33:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xkAdCfNoTuKcbPKto8NrlIa2vGNN+Eo5Yb8by3JJjgGFalIpoiExzlTVYxvLlELg13
         9E7Xtd5bA994WAwuo4Pbd8iG011meJvTjDIvuUGXkiWpRHPj1SuJQfi09mgO581b1+Ss
         ygzOgB0E6gq06iTipZhD4YsiqEAbiiY4s2epU=
Date: Fri, 28 Jan 2011 09:33:05 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mark Lord <kernel@teksavvy.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110128173305.GC6252@core.coreip.homeip.net>
References: <20110127021227.GA29709@core.coreip.homeip.net>
 <4D40E41D.2030003@teksavvy.com>
 <20110127063815.GA29924@core.coreip.homeip.net>
 <4D414928.80801@redhat.com>
 <20110127172128.GA19672@core.coreip.homeip.net>
 <4D41C071.2090201@redhat.com>
 <20110128093922.GA3357@core.coreip.homeip.net>
 <4D42AECE.3020402@redhat.com>
 <20110128164057.GA6252@core.coreip.homeip.net>
 <4D42F686.8010104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D42F686.8010104@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 03:01:58PM -0200, Mauro Carvalho Chehab wrote:
> Em 28-01-2011 14:40, Dmitry Torokhov escreveu:
> > On Fri, Jan 28, 2011 at 09:55:58AM -0200, Mauro Carvalho Chehab wrote:
> 
> >> The rc-core register (and the corresponding input register) is done when
> >> the device detected a remote controller, so, it should be safe to register
> >> on that point. If not, IMHO, there's a bug somewhere. 
> > 
> > It is not a matter of safe or unsafe registration. Registration is fine.
> > The problem is that with the current set up is that utility is fired
> > when trunk of [sub]tree is created, but the utility wants to operate on
> > leaves which may not be there yet.
> 
> I'm not an udev expert. Is there a udev event that hits only after having
> the driver completely loaded?

Define completely loaded? For a PCI SCSI controller does fully loaded
mean all attached devices are discovered and registered with block layer?
For a wireless NIC does it mean that it assocuated with an AP? What if
you have more than one device that driver serves?

So teh answer is no and there should not be.

>
> Starting an udev rule while modprobe is
> still running is asking for race conditions.

Not if we write stuff properly.

> 
> I'm not entirely convinced that this is the bug that Mark is hitting, as

I do not know yet.

> rc-core does all needed setups before registering the evdev device. We
> need the core and the dmesg to be sure about what's happening there.

I will say it again. Your udev rule triggers when you create rcX device.
eventX device may apeear 2 hours after that (I could have evdev as a
module and blacklisted and load it later manually).

You need to split it into 2 separate steps:

1. Triggers when rcX appears, accesses only rcX and it's parents and
   does rcX related stuff.

2. Triggers when eventX appears and loads keymap and what not. Because
   it is a child of rcX (in  specific case of remotes) it may examine
   rcX attributes as well.

> 
> >> Yet, I agree that udev tries to set devices too fast.
> > 
> > It tries to set devices exacty when you tell it to do so. It's not like
> > it goes trolling for random devices is sysfs.
> > 
> >> It would be better if
> >> it would wait for a few milisseconds, to reduce the risk of race conditions.
> > 
> > Gah, I really prefer using properly engineered solutions instead of
> > adding crutches.
> 
> I agree.
> 
> >>> And this could be easily added to the udev's keymap utility that is
> >>> fired up when we discover evdevX devices.
> >>
> >> Yes, it can, if you add the IR protocol selection on that tool. A remote 
> >> controller keycode table has both the protocol and the keycodes.
> >> This basically means to merge 99% of the logic inside ir-keytable into the
> >> evdev generic tool.
> > 
> > Or just have an utility producing keymap name and feed it as input to
> > the generic tools. The way most of utilities work...
> 
> I don't like the idea of running a some logic at udev that would generate
> such keymap in runtime just before calling the generic tool. The other

Why? You'd just call something like:

      keymap $name `rc-keymap-name -d $name`

where 'keymap' is udev's utility and 'rc-keymap-name' is new utility
that incorporates map selection logic currently found in rc-keytable.

It looks like format of the keymaps is compatible between 'keymap' and
'ir-keytable' and metadata that is present in your keymaps will not
confuse 'keymap' utility.

> alternative (e. g.) to maintain the RC-protocol dependent keytables separate
> from the RC protocol used by each table will be a maintenance nightmare.

I do not propose splitting keytables, I propose splittign utilities.
ir-keytable is a kitchen sink now. It implements 'keymap', 'evtest' and
bucnch of other stuff and would be much cleaner if split apart.

> 
> >>>> Also, I'm currently working on a way to map media keys for remote controllers 
> >>>> into X11 (basically, mapping them into the keyspace between 8-255, passing 
> >>>> through Xorg evdev.c, and then mapping back into some X11 symbols). This way,
> >>>> we don't need to violate the X11 protocol. (Yeah, I know this is hacky, but
> >>>> while X11 cannot pass the full evdev keycode, at least the Remote Controllers
> >>>> will work). This probably means that we may need to add some DBus logic
> >>>> inside ir-keytable, when called via udev, to allow it to announce to X11.
> >>>
> >>> The same issue is present with other types of input devices (multimedia
> >>> keyboards emitting codes that X can't consume) and so it again would
> >>> make sense to enhance udev's utility instead of confining it all to
> >>> ir-keytable.
> >>
> >> I agree with you, but I'm not sure if we can find a solution that will
> >> work for both RC and media keyboards, as X11 evdev just maps keyboards
> >> on the 8-255 range. I was thinking to add a detection there for RC, and
> >> use a separate map for them, as RC don't need most of the normal keyboard
> >> keys.
> > 
> > Well, there will always be clashes - there is reason why evdev goes
> > beyond 255 keycodes...
> 
> Yeah. The most appropriate fix would be for X to just use the full evdev
> keycode range. However, I'm not seeing any indication that such change
> will happen soon. Not sure if there are some news about it at LCA, as
> there were one speech about this subject there.
> 

Would be nice...

Thanks.

-- 
Dmitry
