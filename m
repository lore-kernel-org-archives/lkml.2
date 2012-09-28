Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab2I1I3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:29:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:20814 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab2I1I3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:29:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,501,1344236400"; 
   d="scan'208";a="227648722"
From: "Zhang, Yanmin" <yanmin.zhang@intel.com>
To: "Huang, Ying" <ying.huang@intel.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>
Subject: RE: Why hold device_lock when calling callback in pci_walk_bus?
Thread-Topic: Why hold device_lock when calling callback in pci_walk_bus?
Thread-Index: AQHNnVGXVbR2FhjaIU6Zqhl0QTZvS5efad8w
Date: Fri, 28 Sep 2012 08:29:20 +0000
Message-ID: <144086DDB7BB6D429C79280EB1C804D414B1F6@SHSMSX101.ccr.corp.intel.com>
References: <1348820118.4530.41.camel@yhuang-mobile.sh.intel.com>
In-Reply-To: <1348820118.4530.41.camel@yhuang-mobile.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8S8TqiI010084

Some error handling functions call pci_walk_bus. For example, pci-e aer. Here we lock the device, so the driver wouldn't detach from the device, as the cb might call driver's callback function.

-----Original Message-----
From: Huang, Ying 
Sent: Friday, September 28, 2012 4:15 PM
To: bhelgaas@google.com
Cc: Greg Kroah-Hartman; Zhang, Yanmin; linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org; rjw@sisk.pl
Subject: Why hold device_lock when calling callback in pci_walk_bus?

Hi, All,

If my understanding were correct, device_lock is used to provide mutual exclusion between device probe/remove/suspend/resume etc.  Why hold device_lock when calling callback in pci_walk_bus.

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

But from the commit and email thread, I can not find why we need to do that.

I ask this question because I want to use pci_walk_bus in a function (in pci runtime resume path) which may be called with device_lock held.

Can anyone help me on that?

Best Regards,
Huang Ying


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
