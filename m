Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab0KRAuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 19:50:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752114Ab0KRAuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 19:50:18 -0500
Date: Wed, 17 Nov 2010 16:49:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg Thelen <gthelen@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH v4 05/11] writeback: create dirty_info structure
Message-Id: <20101117164924.25e6cc11.akpm@linux-foundation.org>
In-Reply-To: <1288336154-23256-6-git-send-email-gthelen@google.com>
References: <1288336154-23256-1-git-send-email-gthelen@google.com>
	<1288336154-23256-6-git-send-email-gthelen@google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Oct 2010 00:09:08 -0700
Greg Thelen <gthelen@google.com> wrote:

> Bundle dirty limits and dirty memory usage metrics into a dirty_info
> structure to simplify interfaces of routines that need all.

Problems...

These patches interact pretty badly with Fengguang's "IO-less dirty
throttling v2" patches.  I fixed up
writeback-create-dirty_info-structure.patch pretty mechanically but
when it got to memcg-check-memcg-dirty-limits-in-page-writeback.patch
things got sticky and I gave up.

As your stuff was merged first, I'd normally send the bad news to
Fengguang, but the memcg code is logically built upon the core
writeback code so I do think these patches should be staged after the
changes to core writeback.

Also, while I was there it seemed that the chosen members of the
dirty_info structure were a bit random.  Perhaps we should be putting
nr_dirty in there as well, perhaps other things.  Please have a think
about that.

Also, in ratelimit_pages() we call global_dirty_info() to return four
items, but that caller only actually uses two of them.  Wasted effort?


So I'm afraid I'm going to have to request that you redo and retest
these patches:

writeback-create-dirty_info-structure.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-dirty-limits-to-mem_cgroup-use-native-word-to-represent-dirtyable-pages.patch
memcg-add-dirty-limits-to-mem_cgroup-catch-negative-per-cpu-sums-in-dirty-info.patch
memcg-add-dirty-limits-to-mem_cgroup-avoid-overflow-in-memcg_hierarchical_free_pages.patch
memcg-add-dirty-limits-to-mem_cgroup-correct-memcg_hierarchical_free_pages-return-type.patch
memcg-add-dirty-limits-to-mem_cgroup-avoid-free-overflow-in-memcg_hierarchical_free_pages.patch
memcg-cpu-hotplug-lockdep-warning-fix.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-use-native-word-page-statistics-counters.patch
memcg-use-native-word-page-statistics-counters-fix.patch
#
memcg-add-mem_cgroup-parameter-to-mem_cgroup_page_stat.patch
memcg-pass-mem_cgroup-to-mem_cgroup_dirty_info.patch
#memcg-make-throttle_vm_writeout-memcg-aware.patch: "troublesome": Kamezawa
memcg-make-throttle_vm_writeout-memcg-aware.patch
memcg-make-throttle_vm_writeout-memcg-aware-fix.patch
memcg-simplify-mem_cgroup_page_stat.patch
memcg-simplify-mem_cgroup_dirty_info.patch
memcg-make-mem_cgroup_page_stat-return-value-unsigned.patch

against the http://userweb.kernel.org/~akpm/mmotm/ which I just
uploaded, sorry.  I've uploaded my copy of all the above to
http://userweb.kernel.org/~akpm/stuff/gthelen.tar.gz.  I think only the
two patches need fixing and retesting.

Also, while wrangling the above patches, I stumbled across rejects such
as:


***************
*** 99,106 ****
                   "state:            %8lx\n",
                   (unsigned long) K(bdi_stat(bdi, BDI_WRITEBACK)),
                   (unsigned long) K(bdi_stat(bdi, BDI_RECLAIMABLE)),
-                  K(bdi_thresh), K(dirty_thresh),
-                  K(background_thresh), nr_dirty, nr_io, nr_more_io,
                   !list_empty(&bdi->bdi_list), bdi->state);
  #undef K
  
--- 98,106 ----
                   "state:            %8lx\n",
                   (unsigned long) K(bdi_stat(bdi, BDI_WRITEBACK)),
                   (unsigned long) K(bdi_stat(bdi, BDI_RECLAIMABLE)),
+                  K(bdi_thresh), K(dirty_info.dirty_thresh),
+                  K(dirty_info.background_thresh),
+                  nr_dirty, nr_io, nr_more_io,
                   !list_empty(&bdi->bdi_list), bdi->state);

Please, if you discover crud like this, just fix it up.  One item per
line:

                   "state:            %8lx\n",
                   (unsigned long) K(bdi_stat(bdi, BDI_WRITEBACK)),
                   (unsigned long) K(bdi_stat(bdi, BDI_RECLAIMABLE)),
		   K(bdi_thresh),
		   K(dirty_info.dirty_thresh),
		   K(dirty_info.background_thresh),
		   nr_dirty,
		   nr_io,
		   nr_more_io,
                   !list_empty(&bdi->bdi_list), bdi->state);

all very simple.  And while you're there, fix up the
tab-tab-space-space-space indenting - just use tabs.


The other area where code maintenance is harder than it needs to be is
in definitions of locals:

        long nr_reclaimable;
        long nr_dirty, bdi_dirty;  /* = file_dirty + writeback + unstable_nfs */
        long bdi_prev_dirty = 0;

again, that's just dopey.  Change it to

        long nr_reclaimable;
        long nr_dirty;
	long bdi_dirty;		/* = file_dirty + writeback + unstable_nfs */
        long bdi_prev_dirty = 0;

All very simple.

Thanks.
