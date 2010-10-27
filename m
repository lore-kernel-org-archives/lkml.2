Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab0J0BfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 21:35:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:45841 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab0J0Be6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 21:34:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,243,1286175600"; 
   d="scan'208";a="340904739"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
        "jdike@linux.intel.com" <jdike@linux.intel.com>
Date: Wed, 27 Oct 2010 09:33:12 +0800
Subject: RE: [PATCH v13 10/16] Add a hook to intercept external buffers from
 NIC driver.
Thread-Topic: [PATCH v13 10/16] Add a hook to intercept external buffers
 from NIC driver.
Thread-Index: ActvoZy9iFeNeSI+TnqHwyRq/jsyoAF0OkBg
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D7931E3CB834A@shsmsx502.ccr.corp.intel.com>
References: <1287133937-5538-1-git-send-email-xiaohui.xin@intel.com>
	<fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1287132437.git.xiaohui.xin@intel.com>
	<33f51c5eddec843260451eccbfa3c5fdea13b479.1287132437.git.xiaohui.xin@intel.com>
 <20101019.082401.28817543.davem@davemloft.net>
In-Reply-To: <20101019.082401.28817543.davem@davemloft.net>
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

>-----Original Message-----
>From: David Miller [mailto:davem@davemloft.net]
>Sent: Tuesday, October 19, 2010 11:24 PM
>To: Xin, Xiaohui
>Cc: netdev@vger.kernel.org; kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>mst@redhat.com; mingo@elte.hu; herbert@gondor.apana.org.au; jdike@linux.intel.com
>Subject: Re: [PATCH v13 10/16] Add a hook to intercept external buffers from NIC driver.
>
>From: xiaohui.xin@intel.com
>Date: Fri, 15 Oct 2010 17:12:11 +0800
>
>> @@ -2891,6 +2922,11 @@ static int __netif_receive_skb(struct sk_buff *skb)
>>  ncls:
>>  #endif
>>
>> +	/* To intercept mediate passthru(zero-copy) packets here */
>> +	skb = handle_mpassthru(skb, &pt_prev, &ret, orig_dev);
>> +	if (!skb)
>> +		goto out;
>> +
>>  	/* Handle special case of bridge or macvlan */
>>  	rx_handler = rcu_dereference(skb->dev->rx_handler);
>>  	if (rx_handler) {
>
>If you consume the packet here, devices in passthru mode cannot
>be use with bonding.
>
>But there is nothing that prevents a bond being created with such
>a device.
>
>So we have to either prevent such configurations (bad) or make
>it work somehow (good) :-)

The big picture may like this:
To prevent such configurations, we should add code to check in both
mp and bonding driver. If a nic is in zero-copy mode , bonding can't
be made with it, and if nic is in bonding mode, we can't bind the device
to do zero-copy.

If we want to support such configurations, it also has some constraints.
If bonding is created first, we need code to check if all the slaves support
zero-copy mode, and if yes, all the slaves should be assigned a same 
page_ctor(), all the packets received should be intercepted with master nic. 
If not, fails.
If zero-copy is enabled first, bonding created with it should fail.

Somehow, it seems not a trivial work to support it now. Can we support it
later and as a todo with our current work?

Thanks
Xiaohui




