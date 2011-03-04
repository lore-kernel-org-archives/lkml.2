Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab1CDPko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:40:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759732Ab1CDPkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 10:40:42 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, "Alex\,Shi" <alex.shi@intel.com>,
        "Li\, Shaohua" <shaohua.li@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        "tytso\@mit.edu" <tytso@mit.edu>,
        "jaxboe\@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen\, Tim C" <tim.c.chen@intel.com>
Subject: Re: [performance bug] kernel building regression on 64 LCPUs machine
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
	<20110304153248.GC2649@quack.suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 04 Mar 2011 10:40:34 -0500
In-Reply-To: <20110304153248.GC2649@quack.suse.cz> (Jan Kara's message of
	"Fri, 4 Mar 2011 16:32:48 +0100")
Message-ID: <x49hbbij3m5.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>   Hi Jeff,
> On Wed 02-03-11 20:14:13, Jeff Moyer wrote:
>> So, the results are in.  The test workload is an fs_mark process writing
>> out 64k files and fsyncing each file after it's written.  Concurrently
>> with this is a fio job running a buffered sequential reader (bsr).  Each
>> data point is the average of 10 runs, after throwing out the first run.
>> File system mount options are left at their defaults, which means that
>> barriers are on.  The storage is an HP EVA, connected to the host via a
>> single 4Gb FC path.
>   Thanks a lot for testing! BTW: fs_mark runs in a single thread or do you
> use more threads?

I use a single fs_mark thread.  FWIW, I also tested just fs_mark, and
those numbers look good.

>> ext3 looks marginally better with your patches.  We get better files/sec
>> AND better throughput from the buffered reader.  For ext4, the results
>> are less encouraging.  We see a drop in files/sec, and an increase in
>> throughput for the sequential reader.  So, the fsync-ing is being
>> starved a bit more than before.
>> 
>>         ||       ext3        ||       ext4        ||
>>         || fs_mark | fio bsr || fs_mark | fio bsr ||
>> --------++---------+---------++---------+---------||
>> vanilla || 517.535 | 178187  || 408.547 | 277130  ||
>> patched || 540.34  | 182312  || 342.813 | 294655  ||
>> ====================================================
>> %diff   ||  +4.4% |    +2.3% ||  -16.1% |  +6.3%  ||
> Interesting. I'm surprised ext3 and ext4 results differ this much. I'm more
> than happy with ext3 results since I just wanted to verify that fsync load
> doesn't degrade too much with the improved logic preferring non-fsync load
> more than we used to.
>
> I'm not so happy with ext4 results. The difference between ext3 and ext4
> might be that amount of data written by kjournald in ext3 is considerably
> larger if it ends up pushing out data (because of data=ordered mode) as
> well. With ext4, all data are written by filemap_fdatawrite() from fsync
> because of delayed allocation. And thus maybe for ext4 WRITE_SYNC_PLUG
> is hurting us with your fast storage and small amount of written data? With
> WRITE_SYNC, data would be already on it's way to storage before we get to
> wait for them...
>
> Or it could be that we really send more data in WRITE mode rather than in
> WRITE_SYNC mode with the patch on ext4 (that should be verifiable with
> blktrace). But I wonder how that could happen...

Yeah, I've collected blktrace data and I'll get to evaluating that.
Sorry, I ran out of time yesterday.

Cheers,
Jeff
