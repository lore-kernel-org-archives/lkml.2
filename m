Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab1GRWpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 18:45:09 -0400
Received: from adelie.canonical.com ([91.189.90.139]:37873 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab1GRWpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 18:45:08 -0400
Date: Mon, 18 Jul 2011 17:44:58 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb_storage: make usb-stor-scan task non-freezable
Message-ID: <20110718224458.GD19552@thinkpad-t410>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
References: <20110718162818.GC19552@thinkpad-t410>
 <Pine.LNX.4.44L0.1107181708590.1663-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1107181708590.1663-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 05:12:35PM -0400, Alan Stern wrote:
> On Mon, 18 Jul 2011, Seth Forshee wrote:
> 
> > The following patch is in response to a consistently reproducible
> > failure to freeze tasks prior to restoring a hibernation image on a
> > Toshiba NB505 netbook. This machine has a built-in USB card reader.
> > Since the usb-stor-scan task is freezable but the code in
> > quiesce_and_remove_host() that waits for scanning to complete is not,
> > khubd can fail to freeze when processing the disconnect for the card
> > reader.
> 
> What card-reader disconnect?

The call trace (below) shows that the code is processing a device
disconnection when this happens. I don't know what triggers it. I take
it from your response that this isn't expected (sorry, I'm not really
all that familiar with USB)?

[   22.730125] Freezing of tasks failed after 20.01 seconds (1 tasks refusing to freeze, wq_busy=0):
[   22.730159] khubd           D 0000000000000000     0    20      2 0x00800000
[   22.730174]  ffff88003c1bda20 0000000000000046 ffffffff8183f119 ffff88003c1bd9e6
[   22.730187]  ffff88003c1bdfd8 ffff88003c1bdfd8 ffff88003c1bdfd8 0000000000012a40
[   22.730199]  ffff88003ce85bc0 ffff88003ca8c4d0 00000000000003f4 7fffffffffffffff
[   22.730212] Call Trace:
[   22.730232]  [<ffffffff815ed985>] schedule_timeout+0x2a5/0x320
[   22.730247]  [<ffffffff81151564>] ? kmem_cache_free+0x114/0x120
[   22.730258]  [<ffffffff815ef21e>] ? _raw_spin_lock+0xe/0x20
[   22.730270]  [<ffffffff815ed3ef>] wait_for_common+0xdf/0x180
[   22.730282]  [<ffffffff81056f20>] ? try_to_wake_up+0x200/0x200
[   22.730294]  [<ffffffff815ed56d>] wait_for_completion+0x1d/0x20
[   22.730308]  [<ffffffffa0031765>] quiesce_and_remove_host+0x65/0xc0 [usb_storage]
[   22.730319]  [<ffffffffa00317e2>] usb_stor_disconnect+0x22/0x40 [usb_storage]
[   22.730329]  [<ffffffff8144a7e2>] usb_unbind_interface+0x52/0x180
[   22.730338]  [<ffffffff813c406c>] __device_release_driver+0x7c/0xe0
[   22.730346]  [<ffffffff813c40fc>] device_release_driver+0x2c/0x40
[   22.730353]  [<ffffffff813c3ba8>] bus_remove_device+0x78/0xb0
[   22.730362]  [<ffffffff813c118d>] device_del+0x12d/0x1b0
[   22.730370]  [<ffffffff8144851f>] usb_disable_device+0xaf/0x1d0
[   22.730378]  [<ffffffff81441320>] usb_disconnect+0xa0/0x140
[   22.730386]  [<ffffffff81442120>] hub_port_connect_change+0xa0/0x6e0
[   22.730394]  [<ffffffff81447a37>] ? usb_control_msg+0xf7/0x120
[   22.730402]  [<ffffffff81442c14>] hub_events+0x4b4/0x610
[   22.730410]  [<ffffffff81442da5>] hub_thread+0x35/0x180
[   22.730419]  [<ffffffff810815f0>] ? add_wait_queue+0x60/0x60
[   22.730426]  [<ffffffff81442d70>] ? hub_events+0x610/0x610
[   22.730434]  [<ffffffff81080b4c>] kthread+0x8c/0xa0
[   22.730442]  [<ffffffff815f8724>] kernel_thread_helper+0x4/0x10
[   22.730451]  [<ffffffff81080ac0>] ? flush_kthread_worker+0xa0/0xa0
[   22.730458]  [<ffffffff815f8720>] ? gs_change+0x13/0x13

> > It seems that both should either be freezable or not freezable. Since
> > there doesn't currently seem to be any freezable way to wait on a
> > completion, I started with the simpler approach of making usb-stor-scan
> > non-freezable. If it would be preferable to make both freezable I can
> > take that approach instead.
> 
> I'm not sure what the best approach is.  usb-stor-scan has to be
> freezable, because the scanning code registers new child device
> structures, which isn't allowed during suspend or hibernation.

Unless there's some way to ensure we won't wait on scanning during
freezing, I don't really see any option besides making the wait
freezable.
