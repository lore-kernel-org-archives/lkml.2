Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab2I1N4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:56:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43180 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714Ab2I1N4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:56:14 -0400
Date: Fri, 28 Sep 2012 14:55:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ming Lei <ming.lei@canonical.com>
Cc: anish singh <anish198519851985@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] driver core: fix possible missing of device probe
Message-ID: <20120928135459.GH7916@n2100.arm.linux.org.uk>
References: <1348793563-19186-1-git-send-email-ming.lei@canonical.com> <CAK7N6vqS9PW85hgcA7EVzCk-TQo_ru4OcC5i0Rw-b2hvb4YoXg@mail.gmail.com> <20120928084626.GB7916@n2100.arm.linux.org.uk> <CACVXFVOOVvf4xOABnv1FqPOMH6_XwFcH-ZTfBDojQrZJyypT+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVOOVvf4xOABnv1FqPOMH6_XwFcH-ZTfBDojQrZJyypT+A@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 09:42:40PM +0800, Ming Lei wrote:
> On Fri, Sep 28, 2012 at 4:46 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> >
> > Actually, this description is rubbish.  It's not about the SMP barriers,
> > or read/write device/driver lists, or about two CPUs (my test setup only
> > has one CPU.)
> 
> Could you point out in detail what is wrong with my description?
> 
> Looks the description has been posted for about 12 days...
> 
> >
> > It's about threads, and the relative timing of those threads through
> 
> I do not mention threads case in one CPU because the context in
> which device_add runs will always see the driver added into

There you go again.  Look at my _much_ better description of the problem
and you'll notice that device_add has nothing to do with this.

> bus's driver list after applying the patch in this situation. And it
> is obvious under UP case.
> 
> But in SMP case, it is not so obvious like UP, driver_register and
> device_add will be run in two individual CPU,  so memory barrier

Again, device_add() has nothing to do with this.  Do you actually
understand the problem?  Plainly as you're bringing device_add() into
this, you do not.

> plays a role in making device_add see the new added driver in
> the situation described in the commit log, and avoid the problem.
> 
> > the driver model code.  All in all, what with the error path issue, and
> > now the blatently wrong description, I'm not gaining much confidence in
> > Ming Lei.
> >
> > The below is actually what's happening, according to my analysis - and
> > you'll notice that the device list has absolutely nothing to do with it:
> 
> I don't think your analysis is complete for the two reasons:
> 
>       - the problem isn't only triggered by deferred probe, and can be triggered
>         by device_add too
>       - your analysis doesn't cover SMP case

Total rubbish.  It does cover the SMP case, because those threads can run
on different CPUs.  The key issue is that there's a race between different
parts of the kernel, and IT IS NOT between the major device list and driver
list as you keep on bringing up.

> In fact, it is just a race between driver_register and device_add or
> bus_probe_device, and should be nothing to do with deferred probe.
> 
> See my posted description again:
> 
>           Inside bus_add_driver(), one device might be added into
>           the bus or probed which is triggered by deferred probe
>           just after completing of driver_attach() and before
>           'klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers)',
>           so the device won't be probed by this driver.

This paragraph makes no sense to me as a native English speaker.

> > Thread 0                        Thread 1                        Thread 2
> > driver_attach()
> >  bus_for_each_dev()
> >   __driver_attach(, devA)
> >    driver_probe_device(, devA)
> >     really_probe(devA, )
> >      driver_deferred_probe_add(devA)
> >                                 driver_attach()
> >                                  bus_for_each_dev()
> >                                   __driver_attach(, devA)
> >                                    driver_probe_device(, devB)
> >                                     really_probe(devB, )
> >                                      driver_bound(devB)
> >                                       driver_deferred_probe_trigger()
> >                                                                 deferred_probe_work_func()
> >                                                                  bus_probe_device(devA)
> >                                                                   device_attach(devA)
> >                                                                    bus_for_each_drv()
> >                                                                     __device_attach(, devA)
> >                                                                      *fails to find driver*
> >                                                                      *devA dropped from
> >                                                                       deferred probe list*
> > klist_add_tail(klist_drivers)
> 
> Didn't my description cover the description above? ( bus_probe_device is
> called between driver_attach and klist_add_tail)

Given that your description makes no sense (either to me or, as we've
also found out, to Anish Singh), it means your description is not able
to be understood.  So no, your description does not cover the situation
I reported by the mere fact that it was uninteligable.

> Also it is only one of the two situations addressed by the patch.
> 
> >
> > The reason this fix works is because the order in thread 0 means that
> > when thread 2 comes to re-probe the device, it does find the driver,
> 
> You mean the driver_attach on same driver can happen at the same time?
> If so, it is simply wrong.

Sigh... your lack of understanding is impressive.  I do not mean that
driver_attach() can happen on the same struct device_driver simultaneously.
Go back and look at my description of the three threads.  Do you see two
driver_attach() statements in that?  No.  So clearly I don't mean that.

> > and if the resources that the driver needs are still not found (and it
> > again returns -EPROBE_DEFER) the device will be placed back on the
> > deferred probe list.
> 
> Thanks,

Sorry, I don't think you know what you're talking about, and as such
please remove my reported and tested by from this patch.  I do not wish
to endorse a patch created by someone who seemingly has a total lack of
understanding of the problem I reported.

Thanks.
