Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab2I1Ism (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:48:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42952 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab2I1Isk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:48:40 -0400
Date: Fri, 28 Sep 2012 09:46:26 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: anish singh <anish198519851985@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] driver core: fix possible missing of device probe
Message-ID: <20120928084626.GB7916@n2100.arm.linux.org.uk>
References: <1348793563-19186-1-git-send-email-ming.lei@canonical.com> <CAK7N6vqS9PW85hgcA7EVzCk-TQo_ru4OcC5i0Rw-b2hvb4YoXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7N6vqS9PW85hgcA7EVzCk-TQo_ru4OcC5i0Rw-b2hvb4YoXg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 09:01:13AM +0530, anish singh wrote:
> Hello Ming,
> Though I am not an expert in this driver core area but
> I have been following this fix.So have some queries below:
> 
> On Fri, Sep 28, 2012 at 6:22 AM, Ming Lei <ming.lei@canonical.com> wrote:
> > Inside bus_add_driver(), one device might be added into
> should it not be "driver might be added into"?
> > the bus or probed which is triggered by deferred probe
> > just after completing of driver_attach() and before
> > 'klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers)',
> > so the device won't be probed by this driver.
> So the corresponding device will not be probed.
> >
> > This patch moves the below line
> >
> >         'klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers)'
> >
> > before driver_attach() inside bus_add_driver().
> >
> > So fixes the problem since the below way can guarantee that
> > no probe(dev) may be lost.
> >
> As I understand CPU0 is just calling bus_add_driver and driver_attach
> is called and after that it was pre-empted and cpu1 came into picture.
> Deferred probe started running on cpu1 and it didn't find the driver present
> int the knode_bus and unloaded the driver(why it unloaded is already
> explained by russell in his first post).
> Hope my understanding is correct.
> > CPU0                                    CPU1
> > driver_register
> >         ...
> >         write(bus->driver_list)
> >         smp_mb()
> >         read(bus->device_list)
> >         ...
> >                                         device_add
> >                                                 /* bus_add_device */
> >                                                 write(bus->device_list)
> >                                                 smp_mb()
> >                                                 /* bus_probe_device*/
> >                                                 read(bus->driver_list)

Actually, this description is rubbish.  It's not about the SMP barriers,
or read/write device/driver lists, or about two CPUs (my test setup only
has one CPU.)

It's about threads, and the relative timing of those threads through
the driver model code.  All in all, what with the error path issue, and
now the blatently wrong description, I'm not gaining much confidence in
Ming Lei.

The below is actually what's happening, according to my analysis - and
you'll notice that the device list has absolutely nothing to do with it:

Thread 0			Thread 1			Thread 2
driver_attach()
 bus_for_each_dev()
  __driver_attach(, devA)
   driver_probe_device(, devA)
    really_probe(devA, )
     driver_deferred_probe_add(devA)
				driver_attach()
				 bus_for_each_dev()
				  __driver_attach(, devA)
				   driver_probe_device(, devB)
				    really_probe(devB, )
				     driver_bound(devB)
				      driver_deferred_probe_trigger()
								deferred_probe_work_func()
								 bus_probe_device(devA)
								  device_attach(devA)
								   bus_for_each_drv()
								    __device_attach(, devA)
								     *fails to find driver*
								     *devA dropped from
								      deferred probe list*
klist_add_tail(klist_drivers)

The reason this fix works is because the order in thread 0 means that
when thread 2 comes to re-probe the device, it does find the driver,
and if the resources that the driver needs are still not found (and it
again returns -EPROBE_DEFER) the device will be placed back on the
deferred probe list.
