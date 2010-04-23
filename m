Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab0DWQpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:45:25 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:63859 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab0DWQpX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:45:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Rqkk2ieqthvyiRFGiCjU6TMhuLvGRoMlpZ6Zcj4dXkMEGpBpyB/sy1FwXRydqghTYq
         Q4oZkS8Ppi1tjhaw/oU+Vx1vBAX62oGPl2PwsHUkVICiiQ8D5jdOxPwvGcqHCo3hwXYW
         lRb3ZuPzY9Qo3qG6vVzozOeg23JIeUgBLPAd4=
MIME-Version: 1.0
In-Reply-To: <s2xe6bf505b1004230933z9416196cobef1b2847fef1feb@mail.gmail.com>
References: <s2xe6bf505b1004230933z9416196cobef1b2847fef1feb@mail.gmail.com>
Date: Fri, 23 Apr 2010 11:45:22 -0500
Message-ID: <t2ye6bf505b1004230945w38980a4fn9a5a5045702e6672@mail.gmail.com>
Subject: Re: BUG at net/core/sock.c when using PREEMPT_VOLUNTARY/PREEMPT_DESKTOP
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 11:33 AM, Xianghua Xiao <xiaoxianghua@gmail.com> wrote:
> I'm running a 2.6.33.1 on a powerpc board, when choose either
> PREEMPT_NONE or PREEMPT_RT I can run iperf between two boards just
> fine.
>
> However when I enable PREEMPT_VOLUNTARY, I saw BUG immediately when I
> start to run iperf:
> -------------------------------------------
> BUG: sleeping function called from invalid context at net/core/sock.c:1537
> pcnt: 0 256 in_atomic(): 0, irqs_disabled(): 0, pid: 1364, name: iperf
> Call Trace:
> [cdc19d10] [c0009614] show_stack+0x70/0x1b8 (unreliable)
> [cdc19d50] [c001d370] __might_sleep+0x104/0x108
> [cdc19d60] [c0283018] release_sock+0x6c/0xd0
> [cdc19d80] [c02c27d0] tcp_sendmsg+0x258/0xc70
> [cdc19df0] [c027e86c] sock_aio_write+0x13c/0x14c
> --- Exception: cdc19df8 at (null)
>    LR = (null)
> [cdc19e50] [c008cd58] do_sync_write+0xb4/0x140 (unreliable)
> [cdc19ef0] [c008dcb4] vfs_write+0x198/0x1a0
> [cdc19f10] [c008ddf4] sys_write+0x58/0xc8
> [cdc19f40] [c00134c8] ret_from_syscall+0x0/0x38
> --- Exception: c01 at 0x1001b010
>    LR = 0x1001aff8
>
> If I enable PREEMPT_DESKTOP instead, I saw BUG before I even start iperf:
> -------------------------------------------
> BUG: sleeping function called from invalid context at net/core/sock.c:1537
> pcnt: 0 256 in_atomic(): 0, irqs_disabled(): 0, pid: 1089, name: xsupplicant
> Call Trace:
> [ce3abd90] [c00097c0] show_stack+0x70/0x1b8 (unreliable)
> [ce3abdd0] [c001ca5c] __might_sleep+0x104/0x108
> [ce3abde0] [c02ac900] release_sock+0xa0/0x120
> [ce3abe00] [c0311a20] inet_stream_connect+0x98/0x2f4
> [ce3abe50] [c02a9f38] sys_connect+0x84/0xe4
> [ce3abf00] [c02ab330] sys_socketcall+0x1f0/0x20c
> [ce3abf40] [c00139e8] ret_from_syscall+0x0/0x38
>
> Anyone can reproduce this?
>
> Thanks,
> Xianghua
>

When enable PREEMPT_DESKTOP I also saw BUG below:
-------------------------------------
BUG: sleeping function called from invalid context at mm/slab.c:3266
pcnt: 2 0 in_atomic(): 1, irqs_disabled(): 0, pid: 6, name: sirq-net-rx/0
Call Trace:
[cf067b40] [c00097c0] show_stack+0x70/0x1b8 (unreliable)
[cf067b80] [c001ca5c] __might_sleep+0x104/0x108
[cf067b90] [c00944e4] kmem_cache_alloc+0x14c/0x150
[cf067bc0] [c02b36c0] __alloc_skb+0x48/0x150
[cf067be0] [c0340ebc] inet6_rt_notify+0x80/0x188
[cf067c20] [c0345214] fib6_add+0x374/0x620
[cf067ca0] [c03420ac] __ip6_ins_rt+0x3c/0x68
[cf067cc0] [c0342b40] ip6_ins_rt+0x2c/0x3c
[cf067ce0] [c0343350] ip6_pol_route+0x284/0x358
[cf067d40] [c0343980] fib6_rule_lookup+0x24/0x34
[cf067d50] [c0341d9c] ip6_route_input+0x128/0x160
[cf067de0] [c03382f0] ipv6_rcv+0x454/0x45c
[cf067e10] [c02bc490] netif_receive_skb+0x298/0x3d8
[cf067e40] [c0261294] gfar_clean_rx_ring+0x190/0x49c
[cf067e90] [c0261a00] gfar_poll+0x460/0x578
[cf067f30] [c02bd0d8] net_rx_action+0x140/0x1e0
[cf067f70] [c002b9ac] run_ksoftirqd+0x188/0x2e8
[cf067fc0] [c0041110] kthread+0x80/0x84
[cf067ff0] [c001380c] kernel_thread+0x4c/0x68
