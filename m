Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab0FRHO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 03:14:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:31179 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841Ab0FRHOY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 03:14:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,437,1272870000"; 
   d="scan'208";a="809199560"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: Stephen Hemminger <shemminger@vyatta.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mst@redhat.com" <mst@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "jdike@linux.intel.com" <jdike@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 18 Jun 2010 15:14:18 +0800
Subject: RE: [RFC PATCH v7 01/19] Add a new structure for skb buffer from
	external.
Thread-Topic: [RFC PATCH v7 01/19] Add a new structure for skb buffer from
	external.
Thread-Index: AcsOq2/F4WScyPR0SD+F8ysxUhadzAACXYZg
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D7915089FE573@shsmsx502.ccr.corp.intel.com>
References: <1275732899-5423-1-git-send-email-xiaohui.xin@intel.com>
 <20100606161348.427822fb@nehalam>
 <20100608052744.GA21547@gondor.apana.org.au>
 <F2E9EB7348B8264F86B6AB8151CE2D791100848F9F@shsmsx502.ccr.corp.intel.com>
 <20100611052112.GA25649@gondor.apana.org.au>
 <F2E9EB7348B8264F86B6AB8151CE2D791210AA4475@shsmsx502.ccr.corp.intel.com>
 <F2E9EB7348B8264F86B6AB8151CE2D79134F9AA999@shsmsx502.ccr.corp.intel.com>
 <20100617112119.GB1515@gondor.apana.org.au>
 <F2E9EB7348B8264F86B6AB8151CE2D7915089FE4CC@shsmsx502.ccr.corp.intel.com>
 <20100618055929.GA11333@gondor.apana.org.au>
In-Reply-To: <20100618055929.GA11333@gondor.apana.org.au>
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
>From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
>Sent: Friday, June 18, 2010 1:59 PM
>To: Xin, Xiaohui
>Cc: Stephen Hemminger; netdev@vger.kernel.org; kvm@vger.kernel.org;
>linux-kernel@vger.kernel.org; mst@redhat.com; mingo@elte.hu; davem@davemloft.net;
>jdike@linux.intel.com; Rusty Russell
>Subject: Re: [RFC PATCH v7 01/19] Add a new structure for skb buffer from external.
>
>On Fri, Jun 18, 2010 at 01:26:49PM +0800, Xin, Xiaohui wrote:
>>
>> Herbert,
>> I have questions about the idea above:
>> 1) Since netdev_alloc_skb() is still there, and we only modify alloc_page(),
>> then we don't need napi_gro_frags() any more, the driver's original receiving
>> function is ok. Right?
>
>Well I was actually thinking about converting all drivers that
>need this to napi_gro_frags.  But now that you mention it, yes
>we could still keep the old interface to minimise the work.
>
>> 2) Is napi_gro_frags() only suitable for TCP protocol packet?
>> I have done a small test for ixgbe driver to let it only allocate paged buffers
>> and found kernel hangs when napi_gro_frags() receives an ARP packet.
>
>It should work with any packet.  In fact, I'm pretty sure the
>other drivers (e.g., cxgb3) use that interface for all packets.
>
Thanks for the verification. By the way, does that mean that nearly all drivers can use the 
same napi_gro_frags() to receive buffers though currently each driver has it's own receiving 
function?

>> 3) As I have mentioned above, with this idea, netdev_alloc_skb() will allocate
>> as usual, the data pointed by skb->data will be copied into the first guest buffer.
>> That means we should reserve sufficient room in guest buffer. For PS mode
>> supported driver (for example ixgbe), the room will be more than 128. After 128bytes,
>> we will put the first frag data. Look into virtio-net.c the function page_to_skb()
>> and receive_mergeable(), that means we should modify guest virtio-net driver to
>> compute the offset as the parameter for skb_set_frag().
>>
>> How do you think about this? Attached is a patch to how to modify the guest driver.
>> I reserve 512 bytes as an example, and transfer the header len of the skb in hdr->hdr_len.
>
>Expanding the buffer size to 512 bytes to accomodate PS mode
>looks reasonable to me.
>
>However, I don't think we should increase the copy threshold to
>512 bytes at the same time.  I don't have any figures myself but
>I think if we are to make such a change it should be a separate
>one and come with supporting numbers.
>
Let me have a look to see if I can retain the copy threshold as 128 bytes 
and copy the header data safely.

>Cheers,
>--
>Visit Openswan at http://www.openswan.org/
>Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
>Home Page: http://gondor.apana.org.au/~herbert/
>PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
