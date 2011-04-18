Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab1DRBLa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 21:11:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:1971 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab1DRBLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 21:11:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,229,1301900400"; 
   d="scan'208";a="680366362"
Date: Mon, 18 Apr 2011 09:11:19 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG 2.6.39-rc3] NFS spinlock recursion
Message-ID: <20110418011119.GA5606@localhost>
References: <20110415024758.GA20420@localhost>
 <1302837129.24028.190.camel@lade.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302837129.24028.190.camel@lade.trondhjem.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond and Maciej,

I confirmed that this commit fixed the bug

        0d88f6e804c824454b5ed0d3034ed3dcf7467a87
        (nfs: don't call __mark_inode_dirty while holding i_lock)

It's working fine all these days.

Thanks,
Fengguang

On Fri, Apr 15, 2011 at 11:12:09AM +0800, Trond Myklebust wrote:
> On Fri, 2011-04-15 at 10:47 +0800, Wu Fengguang wrote:
> > Hi Trond,
> > 
> > I got these errors when testing writeback, did you see it before?
> > (I've removed all local changes to NFS code..)
> > 
> > Thanks,
> > Fengguang
> > ---
> > [   15.463942] XFS (sda5): Mounting Filesystem
> > [   15.468446] XFS: Mounting Filesystem
> > [   15.548984] XFS (sda5): Ending clean mount
> > [   15.553347] XFS: Ending clean mount
> > [   89.917428] BUG: spinlock recursion on CPU#3, flush-0:24/2548
> > [   89.923647]  lock: ffff8801223c9240, .magic: dead4ead, .owner: flush-0:24/2548, .owner_cpu: 3
> > [   89.932677] Pid: 2548, comm: flush-0:24 Not tainted 2.6.39-rc3-dt7+ #175
> > [   89.939649] Call Trace:
> > [   89.942356]  [<ffffffff813b3d2d>] spin_bug+0x9c/0xa3
> > [   89.947584]  [<ffffffff813b3e1b>] do_raw_spin_lock+0x47/0x137
> > [   89.953600]  [<ffffffff818f97fb>] _raw_spin_lock+0x56/0x69
> > [   89.959345]  [<ffffffff8115d388>] ? __mark_inode_dirty+0x66/0x1d0
> > [   89.965734]  [<ffffffff8115d388>] __mark_inode_dirty+0x66/0x1d0
> > [   89.971952]  [<ffffffff81238955>] nfs_commit_inode+0xf1/0x1c1
> > [   89.978022]  [<ffffffff81238a63>] nfs_write_inode+0x3e/0x93
> > [   89.983913]  [<ffffffff818fa1a3>] ? _raw_spin_unlock+0x2b/0x2f
> > [   89.990068]  [<ffffffff8115c8de>] writeback_single_inode+0x17a/0x267
> > [   89.996739]  [<ffffffff8115cdac>] writeback_sb_inodes+0xcf/0x157
> > [   90.003032]  [<ffffffff8115d7a2>] writeback_inodes_wb+0x131/0x143
> > [   90.009415]  [<ffffffff8115da2e>] wb_writeback+0x27a/0x3c3
> > [   90.015166]  [<ffffffff8115dd32>] wb_do_writeback+0x1bb/0x1d6
> > [   90.021206]  [<ffffffff8115ddd8>] bdi_writeback_thread+0x8b/0x212
> > [   90.027572]  [<ffffffff8115dd4d>] ? wb_do_writeback+0x1d6/0x1d6
> > [   90.033758]  [<ffffffff8108c4cc>] kthread+0x8e/0x96
> > [   90.038906]  [<ffffffff81901ee4>] kernel_thread_helper+0x4/0x10
> > [   90.045115]  [<ffffffff818fa414>] ? retint_restore_args+0x13/0x13
> > [   90.051494]  [<ffffffff8108c43e>] ? __init_kthread_worker+0x5b/0x5b
> > [   90.058047]  [<ffffffff81901ee0>] ? gs_change+0x13/0x13
> 
> Hi Fengguang,
> 
> Are you testing with a kernel that contains commit
> 0d88f6e804c824454b5ed0d3034ed3dcf7467a87 (nfs: don't call
> __mark_inode_dirty while holding i_lock)?
> 
> The locking scheme for __mark_inode_dirty was changed in commit
> 250df6ed274d767da844a5d9f05720b804240197 (in the 2.6.39 merge window),
> but as far as I can tell all the NFS users of that function should now
> have now been fixed except for the case of one pNFS user for which I do
> have a patch in my 'bugfixes' branch on linux-nfs.org.
> 
> Cheers
>   Trond
> 
> -- 
> Trond Myklebust
> Linux NFS client maintainer
> 
> NetApp
> Trond.Myklebust@netapp.com
> www.netapp.com
> 
