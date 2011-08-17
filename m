Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab1HQTk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 15:40:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752877Ab1HQTky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 15:40:54 -0400
Date: Wed, 17 Aug 2011 12:39:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        yrl.pp-manager.tt@hitachi.com, Namhyung Kim <namhyung@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH] avoid null pointer access in vm_struct
Message-Id: <20110817123959.800164ff.akpm@linux-foundation.org>
In-Reply-To: <20110817132848.2352.80544.stgit@ltc219.sdl.hitachi.co.jp>
References: <20110817132848.2352.80544.stgit@ltc219.sdl.hitachi.co.jp>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Aug 2011 22:28:48 +0900
Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com> wrote:

> The /proc/vmallocinfo shows information about vmalloc allocations in vmlist
> that is a linklist of vm_struct. It, however, may access pages field of
> vm_struct where a page was not allocated, which results in a null pointer
> access and leads to a kernel panic.
> 
> Why this happen:
> For example, in __vmalloc_area_node, the nr_pages field of vm_struct are
> set to the expected number of pages to be allocated, before the actual
> pages allocations. At the same time, when the /proc/vmallocinfo is read, it
> accesses the pages field of vm_struct according to the nr_pages field at
> show_numa_info(). Thus, a null pointer access happens.
> 
> Patch:
> This patch avoids accessing the pages field with unallocated page when
> show_numa_info() is called. So, it can solve this problem.

Do we have a similar race when running __vunmap() in parallel with
show_numa_info()?

> index 7ef0903..e2ec5b0 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2472,13 +2472,16 @@ static void show_numa_info(struct seq_file *m, struct vm_struct *v)
>  	if (NUMA_BUILD) {
>  		unsigned int nr, *counters = m->private;
>  
> -		if (!counters)
> +		if (!counters || !v->nr_pages || !v->pages)
>  			return;
>  
>  		memset(counters, 0, nr_node_ids * sizeof(unsigned int));
>  
> -		for (nr = 0; nr < v->nr_pages; nr++)
> +		for (nr = 0; nr < v->nr_pages; nr++) {
> +			if (!v->pages[nr])
> +				break;
>  			counters[page_to_nid(v->pages[nr])]++;
> +		}
>  
>  		for_each_node_state(nr, N_HIGH_MEMORY)
>  			if (counters[nr])

I think this has memory ordering issues: it requires that this CPU see
the modification to ->nr_pages and ->pages in the same order as the CPU
which is writing ->nr_pages, ->pages and ->pages[x].  Perhaps fixable
by taking vmlist_lock appropriately.

I suspect that the real bug is that __vmalloc_area_node() and its
caller made the new vmap_area globally visible before it was fully
initialised.  If we were to fix that, the /proc/vmallocinfo read would
not encounter this vm_struct at all.
