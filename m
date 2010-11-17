Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368Ab0KQARN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:17:13 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52807 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab0KQARL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:17:11 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 17 Nov 2010 09:11:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUGFIX] memcg: avoid deadlock between move charge and
 try_charge()
Message-Id: <20101117091135.1d811e89.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101116191748.d6645376.nishimura@mxp.nes.nec.co.jp>
References: <20101116191748.d6645376.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010 19:17:48 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> __mem_cgroup_try_charge() can be called under down_write(&mmap_sem)(e.g.
> mlock does it). This means it can cause deadlock if it races with move charge:
> 
> Ex.1)
>                 move charge             |        try charge
>   --------------------------------------+------------------------------
>     mem_cgroup_can_attach()             |  down_write(&mmap_sem)
>       mc.moving_task = current          |    ..
>       mem_cgroup_precharge_mc()         |  __mem_cgroup_try_charge()
>         mem_cgroup_count_precharge()    |    prepare_to_wait()
>           down_read(&mmap_sem)          |    if (mc.moving_task)
>           -> cannot aquire the lock     |    -> true
>                                         |      schedule()
> 
> Ex.2)
>                 move charge             |        try charge
>   --------------------------------------+------------------------------
>     mem_cgroup_can_attach()             |
>       mc.moving_task = current          |
>       mem_cgroup_precharge_mc()         |
>         mem_cgroup_count_precharge()    |
>           down_read(&mmap_sem)          |
>           ..                            |
>           up_read(&mmap_sem)            |
>                                         |  down_write(&mmap_sem)
>     mem_cgroup_move_task()              |    ..
>       mem_cgroup_move_charge()          |  __mem_cgroup_try_charge()
>         down_read(&mmap_sem)            |    prepare_to_wait()
>         -> cannot aquire the lock       |    if (mc.moving_task)
>                                         |    -> true
>                                         |      schedule()
> 
> To avoid this deadlock, we do all the move charge works (both can_attach() and
> attach()) under one mmap_sem section.
> And after this patch, we set/clear mc.moving_task outside mc.lock, because we
> use the lock only to check mc.from/to.
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Cc: <stable@kernel.org>

Thanks,
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

