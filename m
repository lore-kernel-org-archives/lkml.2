Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab2E2HrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 03:47:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:13813 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab2E2HrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 03:47:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="148835157"
Date: Tue, 29 May 2012 10:48:31 +0300
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, gustavo@padovan.org,
        johan.hedberg@gmail.com, davem@davemloft.net,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Bluetooth: Really fix registering hci with duplicate
 name
Message-ID: <20120529074829.GB15895@aemeltch-MOBL1>
Mail-Followup-To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Sasha Levin <levinsasha928@gmail.com>, gustavo@padovan.org,
	johan.hedberg@gmail.com, davem@davemloft.net,
	linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1338151016-13494-1-git-send-email-levinsasha928@gmail.com>
 <1338176868.15105.113.camel@aeonflux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338176868.15105.113.camel@aeonflux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 28, 2012 at 05:47:48AM +0200, Marcel Holtmann wrote:
> Hi Sasha,
> 
> > Commit fc50744 ("Bluetooth: Fix registering hci with duplicate name") didn't
> > fully fix the duplicate naming issue with devices, and duplicate device names
> > could still be created:
> > 
> > [  142.484097] device: 'hci1': device_add
> > [...]
> > [  150.545263] device: 'hci1': device_add
> > [  150.550128] kobject: 'hci1' (ffff880014cc4e58): kobject_add_internal: parent: 'bluetooth', set: 'devices'
> > [  150.558979] ------------[ cut here ]------------
> > [  150.561438] WARNING: at fs/sysfs/dir.c:529 sysfs_add_one+0xb0/0xd0()
> > [  150.572974] Hardware name: Bochs
> > [  150.580502] sysfs: cannot create duplicate filename '/devices/virtual/bluetooth/hci1'
> > [  150.584444] Pid: 7563, comm: trinity-child1 Tainted: G        W    3.4.0-next-20120524-sasha #296
> > [...]
> > 
> > Instead of the weird logic and the attempt at keeping the device list sorted,
> > just use an IDA.
> > 
> > Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> > ---
> > 
> > Changes from v1:
> > 
> >  - Address comments by Marcel.
> >  - Remove errornous mutex lock.
> > 
> >  net/bluetooth/hci_core.c |   41 ++++++++++++++++++++++++-----------------
> >  1 files changed, 24 insertions(+), 17 deletions(-)
> 
> thanks for addressing this. Patch has been applied to bluetooth-next
> tree.

The patch looks OK but I start to notice kmemleak messages like
shown below:

...
unreferenced object 0xf46e4ed8 (size 148):
  comm "modprobe", pid 656, jiffies 4294900233 (age 4661.940s)
  hex dump (first 32 bytes):
    00 00 00 00 40 4e 6e f4 00 00 00 00 00 00 00 00  ....@Nn.........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<c154dfcc>] kmemleak_alloc+0x3c/0xa0
    [<c1132c7a>] kmem_cache_alloc+0x14a/0x190
    [<c12af2dd>] idr_pre_get+0x5d/0x80
    [<c12af3e5>] ida_pre_get+0x15/0x90
    [<c12af497>] ida_simple_get+0x37/0xe0
    [<f8369b79>] 0xf8369b79
    [<f81be63e>] 0xf81be63e
    [<c13f2a5e>] usb_probe_interface+0xce/0x210
    [<c13733cb>] driver_probe_device+0x8b/0x370
    [<c1373749>] __driver_attach+0x99/0xa0
    [<c1371902>] bus_for_each_dev+0x42/0x70
    [<c1372ea1>] driver_attach+0x21/0x30
    [<c1372a47>] bus_add_driver+0x1c7/0x2e0
    [<c1373bf6>] driver_register+0x66/0x110
    [<c13f1acb>] usb_register_driver+0x7b/0x140
    [<f8005017>] 0xf8005017
unreferenced object 0xf454c260 (size 148):
  comm "modprobe", pid 656, jiffies 4294900233 (age 4661.940s)
  hex dump (first 32 bytes):
    00 00 00 00 d8 4e 6e f4 00 00 00 00 00 00 00 00  .....Nn.........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<c154dfcc>] kmemleak_alloc+0x3c/0xa0
    [<c1132c7a>] kmem_cache_alloc+0x14a/0x190
    [<c12af2dd>] idr_pre_get+0x5d/0x80
    [<c12af3e5>] ida_pre_get+0x15/0x90
    [<c12af497>] ida_simple_get+0x37/0xe0
    [<f8369b79>] 0xf8369b79
    [<f81be63e>] 0xf81be63e
    [<c13f2a5e>] usb_probe_interface+0xce/0x210
    [<c13733cb>] driver_probe_device+0x8b/0x370
    [<c1373749>] __driver_attach+0x99/0xa0
    [<c1371902>] bus_for_each_dev+0x42/0x70
    [<c1372ea1>] driver_attach+0x21/0x30
    [<c1372a47>] bus_add_driver+0x1c7/0x2e0
    [<c1373bf6>] driver_register+0x66/0x110
    [<c13f1acb>] usb_register_driver+0x7b/0x140
    [<f8005017>] 0xf8005017
...

Best regards 
Andrei Emeltchenko 

