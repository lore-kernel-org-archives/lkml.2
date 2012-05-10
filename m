Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab2EJS6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:58:30 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36713 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab2EJS63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:58:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>, Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC v2 2/5] PM, Add sysfs file power_off to control device power off policy
Date: Thu, 10 May 2012 21:03:21 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: huang ying <huang.ying.caritas@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>, Lan Tianyu <tianyu.lan@intel.com>
References: <Pine.LNX.4.44L0.1205101046010.1831-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1205101046010.1831-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205102103.21307.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 10, 2012, Alan Stern wrote:
> On Thu, 10 May 2012, Huang Ying wrote:
> 
> > How to remove power is not general enough, but I think whether to power
> > off is more general.  So a flag like power_must_be_on can be general and
> > useful.
> 
> I'm not so sure about that.

Me neither. :-)

> > > Also, from a driver's perspective the result of putting a device into
> > > some non-power-off low-power state may be just as unpleasant as the
> > > result of removing power from it.
> > 
> > Yes.  From device driver or bus point of view, "power off" is just like
> > other low power state.  But from the "all devices" point of view, power
> > off can be the only low power state that is shared by all devices.  So
> > we can say "power off" is special from this point of view.
> 
> No -- it's not true that all devices share a "power off" state while 
> the system is running.
> 
> The only thing that can be said about all devices is that some of them 
> can be put into one or many low-power states.  That's what the PM core 
> means when it talks about runtime suspend.

That's correct.

We actually had discussed that in-depth when we were about to implement the
runtime PM core code and the conclusion was that low-power states, including
the "power off" one, could not be generalized.  That's why we decided to make
the runtime PM core distinguish only two status values related to the current
state of the device, active, which meant that the device could do the I/O
normally, and suspended, which meant that the device was not supposed to do the
I/O (most likely because it was in a low-power state of some sort).

The handling of the detials related to device low-power states is supposed to
be done at the subsystem (e.g. bus type) or PM domain level and "power off" is
just one of those states, so I think it should just stay at this level.

Of course, the power state of a parent device may be restricted by its children
requirements, but "don't remove power from me" is just one way of specifying
them (and it's not universal).

So, I suggest that we add a no_d3_cold flag to struct pci_dev and an analogous
flag to the SATA data structures and make the PCI core and SATA controller
drivers use those flags.  If it turns out that we can or have to do something
more general in the future, we'll to it _then_.

Thanks,
Rafael
