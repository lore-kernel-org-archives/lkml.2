Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205Ab1LPSTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 13:19:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39884 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756594Ab1LPSTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 13:19:04 -0500
Date: Fri, 16 Dec 2011 10:18:55 -0800
From: Greg KH <gregkh@suse.de>
To: MyungJoo Ham <myungjoo.ham@gmail.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, NeilBrown <neilb@suse.de>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        android-kernel@googlegroups.com
Subject: Re: [PATCH v2 1/3] Extcon (external connector): import Android's
 switch class and modify.
Message-ID: <20111216181855.GA6332@suse.de>
References: <1323858508-27198-1-git-send-email-myungjoo.ham@samsung.com>
 <1323858508-27198-2-git-send-email-myungjoo.ham@samsung.com>
 <20111215010108.GA15650@suse.de>
 <CAJ0PZbRRiMoEDEV5vwr9rREfSejA_hqLMDmLMBoUBZKjafYq1g@mail.gmail.com>
 <20111215071859.GA13584@suse.de>
 <CAJ0PZbT-qrnr74ggQEYRjgSRqoRbW5dAxRwfjtrrDCykuLGtjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ0PZbT-qrnr74ggQEYRjgSRqoRbW5dAxRwfjtrrDCykuLGtjQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 02:38:38PM +0900, MyungJoo Ham wrote:
> On Thu, Dec 15, 2011 at 4:18 PM, Greg KH <gregkh@suse.de> wrote:
> > On Thu, Dec 15, 2011 at 02:41:38PM +0900, MyungJoo Ham wrote:
> >> On Thu, Dec 15, 2011 at 10:01 AM, Greg KH <gregkh@suse.de> wrote:
> >> >
> >> > Nice, but if we accept this, will someone also make the needed changes
> >> > to the Android userspace code to handle the user api changes that this
> >> > causes?
> >>
> >> I have no idea about how Android will react to this as I have no
> >> developmental experiences with Android.
> >> However, from the perspective of general userspace, this modification
> >> incurs path changes (/sys/class/switch/.... to /sys/class/extcon/...)
> >> only.
> >
> > Well, without such changes, any Android platform will still have to
> > include the switch code in their system, making this work a bit
> > pointless, right?
> >
> > Please look into changing this in userspace, if for no other reason than
> > to test that this kernel code works properly with the Android userspace
> > needs as well.
> 
> 1. Kernel source with Android patch has "switch" class drivers at
> /drivers/switch, which are not compatible with "extcon" class.
> 2. Android userspace access /sys/class/switch/ nodes, which are
> compatible with extcon nodes.
> 
> Not to interfere with Android kernel patches, not to be confused with
> incompatible Android switch class and its drivers, and to be
> compatible with Android userspace at the same time, we may put the
> device drivers located at Linux/drivers/extcon/ and let the class uses
> /sys/class/switch/*.

No, that's really not going to help as you changed the way the sysfs
files worked, right?

> I remember there were big no-es on using the name "switch" for these
> external connectors; however, would this userspace class name be fine?
> Or would it be fine to make the class name customizable? (let the
> device driver choose whether to be named "switch" or "extcon" or let
> the class define its location based on kernel config).
> 
> In order to get some comments from Android kernel builders, I've added
> android-kernel@googlegroups.com.

Why can't you submit patches for the userspace Android code to use this
new api instead of their sys/class/switch/ code?  If functionally it's
the same, it should be ok to do this, right?

> >> >> +                     kobject_uevent(&edev->dev->kobj, KOBJ_CHANGE);
> >> >
> >> > I really dislike using uevents, what is listening for them?  Are you
> >> > hooked into udev's event chain in userspace to properly handle this?  If
> >> > not, what is the point of sending them?
> >>
> >> It is to let userspace processes get notified for the events in extcon.
> >> Do you think sysfs_notify() would be better for this purpose?
> >
> > No, I don't think it does what you think it does :)
> >
> > What are you trying to accomplish here?  And how would sysfs_notify()
> > accomplish that?
> 
> Android has been "observing" kobject uevents. It has been observing
> the switch class kobject (&edev->dev->kobj) and that has not been
> changed from Android kernel.
> In Android, with "startObserving" method, one can let a function to be
> called with incoming UEvent.
> I haven't look into how "startObserving" is implemented. However, they
> do observe KOBJ_CHANGE at userspace. And this is not limted to
> Android.

It would be good to figure out how "observing" actually works here.

> Here, my intention is the same. It is to invoke a function in a user
> process that has registered to be invoked for a UEvent. If we are
> going to use other methods for this, we will also force userspace
> processes to change their methods to get events (at least for switch
> class and chargers) not from UEVENT.
> 
> Maybe the userspace is abusing UEVENT/KOBJ_CHANGE, though... that's
> what userspace observes to get events from kernel often.

I don't mind using the kobject change call, I just want to be very
careful about it as there aren't many users of it in the kernel at the
moment, and very little userspace code that I know of that takes
advantage of it.

If the Android framework is using it, that's fine, it's one reason to
use it, but actually determining this would be a good thing for you to
do, right?

thanks,

greg k-h
