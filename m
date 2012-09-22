Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2IVIgs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 04:36:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:15514 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587Ab2IVIgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 04:36:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,467,1344236400"; 
   d="scan'208";a="225224789"
Date: Sat, 22 Sep 2012 16:10:09 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org
Subject: Re: [ACPI/PCI] possible recursive locking detected
Message-ID: <20120922081009.GA5677@localhost>
References: <20120922003557.GF5959@localhost>
 <CAE9FiQVQJQfBZn7AH4M5hibx=iNa9RbfSaBdb35FWxDiRXHvrA@mail.gmail.com>
 <CAE9FiQVQMVsqG2vHhyktTtUSJ_dDRpTpwB_x--agMWbm6PHsEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVQMVsqG2vHhyktTtUSJ_dDRpTpwB_x--agMWbm6PHsEg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2012 at 12:04:51AM -0700, Yinghai Lu wrote:
> On Fri, Sep 21, 2012 at 9:53 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Fri, Sep 21, 2012 at 5:35 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> >> Hi Taku,
> >>
> >> The below oops is pretty reproducible, and shows up first in:
> >>
> >> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci/taku-acpi-pci-host-bridge-v3
> >> head:   e3faec8ea9c8aa683c56fa20ff2c58a4c5857960
> >> commit: d3c663236318a43fed5d86a643e6ea2534e9220e [5/7] PCI/ACPI: Protect acpi_pci_roots list with mutex
> >>
> >> [    8.613239]  (acpi_pci_root_lock){+.+.+.}, at: [<ffffffff81741e5f>] acpi_get_pci_rootbridge_handle+0x22/0x63
> >> [    8.613239]  (acpi_pci_root_lock){+.+.+.}, at: [<ffffffff81741e5f>] acpi_get_pci_rootbridge_handle+0x22/0x63
> >> [    8.613239]  (acpi_pci_root_lock){+.+.+.}, at: [<ffffffff81742398>] acpi_pci_register_driver+0x21/0x79
> >> [    8.613239]   lock(acpi_pci_root_lock);
> >> [    8.613239]   lock(acpi_pci_root_lock);
> >> [    8.613239]  #0:  (acpi_pci_root_lock){+.+.+.}, at: [<ffffffff81742398>] acpi_pci_register_driver+0x21/0x79
> >> [    8.613239]  [<ffffffff81741e5f>] ? acpi_get_pci_rootbridge_handle+0x22/0x63
> >> [    8.613239]  [<ffffffff81741e5f>] ? acpi_get_pci_rootbridge_handle+0x22/0x63
> >> [    8.613239]  [<ffffffff81741e5f>] ? acpi_get_pci_rootbridge_handle+0x22/0x63
> >> [    8.613239]  [<ffffffff81741e5f>] acpi_get_pci_rootbridge_handle+0x22/0x63
> >>
> >> [    8.610859]
> >> [    8.611385] =============================================
> >> [    8.612505] [ INFO: possible recursive locking detected ]
> >> [    8.613239] 3.6.0-rc1-00022-gd3c6632 #7512 Not tainted
> >> [    8.613239] ---------------------------------------------
> >> [    8.613239] swapper/0/1 is trying to acquire lock:
> >> [    8.613239]  (acpi_pci_root_lock){+.+.+.}, at: [<ffffffff81741e5f>] acpi_get_pci_rootbridge_handle+0x22/0x63
> >> [    8.613239]
> >> [    8.613239] but task is already holding lock:
> >> [    8.613239]  (acpi_pci_root_lock){+.+.+.}, at: [<ffffffff81742398>] acpi_pci_register_driver+0x21/0x79
> >> [    8.613239]
> >> [    8.613239] other info that might help us debug this:
> >> [    8.613239]  Possible unsafe locking scenario:
> >> [    8.613239]
> >> [    8.613239]        CPU0
> >> [    8.613239]        ----
> >> [    8.613239]   lock(acpi_pci_root_lock);
> >> [    8.613239]   lock(acpi_pci_root_lock);
> >> [    8.613239]
> >> [    8.613239]  *** DEADLOCK ***
> >> [    8.613239]
> >> [    8.613239]  May be due to missing lock nesting notation
> >> [    8.613239]
> >> [    8.613239] 1 lock held by swapper/0/1:
> >> [    8.613239]  #0:  (acpi_pci_root_lock){+.+.+.}, at: [<ffffffff81742398>] acpi_pci_register_driver+0x21/0x79
> >> [    8.613239]

> > Please check attached patch that should fix the problem.
> 
> updated more aggressive version. two patches.

Yes they work nicely. Thank you very much!

Thanks,
Fengguang
