Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab2AWOpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 09:45:12 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49381 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab2AWOpK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 09:45:10 -0500
MIME-Version: 1.0
In-Reply-To: <1327327879.2525.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <22013455.801327321838477.JavaMail.root@5-MeO-DMT.ynet.sk> <1327327879.2525.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
From: =?ISO-8859-2?Q?=A9tefan_Gula?= <steweg@ynet.sk>
Date: Mon, 23 Jan 2012 15:44:49 +0100
X-Google-Sender-Auth: gEEod9Ucx8SamDopBy6Ntq99cS8
Message-ID: <CAGsizzLK4HNT+Y3FP_f96LxgROx5BoL-J5iaBj7+Ok5-973+gw@mail.gmail.com>
Subject: Re: [patch v1, kernel version 3.2.1] Source mode for macvlan interaface
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/23 Eric Dumazet <eric.dumazet@gmail.com>:
> Le lundi 23 janvier 2012 à 13:30 +0100, Stefan Gula a écrit :
>> From: Stefan Gula <steweg@gmail.com>
>>
>> New mode of macvlan interface called "source" allows one to specify,
>> which  frames are allowed to be received by given macvlan interface.
>> This logic is used only on received frames on underlaying interface.
>> The ability to send frames from macvlan interface through underlaying
>> interface is not modified. This feature allows one to simulate 802.1x
>> mac based VLAN bahaviour by using proper netlink message to configure
>> this behavior with utililty such as "ip link" from iproute2 suite.
>>
>> Signed-off-by: Stefan Gula <steweg@gmail.com>
>
> Please limit line lengths to 70 chars.
>
> I dont understand your patch description at all, and reading its body I
> still dont understand its purpose.
>
> Is it sort of firewall rules (ebtable) or bridging code ?
Probably partially both of them. Today to achieve the same you need
2/3 things in kernel:
- veth module (optional)
- bridge module
- ebtables module

In real life scenarios, where 802.1x is deployed with mac based
authentication feature usually in wireless networks, but sometimes
also in wired ones, RADIUS message includes part which instruct NAS to
set given user to proper VLAN. As nature of having multiple clients
behind the same physical interface, there is a need to separate the
incoming traffic from clients based on their MAC address (source MAC
addresses in incoming frames). That can be achieved by two ways. One
way is that driver of physical interface allows that directly (usually
not true) or by using virtualization on network layer by:
- incoming interface and all possible outgoing interfaces into one huge bridge
- creating ebtables set of rules that permits given traffic back and
forth through this bridge
- to maintain certain level of segmentation and easy of maintenance
sometime people do (optional steps):
  - creating one veth per VLAN
  - creating one small bridge per VLAN
  - putting one end of veth link into the small bridge with all
possible physical outgoing interfaces for given VLAN
  - putting second end of veth link into the huge bridge instead of
physical outgoing interfaces for given VLAN
- in case that some MAC address resides on multiple VLANs (e.g. some
HW L3 switch used to route traffic), you will end up with problem due
the process of learning on that huge bridge, will allows it to exists
only behind of one port, which is not true as it can exists behind
multiple ports in different VLANs

My patch simple removes this need for using of the huge bridge with
ebtables rules and solves the problem of residing MAC address in
multiple VLANs.

>> +static void macvlan_hash_del_sources(struct macvlan_source_list *list,
>> +                                     bool sync)
>> +{
>> +     hlist_del_rcu(&list->hlist);
>> +     kfree_rcu(list, rcu);
>> +     if (sync)
>> +             synchronize_rcu();
>> +}
>> +
>
> Please explain why are you using synchronize_rcu() here, as there must
> be a good reason, but I missed it.
I though so, but I was not sure whether that should be removed or not
so I rather leave it there as I followed the original code structure
of macvlan driver. So should I remove it?
