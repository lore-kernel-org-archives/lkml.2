Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab0JSIdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:33:10 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:53834 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab0JSIdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:33:08 -0400
Date: Tue, 19 Oct 2010 17:27:44 +0900
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
Subject: Re: [PATCH v3 02/11] memcg: document cgroup dirty memory interfaces
Message-Id: <20101019172744.45e0a8dc.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <1287448784-25684-3-git-send-email-gthelen@google.com>
References: <1287448784-25684-1-git-send-email-gthelen@google.com>
	<1287448784-25684-3-git-send-email-gthelen@google.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 17:39:35 -0700
Greg Thelen <gthelen@google.com> wrote:

> Document cgroup dirty memory interfaces and statistics.
> 
> Signed-off-by: Andrea Righi <arighi@develer.com>
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
> 
> Changelog since v1:
> - Renamed "nfs"/"total_nfs" to "nfs_unstable"/"total_nfs_unstable" in per cgroup
>   memory.stat to match /proc/meminfo.
> 
> - Allow [kKmMgG] suffixes for newly created dirty limit value cgroupfs files.
> 
> - Describe a situation where a cgroup can exceed its dirty limit.
> 
>  Documentation/cgroups/memory.txt |   60 ++++++++++++++++++++++++++++++++++++++
>  1 files changed, 60 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> index 7781857..02bbd6f 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -385,6 +385,10 @@ mapped_file	- # of bytes of mapped file (includes tmpfs/shmem)
>  pgpgin		- # of pages paged in (equivalent to # of charging events).
>  pgpgout		- # of pages paged out (equivalent to # of uncharging events).
>  swap		- # of bytes of swap usage
> +dirty		- # of bytes that are waiting to get written back to the disk.
> +writeback	- # of bytes that are actively being written back to the disk.
> +nfs_unstable	- # of bytes sent to the NFS server, but not yet committed to
> +		the actual storage.
>  inactive_anon	- # of bytes of anonymous memory and swap cache memory on
>  		LRU list.
>  active_anon	- # of bytes of anonymous and swap cache memory on active

Shouldn't we add description of "total_diryt/writeback/nfs_unstable" too ?
Seeing [5/11], it will be showed in memory.stat.

> @@ -453,6 +457,62 @@ memory under it will be reclaimed.
>  You can reset failcnt by writing 0 to failcnt file.
>  # echo 0 > .../memory.failcnt
>  
> +5.5 dirty memory
> +
> +Control the maximum amount of dirty pages a cgroup can have at any given time.
> +
> +Limiting dirty memory is like fixing the max amount of dirty (hard to reclaim)
> +page cache used by a cgroup.  So, in case of multiple cgroup writers, they will
> +not be able to consume more than their designated share of dirty pages and will
> +be forced to perform write-out if they cross that limit.
> +
> +The interface is equivalent to the procfs interface: /proc/sys/vm/dirty_*.  It
> +is possible to configure a limit to trigger both a direct writeback or a
> +background writeback performed by per-bdi flusher threads.  The root cgroup
> +memory.dirty_* control files are read-only and match the contents of
> +the /proc/sys/vm/dirty_* files.
> +
> +Per-cgroup dirty limits can be set using the following files in the cgroupfs:
> +
> +- memory.dirty_ratio: the amount of dirty memory (expressed as a percentage of
> +  cgroup memory) at which a process generating dirty pages will itself start
> +  writing out dirty data.
> +
> +- memory.dirty_limit_in_bytes: the amount of dirty memory (expressed in bytes)
> +  in the cgroup at which a process generating dirty pages will start itself
> +  writing out dirty data.  Suffix (k, K, m, M, g, or G) can be used to indicate
> +  that value is kilo, mega or gigabytes.
> +
> +  Note: memory.dirty_limit_in_bytes is the counterpart of memory.dirty_ratio.
> +  Only one of them may be specified at a time.  When one is written it is
> +  immediately taken into account to evaluate the dirty memory limits and the
> +  other appears as 0 when read.
> +
> +- memory.dirty_background_ratio: the amount of dirty memory of the cgroup
> +  (expressed as a percentage of cgroup memory) at which background writeback
> +  kernel threads will start writing out dirty data.
> +
> +- memory.dirty_background_limit_in_bytes: the amount of dirty memory (expressed
> +  in bytes) in the cgroup at which background writeback kernel threads will
> +  start writing out dirty data.  Suffix (k, K, m, M, g, or G) can be used to
> +  indicate that value is kilo, mega or gigabytes.
> +
> +  Note: memory.dirty_background_limit_in_bytes is the counterpart of
> +  memory.dirty_background_ratio.  Only one of them may be specified at a time.
> +  When one is written it is immediately taken into account to evaluate the dirty
> +  memory limits and the other appears as 0 when read.
> +
> +A cgroup may contain more dirty memory than its dirty limit.  This is possible
> +because of the principle that the first cgroup to touch a page is charged for
> +it.  Subsequent page counting events (dirty, writeback, nfs_unstable) are also
> +counted to the originally charged cgroup.
> +
> +Example: If page is allocated by a cgroup A task, then the page is charged to
> +cgroup A.  If the page is later dirtied by a task in cgroup B, then the cgroup A
> +dirty count will be incremented.  If cgroup A is over its dirty limit but cgroup
> +B is not, then dirtying a cgroup A page from a cgroup B task may push cgroup A
> +over its dirty limit without throttling the dirtying cgroup B task.
> +
>  6. Hierarchy support
>  
>  The memory controller supports a deep hierarchy and hierarchical accounting.
> -- 
> 1.7.1
> 
Can you clarify whether we can limit the "total" dirty pages under hierarchy
in use_hierarchy==1 case ?
If we can, I think it would be better to note it in this documentation.


Thanks,
Daisuke Nishimura. 
