Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab2CARbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 12:31:34 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40052 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab2CARbb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 12:31:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ncardwell@google.com designates 10.224.111.142 as permitted sender) smtp.mail=ncardwell@google.com; dkim=pass header.i=ncardwell@google.com
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.1202290929520.4930@trent.utfs.org>
References: <alpine.DEB.2.01.1202261556150.4930@trent.utfs.org>
	<alpine.DEB.2.01.1202290929520.4930@trent.utfs.org>
Date: Thu, 1 Mar 2012 12:31:30 -0500
Message-ID: <CADVnQy=JkVc_8ptpSkhQWe4HJpbe_+JMad+2uqgN1iUfkfFFCw@mail.gmail.com>
Subject: Re: WARNING: at net/ipv4/tcp_input.c:3418
From: Neal Cardwell <ncardwell@google.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: netdev@vger.kernel.org, markus@trippelsdorf.de,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the detailed reports.

I am working on this, and have a theory and potential fix for a bug
that relates to MSS changes and broken packet counts for SACKed skbs,
which could conceivably lead to the warnings you're seeing. However,
the bug that I am looking at is quite old. (Though it's possible it's
being tickled more now, due to some interaction with recent changes.)

To help provide more data, would you be able to run with 3.3.0-rc3 for
a while (hopefully with roughly the same flavor of workload) and see
if you run into the same problems?

neal

On Wed, Feb 29, 2012 at 12:41 PM, Christian Kujau <lists@nerdbynature.de> wrote:
> This is still happening with 3.3.0-rc5, .config & dmesg here:
>
>   http://nerdbynature.de/bits/3.3.0-rc4/ipv4/
>
> After the WARNING is printed often enough, the machine halts and has to be
> powercycled. It appears that "lots of traffic" or "many connections" may
> cause this, but unfortunately I haven't been able to reproduce this reliably.
>
> Any ideas on that one?
>
> Thanks,
> Christian.
>
> On Sun, 26 Feb 2012 at 16:05, Christian Kujau wrote:
>> Hi,
>>
>> I'm getting the same message here on PowerPC (32bit):
>>
>> ------------[ cut here ]------------
>> WARNING: at /usr/local/src/linux-2.6-git/net/ipv4/tcp_input.c:3418
>> Modules linked in: tun nfs ecryptfs netconsole therm_adt746x aes_generic
>> arc4 b43 i2c_powermac sd_mod firewire_sbp2 mac80211 cfg80211 usb_storage
>> scsi_mod
>> NIP: c04720c4 LR: c04720b8 CTR: c049f2c8
>> REGS: efff1c20 TRAP: 0700   Tainted: G        W     (3.3.0-rc4)
>> MSR: 00029032 <EE,ME,IR,DR,RI>  CR: 42048448  XER: 20000000
>> TASK = ee666780[1964] 'milkyway_0.50_p' THREAD: ee6c6000
>> GPR00: ffffffff efff1cd0 ee666780 ee70c0a0 0000000b ffffffff c0426e70 00000000
>> GPR08: 0000000b 00000001 00000000 00000009 42048448 1013488c 00000000 4f4a260f
>> GPR16: 29c2cc42 00000502 00000000 000001cb 000001cb ee70c1b0 0000000b 00000000
>> GPR24: 00000001 0000000c ffffffff ecef8580 0000000b 3c176da7 ee70c0a0 c0690000
>> NIP [c04720c4] tcp_ack+0x720/0x10a0
>> LR [c04720b8] tcp_ack+0x714/0x10a0
>> Call Trace:
>> [efff1cd0] [c04720b8] tcp_ack+0x714/0x10a0 (unreliable)
>> [efff1d60] [c04756f0] tcp_rcv_established+0x214/0x6c4
>> [efff1d90] [c047d1dc] tcp_v4_do_rcv+0xd8/0x2a4
>> [efff1dd0] [c047db0c] tcp_v4_rcv+0x764/0x8e4
>> [efff1e10] [c045ac6c] ip_local_deliver+0xe0/0x1dc
>> [efff1e30] [c045a870] ip_rcv+0x378/0x694
>> [efff1e50] [c04302c8] __netif_receive_skb+0x320/0x52c
>> [efff1eb0] [c0430790] napi_skb_finish+0x6c/0x90
>> [efff1ec0] [c03b2e20] gem_poll+0x694/0x1274
>> [efff1f50] [c0430ccc] net_rx_action+0x1d4/0x278
>> [efff1fa0] [c003bac0] __do_softirq+0xf4/0x1bc
>> [efff1ff0] [c00103b0] call_do_softirq+0x14/0x24
>> [ee6c7ee0] [c00070ac] do_softirq+0xfc/0x128
>> [ee6c7f00] [c003b73c] irq_exit+0xac/0xcc
>> [ee6c7f10] [c00071d8] do_IRQ+0x8c/0x1b0
>> [ee6c7f40] [c0012e60] ret_from_except+0x0/0x14
>> Instruction dump:
>> 2f800000 419e0020 73250008 4182046c 38a0ffff 7ec4b378 7fc3f378 7c0903a6
>> 4e800421 801e04e8 7c1a0378 54090ffe <0f090000> 809e04e4 54890ffe 0f090000
>> ---[ end trace de136ca1488e7a83 ]---
>> Leak s=4294967295 1
>>
>>
>> Yesterday the machine panick'ed and shutdown shortly after the message
>> appeared. From today's logs I can see the message appeared some 10 hours
>> ago but the machine is still up & running. I've been running 3.3.0-rc4 for
>> some time now, but network activity went up a few days ago, so that
>> might've triggered it.
>>
>> Ful dmesg & .config: http://nerdbynature.de/bits/3.3.0-rc4/ipv4/
>>
>> Note: the machine's internal battery seems to be bad, that's why the
>> timestamps during bootup are b0rked in those logfiles.
>>
>> Please Cc me on replies as I'm not subscribed to netdev.
>>
>> Thanks,
>> Christian.
>> --
>> BOFH excuse #444:
>>
>> overflow error in /dev/null
>>
>
> --
> BOFH excuse #38:
>
> secretary plugged hairdryer into UPS
