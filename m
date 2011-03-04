Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999Ab1CDS2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 13:28:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759842Ab1CDS2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 13:28:05 -0500
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
	<x49d3m6j35j.fsf@segfault.boston.devel.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 04 Mar 2011 13:27:57 -0500
In-Reply-To: <x49d3m6j35j.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Fri, 04 Mar 2011 10:50:32 -0500")
Message-ID: <x491v2mivv6.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer <jmoyer@redhat.com> writes:

> Jan Kara <jack@suse.cz> writes:
>
>> I'm not so happy with ext4 results. The difference between ext3 and ext4
>> might be that amount of data written by kjournald in ext3 is considerably
>> larger if it ends up pushing out data (because of data=ordered mode) as
>> well. With ext4, all data are written by filemap_fdatawrite() from fsync
>> because of delayed allocation. And thus maybe for ext4 WRITE_SYNC_PLUG
>> is hurting us with your fast storage and small amount of written data? With
>> WRITE_SYNC, data would be already on it's way to storage before we get to
>> wait for them...
>
>> Or it could be that we really send more data in WRITE mode rather than in
>> WRITE_SYNC mode with the patch on ext4 (that should be verifiable with
>> blktrace). But I wonder how that could happen...
>
> It looks like this is the case, the I/O isn't coming down as
> synchronous.  I'm seeing a lot of writes, very few write sync's, which
> means that the write stream will be preempted by the incoming reads.
>
> Time to audit that fsync path and make sure it's marked properly, I
> guess.

OK, I spoke too soon.  Here's the blktrace summary information (I re-ran
the tests using 3 samples, the blktrace is from the last run of the
three in each case):

Vanilla
-------
fs_mark: 307.288 files/sec
fio: 286509 KB/s

Total (sde):
 Reads Queued:     341,558,   84,994MiB  Writes Queued:       1,561K,    6,244MiB
 Read Dispatches:  341,493,   84,994MiB  Write Dispatches:  648,046,    6,244MiB
 Reads Requeued:         0               Writes Requeued:        27
 Reads Completed:  341,491,   84,994MiB  Writes Completed:  648,021,    6,244MiB
 Read Merges:           65,    2,780KiB  Write Merges:      913,076,    3,652MiB
 IO unplugs:       578,102               Timer unplugs:           0

Throughput (R/W): 282,797KiB/s / 20,776KiB/s
Events (sde): 16,724,303 entries

Patched
-------
fs_mark: 278.587 files/sec
fio: 298007 KB/s

Total (sde):
 Reads Queued:     345,407,   86,834MiB  Writes Queued:       1,566K,    6,264MiB
 Read Dispatches:  345,391,   86,834MiB  Write Dispatches:  327,404,    6,264MiB
 Reads Requeued:         0               Writes Requeued:        33
 Reads Completed:  345,391,   86,834MiB  Writes Completed:  327,371,    6,264MiB
 Read Merges:           16,    1,576KiB  Write Merges:        1,238K,    4,954MiB
 IO unplugs:       580,308               Timer unplugs:           0

Throughput (R/W): 288,771KiB/s / 20,832KiB/s
Events (sde): 14,030,610 entries

So, it appears we flush out writes much more aggressively without the
patch in place.  I'm not sure why the write bandwidth looks to be higher
in the patched case... odd.

Cheers,
Jeff
