Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab2I1IQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:16:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:57668 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab2I1IQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:16:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,501,1344236400"; 
   d="scan'208";a="227644923"
Message-ID: <1348820118.4530.41.camel@yhuang-mobile.sh.intel.com>
Subject: Why hold device_lock when calling callback in pci_walk_bus?
From: Huang Ying <ying.huang@intel.com>
To: bhelgaas@google.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, yanmin.zhang@intel.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl
Date: Fri, 28 Sep 2012 16:15:18 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All,

If my understanding were correct, device_lock is used to provide mutual
exclusion between device probe/remove/suspend/resume etc.  Why hold
device_lock when calling callback in pci_walk_bus.

This is introduced by the following commit.

commit d71374dafbba7ec3f67371d3b7e9f6310a588808
Author: Zhang Yanmin <yanmin.zhang@intel.com>
Date:   Fri Jun 2 12:35:43 2006 +0800

    [PATCH] PCI: fix race with pci_walk_bus and pci_destroy_dev
    
    pci_walk_bus has a race with pci_destroy_dev. When cb is called
    in pci_walk_bus, pci_destroy_dev might unlink the dev pointed by next.
    Later on in the next loop, pointer next becomes NULL and cause
    kernel panic.
    
    Below patch against 2.6.17-rc4 fixes it by changing pci_bus_lock (spin_lock)
    to pci_bus_sem (rw_semaphore).
    
    Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Corresponding email thread is: https://lkml.org/lkml/2006/5/26/38

But from the commit and email thread, I can not find why we need to do
that.

I ask this question because I want to use pci_walk_bus in a function (in
pci runtime resume path) which may be called with device_lock held.

Can anyone help me on that?

Best Regards,
Huang Ying


