Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab0FYBGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 21:06:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:15556 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338Ab0FYBGi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 21:06:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,477,1272870000"; 
   d="scan'208";a="530056319"
From: "Dong, Eddie" <eddie.dong@intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: "Xin, Xiaohui" <xiaohui.xin@intel.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mst@redhat.com" <mst@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "jdike@linux.intel.com" <jdike@linux.intel.com>,
       "Dong, Eddie" <eddie.dong@intel.com>,
       "Dong, Eddie" <eddie.dong@intel.com>
Date: Fri, 25 Jun 2010 09:03:46 +0800
Subject: RE: [RFC PATCH v7 01/19] Add a new structure for skb buffer from
	external.
Thread-Topic: [RFC PATCH v7 01/19] Add a new structure for skb buffer from
	external.
Thread-Index: AcsThT/zH5J3EVkHSUqVqVPxYO+wXwAe7Z4g
Message-ID: <1A42CE6F5F474C41B63392A5F80372B21F58D666@shsmsx501.ccr.corp.intel.com>
References: <20100608052744.GA21547@gondor.apana.org.au>
 <F2E9EB7348B8264F86B6AB8151CE2D791100848F9F@shsmsx502.ccr.corp.intel.com>
 <20100611052112.GA25649@gondor.apana.org.au>
 <F2E9EB7348B8264F86B6AB8151CE2D791210AA4475@shsmsx502.ccr.corp.intel.com>
 <F2E9EB7348B8264F86B6AB8151CE2D79134F9AA999@shsmsx502.ccr.corp.intel.com>
 <20100617112119.GB1515@gondor.apana.org.au>
 <F2E9EB7348B8264F86B6AB8151CE2D7915089FE4CC@shsmsx502.ccr.corp.intel.com>
 <1A42CE6F5F474C41B63392A5F80372B21F58CD9A@shsmsx501.ccr.corp.intel.com>
 <20100623095254.GA32491@gondor.apana.org.au>
 <1A42CE6F5F474C41B63392A5F80372B21F58CE7F@shsmsx501.ccr.corp.intel.com>
 <20100624100836.GA16220@gondor.apana.org.au>
In-Reply-To: <20100624100836.GA16220@gondor.apana.org.au>
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

Herbert Xu wrote:
> On Wed, Jun 23, 2010 at 06:05:41PM +0800, Dong, Eddie wrote:
>> 
>> I mean once the frontend side driver post the buffers to the backend
>> driver, the backend driver will "immediately" use that buffers to
>> compose skb or gro_frags and post them to the assigned host NIC
>> driver as receive buffers. In that case, if the backend driver
>> recieves a packet from the NIC that requires to do copy, it may be
>> unable to find additional free guest buffer because all of them are
>> already used by the NIC driver. We have to reserve some guest
>> buffers for the possible copy even if the buffer address is not
>> identified by original skb :(        
> 
> OK I see what you mean.  Can you tell me how does Xiaohui's
> previous patch-set deal with this problem?
> 
> Thanks,

In current patch, each SKB for the assigned device (SRIOV VF or NIC or a complete queue pairs) uses the buffer from guest, so it eliminates copy completely in software and requires hardware to do so. If we can have an additonal place to store the buffer per skb (may cause copy later on), we can do copy later on or re-post the buffer to assigned NIC driver later on. But that may be not very clean either :(

BTW, some hardware may require certain level of packet copy such as for broadcast packets in very old VMDq device, which is not addressed in previous Xiaohui's patch yet. We may address this by implementing an additional virtqueue between guest and host for slow path (broadcast packets only here) with additinal complexity in FE/BE driver. 

Thx, Eddie