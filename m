Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab0DNIH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 04:07:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab0DNIH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 04:07:56 -0400
Message-ID: <4BC57896.9060707@redhat.com>
Date: Wed, 14 Apr 2010 16:11:02 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Jay Vosburgh <fubar@us.ibm.com>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Neil Horman <nhorman@tuxdriver.com>, netdev@vger.kernel.org,
       Andy Gospodarek <gospo@redhat.com>, bridge@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, bonding-devel@lists.sourceforge.net,
       Jeff Moyer <jmoyer@redhat.com>, Matt Mackall <mpm@selenic.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [Bonding-devel] [v3 Patch 2/3] bridge: make bridge support netpoll
References: <20100408062234.4499.17042.sendpatchset@localhost.localdomain> <20100408062246.4499.5670.sendpatchset@localhost.localdomain> <20100408083710.2b61ee44@nehalam> <4BC2F7E2.7020309@redhat.com> <1271068737.16881.18.camel@edumazet-laptop> <20100412083842.26d71bda@nehalam> <4BC43214.6030009@redhat.com> <8304.1271177567@death.nxdomain.ibm.com>
In-Reply-To: <8304.1271177567@death.nxdomain.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Vosburgh wrote:
> Cong Wang <amwang@redhat.com> wrote:
> 
>> Stephen Hemminger wrote:
>>> On Mon, 12 Apr 2010 12:38:57 +0200
>>> Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>>
>>>> Le lundi 12 avril 2010 à 18:37 +0800, Cong Wang a écrit :
>>>>> Stephen Hemminger wrote:
>>>>>> There is no protection on dev->priv_flags for SMP access.
>>>>>> It would better bit value in dev->state if you are using it as control flag.
>>>>>>
>>>>>> Then you could use 
>>>>>> 			if (unlikely(test_and_clear_bit(__IN_NETPOLL, &skb->dev->state)))
>>>>>> 				netpoll_send_skb(...)
>>>>>>
>>>>>>
>>>>> Hmm, I think we can't use ->state here, it is not for this kind of purpose,
>>>>> according to its comments.
>>>>>
>>>>> Also, I find other usages of IFF_XXX flags of ->priv_flags are also using
>>>>> &, | to set or clear the flags. So there must be some other things preventing
>>>>> the race...
>>>> Yes, its RTNL that protects priv_flags changes, hopefully...
>>>>
>>> The patch was not protecting priv_flags with RTNL.
>>> For example..
>>>
>>>
>>> @@ -308,7 +312,9 @@ static void netpoll_send_skb(struct netp
>>>  		     tries > 0; --tries) {
>>>  			if (__netif_tx_trylock(txq)) {
>>>  				if (!netif_tx_queue_stopped(txq)) {
>>> +					dev->priv_flags |= IFF_IN_NETPOLL;
>>>  					status = ops->ndo_start_xmit(skb, dev);
>>> +					dev->priv_flags &= ~IFF_IN_NETPOLL;
>>>  					if (status == NETDEV_TX_OK)
>>>  						txq_trans_update(txq);
>> Hmm, but I checked the bonding case (IFF_BONDING), it doesn't
>> hold rtnl_lock. Strange.
> 
> 	I looked, and there are a couple of cases in bonding that don't
> have RTNL for adjusting priv_flags (in bond_ab_arp_probe when no slaves
> are up, and a couple of cases in 802.3ad).  I think the solution there
> is to move bonding away from priv_flags for some of this (e.g., convert
> bonding to use a frame hook like bridge and macvlan, and greatly
> simplify skb_bond_should_drop), but that's a separate topic.
> 
> 	The majority of the cases, however, do hold RTNL.  Bonding
> generally doesn't have to acquire RTNL itself, since whatever called
> into bonding is holding it already.  For example, the slave add and
> remove paths (bond_enslave, bond_release) are called either via sysfs or
> ioctl, both of which acquire RTNL.  All of the set and clear operations
> for IFF_BONDING fall into this category; look at bonding_store_slaves
> for an example.
> 
> 	Bonding does acquire RTNL itself when performing failovers,
> e.g., bond_mii_monitor holds RTNL prior to calling bond_miimon_commit,
> which will change priv_flags.
> 

Thanks a lot for your reply!

You are right, I missed something.

Hmm, for bonding, RTNL lock is necessary because there are sysfs
interface and ioctl interface to change its configuration.

