Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab1EFINF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 04:13:05 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34711 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973Ab1EFIM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 04:12:59 -0400
Date: Fri, 6 May 2011 01:12:43 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ram Pai <linuxram@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] pci: Check bridge resources after resource allocation.
Message-ID: <20110506081243.GF16782@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <4DC250A6.9040802@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC250A6.9040802@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 12:24:22AM -0700, Yinghai Lu wrote:
> 
> During pci remove/rescan testing found:
> 
> [  541.141614] pci 0000:c0:03.0: PCI bridge to [bus c4-c9]
> [  541.141965] pci 0000:c0:03.0:   bridge window [io  0x1000-0x0fff]
> [  541.159181] pci 0000:c0:03.0:   bridge window [mem 0xf0000000-0xf00fffff]
> [  541.159540] pci 0000:c0:03.0:   bridge window [mem 0xfc180000000-0xfc197ffffff 64bit pref]
> [  541.179374] pci 0000:c0:03.0: device not available (can't reserve [io  0x1000-0x0fff])
> [  541.199198] pci 0000:c0:03.0: Error enabling bridge (-22), continuing
> [  541.199202] pci 0000:c0:03.0: enabling bus mastering
> [  541.199209] pci 0000:c0:03.0: setting latency timer to 64
> [  541.199917] pcieport 0000:c0:03.0: device not available (can't reserve [io  0x1000-0x0fff])
> [  541.199963] pcieport: probe of 0000:c0:03.0 failed with error -22
> 
> This bug was uncovered by commit
> | commit c8adf9a3e873eddaaec11ac410a99ef6b9656938
> | Author: Ram Pai <linuxram@us.ibm.com>
> | Date:   Mon Feb 14 17:43:20 2011 -0800
> |
> |    PCI: pre-allocate additional resources to devices only after successful allo
> cation of essential resources.
> 
> After that commit, pci_hotplug_io_size is changed to additional_io_size from minium size. So it will not get into failed list, and will not be reset there.
> 
> The root cause is: pci_bridge_check_ranges will set RESOURCE_IO flag for pci
> bridge, and later if children does not need to IO resource. those bridge
> resources will not need to be allocated. but flags still there.
> 
> Add pci_bridge_check_resources() to close the loop.

How about resetting the resource in  adjust_resources_sorted() if  call to
adjust_resource() fails, and the resource is left with zero size?

Something like this:

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 8e73abf..77e8454 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -157,8 +157,11 @@ static void adjust_resources_sorted(struct resource_list_x *add_head,
                         if(pci_assign_resource(list->dev, idx))
                                reset_resource(res);
                } else if (add_size) {
-                       adjust_resource(res, res->start,
-                               resource_size(res) + add_size);
+                       if (adjust_resource(res, res->start,
+                               resource_size(res) + add_size) && 
+                               !resource_size(res)) {
+                               reset_resource(res);
+                       }
                }
 out:
                tmp = list;


RP
