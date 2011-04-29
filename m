Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab1D2BTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 21:19:35 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:64369 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754567Ab1D2BTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 21:19:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmUDAGIOuk15LHHJgWdsb2JhbACmABUBARYmJcZkDoVoBJx5
Date: Fri, 29 Apr 2011 11:19:29 +1000
From: Dave Chinner <david@fromorbit.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
        Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.39-rc3, 2.6.39-rc4: XFS lockup - regression since 2.6.38
Message-ID: <20110429011929.GA13542@dastard>
References: <20110423224403.5fd1136a@neptune.home>
 <20110427050850.GG12436@dastard>
 <20110427182622.05a068a2@neptune.home>
 <20110428194528.GA1627@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110428194528.GA1627@x4.trippels.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 09:45:28PM +0200, Markus Trippelsdorf wrote:
> On 2011.04.27 at 18:26 +0200, Bruno Prémont wrote:
> > On Wed, 27 April 2011 Dave Chinner <david@fromorbit.com> wrote:
> > > On Sat, Apr 23, 2011 at 10:44:03PM +0200, Bruno Prémont wrote:
> > > > Running 2.6.39-rc3+ and now again on 2.6.39-rc4+ (I've not tested -rc1
> > > > or -rc2) I've hit a "dying machine" where processes writing to disk end
> > > > up in D state.
> > > > From occurrence with -rc3+ I don't have logs as those never hit the disk,
> > > > for -rc4+ I have the following (sysrq+t was too big, what I have of it
> > > > misses a dozen of kernel tasks - if needed, please ask):
> > > > 
> > > > The -rc4 kernel is at commit 584f79046780e10cb24367a691f8c28398a00e84
> > > > (+ 1 patch of mine to stop disk on reboot),
> > > > full dmesg available if needed; kernel config attached (only selected
> > > > options). In case there is something I should do at next occurrence
> > > > please tell. Unfortunately I have no trigger for it and it does not
> > > > happen very often.
> > > > 
> > > > [    0.000000] Linux version 2.6.39-rc4-00120-g73b5b55 (kbuild@neptune) (gcc version 4.4.5 (Gentoo 4.4.5 p1.2, pie-0.4.5) ) #12 Thu Apr 21 19:28:45 CEST 2011
> > > > 
> > > > 
> > > > [32040.120055] INFO: task flush-8:0:1665 blocked for more than 120 seconds.
> > > > [32040.120068] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > > [32040.120077] flush-8:0       D 00000000  4908  1665      2 0x00000000
> > > > [32040.120099]  f55efb5c 00000046 00000000 00000000 00000000 00000001 e0382924 00000000
> > > > [32040.120118]  f55efb0c f55efb5c 00000004 f629ba70 572f01a2 00001cfe f629ba70 ffffffc0
> > > > [32040.120135]  f55efc68 f55efb30 f889d7f8 f55efb20 00000000 f55efc68 e0382900 f55efc94
> > > > [32040.120153] Call Trace:
> > > > [32040.120220]  [<f889d7f8>] ? xfs_bmap_search_multi_extents+0x88/0xe0 [xfs]
> > > > [32040.120239]  [<c109ce1d>] ? kmem_cache_alloc+0x2d/0x110
> > > > [32040.120294]  [<f88c88ca>] ? xlog_space_left+0x2a/0xc0 [xfs]
> > > > [32040.120346]  [<f88c85cb>] xlog_wait+0x4b/0x70 [xfs]
> > > > [32040.120359]  [<c102ca00>] ? try_to_wake_up+0xc0/0xc0
> > > > [32040.120411]  [<f88c948b>] xlog_grant_log_space+0x8b/0x240 [xfs]
> > > > [32040.120464]  [<f88c936e>] ? xlog_grant_push_ail+0xbe/0xf0 [xfs]
> > > > [32040.120516]  [<f88c99db>] xfs_log_reserve+0xab/0xb0 [xfs]
> > > > [32040.120571]  [<f88d6dc8>] xfs_trans_reserve+0x78/0x1f0 [xfs]
> > > 
> > > Hmmmmm. That may be caused by the conversion of the xfsaild to a
> > > work queue. Can you post the output of "xfs_info <mntpt>" and the
> > > mount options (/proc/mounts) used on you system?
> 
> I may have hit the same problem today and managed to capture some sysrq-l
> and sysrq-w output. 
> 
> The system was largely unusable during this incident. I could still
> switch between X and the console (and press the sysrq key-combination),
> but I couldn't run any commands in the terminal.
> 
> 
> x4 ~ # xfs_info /
> meta-data=/dev/root              isize=256    agcount=4, agsize=1949824 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=7799296, imaxpct=25
>          =                       sunit=128    swidth=128 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=3808, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

OK, so the common elements here appears to be root filesystems
with small log sizes, which means they are tail pushing all the
time metadata operations are in progress. Definitely seems like a
race in the AIL workqueue trigger mechanism. I'll see if I can
reproduce this and cook up a patch to fix it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
