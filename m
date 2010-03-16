Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666Ab0CPHoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 03:44:15 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:47999 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab0CPHoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 03:44:14 -0400
Date: Tue, 16 Mar 2010 16:41:21 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Andrea Righi <arighi@develer.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH -mmotm 2/5] memcg: dirty memory documentation
Message-Id: <20100316164121.024e35d8.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <1268609202-15581-3-git-send-email-arighi@develer.com>
References: <1268609202-15581-1-git-send-email-arighi@develer.com>
	<1268609202-15581-3-git-send-email-arighi@develer.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010 00:26:39 +0100, Andrea Righi <arighi@develer.com> wrote:
> Document cgroup dirty memory interfaces and statistics.
> 
> Signed-off-by: Andrea Righi <arighi@develer.com>
> ---
>  Documentation/cgroups/memory.txt |   36 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 36 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> index 49f86f3..38ca499 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -310,6 +310,11 @@ cache		- # of bytes of page cache memory.
>  rss		- # of bytes of anonymous and swap cache memory.
>  pgpgin		- # of pages paged in (equivalent to # of charging events).
>  pgpgout		- # of pages paged out (equivalent to # of uncharging events).
> +filedirty	- # of pages that are waiting to get written back to the disk.
> +writeback	- # of pages that are actively being written back to the disk.
> +writeback_tmp	- # of pages used by FUSE for temporary writeback buffers.
> +nfs		- # of NFS pages sent to the server, but not yet committed to
> +		  the actual storage.
>  active_anon	- # of bytes of anonymous and  swap cache memory on active
>  		  lru list.
>  inactive_anon	- # of bytes of anonymous memory and swap cache memory on
> @@ -345,6 +350,37 @@ Note:
>    - a cgroup which uses hierarchy and it has child cgroup.
>    - a cgroup which uses hierarchy and not the root of hierarchy.
>  
> +5.4 dirty memory
> +
> +  Control the maximum amount of dirty pages a cgroup can have at any given time.
> +
> +  Limiting dirty memory is like fixing the max amount of dirty (hard to
> +  reclaim) page cache used by any cgroup. So, in case of multiple cgroup writers,
> +  they will not be able to consume more than their designated share of dirty
> +  pages and will be forced to perform write-out if they cross that limit.
> +
> +  The interface is equivalent to the procfs interface: /proc/sys/vm/dirty_*.
> +  It is possible to configure a limit to trigger both a direct writeback or a
> +  background writeback performed by per-bdi flusher threads.
> +
> +  Per-cgroup dirty limits can be set using the following files in the cgroupfs:
> +
> +  - memory.dirty_ratio: contains, as a percentage of cgroup memory, the
> +    amount of dirty memory at which a process which is generating disk writes
> +    inside the cgroup will start itself writing out dirty data.
> +
> +  - memory.dirty_bytes: the amount of dirty memory of the cgroup (expressed in
> +    bytes) at which a process generating disk writes will start itself writing
> +    out dirty data.
> +
> +  - memory.dirty_background_ratio: contains, as a percentage of the cgroup
> +    memory, the amount of dirty memory at which background writeback kernel
> +    threads will start writing out dirty data.
> +
> +  - memory.dirty_background_bytes: the amount of dirty memory of the cgroup (in
> +    bytes) at which background writeback kernel threads will start writing out
> +    dirty data.
> +
>  
It would be better to note that what those files of root cgroup mean.
We cannot write any value to them, IOW, we cannot control dirty limit about root cgroup.
And they show the same value as the global one(strictly speaking, it's not true
because global values can change. We need a hook in mem_cgroup_dirty_read()?).

Thanks,
Daisuke Nishimura.

>  6. Hierarchy support
>  
> -- 
> 1.6.3.3
> 
