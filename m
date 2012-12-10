Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab2LJQDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 11:03:06 -0500
Received: from mx2.fusionio.com ([66.114.96.31]:52230 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab2LJQDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 11:03:03 -0500
X-ASG-Debug-ID: 1355155381-0421b549eb79820001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Mon, 10 Dec 2012 11:02:59 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Chris Mason <clmason@fusionio.com>
CC: Dave Chinner <david@fromorbit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121210160259.GA20541@shiny>
X-ASG-Orig-Subj: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Chris Mason <clmason@fusionio.com>,
	Dave Chinner <david@fromorbit.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Martin Steigerwald <Martin@lichtvoll.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <20121126091202.GO32450@dastard>
 <201212051148.28039.Martin@lichtvoll.de>
 <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
 <20121206120532.GA14100@infradead.org>
 <20121207011628.GB16373@gmail.com>
 <50C22923.90102@redhat.com>
 <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org>
 <20121207190306.GB14972@shiny>
 <20121208001705.GO27172@dastard>
 <20121208013949.GD25713@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121208013949.GD25713@shiny>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1355155381
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.73
X-Barracuda-Spam-Status: No, SCORE=0.73 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_SA_TO_FROM_DOMAIN_MATCH, CN_BODY_332, COMMA_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.116623
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.60 COMMA_SUBJECT          Subject is like 'Re: FDSDS, this is a subject'
	0.12 CN_BODY_332            BODY: CN_BODY_332
	0.01 BSF_SC0_SA_TO_FROM_DOMAIN_MATCH Sender Domain Matches Recipient
	                           Domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 06:39:49PM -0700, Chris Mason wrote:
> On Fri, Dec 07, 2012 at 05:17:05PM -0700, Dave Chinner wrote:
> > On Fri, Dec 07, 2012 at 02:03:06PM -0500, Chris Mason wrote:
> > > On a single flash drive doing random 4K writes, xfs does 950MB/s into
> > > regular extents but only 400MB/s into preallocated extents.
> > > 
> > > http://masoncoding.com/presentation/perf-linuxcon12/fallocate.png
> > 
> > This is bordering on irrelevancy, but can you provide the workload
> > you were running to generate this graph?  Random 4k writes could be
> > anything, really.
> 
> This one was fio aio/dio, I'll dig out the job file and rerun it on
> 3.7-rc on Monday.  Any real random write is going to show this with
> enough load.

Ok, I ran this against 3.6.  Since my box has two iodrives in it now, I
tossed them into lvm and ran striped over both.  A single drive is iop
bound at 1GB/s, and we're able to push 2GB/s over both.  LVM slows it
down slightly, and if you let the runs go long enough, you can see the
little log structured squirrels jumping in from time to time.

Long story short, on the lvm block device we average about 1.7GB/s over
the two drives.  This is iop bound, the two cards can push about 2.6GB/s
doing streaming writes.

XFS without preallocation comes very close to the iops bound number.
This is really impressive, but it also means every additional IO to track
the preallocation is going to hurt the bottom line.

With preallocation on, the speed is the same with one drive as with two.
Eric had asked me to do a run with holes, and they come out a little
worse than preallocated.

Graphs:

http://masoncoding.com/mason/benchmark/xfs-fallocate/xfs-random-write-compare.png

The fio job is in that xfs-fallocate directory, and included below.

-chris

[global]
bs=4k
direct=1
ioengine=aio
size=12g
rw=randwrite
norandommap
runtime=30
iodepth=1024

# set overwrite=1 to force us to fully overwrite
# the preallocated files before the random IO starts
#
#overwrite=1

# set fallocate=none to ues sparse files
#fallocate=none

# run 4 jobs where each job is operating on
# only one file.  This way there's no lock contention
# on the file itself.
#
[f1]
filename=/mnt/f1
[f1]
filename=/mnt/f2
[f1]
filename=/mnt/f3
[f1]
filename=/mnt/f4

