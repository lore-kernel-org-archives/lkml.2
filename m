Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961Ab2COKOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 06:14:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:3408 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033Ab2COKOL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 06:14:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="77843738"
From: "Du, Alek" <alek.du@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        "Zuo, Jiao" <jiao.zuo@intel.com>
Subject: RE: [PATCH] tty: hold lock across tty buffer finding and buffer
 filling
Thread-Topic: [PATCH] tty: hold lock across tty buffer finding and buffer
 filling
Thread-Index: Ac0CUERRacLD33MLTtaeiAHOWyOq2AAADUEAABDKXdA=
Date: Thu, 15 Mar 2012 10:14:07 +0000
Message-ID: <09F19C497AD02E4EA4E14917772649B70FCD36C2@SHSMSX102.ccr.corp.intel.com>
References: <EE928378561BF1449699C96571234A740FCC580F@SHSMSX102.ccr.corp.intel.com>
 <20120315100812.6cda2ef9@pyramind.ukuu.org.uk>
In-Reply-To: <20120315100812.6cda2ef9@pyramind.ukuu.org.uk>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

I agree with you for the case of multiple writers to the tty buffer.

But there is another case that cause kernel hang: driver is writing data to tty, while app shutdown the port or flush through IOCTL. The buf.tail is set to NULL, here is the log:


<1>[ 4713.451954] BUG: unable to handle kernel NULL pointer dereference at
00000004
<1>[ 4713.452424] IP: [<c14ff59c>] tty_insert_flip_string_fixed_flag+0x4c/0x90
<4>[ 4713.452832] *pde = 00000000 
<0>[ 4713.453017] Oops: 0000 [#1] PREEMPT SMP 
<0>[ 4713.453280] last sysfs file:
/sys/devices/pci0000:00/0000:00:03.5/gpio/gpio172/value
<4>[ 4713.453709] Modules linked in: ipv6 atomisp lm3554 mt9m114 mt9e013
videobuf_vmalloc videobuf_dma_contig videobuf_core wl12xx_sdio wl12xx mac80211
cfg80211 compat btwilink st_drv
<4>[ 4713.454768] 
<4>[ 4713.454875] Pid: 0, comm: swapper Not tainted 2.6.35.3-84779-g68baa8f #1
/
<4>[ 4713.455258] EIP: 0060:[<c14ff59c>] EFLAGS: 00010002 CPU: 0
<4>[ 4713.455573] EIP is at tty_insert_flip_string_fixed_flag+0x4c/0x90
<4>[ 4713.455914] EAX: e01a6800 EBX: 00000000 ECX: 00000001 EDX: 00010002
<4>[ 4713.456264] ESI: 00000001 EDI: 00000000 EBP: c1a8be50 ESP: c1a8be38
<4>[ 4713.456614]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
<0>[ 4713.456921] Process swapper (pid: 0, ti=c1a8a000 task=c1aa02a0
task.ti=c1a8a000)
<0>[ 4713.457324] Stack:
<4>[ 4713.457447]  00000000 f5abf800 e01a6800 f6dec358 f6df877c e01a6800
c1a8be78 c1544b13
<4>[ 4713.457958] <0> 00000001 000e0100 f79a785c 00000000 00000001 f6dec358
000000dc 00000001
<4>[ 4713.458511] <0> c1a8be98 c1544d0c 00000002 00000082 f6de0000 f7880f40
c1a908fc 00000000
<0>[ 4713.459087] Call Trace:
<4>[ 4713.459255]  [<c1544b13>] ? hsu_dma_rx+0xa3/0x190
<4>[ 4713.459534]  [<c1544d0c>] ? dma_irq+0x10c/0x160
<4>[ 4713.459806]  [<c12981f4>] ? handle_IRQ_event+0x44/0x1a0
<4>[ 4713.460109]  [<c129a798>] ? handle_fasteoi_irq+0x68/0xd0
<4>[ 4713.460418]  [<c120569d>] ? handle_irq+0x1d/0x30
<4>[ 4713.460695]  [<c18744cf>] ? do_IRQ+0x4f/0xc0
<4>[ 4713.460953]  [<c120356e>] ? common_interrupt+0x2e/0x34
<4>[ 4713.461257]  [<c124007b>] ? pre_schedule_rt+0x1b/0x30
<4>[ 4713.461557]  [<c14ede14>] ? soc_s0ix_idle+0x144/0x290
<4>[ 4713.461859]  [<c16544a0>] ? cpuidle_idle_call+0x90/0x180
<4>[ 4713.462168]  [<c1201d61>] ? cpu_idle+0x51/0xb0
<4>[ 4713.462431]  [<c1853e6b>] ? rest_init+0xab/0xc0
<4>[ 4713.462702]  [<c1b07991>] ? start_kernel+0x342/0x348
<4>[ 4713.462992]  [<c1b07460>] ? unknown_bootoption+0x0/0x1a0
<4>[ 4713.463301]  [<c1b070de>] ? i386_start_kernel+0xde/0xe6
<0>[ 4713.463593] Code: e8 8b 55 08 b8 00 07 00 00 29 fa 81 fa 00 07 00 00 0f
47
d0 8b 45 f0 e8 33 fd ff ff 89 c6 8b 45 f0 85 f6 8b 98 d4 00 00 00 74 2a <8b> 43
04 89 f1 01 f7 8b 55 ec 03 43 0c e8 72 99 fb ff 8b 43 08 
<0>[ 4713.465460] EIP: [<c14ff59c>] tty_insert_flip_string_fixed_flag+0x4c/0x90
SS:ESP 0068:c1a8be3





-----Original Message-----
From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk] 
Sent: Thursday, March 15, 2012 6:08 PM
To: Tu, Xiaobing
Cc: linux-kernel@vger.kernel.org; gregkh@linuxfoundation.org; Zhang, Yanmin; Du, Alek; Zuo, Jiao
Subject: Re: [PATCH] tty: hold lock across tty buffer finding and buffer filling

On Thu, 15 Mar 2012 02:06:43 +0000
"Tu, Xiaobing" <xiaobing.tu@intel.com> wrote:

> From: Xiaobing Tu <xiaobing.tu@intel.com>
> 
> tty_buffer_request_room is well protected, but while after it returns,  
> it releases the port->lock. tty->buf.tail might be modified

This can only occur in a way that matters if you have multiple writers to the tty buffer. 

It is a design requirement of the tty layer that your input is single threaded paths and this is true for existing drivers. There is a good reason it is true as well - ordering of bytes is defined for serial data, any parallel writer breaks that ordering even if you have locks in tty_insert_flip_*.

In practice that means that the tail pointer has a single incrementer and the reader is the ldisc processing queue. 

So NAK pending a lot more explanation and an actual case where you can show it is required.

Under what situations with what in tree driver do you see a problem ?


Alan
