Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab2IFJF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 05:05:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:46960 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab2IFJFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 05:05:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,379,1344236400"; 
   d="scan'208";a="142103104"
Date: Thu, 6 Sep 2012 17:05:22 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: PCI/e1000 BUG: unable to handle kernel paging request at 0ffff163
Message-ID: <20120906090522.GA25102@localhost>
References: <20120905065118.GA9603@localhost>
 <CAE9FiQVO6dj+rEP=phQD5VYEF-rak6UPYGMSV8ud0OyELo7Opg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVO6dj+rEP=phQD5VYEF-rak6UPYGMSV8ud0OyELo7Opg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 11:41:04AM -0700, Yinghai Lu wrote:
> On Tue, Sep 4, 2012 at 11:51 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > Yinghai,
> >
> > There are many kernel paging errors showing up in tree:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-for-each-res-addon-v2
> >
> > The below summary shows that
> >
> > 1) it's a reliably reproducible bug
> > 2) all paging fault happens at address 0ffff163 and in some e1000 functions
> >
> > I'll try to bisect if the root cause is not obvious to you.  (Cannot
> > do so for now because there are 3 bisections on the way and I cannot
> > afford more..)
> 
> thanks, will check that...

Yinghai, I'm very sorry that it's a false report...

The root cause is memory corruption by the isdnloop driver:

==>     [    9.345694] isdnloop-ISDN-driver Rev 1.11.6.7
==>     [    9.347484] isdnloop: (loop0) virtual card added
        [    9.348444] bus: 'usb': driver_probe_device: matched device 1-1:2.0 with driver cdc_acm
        [    9.349773] bus: 'usb': really_probe: probing driver cdc_acm with device 1-1:2.0
        [    9.350967] cdc_acm 1-1:2.0: This device cannot do calls on its own. It is not a modem.
        [    9.353255] cdc_acm 1-1:2.0: ttyACM0: USB ACM device
        [    9.354137] BUG: unable to handle kernel paging request at 0ffff163
        [    9.355214] IP: [<0ffff163>] 0xffff162
        [    9.355869] *pde = 00000000

Which was recently fixed by

        commit 77f00f6324cb97cf1df6f9c4aaeea6ada23abdb2
        Author:     Wu Fengguang <fengguang.wu@intel.com>
        Commit:     David S. Miller <davem@davemloft.net>
        CommitDate: Fri Aug 3 16:53:22 2012 -0700

            isdnloop: fix and simplify isdnloop_init()
            
            Fix a buffer overflow bug by removing the revision and printk.

Thanks,
Fengguang
