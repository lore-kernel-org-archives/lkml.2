Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab2IYQLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:11:54 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37383 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043Ab2IYQLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:11:53 -0400
MIME-Version: 1.0
Date: Tue, 25 Sep 2012 09:11:52 -0700
Message-ID: <CANR7ExJwRhgDyK0UrFtTX0SpVvOAb-fE9Vf52CXZCZCLYnLfHg@mail.gmail.com>
Subject: Kernel crashes while using aesni_intel
From: Guru Shetty <gurushettylists@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,
 I have been seeing a bunch of kernel crashes while using aesni_intel
module and IPSEC.

I have so far reproduced the kernel crashes while using the AES-GCM
encryption algorithms(I am using strongswan). It is very easily
reproducible in the 3.2 kernel (stable branch). It is also
reproducible in 3.3, 3.4 and 3.5 kernel stable branches (The
reproduction is a little harder with newer kernels. I have seen 2-3
kernel crashes in Linux 3.5 after running netperf traffic for over
week.)

In the 3.2 kernel, the crash happens once every 15 minutes(average) of
netperf TCP traffic.

I have seen this with both Intel (82599EB 10-Gigabit) and Broadcom
(BCM57711 10-Gigabit PCIe) NICs.
I can provide more information if anyone needs it.

Here is the backtrace as seen in the crash utility.
---------------------
PID: 125    TASK: ffff880bee255bc0  CPU: 3   COMMAND: "kworker/3:1"
 #0 [ffff880c0fc63710] machine_kexec at ffffffff8103842a
 #1 [ffff880c0fc63780] crash_kexec at ffffffff810b4448
 #2 [ffff880c0fc63850] oops_end at ffffffff8165ab68
 #3 [ffff880c0fc63880] die at ffffffff810168d8
 #4 [ffff880c0fc638b0] do_general_protection at ffffffff8165a6e2
 #5 [ffff880c0fc638e0] general_protection at ffffffff8165a105
    [exception RIP: crypto_enqueue_request+43]
    RIP: ffffffff812dd77b  RSP: ffff880c0fc63990  RFLAGS: 00010206
    RAX: 00000000ffffff8d  RBX: ffff8817d74e3a08  RCX: 0000000000000000
    RDX: dead000000200200  RSI: ffff8817d74e3a60  RDI: ffffe8f3cfc61ef0
    RBP: ffff880c0fc63990   R8: 0000000000000000   R9: ffff8817d74e3b18
    R10: 000000007b3dc352  R11: 0000000000000001  R12: 0000000000000003
    R13: ffffe8f3cfc61ef0  R14: ffff880bc6ff3800  R15: 0000000000000001
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #6 [ffff880c0fc63998] cryptd_enqueue_request at ffffffffa02d9106 [cryptd]
 #7 [ffff880c0fc639c8] cryptd_aead_decrypt_enqueue at ffffffffa02d92c0 [cryptd]
 #8 [ffff880c0fc639d8] rfc4106_decrypt at ffffffffa02ec2bf [aesni_intel]
 #9 [ffff880c0fc63a08] esp_input at ffffffffa029da65 [esp4]
#10 [ffff880c0fc63a98] xfrm_input at ffffffff815cb9c4
#11 [ffff880c0fc63b08] xfrm4_rcv_encap at ffffffff815c148c
#12 [ffff880c0fc63b18] xfrm4_rcv at ffffffff815c14b4
#13 [ffff880c0fc63b28] ip_local_deliver_finish at ffffffff815749ed
#14 [ffff880c0fc63b58] ip_local_deliver at ffffffff81574d58
#15 [ffff880c0fc63b88] ip_rcv_finish at ffffffff815746c1
#16 [ffff880c0fc63bb8] ip_rcv at ffffffff81574f95
#17 [ffff880c0fc63bf8] __netif_receive_skb at ffffffff81540523
#18 [ffff880c0fc63c58] netif_receive_skb at ffffffff81541300
#19 [ffff880c0fc63c88] napi_skb_finish at ffffffff81541450
#20 [ffff880c0fc63ca8] napi_gro_receive at ffffffff81541a55
#21 [ffff880c0fc63ce8] bnx2x_rx_int at ffffffffa01850c8 [bnx2x]
#22 [ffff880c0fc63e18] bnx2x_poll at ffffffffa0187409 [bnx2x]
#23 [ffff880c0fc63e68] net_rx_action at ffffffff81541ca4
#24 [ffff880c0fc63ed8] __do_softirq at ffffffff8106ea58
#25 [ffff880c0fc63f48] call_softirq at ffffffff8166422c
#26 [ffff880c0fc63f60] do_softirq at ffffffff81015305
#27 [ffff880c0fc63f80] irq_exit at ffffffff8106ee3e
#28 [ffff880c0fc63f90] smp_apic_timer_interrupt at ffffffff81664bce
#29 [ffff880c0fc63fb0] apic_timer_interrupt at ffffffff81662a9e
--- <IRQ stack> ---
#30 [ffff880bedd939f0] apic_timer_interrupt at ffffffff81662a9e
    RIP: ffffffffffffff10  RSP: 0000000000000202  RFLAGS: 00000010
    RAX: 00007ffffffff000  RBX: ffff880bedd93ac8  RCX: ffff880bee255bc0
    RDX: 0000000000000000  RSI: 0000000000000000  RDI: 0000000000000001
    RBP: ffffffff8103dcf9   R8: 000000000000007d   R9: 0000000000000000
   R10: 0000000000000011  R11: ffffffff81659c5e  R12: ffff880bedd93a18
    R13: 0044b82fa09b5a53  R14: ffff880bedd93a3e  R15: 000000000000003a
    ORIG_RAX: ffff880bedd41888  CS: ffffffff810b2a4f  SS: ffff880bedd93aa8
