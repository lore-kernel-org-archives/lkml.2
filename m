Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab2DBT2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 15:28:55 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:59315 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab2DBT2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 15:28:53 -0400
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Apr 2012 15:28:52 EDT
Date: Mon, 2 Apr 2012 21:20:12 +0200
From: Andreas Mohr <andi@lisas.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Hendry <andrew.hendry@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: 2.6.35-rc4 Graphics performance issue and freeing invalid
 memtype messages on boot.
Message-ID: <20120402192012.GA32147@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708152656.34cfd24f.akpm@linux-foundation.org>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

how's that for a hijacked thread?
- timing completely bollocks... (2010)
- author completely... err, something else :)
- versioning now in a completely different league

For the dazed and confused among you, rescue is to be found... here:
https://lkml.org/lkml/2010/7/6/108 (original parent)

OP said in the last reply that a PAT rb tree patch fixed it,
but - for me it persists.

> hrmpf, one of those wonderful messages where neither it nor its source
> code give you any clue regarding what caused it nor how to fix it.
> 
> please, apply this:
> 
> --- a/arch/x86/mm/pat.c~a
> +++ a/arch/x86/mm/pat.c
> @@ -359,7 +359,7 @@ int free_memtype(u64 start, u64 end)
>  	entry = rbt_memtype_erase(start, end);
>  	spin_unlock(&memtype_lock);
>  
> -	if (!entry) {
> +	if (WARN_ON(!entry)) {
>  		printk(KERN_INFO "%s:%d freeing invalid memtype %Lx-%Lx\n",
>  			current->comm, current->pid, start, end);
>  		return -EINVAL;
> 
> and let's at least see where it's coming from.

Applied that patch since I (_still_) keep having it
on 3.3.0something, on my Athlon XP something Debian testing,
Radeon RV250 something (does that trigger a bell!?).

Happens on kdm stop (i.e., xorg shutdown).


pat_memtype_list_w_xorg.log:

PAT memtype list:
write-back @ 0x1fff0000-0x1fff1000
write-back @ 0x1fff3000-0x1fff8000
uncached-minus @ 0xc0000000-0xc0101000
uncached-minus @ 0xc0000000-0xc0101000
uncached-minus @ 0xc0101000-0xc0102000
uncached-minus @ 0xc0101000-0xc0102000
uncached-minus @ 0xc0101000-0xc0102000
uncached-minus @ 0xc0102000-0xc0302000
uncached-minus @ 0xc0102000-0xc0302000
uncached-minus @ 0xc0102000-0xc0302000
uncached-minus @ 0xc0102000-0xc0302000
uncached-minus @ 0xc0302000-0xc07e2000
uncached-minus @ 0xc0302000-0xc07e2000
write-combining @ 0xd0000000-0xd4000000
write-combining @ 0xd0000000-0xd4000000
uncached-minus @ 0xd9000000-0xd9010000
uncached-minus @ 0xd9000000-0xd9010000
uncached-minus @ 0xd9000000-0xd9010000
uncached-minus @ 0xd9000000-0xd9010000


pat_memtype_list_wo_xorg.log:

PAT memtype list:
write-back @ 0x1fff0000-0x1fff1000
write-back @ 0x1fff3000-0x1fff8000
uncached-minus @ 0xc0102000-0xc0302000
uncached-minus @ 0xc0102000-0xc0302000
uncached-minus @ 0xd9000000-0xd9010000


mtrr_w_xorg.log:

reg00: base=0x000000000 (    0MB), size=  512MB, count=1: write-back
reg01: base=0x0c0000000 ( 3072MB), size=  256MB, count=2: write-combining
reg02: base=0x0c0000000 ( 3072MB), size=  256MB, count=1: write-combining
reg03: base=0x0d0000000 ( 3328MB), size=   64MB, count=1: write-combining


mtrr_wo_xorg.log:

reg00: base=0x000000000 (    0MB), size=  512MB, count=1: write-back
reg01: base=0x0c0000000 ( 3072MB), size=  256MB, count=2: write-combining
reg02: base=0x0c0000000 ( 3072MB), size=  256MB, count=1: write-combining



dmesg:


------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Not tainted 3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b183 ]---
Xorg:2088 freeing invalid memtype c0102000-c0112000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b184 ]---
Xorg:2088 freeing invalid memtype c0112000-c0122000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b185 ]---
Xorg:2088 freeing invalid memtype c0122000-c0132000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b186 ]---
Xorg:2088 freeing invalid memtype c0132000-c0142000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b187 ]---
Xorg:2088 freeing invalid memtype c0142000-c0152000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b188 ]---
Xorg:2088 freeing invalid memtype c0152000-c0162000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b189 ]---
Xorg:2088 freeing invalid memtype c0162000-c0172000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b18a ]---
Xorg:2088 freeing invalid memtype c0172000-c0182000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b18b ]---
Xorg:2088 freeing invalid memtype c0182000-c0192000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b18c ]---
Xorg:2088 freeing invalid memtype c0192000-c01a2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b18d ]---
Xorg:2088 freeing invalid memtype c01a2000-c01b2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b18e ]---
Xorg:2088 freeing invalid memtype c01b2000-c01c2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b18f ]---
Xorg:2088 freeing invalid memtype c01c2000-c01d2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b190 ]---
Xorg:2088 freeing invalid memtype c01d2000-c01e2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b191 ]---
Xorg:2088 freeing invalid memtype c01e2000-c01f2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b192 ]---
Xorg:2088 freeing invalid memtype c01f2000-c0202000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b193 ]---
Xorg:2088 freeing invalid memtype c0202000-c0212000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b194 ]---
Xorg:2088 freeing invalid memtype c0212000-c0222000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b195 ]---
Xorg:2088 freeing invalid memtype c0222000-c0232000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b196 ]---
Xorg:2088 freeing invalid memtype c0232000-c0242000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b197 ]---
Xorg:2088 freeing invalid memtype c0242000-c0252000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b198 ]---
Xorg:2088 freeing invalid memtype c0252000-c0262000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b199 ]---
Xorg:2088 freeing invalid memtype c0262000-c0272000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b19a ]---
Xorg:2088 freeing invalid memtype c0272000-c0282000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b19b ]---
Xorg:2088 freeing invalid memtype c0282000-c0292000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b19c ]---
Xorg:2088 freeing invalid memtype c0292000-c02a2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b19d ]---
Xorg:2088 freeing invalid memtype c02a2000-c02b2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b19e ]---
Xorg:2088 freeing invalid memtype c02b2000-c02c2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b19f ]---
Xorg:2088 freeing invalid memtype c02c2000-c02d2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1a0 ]---
Xorg:2088 freeing invalid memtype c02d2000-c02e2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1a1 ]---
Xorg:2088 freeing invalid memtype c02e2000-c02f2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1091701>] ? vma_prio_tree_remove+0x81/0xf0
 [<c10998a6>] ? __remove_shared_vm_struct.isra.25+0x36/0x50
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c129f9c6>] ? drm_vm_close_locked+0xa6/0xc0
 [<c10997a0>] ? remove_vma+0x50/0x70
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1a2 ]---
Xorg:2088 freeing invalid memtype c02f2000-c0302000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1a3 ]---
Xorg:2088 freeing invalid memtype c0102000-c0112000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1a4 ]---
Xorg:2088 freeing invalid memtype c0112000-c0122000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1a5 ]---
Xorg:2088 freeing invalid memtype c0122000-c0132000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1a6 ]---
Xorg:2088 freeing invalid memtype c0132000-c0142000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1a7 ]---
Xorg:2088 freeing invalid memtype c0142000-c0152000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1a8 ]---
Xorg:2088 freeing invalid memtype c0152000-c0162000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1a9 ]---
Xorg:2088 freeing invalid memtype c0162000-c0172000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1aa ]---
Xorg:2088 freeing invalid memtype c0172000-c0182000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1ab ]---
Xorg:2088 freeing invalid memtype c0182000-c0192000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1ac ]---
Xorg:2088 freeing invalid memtype c0192000-c01a2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1ad ]---
Xorg:2088 freeing invalid memtype c01a2000-c01b2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1ae ]---
Xorg:2088 freeing invalid memtype c01b2000-c01c2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1af ]---
Xorg:2088 freeing invalid memtype c01c2000-c01d2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1b0 ]---
Xorg:2088 freeing invalid memtype c01d2000-c01e2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1b1 ]---
Xorg:2088 freeing invalid memtype c01e2000-c01f2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1b2 ]---
Xorg:2088 freeing invalid memtype c01f2000-c0202000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1b3 ]---
Xorg:2088 freeing invalid memtype c0202000-c0212000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1b4 ]---
Xorg:2088 freeing invalid memtype c0212000-c0222000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1b5 ]---
Xorg:2088 freeing invalid memtype c0222000-c0232000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1b6 ]---
Xorg:2088 freeing invalid memtype c0232000-c0242000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1b7 ]---
Xorg:2088 freeing invalid memtype c0242000-c0252000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1b8 ]---
Xorg:2088 freeing invalid memtype c0252000-c0262000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1b9 ]---
Xorg:2088 freeing invalid memtype c0262000-c0272000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1ba ]---
Xorg:2088 freeing invalid memtype c0272000-c0282000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1bb ]---
Xorg:2088 freeing invalid memtype c0282000-c0292000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1bc ]---
Xorg:2088 freeing invalid memtype c0292000-c02a2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1bd ]---
Xorg:2088 freeing invalid memtype c02a2000-c02b2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1be ]---
Xorg:2088 freeing invalid memtype c02b2000-c02c2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1bf ]---
Xorg:2088 freeing invalid memtype c02c2000-c02d2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1c0 ]---
Xorg:2088 freeing invalid memtype c02d2000-c02e2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1205b19>] ? prio_tree_insert+0xf9/0x1e0
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c109a011>] ? __split_vma+0xd1/0x170
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1c1 ]---
Xorg:2088 freeing invalid memtype c02e2000-c02f2000
------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:362 free_memtype+0x166/0x1b0()
Hardware name: VT8367-8235
Modules linked in:
Pid: 2088, comm: Xorg Tainted: G        W    3.3.0-08839-gb5174fa-dirty #58
Call Trace:
 [<c144c6f0>] ? printk+0x18/0x1a
 [<c1026cfd>] warn_slowpath_common+0x6d/0xa0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c10230f6>] ? free_memtype+0x166/0x1b0
 [<c1026d4d>] warn_slowpath_null+0x1d/0x20
 [<c10230f6>] free_memtype+0x166/0x1b0
 [<c102c899>] ? page_is_ram+0x19/0x40
 [<c102bf80>] ? release_resource+0x80/0x80
 [<c1022942>] ? pat_pagerange_is_ram+0x42/0x70
 [<c10238c6>] untrack_pfn_vma+0x56/0x60
 [<c10967d2>] unmap_single_vma+0x322/0x390
 [<c1091701>] ? vma_prio_tree_remove+0x81/0xf0
 [<c10998a6>] ? __remove_shared_vm_struct.isra.25+0x36/0x50
 [<c1096e9d>] unmap_vmas+0x4d/0x60
 [<c10996ec>] unmap_region+0x6c/0xd0
 [<c129f9c6>] ? drm_vm_close_locked+0xa6/0xc0
 [<c10997a0>] ? remove_vma+0x50/0x70
 [<c1207a84>] ? rb_erase+0x244/0x290
 [<c109a57c>] do_munmap+0x20c/0x290
 [<c109b8ba>] sys_munmap+0x3a/0x60
 [<c1451d90>] sysenter_do_call+0x12/0x26
