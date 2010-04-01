Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab0DAJ2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 05:28:08 -0400
Received: from mga10.intel.com ([192.55.52.92]:37734 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753709Ab0DAJ17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 05:27:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,347,1267430400"; 
   d="scan'208";a="554099686"
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: alex.shi@intel.com, Christoph Lameter <cl@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
       "Tim C <tim.c.chen"@intel.com, Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <1269570902.9614.92.camel@alexs-hp.sh.intel.com>
References: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>
	 <alpine.DEB.2.00.1003250942080.2670@router.home>
	 <1269570902.9614.92.camel@alexs-hp.sh.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 01 Apr 2010 17:29:26 +0800
Message-Id: <1270114166.2078.107.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-26 at 10:35 +0800, Alex Shi wrote:
> On Thu, 2010-03-25 at 22:49 +0800, Christoph Lameter wrote:
> > On Thu, 25 Mar 2010, Alex Shi wrote:
> > 
> > >     SLUB: Use this_cpu operations in slub
> > >
> > > The hackbench is prepared hundreds pair of processes/threads. And each
> > > of pair of processes consists of a receiver and a sender. After all
> > > pairs created and ready with a few memory block (by malloc), hackbench
> > > let the sender do appointed times sending to receiver via socket, then
> > > wait all pairs finished. The total sending running time is the indicator
> > > of this benchmark. The less the better.
> > 
> > > The socket send/receiver generate lots of slub alloc/free. slabinfo
> > > command show the following slub get huge increase from about 81412344 to
> > > 141412497, after command "backbench 150 thread 1000" running.
> > 
> > The number of frees is different? From 81 mio to 141 mio? Are you sure it
> > was the same load?
> The slub free number has similar increase, the following is the data
> before testing:
> name                   Objects      Alloc       Free   %Fast Fallb Onn
> :t-0001024                 855   81412344   81411981  93   1     0 3
> :t-0000256                1540   81224970   81223835  93   1     0 1
> 
> I am sure there is no effective task running when I do testing. 
> 
> Just for this info, CONFIG_SLUB_STATS enabled.
> 
> > 
> > > Name                   Objects      Alloc       Free   %Fast Fallb O
> > > :t-0001024                 870  141412497  141412132  94   1     0 3
> > > :t-0000256                1607  141225312  141224177  94   1     0 1
> > >
> > >
> > > Via perf tool I collected the L1 data cache miss info of comamnd:
> > > "./hackbench 150 thread 100"
> > >
> > > On 33-rc1, about 1303976612 time L1 Dcache missing
> > >
> > > On 9dfc6, about 1360574760 times L1 Dcache missing
> > 
> > I hope this is the same load?
> for the same load parameter: ./hackbench 150 thread 1000
> on 33-rc1, about 10649258360 times L1 Dcache missing
> on 9dfc6, about 11061002507 times L1 Dcahce missing
> 
> For this this info, without CONFIG_SLUB_STATS and slub_debug is close. 
> 
> > 
> > What debugging options did you use? We are now using per cpu operations in
> > the hot paths. Enabling debugging for per cpu ops could decrease your
> > performance now. Have a look at a dissassembly of kfree() to verify that
> > there is no instrumentation.
> > 
> Basically, slub_debug never opened in booting, some SLUB related kernel
> config is here:
> CONFIG_SLUB_DEBUG=y
> CONFIG_SLUB=y
> #CONFIG_SLUB_DEBUG_ON is not set
> 
> I just dissemble kfree, but whether the KMEMTRACE enabled or not, the
> trace_kfree code stay in kfree function, and in my testing the debugfs
> are not mounted.  

Christoph,

I suspect the moving of place of cpu_slab in kmem_cache causes the new cache
miss. But when I move it to the tail of the structure, kernel always panic when
booting. Perhaps there is another potential bug?

---
Mount-cache hash table entries: 256
general protection fault: 0000 [#1] SMP
last sysfs file:
CPU 0
Pid: 0, comm: swapper Not tainted 2.6.33-rc1-this_cpu #1 X8DTN/X8DTN
RIP: 0010:[<ffffffff810c5041>]  [<ffffffff810c5041>] kmem_cache_alloc+0x58/0xf7
RSP: 0000:ffffffff81a01df8  EFLAGS: 00010083
RAX: ffff8800bec02220 RBX: ffffffff81c19180 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 00000000000006ae RDI: ffffffff818031ee
RBP: ffff8800bec02000 R08: ffff1000e6e02220 R09: 0000000000000002
R10: ffff88000001b9f0 R11: ffff88000001baf8 R12: 00000000000080d0
R13: 0000000000000296 R14: 00000000000080d0 R15: ffffffff8126b0be
FS:  0000000000000000(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001a55000 CR4: 00000000000006b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff81a00000, task ffffffff81a5d020)
Stack:
 0000000000000010 ffffffff81a01e20 ffff880100002038 ffffffff81c19180
<0> 00000000000080d0 ffffffff81c19198 0000000000400000 ffffffff81836aca
<0> 0000000000000000 ffffffff8126b0be 0000000000000296 00000000000000d0
Call Trace:
 [<ffffffff8126b0be>] ? idr_pre_get+0x29/0x6d
 [<ffffffff8126b116>] ? ida_pre_get+0x14/0xba
 [<ffffffff810e19a1>] ? alloc_vfsmnt+0x3c/0x166
 [<ffffffff810cdd0e>] ? vfs_kern_mount+0x32/0x15b
 [<ffffffff81b22c41>] ? sysfs_init+0x55/0xae
 [<ffffffff81b21ce1>] ? mnt_init+0x9b/0x179
 [<ffffffff81b2194e>] ? vfs_caches_init+0x105/0x115
 [<ffffffff81b07c03>] ? start_kernel+0x32e/0x370


