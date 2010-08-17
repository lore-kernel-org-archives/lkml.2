Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab0HQFwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 01:52:49 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5024 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab0HQFwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 01:52:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Vz4GMglSkmjkFao3/iUiYa2ACJVipsOXP39ERepmOAp721bJMM6Knc8JZM5po1J6K
	cq6TnDC1A7joLF/3xgmQw==
Date: Mon, 16 Aug 2010 22:52:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [S+Q3 20/23] slub: Shared cache to exploit cross cpu caching
 abilities.
In-Reply-To: <20100804024535.338543724@linux.com>
Message-ID: <alpine.DEB.2.00.1008162246500.26781@chino.kir.corp.google.com>
References: <20100804024514.139976032@linux.com> <20100804024535.338543724@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010, Christoph Lameter wrote:

> Strictly a performance enhancement by better tracking of objects
> that are likely in the lowest cpu caches of processors.
> 
> SLAB uses one shared cache per NUMA node or one globally. However, that
> is not satifactory for contemporary cpus. Those may have multiple
> independent cpu caches per node. SLAB in these situation treats
> cache cold objects like cache hot objects.
> 
> The shared caches of slub are per physical cpu cache for all cpus using
> that cache. Shared cache content will not cross physical caches.
> 
> The shared cache can be dynamically configured via
> /sys/kernel/slab/<cache>/shared_queue
> 
> The current shared cache state is available via
> cat /sys/kernel/slab/<cache/<shared_caches>
> 
> Shared caches are always allocated in the sizes available in the kmalloc
> array. Cache sizes are rounded up to the sizes available.
> 
> F.e. on my Dell with 8 cpus in 2 packages in which each 2 cpus shared
> an l2 cache I get:
> 
> christoph@:/sys/kernel/slab$ cat kmalloc-64/shared_caches
> 384 C0,2=66/126 C1,3=126/126 C4,6=126/126 C5,7=66/126
> christoph@:/sys/kernel/slab$ cat kmalloc-64/per_cpu_caches
> 617 C0=54/125 C1=37/125 C2=102/125 C3=76/125 C4=81/125 C5=108/125 C6=72/125 C7=87/125
> 

This explodes on the memset() in slab_alloc() because of __GFP_ZERO on my 
system:

[    1.922641] BUG: unable to handle kernel paging request at 0000007e7e581f70
[    1.923625] IP: [<ffffffff811053ee>] slab_alloc+0x549/0x590
[    1.923625] PGD 0 
[    1.923625] Oops: 0002 [#1] SMP 
[    1.923625] last sysfs file: 
[    1.923625] CPU 12 
[    1.923625] Modules linked in:
[    1.923625] 
[    1.923625] Pid: 1, comm: swapper Not tainted 2.6.35-slubq #1
[    1.923625] RIP: 0010:[<ffffffff811053ee>]  [<ffffffff811053ee>] slab_alloc+0x549/0x590
[    1.923625] RSP: 0000:ffff88047e09dd30  EFLAGS: 00010246
[    1.923625] RAX: 0000000000000000 RBX: ffff88047fc04500 RCX: 0000000000000010
[    1.923625] RDX: 0000000000000003 RSI: 0000000000000348 RDI: 0000007e7e581f70
[    1.923625] RBP: ffff88047e09dde0 R08: ffff88048e200000 R09: ffffffff81ad2c70
[    1.923625] R10: ffff88107e51fd20 R11: 0000000000000000 R12: 0000007e7e581f70
[    1.923625] R13: 0000000000000001 R14: ffff880c7e54eb28 R15: 00000000000080d0
[    1.923625] FS:  0000000000000000(0000) GS:ffff880c8e200000(0000) knlGS:0000000000000000
[    1.923625] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.923625] CR2: 0000007e7e581f70 CR3: 0000000001a04000 CR4: 00000000000006e0
[    1.923625] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.923625] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    1.923625] Process swapper (pid: 1, threadinfo ffff88047e09c000, task ffff88107e468000)
[    1.923625] Stack:
[    1.923625]  ffff88047e09dd60 ffffffff81162c4d 0000000000000008 ffff88087dd5f870
[    1.923625] <0> ffff88047e09dfd8 ffffffff81106e14 ffff88047e09dd80 ffff88107e468670
[    1.923625] <0> ffff88107e468670 ffff88107e468000 ffff88047e09ddd0 ffff88107e468000
[    1.923625] Call Trace:
[    1.923625]  [<ffffffff81162c4d>] ? sysfs_find_dirent+0x3f/0x58
[    1.923625]  [<ffffffff81106e14>] ? alloc_shared_caches+0x10f/0x277
[    1.923625]  [<ffffffff811060f8>] __kmalloc_node+0x78/0xa3
[    1.923625]  [<ffffffff81106e14>] alloc_shared_caches+0x10f/0x277
[    1.923625]  [<ffffffff811065e8>] ? kfree+0x85/0x8d
[    1.923625]  [<ffffffff81b09661>] slab_sysfs_init+0x96/0x10a
[    1.923625]  [<ffffffff81b095cb>] ? slab_sysfs_init+0x0/0x10a
[    1.923625]  [<ffffffff810001f9>] do_one_initcall+0x5e/0x14e
[    1.923625]  [<ffffffff81aec6bb>] kernel_init+0x178/0x202
[    1.923625]  [<ffffffff81030954>] kernel_thread_helper+0x4/0x10
[    1.923625]  [<ffffffff81aec543>] ? kernel_init+0x0/0x202
[    1.923625]  [<ffffffff81030950>] ? kernel_thread_helper+0x0/0x10
[    1.923625] Code: 95 78 ff ff ff 4c 89 e6 48 89 df e8 13 f4 ff ff 85 c0 0f 84 44 fb ff ff ff 75 b0 9d 66 45 85 ff 79 3b 48 63 4b 14 31 c0 4c 89 e7 <f3> aa eb 2e ff 75 b0 9d 41 f7 c7 00 02 00 00 75 1e 48 c7 c7 10 
[    1.923625] RIP  [<ffffffff811053ee>] slab_alloc+0x549/0x590
[    1.923625]  RSP <ffff88047e09dd30>
[    1.923625] CR2: 0000007e7e581f70
