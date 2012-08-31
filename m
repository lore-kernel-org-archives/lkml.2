Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab2HaN41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 09:56:27 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33225 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753255Ab2HaN4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 09:56:25 -0400
X-Sasl-enc: VMPGSAC3eBUdw6yfw54aC11syOCM2nuycLpZV5iN54C4 1346421384
Message-ID: <5040C283.7040809@signal11.us>
Date: Fri, 31 Aug 2012 09:56:19 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tony Cheneau <tony.cheneau@amnesiak.org>,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] 6lowpan: Make a copy of skb's delivered to 6lowpan
References: <1346294341-26808-1-git-send-email-alan@signal11.us>  <1346294341-26808-2-git-send-email-alan@signal11.us> <1346396485.2586.307.camel@edumazet-glaptop>
In-Reply-To: <1346396485.2586.307.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2012 03:01 AM, Eric Dumazet wrote:
> On Wed, 2012-08-29 at 22:39 -0400, Alan Ott wrote:
>> Since lowpan_process_data() modifies the skb (by calling skb_pull()), we
>> need our own copy so that it doesn't affect the data received by other
>> protcols (in this case, af_ieee802154).
>>
>> Signed-off-by: Alan Ott <alan@signal11.us>
>> ---
>>  net/ieee802154/6lowpan.c |    9 ++++++++-
>>  1 files changed, 8 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/ieee802154/6lowpan.c b/net/ieee802154/6lowpan.c
>> index 6a09522..ce33b02 100644
>> --- a/net/ieee802154/6lowpan.c
>> +++ b/net/ieee802154/6lowpan.c
>> @@ -1133,6 +1133,8 @@ static int lowpan_validate(struct nlattr *tb[], struct nlattr *data[])
>>  static int lowpan_rcv(struct sk_buff *skb, struct net_device *dev,
>>  	struct packet_type *pt, struct net_device *orig_dev)
>>  {
>> +	struct sk_buff *local_skb;
>> +
>>  	if (!netif_running(dev))
>>  		goto drop;
>>  
>> @@ -1144,7 +1146,12 @@ static int lowpan_rcv(struct sk_buff *skb, struct net_device *dev,
>>  	case LOWPAN_DISPATCH_IPHC:	/* ipv6 datagram */
>>  	case LOWPAN_DISPATCH_FRAG1:	/* first fragment header */
>>  	case LOWPAN_DISPATCH_FRAGN:	/* next fragments headers */
>> -		lowpan_process_data(skb);
>> +		local_skb = skb_copy(skb, GFP_ATOMIC);
>> +		if (!local_skb)
>> +			goto drop;
>> +		lowpan_process_data(local_skb);
>> +
>> +		kfree_skb(skb);
>>  		break;
>>  	default:
>>  		break;
> Its not clear to me why skb_copy() is needed here.
>
> >From patch description, I would say skb_clone() would be enough (and
> faster) ?

You're probably right. I'll check it out. Thanks.

Alan.
