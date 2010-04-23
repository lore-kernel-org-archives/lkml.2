Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab0DWQda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:33:30 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:34745 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758139Ab0DWQdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:33:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Mn6nv6WhUCZGXHdpG+W4x3nSXPUTU3XG9dHA4MUn0asreDlp1NvNGPwaKxSCDzo+F2
         NgbxgzCtrfg19/mUkfa65EmDD1MWsndi2K/4reKkTvfI5uLAIM312AW2ZJTkpB+7JreF
         S+6Q9QKXQ1GAJd3UWpIihYZNr7IQju3Zy45wE=
MIME-Version: 1.0
Date: Fri, 23 Apr 2010 11:33:23 -0500
Message-ID: <s2xe6bf505b1004230933z9416196cobef1b2847fef1feb@mail.gmail.com>
Subject: BUG at net/core/sock.c when using PREEMPT_VOLUNTARY/PREEMPT_DESKTOP
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm running a 2.6.33.1 on a powerpc board, when choose either
PREEMPT_NONE or PREEMPT_RT I can run iperf between two boards just
fine.

However when I enable PREEMPT_VOLUNTARY, I saw BUG immediately when I
start to run iperf:
-------------------------------------------
BUG: sleeping function called from invalid context at net/core/sock.c:1537
pcnt: 0 256 in_atomic(): 0, irqs_disabled(): 0, pid: 1364, name: iperf
Call Trace:
[cdc19d10] [c0009614] show_stack+0x70/0x1b8 (unreliable)
[cdc19d50] [c001d370] __might_sleep+0x104/0x108
[cdc19d60] [c0283018] release_sock+0x6c/0xd0
[cdc19d80] [c02c27d0] tcp_sendmsg+0x258/0xc70
[cdc19df0] [c027e86c] sock_aio_write+0x13c/0x14c
--- Exception: cdc19df8 at (null)
    LR = (null)
[cdc19e50] [c008cd58] do_sync_write+0xb4/0x140 (unreliable)
[cdc19ef0] [c008dcb4] vfs_write+0x198/0x1a0
[cdc19f10] [c008ddf4] sys_write+0x58/0xc8
[cdc19f40] [c00134c8] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0x1001b010
    LR = 0x1001aff8

If I enable PREEMPT_DESKTOP instead, I saw BUG before I even start iperf:
-------------------------------------------
BUG: sleeping function called from invalid context at net/core/sock.c:1537
pcnt: 0 256 in_atomic(): 0, irqs_disabled(): 0, pid: 1089, name: xsupplicant
Call Trace:
[ce3abd90] [c00097c0] show_stack+0x70/0x1b8 (unreliable)
[ce3abdd0] [c001ca5c] __might_sleep+0x104/0x108
[ce3abde0] [c02ac900] release_sock+0xa0/0x120
[ce3abe00] [c0311a20] inet_stream_connect+0x98/0x2f4
[ce3abe50] [c02a9f38] sys_connect+0x84/0xe4
[ce3abf00] [c02ab330] sys_socketcall+0x1f0/0x20c
[ce3abf40] [c00139e8] ret_from_syscall+0x0/0x38

Anyone can reproduce this?

Thanks,
Xianghua
