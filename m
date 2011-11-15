Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab1KORek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 12:34:40 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:16187 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756927Ab1KORei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 12:34:38 -0500
Subject: Re: [PATCH V2] vlan:return error when real dev is enslaved
From: Ben Hutchings <bhutchings@solarflare.com>
To: Weiping Pan <wpan@redhat.com>
CC: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        "open list:VLAN (802.1Q)" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
In-Reply-To: <d7ea491a500c99c0b4839ddcedab027a3c865c59.1321360959.git.wpan@redhat.com>
References: <CAM_iQpXCtH1cSJFsWVGrdreyhBgAjujLygktQGrK7iP-zyhN5g@mail.gmail.com>
	 <d7ea491a500c99c0b4839ddcedab027a3c865c59.1321360959.git.wpan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Tue, 15 Nov 2011 17:34:31 +0000
Message-ID: <1321378471.2744.5.camel@bwh-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18520.003
X-TM-AS-Result: No--8.288200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-OriginalArrivalTime: 15 Nov 2011 17:34:38.0000 (UTC) FILETIME=[D931CB00:01CCA3BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 20:44 +0800, Weiping Pan wrote:
> Qinhuibin reported a kernel panic when he do some operation about vlan.
> https://lkml.org/lkml/2011/11/6/218
> 
> The operation is as below:
> ifconfig eth2 up
> modprobe bonding
> modprobe 8021q
> ifconfig bond0 up
> ifenslave bond0 eth2
> vconfig add eth2 3300
> vconfig add bond0 33
> vconfig rem eth2.3300
>
> the panic stack is as below:
> [<ffffffffa002f1c9>] panic_event+0x49/0x70 [ipmi_msghandler]
> [<ffffffff80378917>] notifier_call_chain+0x37/0x70
> [<ffffffff80372122>] panic+0xa2/0x195
> [<ffffffff80376ed8>] oops_end+0xd8/0x140
> [<ffffffff8001bea7>] no_context+0xf7/0x280
> [<ffffffff8001c1a5>] __bad_area_nosemaphore+0x175/0x250
> [<ffffffff80376318>] page_fault+0x28/0x30
> [<ffffffffa039dabd>] igb_vlan_rx_kill_vid+0x4d/0x100 [igb]
> [<ffffffffa044045f>] bond_vlan_rx_kill_vid+0x9f/0x290 [bonding]
> [<ffffffffa047e636>] unregister_vlan_dev+0x136/0x180 [8021q]
> [<ffffffffa047ed20>] vlan_ioctl_handler+0x170/0x3f0 [8021q]
> [<ffffffff802c1d3f>] sock_ioctl+0x21f/0x280
> [<ffffffff800e6d7f>] vfs_ioctl+0x2f/0xb0
> [<ffffffff800e726b>] do_vfs_ioctl+0x3cb/0x5a0
> [<ffffffff800e74e1>] sys_ioctl+0xa1/0xb0
> [<ffffffff80007388>] system_call_fastpath+0x16/0x1b
> [<00007f108a2b8bd7>] 0x7f108a2b8bd7
> And the nic is as below:
> [root@localhost ~]# ethtool -i eth2
> driver: igb
> version: 3.0.6-k2
> firmware-version: 1.2-1
> bus-info: 0000:04:00.0
> kernel version：
> 2.6.32.12-0.7 also happen in 2.6.32-131
> 
> For kernel 2.6.32, the reason of this bug is that when we do "vconfig add bond0 33",
> adapter->vlgrp is overwritten in igb_vlan_rx_register. So when we do "vconfig rem
> eth2.3300", it can't find the correct vlgrp.
> 
> And this bug is avoided by vlan cleanup patchset from Jiri Pirko
> <jpirko@redhat.com>, especially commit b2cb09b1a772(igb: do vlan cleanup).

Since this won't be applied to mainline first, you should send it
directly to stable@vger.kernel.org as well as to netdev.

> But it is not a correct operation to creat a vlan interface on eth2
> when it have been enslaved by bond0, so this patch is to return error
> when the real dev is already enslaved.
> 
> Changelog:
> V2: use pr_err instead of pr_info
> 
> Signed-off-by: Weiping Pan <wpan@redhat.com>
> ---
>  net/8021q/vlan.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
> index 5471628..7ce50ba 100644
> --- a/net/8021q/vlan.c
> +++ b/net/8021q/vlan.c
> @@ -148,6 +148,11 @@ int vlan_check_real_dev(struct net_device *real_dev, u16 vlan_id)
>  	const char *name = real_dev->name;
>  	const struct net_device_ops *ops = real_dev->netdev_ops;
>  
> +	if (real_dev->flags & IFF_SLAVE) {
> +		pr_err("Error, %s was already enslaved\n", name);
> +		return -EOPNOTSUPP;

I think the appropriate error code is EBUSY.  The operation is supported
(probably - we haven't checked for VLAN_CHALLENGED yet) but the device
is otherwise occupied.

Ben.

> +	}
> +
>  	if (real_dev->features & NETIF_F_VLAN_CHALLENGED) {
>  		pr_info("VLANs not supported on %s\n", name);
>  		return -EOPNOTSUPP;

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

