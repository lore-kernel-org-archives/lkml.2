Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab0JGXds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 19:33:48 -0400
Received: from ocean.emcraft.com ([213.221.7.182]:45630 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab0JGXdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 19:33:46 -0400
X-Greylist: delayed 1174 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Oct 2010 19:33:46 EDT
Message-ID: <4CAE5445.4020106@emcraft.com>
Date: Fri, 08 Oct 2010 03:14:13 +0400
From: Ilya Yanok <yanok@emcraft.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ru; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        "'Vladimir K'" <vlad@emcraft.com>
CC: Wolfgang Denk <wd@denx.de>
Subject: [RFC] CONFIG_NET_DMA  can hang the system if DMA engine driver uses
 tasklets
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan, everybody.

I use mpc512x_dma driver which utilizes tasklet to free completed 
descriptors. With CONFIG_NET_DMA enabled the whole system hangs during 
network throughput testing. I've done some investigation and found that 
at some point we run out of descriptors and for some reason my tasklet 
is not executed. After doing some more investigation I've found this 
reason. Here is a stack dump at the moment of hang:

[ 1220.884981] BUG: soft lockup - CPU#0 stuck for 61s! [syslogd:1177]
[ 1220.891143] Modules linked in:
[ 1220.894192] NIP: c02739c0 LR: c027222c CTR: c0273950
[ 1220.899144] REGS: c7ffbbf0 TRAP: 0901   Not tainted 
(2.6.36-rc5-00159-gf3beefd-dirty)
[ 1220.907029] MSR: 00009032 <EE,ME,IR,DR>  CR: 88284482  XER: 20000000
[ 1220.913408] TASK = c78723e0[1177] 'syslogd' THREAD: c7ada000
[ 1220.918870] GPR00: c78a40ac c7ffbca0 c78723e0 00000000 000005a8 
07b22892 00000000 c78a4084
[ 1220.927245] GPR08: 00009032 c78a40ac 10056948 c059f960 00000000
[ 1220.933460] NIP [c02739c0] mpc_dma_prep_memcpy+0x70/0x22c
[ 1220.938849] LR [c027222c] dma_async_memcpy_buf_to_pg+0xd4/0x1c0
[ 1220.944745] Call Trace:
[ 1220.947186] [c7ffbca0] [00009032] 0x9032 (unreliable)
[ 1220.952234] [c7ffbcb0] [20000000] 0x20000000
[ 1220.956502] [c7ffbcd0] [c0273398] dma_memcpy_to_iovec+0xe8/0x180
[ 1220.962511] [c7ffbd10] [c029f040] dma_skb_copy_datagram_iovec+0x200/0x218
[ 1220.969292] [c7ffbd50] [c02c2b9c] tcp_rcv_established+0x6c4/0x7c4
[ 1220.975380] [c7ffbd80] [c02c8ffc] tcp_v4_do_rcv+0xc0/0x1d0
[ 1220.980861] [c7ffbdb0] [c02caffc] tcp_v4_rcv+0x530/0x7b4
[ 1220.986175] [c7ffbde0] [c02ab494] ip_local_deliver+0x9c/0x1fc
[ 1220.991914] [c7ffbe00] [c02ab928] ip_rcv+0x334/0x5a8
[ 1220.996877] [c7ffbe30] [c028adf0] __netif_receive_skb+0x2bc/0x318
[ 1221.002966] [c7ffbe60] [c020aff4] gfar_clean_rx_ring+0x2b0/0x4cc
[ 1221.008965] [c7ffbec0] [c020de94] gfar_poll+0x378/0x5e0
[ 1221.014187] [c7ffbf80] [c028e444] net_rx_action+0x9c/0x1ac
[ 1221.019669] [c7ffbfb0] [c0025e84] __do_softirq+0xa8/0x120
[ 1221.025068] [c7ffbff0] [c000ee04] call_do_softirq+0x14/0x24
[ 1221.030641] [c7adbd10] [c00061a0] do_softirq+0x78/0x84
[ 1221.035773] [c7adbd30] [c0025bd0] irq_exit+0x98/0x9c
[ 1221.040734] [c7adbd40] [c000627c] do_IRQ+0xd0/0x140
[ 1221.045612] [c7adbd70] [c000fad4] ret_from_except+0x0/0x14
[ 1221.051120] --- Exception: 501 at __srcu_read_lock+0x18/0x24
[ 1221.051132]     LR = fsnotify+0x25c/0x26c
[ 1221.060752] [c7adbe30] [3c4a7839] 0x3c4a7839 (unreliable)
[ 1221.066150] [c7adbe90] [c00896d4] do_readv_writev+0x144/0x1e4
[ 1221.071889] [c7adbf10] [c008a13c] sys_writev+0x4c/0x90
[ 1221.077024] [c7adbf40] [c000f43c] ret_from_syscall+0x0/0x38
[ 1221.082588] --- Exception: c01 at 0x20316098
[ 1221.082598]     LR = 0x203c98a8
[ 1221.089962] Instruction dump:
[ 1221.092920] 814c0034 3d200020 60000100 816c0030 61290200 916a0000 
914b0004 900c0030
[ 1221.100684] 912c0034 7d000124 2f8c0000 38600000 <419e00cc> 7ca0fb78 
814c0024 7c0b2378

We can see that the network stack calls dma_memcpy_to_iovec() function 
from the softirq context and it never returns in case of DMA driver runs 
out of descriptors and thus blocks the tasklet from being executed. We 
have a deadlock.

Dan, I'd like to ask your opinion, do you think this is a problem of 
CONFIG_NET_DMA feature implementation or should the DMA engine drivers 
be aware of it? How should we fix it?

I can imagine the following possible solutions:
1. Add a possibility to return a failure to the dma_memcpy_to_iovec() 
function (and reschedule it from the upper level) to give tasklets a 
chance to be executed.
2. Place a restriction on the DMA drivers that descriptors should be 
freed from the hard-irq context, not soft-irq and fix the existing drivers.
3. Try to free the descriptors not only from tasklet but also from the 
place they get requested.

Maybe somebody has a better solution.

Some additional details on my configuration (pretty PowerPC-specific 
though I think this issue is generic one).
I use MPC8308RDB development board based on MPC8308, mpc512x_dma driver 
with my fixes and added support for MPC8308.
Kernel version: v2.6.36-rc5-151-g32163f4 + some my patches that is not 
accepted into mainline yet.
This issue can be easily reproduced with the integrated eTSEC Ethernet 
controller (gianfar driver) but I can't reproduce it with Intel PCIE 
card (e1000e driver).

Regards, Ilya.
