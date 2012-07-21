Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab2GURaG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 13:30:06 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:50804 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab2GURaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 13:30:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [RFC] firmware load: defer request_firmware during early boot and resume
Date: Sat, 21 Jul 2012 19:35:43 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-usb" <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.de>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>, Jack Stone <jwjstone@fastmail.fm>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux PM list <linux-pm@vger.kernel.org>
References: <CACVXFVNWOcrR9tYhU1wVUSJ_DJ8x+SCk993Sn9dYDe2kzJBDuQ@mail.gmail.com> <201207211156.04335.rjw@sisk.pl> <CACVXFVM0hZcA8TPpydODpVsQjYP=w5PpvB4-3PZYdDu+r6SchQ@mail.gmail.com>
In-Reply-To: <CACVXFVM0hZcA8TPpydODpVsQjYP=w5PpvB4-3PZYdDu+r6SchQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207211935.44157.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 21, 2012, Ming Lei wrote:
> On Sat, Jul 21, 2012 at 5:56 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Saturday, July 21, 2012, Ming Lei wrote:
> >> CC guys who discussed the problem in the below link in Jan. :
> >>
> >>       http://marc.info/?t=132528956000002&r=10&w=2
> >>
> >> On Fri, Jul 20, 2012 at 8:33 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> >> > The RFC patch is just for discussing if the idea of deferring
> >> > request_firmware is doable for addressing the issue of
> >> > request_firmware in resume path, which is caused by driver
> >> > unbind/rebind during resume.
> >> >
> >> > At least usb bus is involved in such things, one driver may be
> >> > unbound and rebound in resume path at several situations, and
> >> > request_firmware is often called inside probe().
> >> >
> >> > Also the idea should be helpful for other hotplug buses too,
> >> > at least there was the similar problem report on pcmcia bus.
> >>
> >> Looks it works well in my two test cases: one is to call request_firmware
> >> in early boot(initcall), another one is to call request_firmware in probe()
> >> of resume path(caused by unbind & rebind).  And without the patch, both
> >> two request_firmware return failure and can't complete the loading.
> >
> > And that's precisely why you're not supposed to use request_firmware() in
> > those two situations.
> 
> So you mean we should do as below?
> 
> For the early boot situation, the driver which calls request_firmware in probe()
> can't be built in kernel image.
> 
> For the second situation, some drivers can't be allowed to call
> request_firmware()
> in its probe() because these drivers may be unbound and rebound inside resume()
> or complete_resume(),  for example, see usb_resume_complete().
> 
> IMO, the 1st one is very unfriendly and the 2nd one can't be avoided for some
> hotplug buses.

I'm not sure if it really can't be avoided.

> That is just the motivation of this patch to make request_firmware() workable in
> both the two above situations.
> 
> >
> > My opinion is that, at least for the suspend/hibernate case, the firmware
> > data should be loaded into memory before suspend (e.g. using a PM notifier)
> > and released only after the corresponding resume (or suspend failure), so
> > that it's present in memory during the entire suspend-resume cycle.
> 
> The patch isn't to replace caching firmware data during suspend-resume cycle,
> and just a supplement for it.
> 
> It is not easy to cache firmware data during suspend-resume cycle for
> the above 2nd situation because of the lifetime problem of firmware data:
> the driver may be unbound and rebound inside resume path, even the
> device may vanish and appear again.
> 
> Also, Matthew had a below case[1] which can't be solved with caching
> firmware data at all, not to mention consuming much memory by caching
> firmware:
> 
>        1) user boots from cold. Device comes up with generic USB ID.
>        2) isight_firmware loads and binds. Firmware is loaded. Device
>            disconnects and reconnects with an ID that's bound by the UVC
>            driver.
>        3) user reboots. Device comes up with UVC ID. isight_firmware
>            doesn't bind.
>        4) user suspends.
>        5) user resumes. isight_firmware binds and attempts to load firmware.
> 
> But it can be dealt with easily by the simple patch.
> 
> Finally, suppose caching firmware may work well for the 2nd situation, we still
> have to cache all the firmwares of all hotplug devices(in one system) which
> need firmware before suspending, because these devices may be unplugged
> and plugged again during suspend-resume cycle or be powered off by system.

OK, I give up.  This may not be too ugly to live, after all.

I'll post some comments in a reply to the message with the patch.

Thanks,
Rafael
