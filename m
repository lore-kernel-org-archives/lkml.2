Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab2AYEBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 23:01:25 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:25291 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab2AYEBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 23:01:23 -0500
Date: Tue, 24 Jan 2012 22:58:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tj@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/urgent] memblock: Fix alloc failure due to dumb
 underflow protection in memblock_find_in_range_node ()
Message-ID: <20120125035841.GA17520@phenom.dumpdata.com>
References: <20120113181412.GA11112@google.com>
 <tip-5d53cb27d849c899136c048ec84c940ac449494b@git.kernel.org>
 <20120124145132.GA30828@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124145132.GA30828@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F1F7E80.0065,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 09:51:32AM -0500, Konrad Rzeszutek Wilk wrote:
> On Mon, Jan 16, 2012 at 01:03:50AM -0800, tip-bot for Tejun Heo wrote:
> > Commit-ID:  5d53cb27d849c899136c048ec84c940ac449494b
> > Gitweb:     http://git.kernel.org/tip/5d53cb27d849c899136c048ec84c940ac449494b
> > Author:     Tejun Heo <tj@kernel.org>
> > AuthorDate: Fri, 13 Jan 2012 10:14:12 -0800
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Mon, 16 Jan 2012 08:38:06 +0100
> > 
> > memblock: Fix alloc failure due to dumb underflow protection in memblock_find_in_range_node()
> > 
> > 7bd0b0f0da ("memblock: Reimplement memblock allocation using
> > reverse free area iterator") implemented a simple top-down
> > allocator using a reverse memblock iterator.  To avoid underflow
> > in the allocator loop, it simply raised the lower boundary to
> > the requested size under the assumption that requested size
> > would be far smaller than available memblocks.
> > 
> > This causes early page table allocation failure under certain
> > configurations in Xen.  Fix it by checking for underflow directly
> > instead of bumping up lower bound.
> 
> Well, it fixes my 4GB problem, but when I try to boot a 2GB (1GB of that
> is for balloon usage) guest (i386 only) I get a new failure:
> 
> > more /mnt/lab/bootstrap-i386/test.xm 
> extra="console=hvc0 debug earlyprintk=xen memblock=debug"
> kernel="/mnt/lab/bootstrap-i386/vmlinuz"
> ramdisk="/mnt/lab/bootstrap-i386/initramfs.cpio.gz"
> memory=1024
> maxmem=2048
> vcpus=2
> name="bootstrap-i386"
> on_crash="preserve"
> vif = [ 'mac=00:0F:4B:00:00:68, bridge=switch' ]
> vfb = [ 'vnc=1, vnclisten=0.0.0.0,vncunused=1']
> disk=['phy:/dev/vg_guests/bootstrap-i386,xvda,w']
> 
> So this is v3.3-rc1 + this patch by itself. Any thoughts of what else
> might be amiss?

My apologies, I had been building new kernels everyday and the /lib/modules
was getting filled with v3.3-rc1-000XX making the initramfs bigger and bigger
until well - it no longer could fit in memory. And I added this specific patch
in my testing queue which triggered another build and caused the initramfs to
grow just too big:

> (early) [    0.000000] initrd too large to handle, disabling initrd

while the previous initramfs were under the size constraint.

So, the patch is good, I've retested it and fixed my AutoMaticBuildThingy
to clean up /lib/modules before the built and sorry for the scare! 

Please apply this patch to 3.3-rc1 at your earliest convience! Thanks!
