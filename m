Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762161Ab2KATLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 15:11:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285Ab2KATK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 15:10:57 -0400
Date: Thu, 1 Nov 2012 15:10:52 -0400
From: Dave Jones <davej@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: shmem_getpage_gfp VM_BUG_ON triggered. [3.7rc2]
Message-ID: <20121101191052.GA5884@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <20121025023738.GA27001@redhat.com>
 <alpine.LNX.2.00.1210242121410.1697@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1210242121410.1697@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 09:36:27PM -0700, Hugh Dickins wrote:
 > On Wed, 24 Oct 2012, Dave Jones wrote:
 > 
 > > Machine under significant load (4gb memory used, swap usage fluctuating)
 > > triggered this...
 > > 
 > > WARNING: at mm/shmem.c:1151 shmem_getpage_gfp+0xa5c/0xa70()
 > > Pid: 29795, comm: trinity-child4 Not tainted 3.7.0-rc2+ #49
 > > Call Trace:
 > >  [<ffffffff8107100f>] warn_slowpath_common+0x7f/0xc0
 > >  [<ffffffff8107106a>] warn_slowpath_null+0x1a/0x20
 > >  [<ffffffff811903fc>] shmem_getpage_gfp+0xa5c/0xa70
 > >  [<ffffffff8118fc3e>] ? shmem_getpage_gfp+0x29e/0xa70
 > >  [<ffffffff81190e4f>] shmem_fault+0x4f/0xa0
 > >  [<ffffffff8119f391>] __do_fault+0x71/0x5c0
 > >  [<ffffffff810e1ac6>] ? __lock_acquire+0x306/0x1ba0
 > >  [<ffffffff810b6ff9>] ? local_clock+0x89/0xa0
 > >  [<ffffffff811a2767>] handle_pte_fault+0x97/0xae0
 > >  [<ffffffff816d1069>] ? sub_preempt_count+0x79/0xd0
 > >  [<ffffffff8136d68e>] ? delay_tsc+0xae/0x120
 > >  [<ffffffff8136d578>] ? __const_udelay+0x28/0x30
 > >  [<ffffffff811a4a39>] handle_mm_fault+0x289/0x350
 > >  [<ffffffff816d091e>] __do_page_fault+0x18e/0x530
 > >  [<ffffffff810b6ff9>] ? local_clock+0x89/0xa0
 > >  [<ffffffff810b0e51>] ? get_parent_ip+0x11/0x50
 > >  [<ffffffff810b0e51>] ? get_parent_ip+0x11/0x50
 > >  [<ffffffff816d1069>] ? sub_preempt_count+0x79/0xd0
 > >  [<ffffffff8112d389>] ? rcu_user_exit+0xc9/0xf0
 > >  [<ffffffff816d0ceb>] do_page_fault+0x2b/0x50
 > >  [<ffffffff816cd3b8>] page_fault+0x28/0x30
 > >  [<ffffffff8136d259>] ? copy_user_enhanced_fast_string+0x9/0x20
 > >  [<ffffffff8121c181>] ? sys_futimesat+0x41/0xe0
 > >  [<ffffffff8102bf35>] ? syscall_trace_enter+0x25/0x2c0
 > >  [<ffffffff816d5625>] ? tracesys+0x7e/0xe6
 > >  [<ffffffff816d5688>] tracesys+0xe1/0xe6
 > > 
 > > 
 > > 
 > > 1148                         error = shmem_add_to_page_cache(page, mapping, index,
 > > 1149                                                 gfp, swp_to_radix_entry(swap));
 > > 1150                         /* We already confirmed swap, and make no allocation */
 > > 1151                         VM_BUG_ON(error);
 > > 1152                 }
 > 
 > That's very surprising.  Easy enough to handle an error there, but
 > of course I made it a VM_BUG_ON because it violates my assumptions:
 > I rather need to understand how this can be, and I've no idea.

I just noticed we had a user report hitting this same warning, but
with a different trace..

: [<ffffffff8105b84f>] warn_slowpath_common+0x7f/0xc0
: [<ffffffff8105b8aa>] warn_slowpath_null+0x1a/0x20
: [<ffffffff81143c73>] shmem_getpage_gfp+0x7f3/0x830
: [<ffffffff81158c9d>] ? vma_adjust+0x3ed/0x620
: [<ffffffff81143f02>] shmem_file_aio_read+0x1f2/0x380
: [<ffffffff8118e487>] do_sync_read+0xa7/0xe0
: [<ffffffff8118eda9>] vfs_read+0xa9/0x180
: [<ffffffff8118eeca>] sys_read+0x4a/0x90
: [<ffffffff816226e9>] system_call_fastpath+0x16/0x1b

	Dave
 
