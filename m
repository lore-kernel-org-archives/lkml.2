Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964782Ab2AEQgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 11:36:19 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60619 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488Ab2AEQgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 11:36:18 -0500
Date: Thu, 5 Jan 2012 16:35:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH v5 7/8] mm: Only IPI CPUs to drain local pages if they
	exist
Message-ID: <20120105163529.GA11810@n2100.arm.linux.org.uk>
References: <1325499859-2262-1-git-send-email-gilad@benyossef.com> <1325499859-2262-8-git-send-email-gilad@benyossef.com> <4F033EC9.4050909@gmail.com> <20120105142017.GA27881@csn.ul.ie> <20120105144011.GU11810@n2100.arm.linux.org.uk> <20120105161739.GD27881@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105161739.GD27881@csn.ul.ie>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 04:17:39PM +0000, Mel Gorman wrote:
> Link please?

Forwarded, as its still in my mailbox.

> I'm including a patch below under development that is
> intended to only cope with the page allocator case under heavy memory
> pressure. Currently it does not pass testing because eventually RCU
> gets stalled with the following trace
> 
> [ 1817.176001]  [<ffffffff810214d7>] arch_trigger_all_cpu_backtrace+0x87/0xa0
> [ 1817.176001]  [<ffffffff810c4779>] __rcu_pending+0x149/0x260
> [ 1817.176001]  [<ffffffff810c48ef>] rcu_check_callbacks+0x5f/0x110
> [ 1817.176001]  [<ffffffff81068d7f>] update_process_times+0x3f/0x80
> [ 1817.176001]  [<ffffffff8108c4eb>] tick_sched_timer+0x5b/0xc0
> [ 1817.176001]  [<ffffffff8107f28e>] __run_hrtimer+0xbe/0x1a0
> [ 1817.176001]  [<ffffffff8107f581>] hrtimer_interrupt+0xc1/0x1e0
> [ 1817.176001]  [<ffffffff81020ef3>] smp_apic_timer_interrupt+0x63/0xa0
> [ 1817.176001]  [<ffffffff81449073>] apic_timer_interrupt+0x13/0x20
> [ 1817.176001]  [<ffffffff8116c135>] vfsmount_lock_local_lock+0x25/0x30
> [ 1817.176001]  [<ffffffff8115c855>] path_init+0x2d5/0x370
> [ 1817.176001]  [<ffffffff8115eecd>] path_lookupat+0x2d/0x620
> [ 1817.176001]  [<ffffffff8115f4ef>] do_path_lookup+0x2f/0xd0
> [ 1817.176001]  [<ffffffff811602af>] user_path_at_empty+0x9f/0xd0
> [ 1817.176001]  [<ffffffff81154e7b>] vfs_fstatat+0x4b/0x90
> [ 1817.176001]  [<ffffffff81154f4f>] sys_newlstat+0x1f/0x50
> [ 1817.176001]  [<ffffffff81448692>] system_call_fastpath+0x16/0x1b
> 
> It might be a separate bug, don't know for sure.

I'm not going to even pretend to understand what the above backtrace
means: it doesn't look like what I'd expect from the problem which
PeterZ's patch is supposed to address.  It certainly doesn't do anything
to address the cpu-going-offline problem you seem to have found.
