Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab0DTCWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 22:22:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:3253 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986Ab0DTCWp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 22:22:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,239,1270450800"; 
   d="scan'208";a="614633331"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "jdike@linux.intel.com" <jdike@linux.intel.com>,
       "davem@davemloft.net" <davem@davemloft.net>
Date: Tue, 20 Apr 2010 10:21:55 +0800
Subject: RE: [RFC][PATCH v2 0/3] Provide a zero-copy method on KVM
	virtio-net.
Thread-Topic: [RFC][PATCH v2 0/3] Provide a zero-copy method on KVM
	virtio-net.
Thread-Index: AcrfqqAr4RXIE0yEQo+zu9dIXy3W9gAhQRBg
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D79026FAB1E5F@shsmsx502.ccr.corp.intel.com>
References: <1270193100-6769-1-git-send-email-xiaohui.xin@intel.com>
 <20100414152519.GA10792@redhat.com>
 <97F6D3BD476C464182C1B7BABF0B0AF5C18969CC@shzsmsx502.ccr.corp.intel.com>
 <20100415100546.GA17035@redhat.com>
 <F2E9EB7348B8264F86B6AB8151CE2D79026FA95401@shsmsx502.ccr.corp.intel.com>
 <20100419102118.GA16198@redhat.com>
In-Reply-To: <20100419102118.GA16198@redhat.com>
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

Michael,

>>>>>> What we have not done yet:
>>>>>> 	packet split support
>>>>>> 
>>>>>What does this mean, exactly?
>>>> We can support 1500MTU, but for jumbo frame, since vhost driver before don't 
>>>>support mergeable buffer, we cannot try it for multiple sg.
>>>> 
>>>I do not see why, vhost currently supports 64K buffers with indirect
>>>descriptors.
>>> 
>> The receive_skb() in guest virtio-net driver will merge the multiple sg to skb frags, how >>can indirect descriptors to that?

>See add_recvbuf_big.

I don't mean this, it's for buffer submission. I mean when packet is received, in receive_buf(), mergeable buffer knows which pages received can be hooked in skb frags, it's receive_mergeable() which do this.

When a NIC driver supports packet split mode, then each ring descriptor contains a skb and a page. When packet is received, if the status is not EOP, then hook the page of the next descriptor to the prev skb. We don't how many frags belongs to one skb. So when guest submit buffers, it should submit multiple pages, and when receive, the guest should know which pages are belongs to one skb and hook them together. I think receive_mergeable() can do this, but I don't see how big->packets handle this. May I miss something here?

Thanks
Xiaohui 

