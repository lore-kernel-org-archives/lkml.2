Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab1KGCxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 21:53:18 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:64444 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab1KGCxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 21:53:16 -0500
Date: Mon, 07 Nov 2011 02:53:02 +0000
From: Qianhuibin <qianhuibin@huawei.com>
Subject: kernel panic occurred when I do some operation about vlan.
In-reply-to: <FF4D6E6C1D10244088EA772C65CB346E015159AF@szxeml528-mbs.china.huawei.com>
X-Originating-IP: [10.166.82.152]
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <FF4D6E6C1D10244088EA772C65CB346E01516A22@szxeml528-mbs.china.huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-language: zh-CN
Accept-Language: zh-CN, en-US
Thread-topic: kernel panic occurred when I do some operation about vlan.
Thread-index: Acyc97s4dyNSuTp0SeW7krROgbnwzgAAJfKh
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-CFilter-Loop: Reflected
References: <FF4D6E6C1D10244088EA772C65CB346E015159AF@szxeml528-mbs.china.huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pA72rPSB011926

Hi, all
A kernel panic occurred when I do some operation about vlan.

The operation is as below:
ifconfig eth2 up
modprobe bonding
modprobe 8021q
ifconfig bond0 up
ifenslave bond0 eth2
vconfig add eth2 3300
vconfig add bond0 33
vconfig rem eth2.3300

the panic stack is as below:
[<ffffffffa002f1c9>] panic_event+0x49/0x70 [ipmi_msghandler]
[<ffffffff80378917>] notifier_call_chain+0x37/0x70
[<ffffffff80372122>] panic+0xa2/0x195
[<ffffffff80376ed8>] oops_end+0xd8/0x140
[<ffffffff8001bea7>] no_context+0xf7/0x280
[<ffffffff8001c1a5>] __bad_area_nosemaphore+0x175/0x250
[<ffffffff80376318>] page_fault+0x28/0x30
[<ffffffffa039dabd>] igb_vlan_rx_kill_vid+0x4d/0x100 [igb]
[<ffffffffa044045f>] bond_vlan_rx_kill_vid+0x9f/0x290 [bonding]
[<ffffffffa047e636>] unregister_vlan_dev+0x136/0x180 [8021q]
[<ffffffffa047ed20>] vlan_ioctl_handler+0x170/0x3f0 [8021q]
[<ffffffff802c1d3f>] sock_ioctl+0x21f/0x280
[<ffffffff800e6d7f>] vfs_ioctl+0x2f/0xb0
[<ffffffff800e726b>] do_vfs_ioctl+0x3cb/0x5a0
[<ffffffff800e74e1>] sys_ioctl+0xa1/0xb0
[<ffffffff80007388>] system_call_fastpath+0x16/0x1b
[<00007f108a2b8bd7>] 0x7f108a2b8bd7

And the nic is as below:
[root@localhost ~]# ethtool -i eth2
driver: igb
version: 3.0.6-k2
firmware-version: 1.2-1
bus-info: 0000:04:00.0

kernel version£º
2.6.32.12-0.7 also happen in 2.6.32-131

I had tried the same operation on other nics, like tg3,bnx2. But they haven¡¯t panic.
So I find the reason is that igb have two more netdev_ops (ndo_vlan_rx_add_vid and ndo_vlan_rx_kill_vid) than tg3 and bnx2.
I think the reason of panic is that when ndo_vlan_rx_kill_vid has been called, the vlgrp haven¡¯t been correctly find. And it should be find in parameter like what have been done in ndo_vlan_rx_register.

Finally, I kown that it¡¯s not a correct operation to creat a vlan interface on eth2 when it have been slaved by bond0, but it would cause a panic, so I think maybe some improve in ndo_vlan_rx_add_vid£¨add a vlgrp parameter in netdevice.h£© like ndo_vlan_rx_register would be better.

Qin Chuanyu
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
