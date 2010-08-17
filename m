Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0HQOzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 10:55:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42370 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750938Ab0HQOzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 10:55:17 -0400
Date: Tue, 17 Aug 2010 10:55:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH] usb: fix deadlock with bandwidth_mutex
In-Reply-To: <1282049395-5718-1-git-send-email-cascardo@holoscopio.com>
Message-ID: <Pine.LNX.4.44L0.1008171048550.1656-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010, Thadeu Lima de Souza Cascardo wrote:

> When using the remove sysfs file, the device configuration is set to -1
> (unconfigured). This eventually unbind drivers with the bandwidth_mutex
> held. Some drivers may call functions that hold said mutex, like
> usb_reset_device. This is the case for rtl8187, for example. This will
> lead to the same process holding the mutex twice, which deadlocks.

The deadlock problem probably could be handled somehow, but there's a
separate issue: Until the usb_disable_device call finishes unbinding
the drivers, the drivers are free to continue using their allocated
bandwidth.  We musn't change the bandwidth allocations until after the
unbinding is done.  So this patch is indeed necessary.

> Unbinding the driver before holding the bandwidth_mutex solves the
> problem. If any operation after that fails, drivers are not bound again.
> But that would be a problem anyway that the user may solve resetting the
> device configuration to one that works, just like he would need to do in
> most other failure cases.

That's right; we don't have to worry about this case.

Incidentally, you might also want to change the following code at the 
same time:

	mutex_lock(&hcd->bandwidth_mutex);
	ret = usb_hcd_alloc_bandwidth(dev, cp, NULL, NULL);
	if (ret < 0) {
		usb_autosuspend_device(dev);
		mutex_unlock(&hcd->bandwidth_mutex);
		goto free_interfaces;
	}

In the failure case, it would be safer to drop the mutex _before_
calling usb_autosuspend_device.

Alan Stern

