Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab1F1Kf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:35:27 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:24959 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755448Ab1F1Kek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:34:40 -0400
Message-ID: <4E09AE3A.8050306@dsn.okisemi.com>
Date: Tue, 28 Jun 2011 19:34:34 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alexander Stein <alexander.stein@systec-electronic.com>
CC: "Wang, Yong Y" <yong.y.wang@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        "Wang, Qi" <qi.wang@intel.com>,
        "toshiharu-linux@dsn.okisemi.com" <toshiharu-linux@dsn.okisemi.com>
Subject: Re: [PATCH] pch_dma: Fix channel locking
References: <1308755133-8605-1-git-send-email-alexander.stein@systec-electronic.com> <201106230942.24105.alexander.stein@systec-electronic.com> <4E04206C.5000008@dsn.okisemi.com> <201106271622.52763.alexander.stein@systec-electronic.com>
In-Reply-To: <201106271622.52763.alexander.stein@systec-electronic.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/27 23:22), Alexander Stein wrote:
> Ok. I have a 2.6.39 kernel with the following patches:
> pch_phub: Don't panic if dmi_get_system_info returns NULL
> drivers/tty/serial/pch_uart.c: don't oops if dmi_get_system_info returns NULL
> pch_uart: Add console support
> 
> I need these to get a booting board with console support on pch_uart.
> After boot (dma and pch_uart compiled into kernel), I do
> * setserial /dev/ttyPCH0 ^low_latency
> * ./raise_dma_fault
> <- Here I get the message

Thank you for your information.
I could see the kernel message.
However using your patch, it seems the message remains to be seen.

[  142.401597] pch_uart 0000:02:0a.1: PCH UART : Use DMA Mode
[  148.011410]
[  148.011415] =================================
[  148.011428] [ INFO: inconsistent lock state ]
[  148.011439] 2.6.39.2+ #5
[  148.011446] ---------------------------------
[  148.011455] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[  148.011467] gnome-terminal/1759 [HC1[1]:SC0[0]:HE0:SE1] takes:
[  148.011477]  (&(&pd_chan->lock)->rlock){?.....}, at: [<c0710cc5>]
pd_prep_slave_sg+0x92/0x26d
[  148.011509] {HARDIRQ-ON-W} state was registered at:
[  148.011516]   [<c04618a1>] __lock_acquire+0x2d9/0xbcc
[  148.011533]   [<c0462594>] lock_acquire+0x94/0xb7
[  148.011546]   [<c07cec85>] _raw_spin_lock_bh+0x25/0x34
[  148.011561]   [<c07110d0>] pd_alloc_chan_resources+0xb2/0x165
[  148.011577]   [<c070f447>] dma_chan_get+0x63/0xbb
[  148.011591]   [<c070f7a0>] __dma_request_channel+0x168/0x246
[  148.011606]   [<c0655ff4>] pch_uart_startup+0x16b/0x2c4
[  148.011622]   [<c064f2df>] uart_startup+0x8b/0x158
[  148.011636]   [<c0650149>] uart_open+0x13f/0x168
[  148.011649]   [<c063b561>] tty_open+0x2c2/0x3cc
[  148.011663]   [<c04e8113>] chrdev_open+0xf4/0x118
[  148.011678]   [<c04e3a68>] __dentry_open+0x167/0x255
[  148.011694]   [<c04e477b>] nameidata_to_filp+0x4a/0x58
[  148.011708]   [<c04ee74b>] do_last+0x45d/0x573
[  148.011722]   [<c04ef75c>] path_openat+0x9b/0x2b5
[  148.011735]   [<c04ef99c>] do_filp_open+0x26/0x62
[  148.011749]   [<c04e47e2>] do_sys_open+0x59/0xd2
[  148.011762]   [<c04e487e>] sys_open+0x23/0x2b
[  148.011775]   [<c07d4bdf>] sysenter_do_call+0x12/0x38
[  148.011791] irq event stamp: 485514
[  148.011799] hardirqs last  enabled at (485513): [<c07d4c59>]
sysexit_audit+0x11/0x50
[  148.011815] hardirqs last disabled at (485514): [<c07d51ae>]
common_interrupt+0x2e/0x3c
[  148.011832] softirqs last  enabled at (485398): [<c043f585>]
__do_softirq+0x153/0x162
[  148.011849] softirqs last disabled at (485375): [<c040430a>]
do_softirq+0x65/0xba
[  148.011866]
[  148.011869] other info that might help us debug this:
[  148.011879] 1 lock held by gnome-terminal/1759:
[  148.011886]  #0:  (&port_lock_key){-.-...}, at: [<c06555ab>]
pch_uart_interrupt+0x19/0x804
[  148.011912]
[  148.011915] stack backtrace:
[  148.011926] Pid: 1759, comm: gnome-terminal Not tainted 2.6.39.2+ #5
[  148.011934] Call Trace:
[  148.011949]  [<c07ccca4>] ? printk+0x25/0x29
[  148.011962]  [<c0461407>] valid_state+0x133/0x141
[  148.011976]  [<c04614e4>] mark_lock+0xcf/0x1b3
[  148.011990]  [<c0460e57>] ? print_irq_inversion_bug+0xe9/0xe9
[  148.012004]  [<c046182d>] __lock_acquire+0x265/0xbcc
[  148.012019]  [<c0461af7>] ? __lock_acquire+0x52f/0xbcc
[  148.012034]  [<c0710cc5>] ? pd_prep_slave_sg+0x92/0x26d
[  148.012047]  [<c0462594>] lock_acquire+0x94/0xb7
[  148.012061]  [<c0710cc5>] ? pd_prep_slave_sg+0x92/0x26d
[  148.012076]  [<c07ceacb>] _raw_spin_lock+0x20/0x2f
[  148.012090]  [<c0710cc5>] ? pd_prep_slave_sg+0x92/0x26d
[  148.012104]  [<c0710cc5>] pd_prep_slave_sg+0x92/0x26d
[  148.012120]  [<c0655af2>] pch_uart_interrupt+0x560/0x804
[  148.012138]  [<c04894fa>] handle_irq_event_percpu+0x53/0x174
[  148.012153]  [<c048964c>] handle_irq_event+0x31/0x49
[  148.012167]  [<c048b160>] ? handle_simple_irq+0x59/0x59
[  148.012180]  [<c048b1cb>] handle_fasteoi_irq+0x6b/0x89
[  148.012189]  <IRQ>  [<c0404028>] ? do_IRQ+0x3c/0x87
[  148.012213]  [<c07d51b5>] ? common_interrupt+0x35/0x3c
[  148.012219]  [<c043007b>] ? enqueue_task_fair+0x319/0x4cd
[  148.012219]  [<c04f4a12>] ? dput+0xc5/0xca
[  148.012219]  [<c04ecacc>] ? path_put+0x13/0x1d
[  148.012219]  [<c047e0e2>] ? audit_free_names+0x45/0x5e
[  148.012219]  [<c047e985>] ? audit_syscall_exit+0x96/0x114
[  148.012219]  [<c07d4c71>] ? sysexit_audit+0x29/0x50

Best Regards,
tomoya
