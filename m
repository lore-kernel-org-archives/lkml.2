Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab2BNHXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 02:23:13 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60931 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab2BNHXK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 02:23:10 -0500
MIME-Version: 1.0
In-Reply-To: <20120214121631.782352f2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120214120414.025625c2.kamezawa.hiroyu@jp.fujitsu.com> <20120214121631.782352f2.kamezawa.hiroyu@jp.fujitsu.com>
From: Greg Thelen <gthelen@google.com>
Date: Mon, 13 Feb 2012 23:22:50 -0800
Message-ID: <CAHH2K0baOnU6BE5c16cR0KiMvM3Hz+ngcBCs5e4+xJ_dcoeOww@mail.gmail.com>
Subject: Re: [PATCH 6/6 v4] memcg: fix performance of mem_cgroup_begin_update_page_stat()
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

On Mon, Feb 13, 2012 at 7:16 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> From 3377fd7b6e23a5d2a368c078eae27e2b49c4f4aa Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Mon, 6 Feb 2012 12:14:47 +0900
> Subject: [PATCH 6/6] memcg: fix performance of mem_cgroup_begin_update_page_stat()
>
> mem_cgroup_begin_update_page_stat() should be very fast because
> it's called very frequently. Now, it needs to look up page_cgroup
> and its memcg....this is slow.
>
> This patch adds a global variable to check "a memcg is moving or not".

s/a memcg/any memcg/

> By this, the caller doesn't need to visit page_cgroup and memcg.

s/By/With/

> Here is a test result. A test program makes page faults onto a file,
> MAP_SHARED and makes each page's page_mapcount(page) > 1, and free
> the range by madvise() and page fault again.  This program causes
> 26214400 times of page fault onto a file(size was 1G.) and shows
> shows the cost of mem_cgroup_begin_update_page_stat().

Out of curiosity, what is the performance of the mmap program before
this series?

> Before this patch for mem_cgroup_begin_update_page_stat()
> [kamezawa@bluextal test]$ time ./mmap 1G
>
> real    0m21.765s
> user    0m5.999s
> sys     0m15.434s
>
>    27.46%     mmap  mmap               [.] reader
>    21.15%     mmap  [kernel.kallsyms]  [k] page_fault
>     9.17%     mmap  [kernel.kallsyms]  [k] filemap_fault
>     2.96%     mmap  [kernel.kallsyms]  [k] __do_fault
>     2.83%     mmap  [kernel.kallsyms]  [k] __mem_cgroup_begin_update_page_stat
>
> After this patch
> [root@bluextal test]# time ./mmap 1G
>
> real    0m21.373s
> user    0m6.113s
> sys     0m15.016s
>
> In usual path, calls to __mem_cgroup_begin_update_page_stat() goes away.
>
> Note: we may be able to remove this optimization in future if
>      we can get pointer to memcg directly from struct page.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Greg Thelen <gthelen@google.com>
