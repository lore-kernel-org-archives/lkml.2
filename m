Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab1FIBkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 21:40:42 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:49454 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab1FIBkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 21:40:41 -0400
Date: Thu, 9 Jun 2011 10:30:23 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Ying Han <yinghan@google.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [BUGFIX][PATCH v3] memcg: fix behavior of per cpu charge cache
 draining.
Message-Id: <20110609103023.4c4deaf2.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20110609093045.1f969d30.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110609093045.1f969d30.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jun 2011 09:30:45 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> From 0ebd8a90a91d50c512e7c63e5529a22e44e84c42 Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Wed, 8 Jun 2011 13:51:11 +0900
> Subject: [PATCH] Fix behavior of per-cpu charge cache draining in memcg.
> 
> For performance, memory cgroup caches some "charge" from res_counter
> into per cpu cache. This works well but because it's cache,
> it needs to be flushed in some cases. Typical cases are
> 	1. when someone hit limit.
> 	2. when rmdir() is called and need to charges to be 0.
> 
> But "1" has problem.
> 
> Recently, with large SMP machines, we many kworker runs because
> of flushing memcg's cache. Bad things in implementation are
> 
> a) it's called before calling try_to_free_mem_cgroup_pages()
>    so, it's called immidiately when a task hit limit.
>    (I though it was better to avoid to run into memory reclaim.
>     But it was wrong decision.)
> 
> b) Even if a cpu contains a cache for memcg not related to
>    a memcg which hits limit, drain code is called.
> 
> This patch fixes a) and b) by
> 
> A) delay calling of flushing until one run of try_to_free...
>    Then, the number of calling is decreased.
> B) check percpu cache contains a useful data or not.
> plus
> C) check asynchronous percpu draining doesn't run.
> 
> BTW, why this patch relpaces atomic_t counter with mutex is
> to guarantee a memcg which is pointed by stock->cacne is
> not destroyed while we check css_id.
> 
> Reported-by: Ying Han <yinghan@google.com>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

