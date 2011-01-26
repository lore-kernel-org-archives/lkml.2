Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1AZWhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 17:37:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:62026 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab1AZWhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 17:37:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,382,1291622400"; 
   d="scan'208";a="881316857"
Message-ID: <4D40A223.8020507@intel.com>
Date: Wed, 26 Jan 2011 14:37:23 -0800
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [34/49] igb: only use vlan_gro_receive if vlans are registered
References: <20110105230326.876575746@clark.site>
In-Reply-To: <20110105230326.876575746@clark.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/5/2011 3:00 PM, Greg KH wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
>
> ------------------
>
> From: Alexander Duyck<alexander.h.duyck@intel.com>
>
> commit 31b24b955c3ebbb6f3008a6374e61cf7c05a193c upstream.
>
> This change makes it so that vlan_gro_receive is only used if vlans have been
> registered to the adapter structure.  Previously we were just sending all vlan
> tagged frames in via this function but this results in a null pointer
> dereference when vlans are not registered.
>
> [ This fixes bugzilla entry 15582 -Eric Dumazet]
>
> Signed-off-by: Alexander Duyck<alexander.h.duyck@intel.com>
> Signed-off-by: Jeff Kirsher<jeffrey.t.kirsher@intel.com>
> Acked-by: Eric Dumazet<eric.dumazet@gmail.com>
> Signed-off-by: David S. Miller<davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman<gregkh@suse.de>
>
> ---
>   drivers/net/igb/igb_main.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/drivers/net/igb/igb_main.c
> +++ b/drivers/net/igb/igb_main.c
> @@ -4560,7 +4560,7 @@ static void igb_receive_skb(struct igb_r
>   	bool vlan_extracted = (adapter->vlgrp&&  (status&  E1000_RXD_STAT_VP));
>
>   	skb_record_rx_queue(skb, ring->queue_index);
> -	if (vlan_extracted)
> +	if (vlan_extracted && adapter->vlgrp)
>   		vlan_gro_receive(&ring->napi, adapter->vlgrp,
>   		                 le16_to_cpu(rx_desc->wb.upper.vlan),
>   		                 skb);
>
>

I was just reviewing some history on this and I noticed that this patch 
appears to be applied to the wrong kernel.  The change isn't needed for 
2.6.32 as evidenced by the fact that vlan_extracted already includes 
adapter->vlgrp as part of computing it's value.  However, the change is 
needed for 2.6.33.  The original bugzilla include the patch for that kernel.

Thanks,

Alex

