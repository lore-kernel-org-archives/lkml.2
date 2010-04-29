Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab0D2Bd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 21:33:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:39321 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab0D2BdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 21:33:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,292,1270450800"; 
   d="scan'208";a="271318015"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "jdike@linux.intel.com" <jdike@linux.intel.com>
Date: Thu, 29 Apr 2010 09:33:02 +0800
Subject: RE: [RFC][PATCH v4 00/18] Provide a zero-copy method on KVM
	virtio-net.
Thread-Topic: [RFC][PATCH v4 00/18] Provide a zero-copy method on KVM
	virtio-net.
Thread-Index: AcrkZRSdtn4eaNmyR3uIOyeYsqShJQCPHRnA
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D7902DF999649@shsmsx502.ccr.corp.intel.com>
References: <1272187206-18534-17-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-18-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-19-git-send-email-xiaohui.xin@intel.com>
 <20100425.025529.123989625.davem@davemloft.net>
 <20100425104604.GA10238@redhat.com>
In-Reply-To: <20100425104604.GA10238@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The idea is simple, just to pin the guest VM user space and then let
> > host NIC driver has the chance to directly DMA to it.
> >
> >Isn't it much easier to map the RX ring of the network device into the
> >guest's address space, have DMA map calls translate guest addresses to
> >physical/DMA addresses as well as do all of this crazy page pinning
> >stuff, and provide the translations and protections via the IOMMU?

>This means we need guest know how the specific network device works.
>So we won't be able to, for example, move guest between different hosts.
>There are other problems: many physical systems do not have an iommu,
>some guest OS-es do not support DMA map calls, doing VM exit
>on each DMA map call might turn out to be very slow. And so on.

This solution is what now we can think of to implement zero-copy. Some
modifications are made to net core to try to avoid network device driver
changes.  The major change is to __alloc_skb(), in which we added a dev
parameter to indicate whether the device will DMA to/from guest/user buffer
which is pointed by host skb->data. We also modify skb_release_data() and
skb_reserve(). We made it now works with ixgbe driver with PS mode disabled,
and got some performance data with it.
  
	using netperf with GSO/TSO disabled, 10G NIC, 
	disabled packet split mode, with raw socket case compared to vhost.

	bindwidth will be from 1.1Gbps to 1.7Gbps
	CPU % from 120%-140% to 140%-160%

We are now trying to get decent performance data with advanced features.
Do you have any other concerns with this solution? 

>> What's being proposed here looks a bit over-engineered.

>This is an attempt to reduce overhead for virtio (paravirtualization).
>'Don't use PV' is kind of an alternative, but I do not
>think it's a simpler one.

-- 
MST
