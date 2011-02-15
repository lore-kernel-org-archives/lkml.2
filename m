Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab1BOBKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 20:10:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:50851 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab1BOBKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 20:10:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,471,1291622400"; 
   d="scan'208";a="887480132"
Subject: Re: [performance bug] kernel building regression on 64 LCPUs
 machine
From: Shaohua Li <shaohua.li@intel.com>
To: "Shi, Alex" <alex.shi@intel.com>, Jan Kara <jack@suse.cz>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        "jack@suse.cz" <jack@suse.cz>, "tytso@mit.edu" <tytso@mit.edu>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <1297650318.29573.2482.camel@debian>
References: <1295402148.4773.143.camel@debian>
	 <1295402606.1949.871.camel@sli10-conroe>
	 <20110120151656.GC18875@redhat.com>
	 <20110126081529.GA28909@sli10-conroe.sh.intel.com>
	 <1297502512.29573.26.camel@debian>
	 <AANLkTi=B6kabp+NvRJC_g-AqQO0ZOvnEDYpVFmScttR6@mail.gmail.com>
	 <1297650318.29573.2482.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 09:10:01 +0800
Message-ID: <1297732201.24560.2.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 10:25 +0800, Shi, Alex wrote:
> On Sun, 2011-02-13 at 02:25 +0800, Corrado Zoccolo wrote:
> > On Sat, Feb 12, 2011 at 10:21 AM, Alex,Shi <alex.shi@intel.com> wrote:
> > > On Wed, 2011-01-26 at 16:15 +0800, Li, Shaohua wrote:
> > >> On Thu, Jan 20, 2011 at 11:16:56PM +0800, Vivek Goyal wrote:
> > >> > On Wed, Jan 19, 2011 at 10:03:26AM +0800, Shaohua Li wrote:
> > >> > > add Jan and Theodore to the loop.
> > >> > >
> > >> > > On Wed, 2011-01-19 at 09:55 +0800, Shi, Alex wrote:
> > >> > > > Shaohua and I tested kernel building performance on latest kernel. and
> > >> > > > found it is drop about 15% on our 64 LCPUs NHM-EX machine on ext4 file
> > >> > > > system. We find this performance dropping is due to commit
> > >> > > > 749ef9f8423054e326f. If we revert this patch or just change the
> > >> > > > WRITE_SYNC back to WRITE in jbd2/commit.c file. the performance can be
> > >> > > > recovered.
> > >> > > >
> > >> > > > iostat report show with the commit, read request merge number increased
> > >> > > > and write request merge dropped. The total request size increased and
> > >> > > > queue length dropped. So we tested another patch: only change WRITE_SYNC
> > >> > > > to WRITE_SYNC_PLUG in jbd2/commit.c, but nothing effected.
> > >> > > since WRITE_SYNC_PLUG doesn't work, this isn't a simple no-write-merge issue.
> > >> > >
> > >> >
> > >> > Yep, it does sound like reduce write merging. But moving journal commits
> > >> > back to WRITE, then fsync performance will drop as there will be idling
> > >> > introduced between fsync thread and journalling thread. So that does
> > >> > not sound like a good idea either.
> > >> >
> > >> > Secondly, in presence of mixed workload (some other sync read happening)
> > >> > WRITES can get less bandwidth and sync workload much more. So by
> > >> > marking journal commits as WRITES you might increase the delay there
> > >> > in completion in presence of other sync workload.
> > >> >
> > >> > So Jan Kara's approach makes sense that if somebody is waiting on
> > >> > commit then make it WRITE_SYNC otherwise make it WRITE. Not sure why
> > >> > did it not work for you. Is it possible to run some traces and do
> > >> > more debugging that figure out what's happening.
> > >> Sorry for the long delay.
> > >>
> > >> Looks fedora enables ccache by default. While our kbuild test is on ext4 disk
> > >> but rootfs is on ext3 where ccache cache files live. Jan's patch only covers
> > >> ext4, maybe this is the reason.
> > >> I changed jbd to use WRITE for journal_commit_transaction. With the change and
> > >> Jan's patch, the test seems fine.
> > > Let me clarify the bug situation again.
> > > With the following scenarios, the regression is clear.
> > > 1, ccache_dir setup at rootfs that format is ext3 on /dev/sda1; 2,
> > > kbuild on /dev/sdb1 with ext4.
> > > but if we disable the ccache, only do kbuild on sdb1 with ext4. There is
> > > no regressions whenever with or without Jan's patch.
> > > So, problem focus on the ccache scenario, (from fedora 11, ccache is
> > > default setting).
> > >
> > > If we compare the vmstat output with or without ccache, there is too
> > > many write when ccache enabled. According the result, it should to do
> > > some tunning on ext3 fs.
> > Is ext3 configured with data ordered or writeback?
> 
> The ext3 on sda and ext4 on sdb are both used 'ordered' mounting mode. 
> 
> > I think ccache might be performing fsyncs, and this is a bad workload
> > for ext3, especially in ordered mode.
> > It might be that my patch introduced a regression in ext3 fsync
> > performance, but I don't understand how reverting only the change in
> > jbd2 (that is the ext4 specific journaling daemon) could restore it.
> > The two partitions are on different disks, so each one should be
> > isolated from the I/O perspective (do they share a single
> > controller?).
> 
> No, sda/sdb use separated controller. 
>  
> >  The only interaction I see happens at the VM level,
> > since changing performance of any of the two changes the rate at which
> > pages can be cleaned.
> > 
> > Corrado
> > >
> > >
> > > vmstat average output per 10 seconds, without ccache
> > > procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu-----
> > >  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
> > > 26.8 0.5 0.0 63930192.3 9677.0 96544.9 0.0 0.0 2486.9 337.9 17729.9 4496.4 17.5 2.5 79.8 0.2 0.0
> > >
> > > vmstat average output per 10 seconds, with ccache
> > > procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu-----
> > >  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
> > > 2.4 40.7 0.0 64316231.0 17260.6 119533.8 0.0 0.0 2477.6 1493.1 8606.4 3565.2 2.5 1.1 83.0 13.5 0.0
> > >
> > >
> > >>
> > >> Jan,
> > >> can you send a patch with similar change for ext3? So we can do more tests.
Hi Jan,
can you send a patch with both ext3 and ext4 changes? Our test shows
your patch has positive effect, but need confirm with the ext3 change.

Thanks,
Shaohua

