Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab0JKHH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 03:07:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:39276 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753Ab0JKHHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 03:07:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,312,1283756400"; 
   d="scan'208";a="615423041"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
        "jdike@linux.intel.com" <jdike@linux.intel.com>
Date: Mon, 11 Oct 2010 15:06:52 +0800
Subject: RE: [PATCH v12 10/17] Add a hook to intercept external buffers from
 NIC driver.
Thread-Topic: [PATCH v12 10/17] Add a hook to intercept external buffers
 from NIC driver.
Thread-Index: Actgqugt6exSwPE/S2+iQXrbhq2aWgIZ+ebg
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D793064B2A9DA@shsmsx502.ccr.corp.intel.com>
References: <1285855474-12110-1-git-send-email-xiaohui.xin@intel.com>
	 <fda262fa746dfc1feb8543cf88d5ecf60001c186.1285853725.git.xiaohui.xin@intel.com>
 <1285856533.2615.573.camel@edumazet-laptop>
In-Reply-To: <1285856533.2615.573.camel@edumazet-laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Eric Dumazet [mailto:eric.dumazet@gmail.com]
>Sent: Thursday, September 30, 2010 10:22 PM
>To: Xin, Xiaohui
>Cc: netdev@vger.kernel.org; kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>mst@redhat.com; mingo@elte.hu; davem@davemloft.net; herbert@gondor.apana.org.au;
>jdike@linux.intel.com
>Subject: Re: [PATCH v12 10/17] Add a hook to intercept external buffers from NIC driver.
>
>Le jeudi 30 septembre 2010 à 22:04 +0800, xiaohui.xin@intel.com a
>écrit :
>> From: Xin Xiaohui <xiaohui.xin@intel.com>
>>
>> The hook is called in netif_receive_skb().
>> Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
>> Signed-off-by: Zhao Yu <yzhao81new@gmail.com>
>> Reviewed-by: Jeff Dike <jdike@linux.intel.com>
>> ---
>>  net/core/dev.c |   35 +++++++++++++++++++++++++++++++++++
>>  1 files changed, 35 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index c11e32c..83172b8 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -2517,6 +2517,37 @@ err:
>>  EXPORT_SYMBOL(netdev_mp_port_prep);
>>  #endif
>>
>> +#if defined(CONFIG_MEDIATE_PASSTHRU) ||
>defined(CONFIG_MEDIATE_PASSTHRU_MODULE)
>> +/* Add a hook to intercept mediate passthru(zero-copy) packets,
>> + * and insert it to the socket queue owned by mp_port specially.
>> + */
>> +static inline struct sk_buff *handle_mpassthru(struct sk_buff *skb,
>> +					       struct packet_type **pt_prev,
>> +					       int *ret,
>> +					       struct net_device *orig_dev)
>> +{
>> +	struct mp_port *mp_port = NULL;
>> +	struct sock *sk = NULL;
>> +
>> +	if (!dev_is_mpassthru(skb->dev))
>> +		return skb;
>> +	mp_port = skb->dev->mp_port;
>> +
>> +	if (*pt_prev) {
>> +		*ret = deliver_skb(skb, *pt_prev, orig_dev);
>> +		*pt_prev = NULL;
>> +	}
>> +
>> +	sk = mp_port->sock->sk;
>> +	skb_queue_tail(&sk->sk_receive_queue, skb);
>> +	sk->sk_state_change(sk);
>> +
>> +	return NULL;
>> +}
>> +#else
>> +#define handle_mpassthru(skb, pt_prev, ret, orig_dev)     (skb)
>> +#endif
>> +
>>  /**
>>   *	netif_receive_skb - process receive buffer from network
>>   *	@skb: buffer to process
>> @@ -2598,6 +2629,10 @@ int netif_receive_skb(struct sk_buff *skb)
>>  ncls:
>>  #endif
>>
>> +	/* To intercept mediate passthru(zero-copy) packets here */
>> +	skb = handle_mpassthru(skb, &pt_prev, &ret, orig_dev);
>> +	if (!skb)
>> +		goto out;
>>  	skb = handle_bridge(skb, &pt_prev, &ret, orig_dev);
>>  	if (!skb)
>>  		goto out;
>
>This does not apply to current net-next-2.6
>
>We now have dev->rx_handler (currently for bridge or macvlan)
>
>
Ok. Thanks, will rebase to fix that.

Thanks
Xiaohui

>commit ab95bfe01f9872459c8678572ccadbf646badad0
>Author: Jiri Pirko <jpirko@redhat.com>
>Date:   Tue Jun 1 21:52:08 2010 +0000
>
>    net: replace hooks in __netif_receive_skb V5
>
>    What this patch does is it removes two receive frame hooks (for bridge and for
>    macvlan) from __netif_receive_skb. These are replaced them with a single
>    hook for both. It only supports one hook per device because it makes no
>    sense to do bridging and macvlan on the same device.
>
>    Then a network driver (of virtual netdev like macvlan or bridge) can register
>    an rx_handler for needed net device.
>
>    Signed-off-by: Jiri Pirko <jpirko@redhat.com>
>    Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>    Signed-off-by: David S. Miller <davem@davemloft.net>
>
>

