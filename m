Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab1KPHOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 02:14:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270Ab1KPHOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 02:14:23 -0500
Message-ID: <4EC36358.3030905@redhat.com>
Date: Wed, 16 Nov 2011 15:16:40 +0800
From: Weiping Pan <wpan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: =?UTF-8?B?Tmljb2xhcyBkZSBQZXNsb8O8YW4=?= 
	<nicolas.2p.debian@gmail.com>
CC: "Patrick McHardy (maintainer:VLAN (802.1Q))" <kaber@trash.net>,
        "\"David S. Miller\" (maintainer:NETWORKING [GENERAL])" 
	<davem@davemloft.net>,
        "open list:VLAN (802.1Q)" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] vlan:return error when real dev is enslaved
References: <CAM_iQpXCtH1cSJFsWVGrdreyhBgAjujLygktQGrK7iP-zyhN5g@mail.gmail.com> <d7ea491a500c99c0b4839ddcedab027a3c865c59.1321360959.git.wpan@redhat.com> <4EC2BB48.2070802@gmail.com>
In-Reply-To: <4EC2BB48.2070802@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 03:19 AM, Nicolas de Pesloüan wrote:
> Le 15/11/2011 13:44, Weiping Pan a écrit :
>> Qinhuibin reported a kernel panic when he do some operation about vlan.
>> https://lkml.org/lkml/2011/11/6/218
>>
>> The operation is as below:
>> ifconfig eth2 up
>> modprobe bonding
>> modprobe 8021q
>> ifconfig bond0 up
>> ifenslave bond0 eth2
>> vconfig add eth2 3300
>> vconfig add bond0 33
>> vconfig rem eth2.3300
>>
>> the panic stack is as below:
>> [<ffffffffa002f1c9>] panic_event+0x49/0x70 [ipmi_msghandler]
>> [<ffffffff80378917>] notifier_call_chain+0x37/0x70
>> [<ffffffff80372122>] panic+0xa2/0x195
>> [<ffffffff80376ed8>] oops_end+0xd8/0x140
>> [<ffffffff8001bea7>] no_context+0xf7/0x280
>> [<ffffffff8001c1a5>] __bad_area_nosemaphore+0x175/0x250
>> [<ffffffff80376318>] page_fault+0x28/0x30
>> [<ffffffffa039dabd>] igb_vlan_rx_kill_vid+0x4d/0x100 [igb]
>> [<ffffffffa044045f>] bond_vlan_rx_kill_vid+0x9f/0x290 [bonding]
>> [<ffffffffa047e636>] unregister_vlan_dev+0x136/0x180 [8021q]
>> [<ffffffffa047ed20>] vlan_ioctl_handler+0x170/0x3f0 [8021q]
>> [<ffffffff802c1d3f>] sock_ioctl+0x21f/0x280
>> [<ffffffff800e6d7f>] vfs_ioctl+0x2f/0xb0
>> [<ffffffff800e726b>] do_vfs_ioctl+0x3cb/0x5a0
>> [<ffffffff800e74e1>] sys_ioctl+0xa1/0xb0
>> [<ffffffff80007388>] system_call_fastpath+0x16/0x1b
>> [<00007f108a2b8bd7>] 0x7f108a2b8bd7
>> And the nic is as below:
>> [root@localhost ~]# ethtool -i eth2
>> driver: igb
>> version: 3.0.6-k2
>> firmware-version: 1.2-1
>> bus-info: 0000:04:00.0
>> kernel version：
>> 2.6.32.12-0.7 also happen in 2.6.32-131
>>
>> For kernel 2.6.32, the reason of this bug is that when we do "vconfig 
>> add bond0 33",
>> adapter->vlgrp is overwritten in igb_vlan_rx_register. So when we do 
>> "vconfig rem
>> eth2.3300", it can't find the correct vlgrp.
>>
>> And this bug is avoided by vlan cleanup patchset from Jiri Pirko
>> <jpirko@redhat.com>, especially commit b2cb09b1a772(igb: do vlan 
>> cleanup).
>>
>> But it is not a correct operation to creat a vlan interface on eth2
>> when it have been enslaved by bond0, so this patch is to return error
>> when the real dev is already enslaved.
>
> Why isn't this setup correct?
>
> Compare to bridge, where ebtables allow for some sort of sharing of 
> the physical interface between bridge and vlan.
>
> I think bonding should behave the same way instead of denying this setup.
>
>     Nicolas.
>
Hi, Nicolas,

After some investigation I agree with you that this setup is correct,
since we can  "switchport trunk allowed vlan 2-3" on the switch.

I can confirm that both bonding and bridge support this kind of setup.

bond0.2                                        br0.2
       |                                                |
   eth0 ----- eth0.3                          eth0 -----eth0.3

Both works fine(git commit 06236ac3726f1),  so please discard this patch.

thanks
Weiping Pan









