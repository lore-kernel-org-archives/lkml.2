Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab0KGLhj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 06:37:39 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:14323 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab0KGLhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 06:37:37 -0500
Message-ID: <4CD68F7E.5050407@bfs.de>
Date: Sun, 07 Nov 2010 12:37:34 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.14) Gecko/20101013 SUSE/3.0.9 Thunderbird/3.0.9
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jpirko@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net: packet: fix information leak to userland
References: <1288545028-16436-1-git-send-email-segooon@gmail.com> <4CCE84E2.9050801@bfs.de> <20101106143911.GA17428@albatros>
In-Reply-To: <20101106143911.GA17428@albatros>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 06.11.2010 15:39, schrieb Vasiliy Kulikov:
> On Mon, Nov 01, 2010 at 10:14 +0100, walter harms wrote:
>>
>>
>> Vasiliy Kulikov schrieb:
>>> packet_getname_spkt() doesn't initialize all members of sa_data field of
>>> sockaddr struct if strlen(dev->name) < 13.  This structure is then copied
>>> to userland.  It leads to leaking of contents of kernel stack memory.
>>> We have to fully fill sa_data with strncpy() instead of strlcpy().
>>>
>>> The same with packet_getname(): it doesn't initialize sll_pkttype field of
>>> sockaddr_ll.  Set it to zero.
>>>
>>> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
>>> ---
>>>  net/packet/af_packet.c |    3 ++-
>>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
>>> index 3616f27..0856a13 100644
>>> --- a/net/packet/af_packet.c
>>> +++ b/net/packet/af_packet.c
>>> @@ -1719,7 +1719,7 @@ static int packet_getname_spkt(struct socket *sock, struct sockaddr *uaddr,
>>>  	rcu_read_lock();
>>>  	dev = dev_get_by_index_rcu(sock_net(sk), pkt_sk(sk)->ifindex);
>>>  	if (dev)
>>> -		strlcpy(uaddr->sa_data, dev->name, 15);
>>> +		strncpy(uaddr->sa_data, dev->name, 14);
>>>  	else
>>>  		memset(uaddr->sa_data, 0, 14);
>>
>> if i understand the code correcly the max size for dev->name is IFNAMSIZ.
> 
> For dev->name - IFNAMSIZ, for uaddr->sa_data - 14.
> 


did not notice, since uaddr->sa_data should take dev->name this does no look very
clever. How is the size of  sa_data defined ? Would it hurt when some uses IFNAMSIZ here ?
Perhaps someone who know more about the network stack can figure out what is actualy done
with uaddr->sa_data.

looks like a can of worms.


In packet_bind_spkt() they will copy a char[15], obviously it is a real problem.

re,
 wh


>> You can simply that part:
>>
>> memset(uaddr->sa_data, 0, IFNAMSIZ);
>> dev = dev_get_by_index_rcu(sock_net(sk), pkt_sk(sk)->ifindex);
>> if (dev)
>> 	strlcpy(uaddr->sa_data, dev->name, IFNAMSIZ);
> 
> This will overflow uaddr->sa_data.  Also I don't see any difficulty to
> fill the array only once.
> 
>> you should send that as separate patch.
>> re,
>>  wh
>>
>>
>>>  	rcu_read_unlock();
>>> @@ -1742,6 +1742,7 @@ static int packet_getname(struct socket *sock, struct sockaddr *uaddr,
>>>  	sll->sll_family = AF_PACKET;
>>>  	sll->sll_ifindex = po->ifindex;
>>>  	sll->sll_protocol = po->num;
>>> +	sll->sll_pkttype = 0;
>>>  	rcu_read_lock();
>>>  	dev = dev_get_by_index_rcu(sock_net(sk), po->ifindex);
>>>  	if (dev) {
> 
> Thanks,
> 
