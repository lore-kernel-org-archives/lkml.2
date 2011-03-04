Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406Ab1CDPcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:32:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:48914 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345Ab1CDPcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 10:32:53 -0500
Date: Fri, 4 Mar 2011 16:32:48 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Corrado Zoccolo <czoccolo@gmail.com>,
        "Alex,Shi" <alex.shi@intel.com>, "Li, Shaohua" <shaohua.li@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, "tytso@mit.edu" <tytso@mit.edu>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [performance bug] kernel building regression on 64 LCPUs
 machine
Message-ID: <20110304153248.GC2649@quack.suse.cz>
References: <1297732201.24560.2.camel@sli10-conroe>
 <20110221164909.GG6584@quack.suse.cz>
 <1298449487.14712.1064.camel@debian>
 <20110224121339.GE23042@quack.suse.cz>
 <AANLkTinAeQMy-OoYYpbYeX=EjZ_-uT=67Ktk1PbE=A7_@mail.gmail.com>
 <x49hbbmpqbo.fsf@segfault.boston.devel.redhat.com>
 <20110302094246.GA7496@quack.suse.cz>
 <x491v2p4i0u.fsf@segfault.boston.devel.redhat.com>
 <20110302211748.GF7496@quack.suse.cz>
 <x49lj0x0zve.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49lj0x0zve.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Jeff,
On Wed 02-03-11 20:14:13, Jeff Moyer wrote:
> So, the results are in.  The test workload is an fs_mark process writing
> out 64k files and fsyncing each file after it's written.  Concurrently
> with this is a fio job running a buffered sequential reader (bsr).  Each
> data point is the average of 10 runs, after throwing out the first run.
> File system mount options are left at their defaults, which means that
> barriers are on.  The storage is an HP EVA, connected to the host via a
> single 4Gb FC path.
  Thanks a lot for testing! BTW: fs_mark runs in a single thread or do you
use more threads?

> ext3 looks marginally better with your patches.  We get better files/sec
> AND better throughput from the buffered reader.  For ext4, the results
> are less encouraging.  We see a drop in files/sec, and an increase in
> throughput for the sequential reader.  So, the fsync-ing is being
> starved a bit more than before.
> 
>         ||       ext3        ||       ext4        ||
>         || fs_mark | fio bsr || fs_mark | fio bsr ||
> --------++---------+---------++---------+---------||
> vanilla || 517.535 | 178187  || 408.547 | 277130  ||
> patched || 540.34  | 182312  || 342.813 | 294655  ||
> ====================================================
> %diff   ||  +4.4% |    +2.3% ||  -16.1% |  +6.3%  ||
Interesting. I'm surprised ext3 and ext4 results differ this much. I'm more
than happy with ext3 results since I just wanted to verify that fsync load
doesn't degrade too much with the improved logic preferring non-fsync load
more than we used to.

I'm not so happy with ext4 results. The difference between ext3 and ext4
might be that amount of data written by kjournald in ext3 is considerably
larger if it ends up pushing out data (because of data=ordered mode) as
well. With ext4, all data are written by filemap_fdatawrite() from fsync
because of delayed allocation. And thus maybe for ext4 WRITE_SYNC_PLUG
is hurting us with your fast storage and small amount of written data? With
WRITE_SYNC, data would be already on it's way to storage before we get to
wait for them...

Or it could be that we really send more data in WRITE mode rather than in
WRITE_SYNC mode with the patch on ext4 (that should be verifiable with
blktrace). But I wonder how that could happen...

							Bye
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
