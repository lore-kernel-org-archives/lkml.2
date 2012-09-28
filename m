Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab2I1N2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:28:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:61057 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab2I1N2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:28:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,502,1344236400"; 
   d="scan'208";a="198359564"
Message-ID: <1348838843.4922.5.camel@yhuang-mobile.sh.intel.com>
Subject: Re: Why hold device_lock when calling callback in pci_walk_bus?
From: Huang Ying <ying.huang@intel.com>
To: "Zhang, Yanmin" <yanmin.zhang@intel.com>
Cc: "bhelgaas@google.com" <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>
Date: Fri, 28 Sep 2012 21:27:23 +0800
In-Reply-To: <144086DDB7BB6D429C79280EB1C804D414B1F6@SHSMSX101.ccr.corp.intel.com>
References: <1348820118.4530.41.camel@yhuang-mobile.sh.intel.com>
	 <144086DDB7BB6D429C79280EB1C804D414B1F6@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Yanmin,

Thanks for your explain.

On Fri, 2012-09-28 at 02:29 -0600, Zhang, Yanmin wrote:
> Some error handling functions call pci_walk_bus. For example, pci-e aer. Here we lock the device, so the driver wouldn't detach from the device, as the cb might call driver's callback function.

Still has two question.

1. Is it a good practice to hold device_lock when calling driver
callback to prevent driver be unbind?

2. Is it a good idea to let callback of pci_walk_bus to acquire
device_lock when necessary.  Because pci_walk_bus may be used by driver
callback too.

Best Regards,
Huang Ying

> -----Original Message-----
> From: Huang, Ying 
> Sent: Friday, September 28, 2012 4:15 PM
> To: bhelgaas@google.com
> Cc: Greg Kroah-Hartman; Zhang, Yanmin; linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org; rjw@sisk.pl
> Subject: Why hold device_lock when calling callback in pci_walk_bus?
> 
> Hi, All,
> 
> If my understanding were correct, device_lock is used to provide mutual exclusion between device probe/remove/suspend/resume etc.  Why hold device_lock when calling callback in pci_walk_bus.
> 
> This is introduced by the following commit.
> 
> commit d71374dafbba7ec3f67371d3b7e9f6310a588808
> Author: Zhang Yanmin <yanmin.zhang@intel.com>
> Date:   Fri Jun 2 12:35:43 2006 +0800
> 
>     [PATCH] PCI: fix race with pci_walk_bus and pci_destroy_dev
>     
>     pci_walk_bus has a race with pci_destroy_dev. When cb is called
>     in pci_walk_bus, pci_destroy_dev might unlink the dev pointed by next.
>     Later on in the next loop, pointer next becomes NULL and cause
>     kernel panic.
>     
>     Below patch against 2.6.17-rc4 fixes it by changing pci_bus_lock (spin_lock)
>     to pci_bus_sem (rw_semaphore).
>     
>     Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Corresponding email thread is: https://lkml.org/lkml/2006/5/26/38
> 
> But from the commit and email thread, I can not find why we need to do that.
> 
> I ask this question because I want to use pci_walk_bus in a function (in pci runtime resume path) which may be called with device_lock held.
> 
> Can anyone help me on that?
> 
> Best Regards,
> Huang Ying
> 
> 


