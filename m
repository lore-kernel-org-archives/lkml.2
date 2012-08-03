Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab2HCOqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:46:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55596 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753052Ab2HCOqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:46:21 -0400
Date: Fri, 3 Aug 2012 10:46:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Huang Ying <ying.huang@intel.com>
cc: Bjorn Helgaas <bhelgaas@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [BUGFIX 3/4] PCI/PM: Fix config reg access for D3cold and bridge
 suspending
In-Reply-To: <1343975435-25469-4-git-send-email-ying.huang@intel.com>
Message-ID: <Pine.LNX.4.44L0.1208031042580.1520-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2012, Huang Ying wrote:

> This patch fixes the following bug:
> 
> http://marc.info/?l=linux-pci&m=134338059022620&w=2
> 
> Where lspci does not work properly if a device and the corresponding
> parent bridge (such as PCIe port) is suspended.  This is because the
> device configuration space registers will be not accessible if the
> corresponding parent bridge is suspended or the device is put into
> D3cold state.
> 
> To solve the issue, the bridge/PCIe port connected to the device is
> put into active state before read/write configuration space registers.
> If the device is in D3cold state, it will be put into active state
> too.
> 
> To avoid resume/suspend PCIe port for each configuration register
> read/write, a small delay is added before the PCIe port to go
> suspended.


> +static void
> +pci_config_pm_runtime_put(struct pci_dev *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device *parent = dev->parent;
> +
> +	pm_runtime_put(dev);
> +	if (parent)
> +		pm_runtime_put(parent);
> +}

This is just the sort of thing Rafael and I have been talking about.  
Why do an asynchronous put, going to all the trouble of using the 
workqueue, if the idle routine is just going to call 
pm_schedule_suspend()?

Why not call pm_runtime_put_sync() instead?

Alan Stern

