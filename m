Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab2BNHV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 02:21:57 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39050 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644Ab2BNHVy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 02:21:54 -0500
MIME-Version: 1.0
In-Reply-To: <20120214120756.0a42f065.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120214120414.025625c2.kamezawa.hiroyu@jp.fujitsu.com> <20120214120756.0a42f065.kamezawa.hiroyu@jp.fujitsu.com>
From: Greg Thelen <gthelen@google.com>
Date: Mon, 13 Feb 2012 23:21:34 -0800
Message-ID: <CAHH2K0Ynh6o5fMXnkbaYOSwYYvJhc7F3f48TsJ34hki6WDJF6Q@mail.gmail.com>
Subject: Re: [PATCH 2/6 v4] memcg: simplify move_account() check
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 7:07 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> From 9cdb3b63dc8d08cc2220c54c80438c13433a0d12 Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Thu, 2 Feb 2012 10:02:39 +0900
> Subject: [PATCH 2/6] memcg: simplify move_account() check.
>
> In memcg, for avoiding take-lock-irq-off at accessing page_cgroup,
> a logic, flag + rcu_read_lock(), is used. This works as following
>
>     CPU-A                     CPU-B
>                             rcu_read_lock()
>    set flag
>                             if(flag is set)
>                                   take heavy lock
>                             do job.
>    synchronize_rcu()        rcu_read_unlock()

I assume that CPU-A will take heavy lock after synchronize_rcu() when
updating variables read by CPU-B.

>  memcontrol.c |   65 ++++++++++++++++++++++-------------------------------------
>  1 file changed, 25 insertions(+), 40 deletions(-)
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Greg Thelen <gthelen@google.com>

> ---
>  mm/memcontrol.c |   70 +++++++++++++++++++++++-------------------------------
>  1 files changed, 30 insertions(+), 40 deletions(-)

> @@ -2089,11 +2082,8 @@ static int __cpuinit memcg_cpu_hotplug_callback(struct notifier_block *nb,
>        struct memcg_stock_pcp *stock;
>        struct mem_cgroup *iter;
>
> -       if ((action == CPU_ONLINE)) {
> -               for_each_mem_cgroup(iter)
> -                       synchronize_mem_cgroup_on_move(iter, cpu);
> +       if ((action == CPU_ONLINE))

Extra parenthesis.  I recommend:
+       if (action == CPU_ONLINE)
