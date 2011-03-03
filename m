Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab1CCBOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 20:14:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555Ab1CCBOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 20:14:23 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, "Alex\,Shi" <alex.shi@intel.com>,
        "Li\, Shaohua" <shaohua.li@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        "tytso\@mit.edu" <tytso@mit.edu>,
        "jaxboe\@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen\, Tim C" <tim.c.chen@intel.com>
Subject: Re: [performance bug] kernel building regression on 64 LCPUs machine
References: <AANLkTi=B6kabp+NvRJC_g-AqQO0ZOvnEDYpVFmScttR6@mail.gmail.com>
	<1297650318.29573.2482.camel@debian>
	<1297732201.24560.2.camel@sli10-conroe>
	<20110221164909.GG6584@quack.suse.cz>
	<1298449487.14712.1064.camel@debian>
	<20110224121339.GE23042@quack.suse.cz>
	<AANLkTinAeQMy-OoYYpbYeX=EjZ_-uT=67Ktk1PbE=A7_@mail.gmail.com>
	<x49hbbmpqbo.fsf@segfault.boston.devel.redhat.com>
	<20110302094246.GA7496@quack.suse.cz>
	<x491v2p4i0u.fsf@segfault.boston.devel.redhat.com>
	<20110302211748.GF7496@quack.suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 02 Mar 2011 20:14:13 -0500
In-Reply-To: <20110302211748.GF7496@quack.suse.cz> (Jan Kara's message of
	"Wed, 2 Mar 2011 22:17:48 +0100")
Message-ID: <x49lj0x0zve.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jan,

So, the results are in.  The test workload is an fs_mark process writing
out 64k files and fsyncing each file after it's written.  Concurrently
with this is a fio job running a buffered sequential reader (bsr).  Each
data point is the average of 10 runs, after throwing out the first run.
File system mount options are left at their defaults, which means that
barriers are on.  The storage is an HP EVA, connected to the host via a
single 4Gb FC path.

ext3 looks marginally better with your patches.  We get better files/sec
AND better throughput from the buffered reader.  For ext4, the results
are less encouraging.  We see a drop in files/sec, and an increase in
throughput for the sequential reader.  So, the fsync-ing is being
starved a bit more than before.

        ||       ext3        ||       ext4        ||
        || fs_mark | fio bsr || fs_mark | fio bsr ||
--------++---------+---------++---------+---------||
vanilla || 517.535 | 178187  || 408.547 | 277130  ||
patched || 540.34  | 182312  || 342.813 | 294655  ||
====================================================
%diff   ||  +4.4% |    +2.3% ||  -16.1% |  +6.3%  ||

I'm tired right now, but I'll have a look at your ext4 patch in the
morning and see if I can come up with a good reason for this drop.

Let me know if you have any questions.

Cheers,
Jeff
