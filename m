Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab2FOWiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:38:21 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:6095 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755344Ab2FOWiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:38:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak4JAKW32095LKmV/2dsb2JhbABFtCYEgSyBCIIYAQEFJxMcIxAIAxUDLhQlAyETiAoMuU4UiyJLhRBgA5UjiSWGWYJy
Date: Sat, 16 Jun 2012 08:38:14 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH V2] writeback: fix hung_task alarm when sync block
Message-ID: <20120615223814.GF19223@dastard>
References: <1339562553-10035-1-git-send-email-liwp.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339562553-10035-1-git-send-email-liwp.linux@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 12:42:33PM +0800, Wanpeng Li wrote:
> Hi Fengguang,
> 
> This time it works well after testing.
> 
> Regards,
> Wanpeng Li
> 
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> "V1 -> V2"
> * remove redundant hangcheck variable
> 
> I use several dd processes to write a slow SD card
> dd if=/dev/sda1 of=/dev/sdc4 bs=1M count=4000
> and several sync commands(maybe > 10),dmesg show this:
> 
> [  366.888741] INFO: task sync:3518 blocked for more than 120 seconds.
> [  366.888742] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  366.888746] sync            D 00000201     0  3518   3462 0x00000000
> [  366.888752]  dcde5e54 00000082 00000000 00000201 00000000 c180d220 c1933d00 c1933d00
> [  366.888758]  614a7ae7 00000023 f6bc0d00 ebecb280 c180d220 f6bc0d6c f04acbfc 00000000
> [  366.888786]  f6bc0d6c dcde5e2c 00000023 f6bc0d44 00000000 00000000 ebd8b2b4 dcde5e6c
> [  366.888788] Call Trace:
> [  366.888792]  [<c107a0ee>] ? enqueue_entity+0xee/0x5a0
> [  366.888795]  [<c15abc83>] schedule+0x23/0x60
> [  366.888798]  [<c15aa5ad>] schedule_timeout+0x22d/0x2a0
> [  366.888801]  [<c1071ce2>] ? check_preempt_curr+0x72/0x90
> [  366.888804]  [<c1071d28>] ? ttwu_do_wakeup+0x28/0x130
> [  366.888807]  [<c1037f28>] ? default_spin_lock_flags+0x8/0x10
> [  366.888810]  [<c15acaad>] ? _raw_spin_lock_irqsave+0x2d/0x40
> [  366.888813]  [<c15abb17>] wait_for_common+0xa7/0x110
> [  366.888816]  [<c1074690>] ? try_to_wake_up+0x220/0x220
> [  366.888819]  [<c15abc57>] wait_for_completion+0x17/0x20
> [  366.888822]  [<c116ad80>] writeback_inodes_sb_nr+0x70/0x90
> [  366.888825]  [<c116af75>] writeback_inodes_sb+0x25/0x30
> [  366.888828]  [<c117159f>] __sync_filesystem+0x4f/0x90
> [  366.888831]  [<c11715f7>] sync_one_sb+0x17/0x20
> [  366.888834]  [<c114c430>] iterate_supers+0xc0/0xd0
> [  366.888837]  [<c11715e0>] ? __sync_filesystem+0x90/0x90
> [  366.888831]  [<c11715f7>] sync_one_sb+0x17/0x20
> [  366.888834]  [<c114c430>] iterate_supers+0xc0/0xd0
> [  366.888837]  [<c11715e0>] ? __sync_filesystem+0x90/0x90
> [  366.888840]  [<c117167b>] sys_sync+0x2b/0x60
> [  366.888842]  [<c15b385f>] sysenter_do_call+0x12/0x28
> 
> Too many similar messages flood the logs. So I use a present method to
> fix this issue.

NACK.

You're not fixing anything - you are simply removing a warning
that indicates that there IO subsystem is overloaded. This is a very
good warning to have - when the system slows down immensely, and
these start appearing, we know that there is a problem related to IO
writeback. For example, this -current- thread on the XFS list:

http://oss.sgi.com/archives/xfs/2012-06/msg00144.html

Which a) we probably would have never heard of if the hung task warning
didn't fire on blocked IOs, and b) would have struggled to
understand without the stack traces the hung task timer has provided
us with.


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
