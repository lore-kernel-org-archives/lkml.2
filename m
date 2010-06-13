Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab0FMUgd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 16:36:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:2723 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430Ab0FMUgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 16:36:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,411,1272870000"; 
   d="scan'208";a="526487118"
Message-ID: <4C15414E.5090201@intel.com>
Date: Sun, 13 Jun 2010 13:36:30 -0700
From: John Fastabend <john.r.fastabend@intel.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>,
       "markus@trippelsdorf.de" <markus@trippelsdorf.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, alex.shi@intel.com, tim.c.chen@intel.com
Subject: Re: mpd client timeouts (bisected) 2.6.35-rc3
References: <20100612102802.GA1782@arch.tripp.de> <20100612.145835.123986343.davem@davemloft.net> <4C149147.3080808@intel.com>
In-Reply-To: <4C149147.3080808@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Fastabend wrote:
> David Miller wrote:
>> From: Markus Trippelsdorf <markus@trippelsdorf.de>
>> Date: Sat, 12 Jun 2010 12:28:02 +0200
>>
>>> Commit 597a264b1a9c7e36d1728f677c66c5c1f7e3b837:
>>> »net: deliver skbs on inactive slaves to exact matches«
>>>
>>> causes large timeouts when mpd clients try to connect to a locally
>>> running mpd (music player demon) on my machine. This makes it 
>>> impossible to control mpd.
>>>
>>> I bisected this down to the commit mentioned above.
>>> Reverting the commit from 2.6.35-rc3 also solves the problem.
>> John, find an easy and fast way to fix this or else I am
>> going to revert.
>>
>> Thanks.
> 
> Looks like skbs are hitting loopback_xmit() with deliver_no_wcard set.  Then in 
> the receive path these skbs are only delivered to exact matches.  Not sure why 
> this bit is set here, I'll track this down first thing tomorrow.
> 
> Thanks,
> John.
> --

Needed to set the wcard bit in copy_skb_header otherwise it will not be cleared 
when called from skb_clone.  Which then hits the loopback device gets pushed 
into the rx path and is eventually dropped. The following patch fixes this. 
Hopefully, this is easy and fast enough for you Dave.


[PATCH] net: fix deliver_no_wcard regression on loopback device

deliver_no_wcard is not being set in skb_copy_header.
In the skb_cloned case it is not being cleared and
may cause the skb to be dropped when the loopback device
pushes it back up the stack.

Signed-off-by: John Fastabend <john.r.fastabend@intel.com>
---

  net/core/skbuff.c |    1 +
  1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9f07e74..bcf2fa3 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -532,6 +532,7 @@ static void __copy_skb_header(struct sk_buff *new, const 
struct sk_buff *old)
  	new->ip_summed		= old->ip_summed;
  	skb_copy_queue_mapping(new, old);
  	new->priority		= old->priority;
+	new->deliver_no_wcard	= old->deliver_no_wcard;
  #if defined(CONFIG_IP_VS) || defined(CONFIG_IP_VS_MODULE)
  	new->ipvs_property	= old->ipvs_property;
  #endif
