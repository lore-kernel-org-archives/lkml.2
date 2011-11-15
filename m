Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1KONww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 08:52:52 -0500
Received: from haggis.mythic-beasts.com ([93.93.131.52]:52563 "EHLO
	haggis.mythic-beasts.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668Ab1KONwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 08:52:50 -0500
Date: Tue, 15 Nov 2011 13:52:38 +0000
From: Luis Henriques <henrix@camandro.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.2-rc1-rt2
Message-ID: <20111115135238.GA2434@hades>
References: <alpine.LFD.2.02.1111150050590.4902@ionos>
 <20111115084059.GA23250@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115084059.GA23250@zhy>
X-BlackCat-Spam-Score: -10
X-Mythic-Debug: Threshold =  On = 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 04:40:59PM +0800, Yong Zhang wrote:
> Got below warning:
> 
> [    8.459702] BUG: sleeping function called from invalid context at linux/kernel/rtmutex.c:645
> [    8.459705] in_atomic(): 1, irqs_disabled(): 0, pid: 1, name: swapper/0
> [    8.459707] 1 lock held by swapper/0/1:
> [    8.459708]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff81154c45>] prepare_bprm_creds+0x35/0x80
> [    8.459717] Pid: 1, comm: swapper/0 Not tainted 3.2.0-rc1-rt2-11311-g3c4c0e7-dirty #10
> [    8.459718] Call Trace:

I'm hitting the same issue.  Here's the trace:

[    0.915638] BUG: sleeping function called from invalid context at /home/luis.henriques/git-trees/linux-2.6/kernel/rtmutex.c:645
[    0.915641] in_atomic(): 1, irqs_disabled(): 0, pid: 33, name: busybox
[    0.915642] 1 lock held by busybox/33:
[    0.915643]  #0:  (&mm->page_table_lock){+.+...}, at: [<ffffffff81119ec3>] unmap_vmas+0x333/0x6d0
[    0.915664] Pid: 33, comm: busybox Not tainted 3.2.0-rc1-rt2+ #1
[    0.915665] Call Trace:
[    0.915674]  [<ffffffff810497ba>] __might_sleep+0x12a/0x1e0
[    0.915687]  [<ffffffff81300f74>] rt_spin_lock+0x24/0x60
[    0.915692]  [<ffffffff8113efcd>] memcg_check_events.clone.33+0x14d/0x250
[    0.915696]  [<ffffffff8113f1bf>] __mem_cgroup_uncharge_common+0xef/0x270
[    0.915698]  [<ffffffff8114311f>] mem_cgroup_uncharge_page+0x2f/0x40
[    0.915701]  [<ffffffff81125410>] page_remove_rmap+0x70/0x90
[    0.915703]  [<ffffffff81119fbf>] unmap_vmas+0x42f/0x6d0
[    0.915705]  [<ffffffff811229d9>] exit_mmap+0xa9/0x120
[    0.915710]  [<ffffffff8104b9e0>] mmput+0x50/0x100
[    0.915713]  [<ffffffff81052c5b>] exit_mm+0x11b/0x140
[    0.915718]  [<ffffffff8109cb6d>] ? acct_collect+0x17d/0x1c0
[    0.915720]  [<ffffffff81053518>] do_exit+0x678/0x930
[    0.915722]  [<ffffffff8130224e>] ? retint_swapgs+0xe/0x13
[    0.915724]  [<ffffffff81053881>] do_group_exit+0x61/0xe0
[    0.915726]  [<ffffffff81053917>] sys_exit_group+0x17/0x20
[    0.915728]  [<ffffffff81302aeb>] system_call_fastpath+0x16/0x1b

Cheers,
--
Luis Henriques
