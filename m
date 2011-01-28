Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab1A1QlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 11:41:12 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37394 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1A1QlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 11:41:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BsgPgqOkjXUMo2AlW9fN8krdogax6WU15aNEyM1+4Vkk+g6qX66tG47na9+yXCCRab
         5AncchCfVkZtttd/zz/O6XI2lTz4dPQml/xulGMg8m6XYN0sWVzFNcXORAnifL1sZ1G+
         Acump3Fz6SyKzVps6Yv2OBvvRwqEelXnkVvn8=
Date: Fri, 28 Jan 2011 08:40:57 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mark Lord <kernel@teksavvy.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110128164057.GA6252@core.coreip.homeip.net>
References: <4D40C3D7.90608@teksavvy.com>
 <4D40C551.4020907@teksavvy.com>
 <20110127021227.GA29709@core.coreip.homeip.net>
 <4D40E41D.2030003@teksavvy.com>
 <20110127063815.GA29924@core.coreip.homeip.net>
 <4D414928.80801@redhat.com>
 <20110127172128.GA19672@core.coreip.homeip.net>
 <4D41C071.2090201@redhat.com>
 <20110128093922.GA3357@core.coreip.homeip.net>
 <4D42AECE.3020402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D42AECE.3020402@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 09:55:58AM -0200, Mauro Carvalho Chehab wrote:
> Em 28-01-2011 07:39, Dmitry Torokhov escreveu:
> > On Thu, Jan 27, 2011 at 04:58:57PM -0200, Mauro Carvalho Chehab wrote:
> >> Em 27-01-2011 15:21, Dmitry Torokhov escreveu:
> >>> On Thu, Jan 27, 2011 at 08:30:00AM -0200, Mauro Carvalho Chehab wrote:
> >>>>
> >>>> On my tests here, this is working fine, with Fedora and RHEL 6, on my
> >>>> usual test devices, so I don't believe that the tool itself is broken, 
> >>>> nor I think that the issue is due to the fix patch.
> >>>>
> >>>> I remember that when Kay added a persistence utility tool that opens a V4L
> >>>> device in order to read some capabilities, this caused a race condition
> >>>> into a number of drivers that use to register the video device too early.
> >>>> The result is that udev were opening the device before the end of the
> >>>> register process, causing OOPS and other problems.
> >>>
> >>> Well, this is quite possible. The usev ruls in the v4l-utils reads:
> >>>
> >>> ACTION=="add", SUBSYSTEM=="rc", RUN+="/usr/bin/ir-keytable -a /etc/rc_maps.cfg -s $name"
> >>>
> >>> So we act when we add RC device to the system. The corresponding input
> >>> device has not been registered yet (and will not be for some time
> >>> because before creating input ddevice we invoke request_module() to load
> >>> initial rc map module) so the tool runs simultaneously with kernel
> >>> registering input device and it could very well be it can't find
> >>> something it really wants.
> >>>
> >>> This would explain why Mark sees the segfault only when invoked via
> >>> udev but not when ran manually.
> >>>
> >>> However I still do not understand why Mark does not see the same issue
> >>> without the patch. Like I said, maybe if Mark could recompile with
> >>> debug data and us a core we'd see what is going on.
> >>
> >> Race conditions are hard to track... probably the new code added some delay,
> >> and this allowed the request_module() to finish his job.
> >>
> >>> BTW, that means that we need to redo udev rules. 
> >>
> >> If there's a race condition, then the proper fix is to lock the driver
> >> until it is ready to receive a fops. Maybe we'll need a mutex to preventing
> >> opening the device until it is completely initialized.
> > 
> > No, not at all. The devices are ready to handle everything when they are
> > created, it's just some devices are not there yet. What you do with
> > current udev rule is similar to trying to mount filesystem as soon as
> > you discover a PCI SCSI card. The controller is there but disks have not
> > been discovered, block devices have not been created, and so on.
> 
> The rc-core register (and the corresponding input register) is done when
> the device detected a remote controller, so, it should be safe to register
> on that point. If not, IMHO, there's a bug somewhere. 

