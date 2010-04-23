Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab0DWK5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 06:57:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970Ab0DWK5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 06:57:02 -0400
Subject: Re: CFQ read performance regression
From: Miklos Szeredi <mszeredi@suse.cz>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       Suresh Jayaraman <sjayaraman@suse.de>
In-Reply-To: <20100422203123.GF3228@redhat.com>
References: <1271420878.24780.145.camel@tucsk.pomaz.szeredi.hu>
	 <h2m4e5e476b1004170546z8997cd90h98ecfb9cc5aad8cf@mail.gmail.com>
	 <1271677562.24780.184.camel@tucsk.pomaz.szeredi.hu>
	 <j2t4e5e476b1004201350xbd08a002l3329fbdd4fb1b8db@mail.gmail.com>
	 <1271856324.24780.285.camel@tucsk.pomaz.szeredi.hu>
	 <1271865911.24780.292.camel@tucsk.pomaz.szeredi.hu>
	 <p2t4e5e476b1004220059u2263832atf36ee33ae83463fa@mail.gmail.com>
	 <20100422203123.GF3228@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Apr 2010 12:57:02 +0200
Message-ID: <1272020222.24780.460.camel@tucsk.pomaz.szeredi.hu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-22 at 16:31 -0400, Vivek Goyal wrote:
> On Thu, Apr 22, 2010 at 09:59:14AM +0200, Corrado Zoccolo wrote:
> > Hi Miklos,
> > On Wed, Apr 21, 2010 at 6:05 PM, Miklos Szeredi <mszeredi@suse.cz> wrote:
> > > Jens, Corrado,
> > >
> > > Here's a graph showing the number of issued but not yet completed
> > > requests versus time for CFQ and NOOP schedulers running the tiobench
> > > benchmark with 8 threads:
> > >
> > > http://www.kernel.org/pub/linux/kernel/people/mszeredi/blktrace/queue-depth.jpg
> > >
> > > It shows pretty clearly the performance problem is because CFQ is not
> > > issuing enough request to fill the bandwidth.
> > >
> > > Is this the correct behavior of CFQ or is this a bug?
> >  This is the expected behavior from CFQ, even if it is not optimal,
> > since we aren't able to identify multi-splindle disks yet.
> 
> In the past we were of the opinion that for sequential workload multi spindle
> disks will not matter much as readahead logic (in OS and possibly in
> hardware also) will help. For random workload we anyway don't idle on the
> single cfqq so it is fine. But my tests now seem to be telling a different
> story.
> 
> I also have one FC link to one of the HP EVA and I am running increasing 
> number of sequential readers to see if throughput goes up as number of
> readers go up. The results are with noop and cfq. I do flush OS caches
> across the runs but I have no control on caching on HP EVA.
> 
> Kernel=2.6.34-rc5 
> DIR=/mnt/iostestmnt/fio        DEV=/dev/mapper/mpathe        
> Workload=bsr      iosched=cfq     Filesz=2G   bs=4K   
> =========================================================================
> job       Set NR  ReadBW(KB/s)   MaxClat(us)    WriteBW(KB/s)  MaxClat(us)    
> ---       --- --  ------------   -----------    -------------  -----------    
> bsr       1   1   135366         59024          0              0              
> bsr       1   2   124256         126808         0              0              
> bsr       1   4   132921         341436         0              0              
> bsr       1   8   129807         392904         0              0              
> bsr       1   16  129988         773991         0              0              
> 
> Kernel=2.6.34-rc5             
> DIR=/mnt/iostestmnt/fio        DEV=/dev/mapper/mpathe        
> Workload=bsr      iosched=noop    Filesz=2G   bs=4K   
> =========================================================================
> job       Set NR  ReadBW(KB/s)   MaxClat(us)    WriteBW(KB/s)  MaxClat(us)    
> ---       --- --  ------------   -----------    -------------  -----------    
> bsr       1   1   126187         95272          0              0              
> bsr       1   2   185154         72908          0              0              
> bsr       1   4   224622         88037          0              0              
> bsr       1   8   285416         115592         0              0              
> bsr       1   16  348564         156846         0              0              
> 

These numbers are very similar to what I got.

> So in case of NOOP, throughput shotup to 348MB/s but CFQ reamains more or
> less constat, about 130MB/s.
> 
> So atleast in this case, a single sequential CFQ queue is not keeing the
> disk busy enough.
> 
> I am wondering why my testing results were different in the past. May be
> it was a different piece of hardware and behavior various across hardware?

Probably.  I haven't seen this type of behavior on other hardware.

> Anyway, if that's the case, then we probably need to allow IO from
> multiple sequential readers and keep a watch on throughput. If throughput
> drops then reduce the number of parallel sequential readers. Not sure how
> much of code that is but with multiple cfqq going in parallel, ioprio
> logic will more or less stop working in CFQ (on multi-spindle hardware).

Have you tested on older kernels?  Around 2.6.16 it seemed to allow more
parallel reads, but that might have been just accidental (due to I/O
being submitted in a different pattern).

Thanks,
Miklos