---[ end trace 6b5ec98d9867b1c2 ]---
Xorg:2088 freeing invalid memtype c02f2000-c0302000
mtrr: MTRR 3 not used



Video performance does seem quite spotty at times
(though might also be pulseaudio related on my single-buffered azt3328 card).

Note the multiple repeated identical entries in pat_memtype_list_w_xorg.log above...

Also, I've got suspend/resume issues (monitor seemingly randomly blinking in and out of suspend
after resume - i.e., getting a screen or not -, with the machine then either freezing completely or not,
with a ~ 1 in 4 Russian Roulette), which seem to be related to this.
This did NOT happen prior to a _user space_ upgrade (I'm strongly suspecting
an upgrade of libdrm2 package perhaps some 4 months ago).
And resume lockup does NOT happen if I remember to switch to a text console prior to suspend,
_only_ xorg console is affected.


CONFIG_X86_PAT=y



ii  libdrm-intel1                        2.4.30-1                           Userspace interface to intel-specific kernel DRM services -- runtime
rc  libdrm-nouveau1                      2.4.21-1~squeeze3                  Userspace interface to nouveau-specific kernel DRM services -- runtime
ii  libdrm-nouveau1a                     2.4.30-1                           Userspace interface to nouveau-specific kernel DRM services -- runtime
ii  libdrm-radeon1                       2.4.30-1                           Userspace interface to radeon-specific kernel DRM services -- runtime
ii  libdrm2                              2.4.32-1                           Userspace interface to kernel DRM services -- runtime