It is not a matter of safe or unsafe registration. Registration is fine.
The problem is that with the current set up is that utility is fired
when trunk of [sub]tree is created, but the utility wants to operate on
leaves which may not be there yet.

> 
> Yet, I agree that udev tries to set devices too fast.

It tries to set devices exacty when you tell it to do so. It's not like
it goes trolling for random devices is sysfs.

> It would be better if
> it would wait for a few milisseconds, to reduce the risk of race conditions.

Gah, I really prefer using properly engineered solutions instead of
adding crutches.

> 
> >> It is hard to tell, as Mark didn't provide us yet the dmesg info (at least
> >> on the emails I was c/c), so I don't even know what device he has, and what
> >> drivers are used.
> > 
> > I belie you have been copied on the mail that had the following snippet:
> > 
> >> kernel: Registered IR keymap rc-rc5-tv
> >> udevd-event[6438]: run_program: '/usr/bin/ir-keytable' abnormal exit
> >> kernel: input: i2c IR (Hauppauge) as /devices/virtual/rc/rc0/input7
> >> kernel: ir-keytable[6439]: segfault at 8 ip 00000000004012d2 sp 00007fff6d43ca60 error 4 in ir-keytable[400000+7000]
> >> kernel: rc0: i2c IR (Hauppauge) as /devices/virtual/rc/rc0
> >> kernel: ir-kbd-i2c: i2c IR (Hauppauge) detected at i2c-0/0-0018/ir0 [ivtv i2c driver #0]
> 
> Ok, the last line says it is a ivtv board, using IR. However, it doesn't show
> the I2C detection of other devices that might be racing to gain access to the
> I2C bus, nor if some OOPS were hit by kernel.
> 
> I don't have any ivtv boards handy, but there are some developers at
> linux-media ML that may help with this.
> 
> >>> Maybe we should split
> >>> the utility into 2 parts - one dealing with rcX device and for keymap
> >>> setting reuse udev's existing utility that adjusts maps on ann input
> >>> devices, not for RCs only.
> >>
> >> It could be done, but then we'll need to pollute the existing input tools
> >> with RC-specific stuff. For IR, there are some additional steps, like
> >> the need to select the IR protocol, otherwise the keytable is useless.
> > 
> > That should be done by the separate utility that fires up when udev gets
> > event for /sys/class/rc/rcX device.
> > 
> >> Also, the keytable and persistent info is provided via /sys/class/rc/rc?/uevent.
> >> So, the tool need to first read the RC class, check what keytable should be
> >> associated with that device (based on a custom file), and load the proper
> >> table.
> > 
> > And this could be easily added to the udev's keymap utility that is
> > fired up when we discover evdevX devices.
> 
> Yes, it can, if you add the IR protocol selection on that tool. A remote 
> controller keycode table has both the protocol and the keycodes.
> This basically means to merge 99% of the logic inside ir-keytable into the
> evdev generic tool.

Or just have an utility producing keymap name and feed it as input to
the generic tools. The way most of utilities work...

> 
> I'm not against it, although I prefer a specialized tool for RC.
> 
> >> Also, I'm currently working on a way to map media keys for remote controllers 
> >> into X11 (basically, mapping them into the keyspace between 8-255, passing 
> >> through Xorg evdev.c, and then mapping back into some X11 symbols). This way,
> >> we don't need to violate the X11 protocol. (Yeah, I know this is hacky, but
> >> while X11 cannot pass the full evdev keycode, at least the Remote Controllers
> >> will work). This probably means that we may need to add some DBus logic
> >> inside ir-keytable, when called via udev, to allow it to announce to X11.
> > 
> > The same issue is present with other types of input devices (multimedia
> > keyboards emitting codes that X can't consume) and so it again would
> > make sense to enhance udev's utility instead of confining it all to
> > ir-keytable.
> 
> I agree with you, but I'm not sure if we can find a solution that will
> work for both RC and media keyboards, as X11 evdev just maps keyboards
> on the 8-255 range. I was thinking to add a detection there for RC, and
> use a separate map for them, as RC don't need most of the normal keyboard
> keys.

Well, there will always be clashes - there is reason why evdev goes
beyond 255 keycodes...

Thanks.

-- 
Dmitry
