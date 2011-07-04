Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab1GDIyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 04:54:44 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:39367 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab1GDIym convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 04:54:42 -0400
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 3.0rc3-rc5: usb stops working after resume from suspend to ram
Date: Mon, 4 Jul 2011 10:54:36 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc5-00170-gba466c7-dirty; KDE/4.6.5; x86_64; ; )
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
References: <Pine.LNX.4.44L0.1106301158310.1957-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106301158310.1957-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107041054.36890.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 of June 2011, Alan Stern wrote:

> And now you know why, more or less -- we still have to figure out the
> reason for the hang.  Probably something goes wrong when cdc-ether is
> unbound from the wireless device.

Reverting patch below fixes hang.

commit fccf4e86200b8f5edd9a65da26f150e32ba79808
Author: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Date:   Sun Jun 5 23:22:22 2011 -0700

    USB: Free bandwidth when usb_disable_device is called.
    
    Tanya ran into an issue when trying to switch a UAS device from the BOT
    configuration to the UAS configuration via the bConfigurationValue sysfs
    file.  Before installing the UAS configuration, set_bConfigurationValue()
    calls usb_disable_device().  That function is supposed to remove all host
    controller resources associated with that device, but it leaves some state
    in the xHCI host controller.
    
    Commit 0791971ba8fbc44e4f476079f856335ed45e6324
        usb: allow drivers to use allocated bandwidth until unbound
    added a call to usb_disable_device() in usb_set_configuration(), before
    the xHCI bandwidth functions were invoked.  That commit fixed a bug, but
    also introduced a bug that is triggered when a configured device is
    switched to a new configuration.
    
    usb_disable_device() goes through all the motions of unbinding the drivers
    attached to active interfaces and removing the USB core structures
    associated with those interfaces, but it doesn't actually remove the
    endpoints from the internal xHCI host controller bandwidth structures.
    
    When usb_disable_device() calls usb_disable_endpoint() with reset_hardware
    set to true, the entries in udev->ep_out and udev->ep_in will be set to
    NULL.  Usually, when the USB core installs a new configuration,
    usb_hcd_alloc_bandwidth() will drop all non-NULL endpoints in udev->ep_out
    and udev->ep_in before adding any new endpoints.  However, when the new
    UAS configuration was added, all those entries were null, so none of the
    old endpoints in the BOT configuration were dropped.
    
    The xHCI driver blindly added the UAS configuration endpoints, and some of
    the endpoint addresses overlapped with the old BOT configuration
    endpoints.  This caused the xHCI host to reject the Configure Endpoint
    command.  Now that the xHCI driver code is cleaned up to reject a
    double-add of active endpoints, we need to fix the USB core to properly
    drop old endpoints in usb_disable_device().
    
    If the host controller driver needs bandwidth checking support, make
    usb_disable_device() call usb_disable_endpoint() with
    reset_hardware set to false, drop the endpoints from the xHCI host
    controller, and then call usb_disable_endpoint() again with
    reset_hardware set to true.
    
    The first call to usb_disable_endpoint() will cancel any pending URBs and
    wait on them to be freed in usb_hcd_disable_endpoint(), but will keep the
    pointers in udev->ep_out and udev->ep in intact.  Then
    usb_hcd_alloc_bandwidth() will use those pointers to know which endpoints
    to drop.
    
    The final call to usb_disable_endpoint() will do two things:
    
    1. It will call usb_hcd_disable_endpoint() again, which should be harmless
    since the ep->urb_list should be empty after the first call to
    usb_disable_endpoint() returns.
    
    2. It will set the entries in udev->ep_out and udev->ep in to NULL, and call
    usb_hcd_disable_endpoint().  That call will have no effect, since the xHCI
    driver doesn't set the endpoint_disable function pointer.
    
    Note that usb_disable_device() will now need to be called with
    hcd->bandwidth_mutex held.
    
    This should be backported to kernels as old as 2.6.32.
    
    Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
    Reported-by: Tanya Brokhman <tlinder@codeaurora.org>
    Cc: ablay@codeaurora.org
    Cc: Alan Stern <stern@rowland.harvard.edu>
    Cc: stable@kernel.org


> Alan Stern

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