Hrmm, just realized that libdrm-radeon1 _currently_ differs from libdrm2 version -
however since there were several upgrades already (versions must have been identical at some time)
I don't think that's the cause (will recheck).



ii  xorg-docs-core                       1:1.6-1                            Core documentation for the X.org X Window System
ii  xorg-sgml-doctools                   1:1.7-1                            Common tools for building X.Org SGML documentation
ii  xserver-xorg                         1:7.6+12                           X.Org X server
ii  xserver-xorg-core                    2:1.11.4-1                         Xorg X server - core server
ii  xserver-xorg-input-all               1:7.6+12                           X.Org X server -- input driver metapackage
ii  xserver-xorg-input-evdev             1:2.7.0-1                          X.Org X server -- evdev input driver
ii  xserver-xorg-input-synaptics         1.5.99.901-1                       Synaptics TouchPad driver for X.Org server
ii  xserver-xorg-input-wacom             0.12.0-1                           X.Org X server -- Wacom input driver
ii  xserver-xorg-video-all               1:7.6+12                           X.Org X server -- output driver metapackage
ii  xserver-xorg-video-apm               1:1.2.3-2+b2                       X.Org X server -- APM display driver
ii  xserver-xorg-video-ark               1:0.7.3-2+b2                       X.Org X server -- ark display driver
ii  xserver-xorg-video-ati               1:6.14.3-1                         X.Org X server -- AMD/ATI display driver wrapper
ii  xserver-xorg-video-chips             1:1.2.4-1+b2                       X.Org X server -- Chips display driver
ii  xserver-xorg-video-cirrus            1:1.3.2-4+b2                       X.Org X server -- Cirrus display driver
ii  xserver-xorg-video-fbdev             1:0.4.2-4+b2                       X.Org X server -- fbdev display driver
ii  xserver-xorg-video-i128              1:1.3.4-2+b2                       X.Org X server -- i128 display driver
ii  xserver-xorg-video-i740              1:1.3.2-4+b2                       X.Org X server -- i740 display driver
ii  xserver-xorg-video-intel             2:2.17.0-1                         X.Org X server -- Intel i8xx, i9xx display driver
ii  xserver-xorg-video-mach64            6.9.0-1+b1                         X.Org X server -- ATI Mach64 display driver
ii  xserver-xorg-video-mga               1:1.4.13.dfsg-3+b2                 X.Org X server -- MGA display driver
ii  xserver-xorg-video-neomagic          1:1.2.5-2+b2                       X.Org X server -- Neomagic display driver
ii  xserver-xorg-video-nouveau           1:0.0.16+git20110411+8378443-1+b2  X.Org X server -- Nouveau display driver (experimental)
ii  xserver-xorg-video-openchrome        1:0.2.904+svn920-1+b1              X.Org X server -- VIA display driver
ii  xserver-xorg-video-r128              6.8.1-5+b2                         X.Org X server -- ATI r128 display driver
ii  xserver-xorg-video-radeon            1:6.14.3-1                         X.Org X server -- AMD/ATI Radeon display driver
ii  xserver-xorg-video-rendition         1:4.2.4-2+b2                       X.Org X server -- Rendition display driver
ii  xserver-xorg-video-s3                1:0.6.3-4+b2                       X.Org X server -- legacy S3 display driver
ii  xserver-xorg-video-s3virge           1:1.10.4-4+b2                      X.Org X server -- S3 ViRGE display driver
ii  xserver-xorg-video-savage            1:2.3.3-1                          X.Org X server -- Savage display driver
ii  xserver-xorg-video-siliconmotion     1:1.7.5-1+b2                       X.Org X server -- SiliconMotion display driver
ii  xserver-xorg-video-sis               1:0.10.3-3+b2                      X.Org X server -- SiS display driver
ii  xserver-xorg-video-sisusb            1:0.9.4-2+b2                       X.Org X server -- SiS USB display driver
ii  xserver-xorg-video-tdfx              1:1.4.3-4+b2                       X.Org X server -- tdfx display driver
ii  xserver-xorg-video-trident           1:1.3.4-2+b2                       X.Org X server -- Trident display driver
ii  xserver-xorg-video-tseng             1:1.2.4-2+b2                       X.Org X server -- Tseng display driver
ii  xserver-xorg-video-vesa              1:2.3.0-7+b1                       X.Org X server -- VESA display driver
ii  xserver-xorg-video-vmware            1:11.0.99.901-1                    X.Org X server -- VMware display driver
ii  xserver-xorg-video-voodoo            1:1.2.4-2+b2                       X.Org X server -- Voodoo display driver


01:00.0 VGA compatible controller: ATI Technologies Inc Radeon RV250 If [Radeon 9000] (rev 01) (prog-if 00 [VGA controller])
	Subsystem: PC Partner Limited RV250 If [Radeon 9000 "Atlantis"]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (2000ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at d0000000 (32-bit, prefetchable) [size=64M]
	Region 1: I/O ports at 9000 [size=256]
	Region 2: Memory at d9000000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at d8000000 [disabled] [size=128K]
	Capabilities: [58] AGP version 2.0
		Status: RQ=48 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
		Command: RQ=32 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x4
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-



Thanks a ton,

Andreas Mohr
