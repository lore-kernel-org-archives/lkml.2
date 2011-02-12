Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab1BLJWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 04:22:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:20532 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab1BLJWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 04:22:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,461,1291622400"; 
   d="scan'208";a="886847894"
Subject: Re: [performance bug] kernel building regression on 64 LCPUs
 machine
From: "Alex,Shi" <alex.shi@intel.com>
To: "Li, Shaohua" <shaohua.li@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, "jack@suse.cz" <jack@suse.cz>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "czoccolo@gmail.com" <czoccolo@gmail.com>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <20110126081529.GA28909@sli10-conroe.sh.intel.com>
References: <1295402148.4773.143.camel@debian>
	 <1295402606.1949.871.camel@sli10-conroe>
	 <20110120151656.GC18875@redhat.com>
	 <20110126081529.GA28909@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Feb 2011 17:21:52 +0800
Message-ID: <1297502512.29573.26.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 16:15 +0800, Li, Shaohua wrote:
> On Thu, Jan 20, 2011 at 11:16:56PM +0800, Vivek Goyal wrote:
> > On Wed, Jan 19, 2011 at 10:03:26AM +0800, Shaohua Li wrote:
> > > add Jan and Theodore to the loop.
> > >
> > > On Wed, 2011-01-19 at 09:55 +0800, Shi, Alex wrote:
> > > > Shaohua and I tested kernel building performance on latest kernel. and
> > > > found it is drop about 15% on our 64 LCPUs NHM-EX machine on ext4 file
> > > > system. We find this performance dropping is due to commit
> > > > 749ef9f8423054e326f. If we revert this patch or just change the
> > > > WRITE_SYNC back to WRITE in jbd2/commit.c file. the performance can be
> > > > recovered.
> > > >
> > > > iostat report show with the commit, read request merge number increased
> > > > and write request merge dropped. The total request size increased and
> > > > queue length dropped. So we tested another patch: only change WRITE_SYNC
> > > > to WRITE_SYNC_PLUG in jbd2/commit.c, but nothing effected.
> > > since WRITE_SYNC_PLUG doesn't work, this isn't a simple no-write-merge issue.
> > >
> > 
> > Yep, it does sound like reduce write merging. But moving journal commits
> > back to WRITE, then fsync performance will drop as there will be idling
> > introduced between fsync thread and journalling thread. So that does
> > not sound like a good idea either.
> > 
> > Secondly, in presence of mixed workload (some other sync read happening)
> > WRITES can get less bandwidth and sync workload much more. So by
> > marking journal commits as WRITES you might increase the delay there
> > in completion in presence of other sync workload.
> > 
> > So Jan Kara's approach makes sense that if somebody is waiting on
> > commit then make it WRITE_SYNC otherwise make it WRITE. Not sure why
> > did it not work for you. Is it possible to run some traces and do
> > more debugging that figure out what's happening.
> Sorry for the long delay.
> 
> Looks fedora enables ccache by default. While our kbuild test is on ext4 disk
> but rootfs is on ext3 where ccache cache files live. Jan's patch only covers
> ext4, maybe this is the reason.
> I changed jbd to use WRITE for journal_commit_transaction. With the change and
> Jan's patch, the test seems fine.
Let me clarify the bug situation again. 
With the following scenarios, the regression is clear.
1, ccache_dir setup at rootfs that format is ext3 on /dev/sda1; 2,
kbuild on /dev/sdb1 with ext4. 
but if we disable the ccache, only do kbuild on sdb1 with ext4. There is
no regressions whenever with or without Jan's patch. 
So, problem focus on the ccache scenario, (from fedora 11, ccache is
default setting). 

If we compare the vmstat output with or without ccache, there is too
many write when ccache enabled. According the result, it should to do
some tunning on ext3 fs. 


vmstat average output per 10 seconds, without ccache
procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
26.8 0.5 0.0 63930192.3 9677.0 96544.9 0.0 0.0 2486.9 337.9 17729.9 4496.4 17.5 2.5 79.8 0.2 0.0 

vmstat average output per 10 seconds, with ccache
procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
2.4 40.7 0.0 64316231.0 17260.6 119533.8 0.0 0.0 2477.6 1493.1 8606.4 3565.2 2.5 1.1 83.0 13.5 0.0


> 
> Jan,
> can you send a patch with similar change for ext3? So we can do more tests.
> 
> Thanks,
> Shaohua



