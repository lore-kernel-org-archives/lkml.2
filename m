Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab0JSFKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 01:10:01 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:65023 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab0JSFKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 01:10:00 -0400
Date: Tue, 19 Oct 2010 14:03:38 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH v3 04/11] memcg: add lock to synchronize page accounting
 and migration
Message-Id: <20101019140338.9fd664bc.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <1287448784-25684-5-git-send-email-gthelen@google.com>
References: <1287448784-25684-1-git-send-email-gthelen@google.com>
	<1287448784-25684-5-git-send-email-gthelen@google.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 17:39:37 -0700
Greg Thelen <gthelen@google.com> wrote:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Introduce a new bit spin lock, PCG_MOVE_LOCK, to synchronize
> the page accounting and migration code.  This reworks the
> locking scheme of _update_stat() and _move_account() by
> adding new lock bit PCG_MOVE_LOCK, which is always taken
> under IRQ disable.
> 
> 1. If pages are being migrated from a memcg, then updates to
>    that memcg page statistics are protected by grabbing
>    PCG_MOVE_LOCK using move_lock_page_cgroup().  In an
>    upcoming commit, memcg dirty page accounting will be
>    updating memcg page accounting (specifically: num
>    writeback pages) from IRQ context (softirq).  Avoid a
>    deadlocking nested spin lock attempt by disabling irq on
>    the local processor when grabbing the PCG_MOVE_LOCK.
> 
> 2. lock for update_page_stat is used only for avoiding race
>    with move_account().  So, IRQ awareness of
>    lock_page_cgroup() itself is not a problem.  The problem
>    is between mem_cgroup_update_page_stat() and
>    mem_cgroup_move_account_page().
> 
> Trade-off:
>   * Changing lock_page_cgroup() to always disable IRQ (or
>     local_bh) has some impacts on performance and I think
>     it's bad to disable IRQ when it's not necessary.
>   * adding a new lock makes move_account() slower.  Score is
>     here.
> 
> Performance Impact: moving a 8G anon process.
> 
> Before:
> 	real    0m0.792s
> 	user    0m0.000s
> 	sys     0m0.780s
> 
> After:
> 	real    0m0.854s
> 	user    0m0.000s
> 	sys     0m0.842s
> 
> This score is bad but planned patches for optimization can reduce
> this impact.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Greg Thelen <gthelen@google.com>

This approach is more straightforward and easy to understand.

Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
