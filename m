Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab1KVIVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 03:21:45 -0500
Received: from szxga04-in.huawei.com ([119.145.14.67]:50300 "EHLO
	szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab1KVIVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 03:21:43 -0500
Date: Tue, 22 Nov 2011 08:20:51 +0000
From: Qianhuibin <qianhuibin@huawei.com>
Subject: RE: A kernel panic occurred when I do some operation about vlan
In-reply-to: <20111122074850.GC2190@minipsycho>
X-Originating-IP: [10.166.82.152]
To: Jiri Pirko <jpirko@redhat.com>
Cc: "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Wuchangyi <wuchangyi@huawei.com>, Qinchuanyu <qinchuanyu@huawei.com>,
        Zhanghaoyu <zhanghaoyu@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lichunhe <lichunhe@huawei.com>, Wangzhenguo <wangzhenguo@huawei.com>
Message-id: <FF4D6E6C1D10244088EA772C65CB346E015195E2@szxeml528-mbs.china.huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-language: en-US
Accept-Language: en-US, zh-CN
Thread-topic: A kernel panic occurred when I do some operation about vlan
Thread-index: Acyo5R8O+tzxPc1xQEqrILDu3CUQ7v//hf+AgACOSUo=
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-CFilter-Loop: Reflected
References: <FF4D6E6C1D10244088EA772C65CB346E015195A8@szxeml528-mbs.china.huawei.com>
 <20111122074850.GC2190@minipsycho>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAM8Lt62030304


We find the crash on SLES11SP1.

The igb version is 3.0.6-k2 which comes with SLES11SP1


________________________________________
From: Jiri Pirko [jpirko@redhat.com]
Sent: Tuesday, November 22, 2011 15:48
To: Qianhuibin
Cc: jeffrey.t.kirsher@intel.com; e1000-devel@lists.sourceforge.net; davem@davemloft.net; Wuchangyi; Qinchuanyu; Zhanghaoyu
Subject: Re: A kernel panic occurred when I do some operation about vlan

Tue, Nov 22, 2011 at 08:11:51AM CET, qianhuibin@huawei.com wrote:
>Hi, all
>A kernel panic occurred when I do some operation about vlan.
>
>
>The operation is as below:
>ifconfig eth2 up
>modprobe bonding
>modprobe 8021q
>ifconfig bond0 up
>ifenslave bond0 eth2
>vconfig add eth2 3300
>vconfig add bond0 33
>vconfig rem eth2.3300
>
>
>the panic stack is as below:
>[<ffffffffa002f1c9>] panic_event+0x49/0x70 [ipmi_msghandler]
>[<ffffffff80378917>] notifier_call_chain+0x37/0x70
>[<ffffffff80372122>] panic+0xa2/0x195
>[<ffffffff80376ed8>] oops_end+0xd8/0x140
>[<ffffffff8001bea7>] no_context+0xf7/0x280
>[<ffffffff8001c1a5>] __bad_area_nosemaphore+0x175/0x250
>[<ffffffff80376318>] page_fault+0x28/0x30
>[<ffffffffa039dabd>] igb_vlan_rx_kill_vid+0x4d/0x100 [igb]
>[<ffffffffa044045f>] bond_vlan_rx_kill_vid+0x9f/0x290 [bonding]
>[<ffffffffa047e636>] unregister_vlan_dev+0x136/0x180 [8021q]
>[<ffffffffa047ed20>] vlan_ioctl_handler+0x170/0x3f0 [8021q]
>[<ffffffff802c1d3f>] sock_ioctl+0x21f/0x280
>[<ffffffff800e6d7f>] vfs_ioctl+0x2f/0xb0
>[<ffffffff800e726b>] do_vfs_ioctl+0x3cb/0x5a0
>[<ffffffff800e74e1>] sys_ioctl+0xa1/0xb0
>[<ffffffff80007388>] system_call_fastpath+0x16/0x1b
>[<00007f108a2b8bd7>] 0x7f108a2b8bd7
>
>
>And the nic is as below:
>[root@localhost ~]# ethtool -i eth2
>driver: igb
>version: 3.0.6-k2
>firmware-version: 1.2-1
>bus-info: 0000:04:00.0
>
>
># lspci | grep Eth
>01:00.0 Ethernet controller: Intel Corporation 82576 Gigabit Network Connection (rev 01)
>
>
>kernel version£º
>2.6.32.12-0.7 also happen in 2.6.32-131

What kernel is this? RHEL? And what driver you are using? The one which
came with kernel? In case of [yes, yes] answers I suggest filling up bug
at bugzilla.redhat.com

Jirka

>
>
>I had tried the same operation on other nics, like tg3,bnx2. But they haven¡¯t panic.
>So I find the reason is that igb have two more netdev_ops (ndo_vlan_rx_add_vid and ndo_vlan_rx_kill_vid) than tg3 and bnx2.
>I think the reason of panic is that when ndo_vlan_rx_kill_vid has been called, the vlgrp haven¡¯t been correctly find.
>
>
>My question is what the purpose of  "vlan_group_set_device(adapter->vlgrp, vid, NULL);" in method igb_vlan_rx_kill_vid?
>
>unregister_vlan_dev(vlan.c)  has done the same thing after ops->ndo_vlan_rx_kill_vid was called.
>
>If I delete it , Would it cause somthing bad?
>
>
>qinchuanyu
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
