Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab2KSQbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 11:31:05 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:52265 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753789Ab2KSQbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 11:31:02 -0500
Date: Mon, 19 Nov 2012 11:31:01 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Huang Ying <ying.huang@intel.com>
cc: Bjorn Helgaas <bhelgaas@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [RFC] PCI/PM: Keep runtime PM enabled for unbound PCI devices
In-Reply-To: <1353294849-22588-1-git-send-email-ying.huang@intel.com>
Message-ID: <Pine.LNX.4.44L0.1211191129060.1598-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2012, Huang Ying wrote:

> For unbound PCI devices, what we need is:
> 
>  - Always in D0 state, because some devices does not work again after
>    being put into D3 by the PCI bus.
> 
>  - In SUSPENDED state if allowed, so that the parent devices can still
>    be put into low power state.
> 
> To satisfy these requirement, the runtime PM for the unbound PCI
> devices are disabled and set to SUSPENDED state.  One issue of this
> solution is that the PCI devices will be put into SUSPENDED state even
> if the SUSPENDED state is forbidden via the sysfs interface
> (.../power/control) of the device.  This is not an issue for most
> devices, because most PCI devices are not used at all if unbounded.
> But there are exceptions.  For example, unbound VGA card can be used
> for display, but suspend its parents make it stop working.
> 
> To fix the issue, we keep the runtime PM enabled when the PCI devices
> are unbound.  But the runtime PM callbacks will do nothing if the PCI
> devices are unbound.  This way, we can put the PCI devices into
> SUSPENDED state without put the PCI devices into D3 state.
> 
> Known issue: after some changing, pci_dev->driver is used to indicate
> whether the PCI devices are bound and whether the runtime PM callbacks
> should do nothing.  Maybe it is better to use a dedicated flag such as
> .skip_rtpm_callbacks.  That may improve code readability.

I think it's okay like this, especially if you add a comment in 
pci_runtime_suspend, pci_runtime_resume, and pci_runtime_idle 
explaining that when pci_dev->driver isn't set, the device should 
always remain in D0 regardless of the runtime status.

Alan Stern

