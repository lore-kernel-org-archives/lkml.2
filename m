Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab2FLW3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 18:29:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37465 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab2FLW3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 18:29:33 -0400
Date: Tue, 12 Jun 2012 15:29:12 -0700
From: Mandeep Singh Baines <msb@google.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: fweisbec@gmail.com, msb@chromium.org, sshaiju@mvista.com, mingo@elte.hu,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: hung_task checking and sys_sync
Message-ID: <20120612222912.GB16381@google.com>
References: <20120612220924.GA13376@fifo99.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120612220924.GA13376@fifo99.com>
X-Operating-System: Linux/2.6.38.8-gg683 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker (dwalker@fifo99.com) wrote:
> 

Hi Daniel,

> I found this commit which was a while ago,
> 
> commit fb822db465bd9fd4208eef1af4490539b236c54e
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed Aug 20 11:17:40 2008 +0200
> 
>     softlockup: increase hung tasks check from 2 minutes to 8 minutes
>     
>     Andrew says:
>     
>     > Seems that about 100% of the reports we get of this warning triggering
>     > are sys_sync, transaction commit, etc.
>     
>     increase the timeout. If it still triggers for people, we can kill it.
>     
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> We're seeing these messages on an older kernel (montavista) but the code areas
> appear similar to current kernels. The issue is that we're doing a file copy
> which takes 10-15minutes, and in the background there is a "df --sync"
> happening (which is calling sys_sync). We end up getting a hung task message
> like below,
> 
> INFO: task df:1778 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> ffffffff81578d40 0000000000000086 ffff8801f6135b00 ffff880269a91800
> ffff880269a91800 ffff8802702be000 ffff8801f602a080 0000000000000000
> ffff8801f602a440 ffffffff8109c166 ffff8801e863de18 0000000000000004
> Call Trace:
>   [<ffffffff8109c166>] ? sync_page+0x0/0x49
>   [<ffffffff81320de2>] ? __schedule+0x3c/0x57
>   [<ffffffff810ea3c7>] ? bdi_sched_wait+0x0/0xe
>   [<ffffffff81320de2>] ? __schedule+0x3c/0x57
>   [<ffffffff81320e0d>] ? schedule+0x10/0x1e
>   [<ffffffff810ea3d0>] ? bdi_sched_wait+0x9/0xe
> 
> There some variation in the stack trace , but always thru bdi_sched_wait().
> 
> 
> These don't seem like valid warnings, since the copy happening is know to take
> a long time.

But the time is not unbounded. You could mask the hung_task_detector for
this case but then you lose the ability to catch bugs in this code path.

The timeout is configurable via /proc/sys/kernel/hung_task_timeout_secs.
Can you bump up the value at boot via sysctl.conf?

> Has there been any commit that disable these messages bdi_sched_wait?
> 

No. There is no mechanism to disable hung_task for a specific code path.
We do skip processes if PF_PROZEN or PF_FROZEN_SKIP is set but that is
really a different situation where the wait is unbounded.

Regards,
Mandeep

> Daniel
