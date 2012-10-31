Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974Ab2JaAsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 20:48:55 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33035 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab2JaAsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 20:48:53 -0400
Date: Tue, 30 Oct 2012 20:48:38 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zhouping Liu <zliu@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>, CAI Qian <caiqian@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 00/31] numa/core patches
Message-ID: <20121031004838.GA1657@cmpxchg.org>
References: <20121025121617.617683848@chello.nl>
 <508A52E1.8020203@redhat.com>
 <1351242480.12171.48.camel@twins>
 <20121028175615.GC29827@cmpxchg.org>
 <508F73C5.7050409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508F73C5.7050409@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 02:29:25PM +0800, Zhouping Liu wrote:
> On 10/29/2012 01:56 AM, Johannes Weiner wrote:
> >On Fri, Oct 26, 2012 at 11:08:00AM +0200, Peter Zijlstra wrote:
> >>On Fri, 2012-10-26 at 17:07 +0800, Zhouping Liu wrote:
> >>>[  180.918591] RIP: 0010:[<ffffffff8118c39a>]  [<ffffffff8118c39a>] mem_cgroup_prepare_migration+0xba/0xd0
> >>>[  182.681450]  [<ffffffff81183b60>] do_huge_pmd_numa_page+0x180/0x500
> >>>[  182.775090]  [<ffffffff811585c9>] handle_mm_fault+0x1e9/0x360
> >>>[  182.863038]  [<ffffffff81632b62>] __do_page_fault+0x172/0x4e0
> >>>[  182.950574]  [<ffffffff8101c283>] ? __switch_to_xtra+0x163/0x1a0
> >>>[  183.041512]  [<ffffffff8101281e>] ? __switch_to+0x3ce/0x4a0
> >>>[  183.126832]  [<ffffffff8162d686>] ? __schedule+0x3c6/0x7a0
> >>>[  183.211216]  [<ffffffff81632ede>] do_page_fault+0xe/0x10
> >>>[  183.293705]  [<ffffffff8162f518>] page_fault+0x28/0x30
> >>Johannes, this looks like the thp migration memcg hookery gone bad,
> >>could you have a look at this?
> >Oops.  Here is an incremental fix, feel free to fold it into #31.
> Hello Johannes,
> 
> maybe I don't think the below patch completely fix this issue, as I
> found a new error(maybe similar with this):
> 
> [88099.923724] ------------[ cut here ]------------
> [88099.924036] kernel BUG at mm/memcontrol.c:1134!
> [88099.924036] invalid opcode: 0000 [#1] SMP
> [88099.924036] Modules linked in: lockd sunrpc kvm_amd kvm
> amd64_edac_mod edac_core ses enclosure serio_raw bnx2 pcspkr shpchp
> joydev i2c_piix4 edac_mce_amd k8temp dcdbas ata_generic pata_acpi
> megaraid_sas pata_serverworks usb_storage radeon i2c_algo_bit
> drm_kms_helper ttm drm i2c_core
> [88099.924036] CPU 7
> [88099.924036] Pid: 3441, comm: stress Not tainted 3.7.0-rc2Jons+ #3
> Dell Inc. PowerEdge 6950/0WN213
> [88099.924036] RIP: 0010:[<ffffffff81188e97>] [<ffffffff81188e97>]
> mem_cgroup_update_lru_size+0x27/0x30

Thanks a lot for your testing efforts, I really appreciate it.

I'm looking into it, but I don't expect power to get back for several
days where I live, so it's hard to reproduce it locally.

But that looks like an LRU accounting imbalance that I wasn't able to
tie to this patch yet.  Do you see weird numbers for the lru counters
in /proc/vmstat even without this memory cgroup patch?  Ccing Hugh as
well.

Thanks,
Johannes
