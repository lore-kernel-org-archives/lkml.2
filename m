Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab2HDVcG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 17:32:06 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42157 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069Ab2HDVb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 17:31:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [BUGFIX 3/4] PCI/PM: Fix config reg access for D3cold and bridge suspending
Date: Sat, 4 Aug 2012 23:37:46 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Huang Ying <ying.huang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <Pine.LNX.4.44L0.1208031042580.1520-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1208031042580.1520-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208042337.46394.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 03, 2012, Alan Stern wrote:
> On Fri, 3 Aug 2012, Huang Ying wrote:
> 
> > This patch fixes the following bug:
> > 
> > http://marc.info/?l=linux-pci&m=134338059022620&w=2
> > 
> > Where lspci does not work properly if a device and the corresponding
> > parent bridge (such as PCIe port) is suspended.  This is because the
> > device configuration space registers will be not accessible if the
> > corresponding parent bridge is suspended or the device is put into
> > D3cold state.
> > 
> > To solve the issue, the bridge/PCIe port connected to the device is
> > put into active state before read/write configuration space registers.
> > If the device is in D3cold state, it will be put into active state
> > too.
> > 
> > To avoid resume/suspend PCIe port for each configuration register
> > read/write, a small delay is added before the PCIe port to go
> > suspended.
> 
> 
> > +static void
> > +pci_config_pm_runtime_put(struct pci_dev *pdev)
> > +{
> > +	struct device *dev = &pdev->dev;
> > +	struct device *parent = dev->parent;
> > +
> > +	pm_runtime_put(dev);
> > +	if (parent)
> > +		pm_runtime_put(parent);
> > +}
> 
> This is just the sort of thing Rafael and I have been talking about.  
> Why do an asynchronous put, going to all the trouble of using the 
> workqueue, if the idle routine is just going to call 
> pm_schedule_suspend()?

If that's PCI, it will call pm_runtime_suspend().  That probably _should_ be
pm_schedule_suspend(), but it isn't at the moment.

> Why not call pm_runtime_put_sync() instead?

I guess because the caller doesn't care whether or not the devices will be
suspended immediately and we seem to have agreed already that the added
workqueue overhead is minimal.

If the _idle() routine were to call pm_schedule_suspend(), though, I'd
agree that the overhead would be absolutely unnecessary.

Thanks,
Rafael
