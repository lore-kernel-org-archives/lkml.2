Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528Ab1EMJcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 05:32:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46894 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903Ab1EMJc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 05:32:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 13 May 2011 18:25:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC][PATCH v7 00/14] memcg: per cgroup dirty page accounting
Message-Id: <20110513182534.bebd904e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1305276473-14780-1-git-send-email-gthelen@google.com>
References: <1305276473-14780-1-git-send-email-gthelen@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011 01:47:39 -0700
Greg Thelen <gthelen@google.com> wrote:

> This patch series provides the ability for each cgroup to have independent dirty
> page usage limits.  Limiting dirty memory fixes the max amount of dirty (hard to
> reclaim) page cache used by a cgroup.  This allows for better per cgroup memory
> isolation and fewer ooms within a single cgroup.
> 
> Having per cgroup dirty memory limits is not very interesting unless writeback
> is cgroup aware.  There is not much isolation if cgroups have to writeback data
> from other cgroups to get below their dirty memory threshold.
> 
> Per-memcg dirty limits are provided to support isolation and thus cross cgroup
> inode sharing is not a priority.  This allows the code be simpler.
> 
> To add cgroup awareness to writeback, this series adds a memcg field to the
> inode to allow writeback to isolate inodes for a particular cgroup.  When an
> inode is marked dirty, i_memcg is set to the current cgroup.  When inode pages
> are marked dirty the i_memcg field compared against the page's cgroup.  If they
> differ, then the inode is marked as shared by setting i_memcg to a special
> shared value (zero).
> 
> Previous discussions suggested that a per-bdi per-memcg b_dirty list was a good
> way to assoicate inodes with a cgroup without having to add a field to struct
> inode.  I prototyped this approach but found that it involved more complex
> writeback changes and had at least one major shortcoming: detection of when an
> inode becomes shared by multiple cgroups.  While such sharing is not expected to
> be common, the system should gracefully handle it.
> 
> balance_dirty_pages() calls mem_cgroup_balance_dirty_pages(), which checks the
> dirty usage vs dirty thresholds for the current cgroup and its parents.  If any
> over-limit cgroups are found, they are marked in a global over-limit bitmap
> (indexed by cgroup id) and the bdi flusher is awoke.
> 
> The bdi flusher uses wb_check_background_flush() to check for any memcg over
> their dirty limit.  When performing per-memcg background writeback,
> move_expired_inodes() walks per bdi b_dirty list using each inode's i_memcg and
> the global over-limit memcg bitmap to determine if the inode should be written.
> 
> If mem_cgroup_balance_dirty_pages() is unable to get below the dirty page
> threshold writing per-memcg inodes, then downshifts to also writing shared
> inodes (i_memcg=0).
> 
> I know that there is some significant writeback changes associated with the
> IO-less balance_dirty_pages() effort.  I am not trying to derail that, so this
> patch series is merely an RFC to get feedback on the design.  There are probably
> some subtle races in these patches.  I have done moderate functional testing of
> the newly proposed features.
> 
> Here is an example of the memcg-oom that is avoided with this patch series:
> 	# mkdir /dev/cgroup/memory/x
> 	# echo 100M > /dev/cgroup/memory/x/memory.limit_in_bytes
> 	# echo $$ > /dev/cgroup/memory/x/tasks
> 	# dd if=/dev/zero of=/data/f1 bs=1k count=1M &
>         # dd if=/dev/zero of=/data/f2 bs=1k count=1M &
>         # wait
> 	[1]-  Killed                  dd if=/dev/zero of=/data/f1 bs=1M count=1k
> 	[2]+  Killed                  dd if=/dev/zero of=/data/f1 bs=1M count=1k
> 
> Known limitations:
> 	If a dirty limit is lowered a cgroup may be over its limit.
> 


Thank you, I think this should be merged earlier than all other works. Without this,
I think all memory reclaim changes of memcg will do something wrong.

I'll do a brief review today but I'll be busy until Wednesday, sorry.

In general, I agree with inode->i_mapping->i_memcg, simple 2bytes field and
ignoring a special case of shared inode between memcg.

BTW, IIUC, i_memcg is resetted always when mark_inode_dirty() sets new I_DIRTY to
the flags, right ?

Thanks,
-Kame


