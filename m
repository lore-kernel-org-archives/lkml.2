Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab0FNSHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 14:07:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab0FNSHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 14:07:01 -0400
Date: Mon, 14 Jun 2010 14:06:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       Suresh Jayaraman <sjayaraman@suse.de>
Subject: Re: CFQ read performance regression
Message-ID: <20100614180653.GA2695@redhat.com>
References: <1271865911.24780.292.camel@tucsk.pomaz.szeredi.hu>
 <p2t4e5e476b1004220059u2263832atf36ee33ae83463fa@mail.gmail.com>
 <20100422203123.GF3228@redhat.com>
 <1272020222.24780.460.camel@tucsk.pomaz.szeredi.hu>
 <s2q4e5e476b1004241336lbd071624ke489350093ca6e1a@mail.gmail.com>
 <20100426191453.GE3372@redhat.com>
 <x2i4e5e476b1004271025u8571ae0fuaee6453eac97e929@mail.gmail.com>
 <20100428200222.GL16033@redhat.com>
 <h2p4e5e476b1005010513s850e4c0bv997642d45490e414@mail.gmail.com>
 <1276538353.3666.1.camel@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276538353.3666.1.camel@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 07:59:13PM +0200, Miklos Szeredi wrote:
> On Sat, 2010-05-01 at 14:13 +0200, Corrado Zoccolo wrote:
> > On Wed, Apr 28, 2010 at 10:02 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > On Tue, Apr 27, 2010 at 07:25:14PM +0200, Corrado Zoccolo wrote:
> > >> On Mon, Apr 26, 2010 at 9:14 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > >> > On Sat, Apr 24, 2010 at 10:36:48PM +0200, Corrado Zoccolo wrote:
> > >> >
> > >> > [..]
> > >> >> >> Anyway, if that's the case, then we probably need to allow IO from
> > >> >> >> multiple sequential readers and keep a watch on throughput. If throughput
> > >> >> >> drops then reduce the number of parallel sequential readers. Not sure how
> > >> >> >> much of code that is but with multiple cfqq going in parallel, ioprio
> > >> >> >> logic will more or less stop working in CFQ (on multi-spindle hardware).
> > >> >> Hi Vivek,
> > >> >> I tried to implement exactly what you are proposing, see the attached patches.
> > >> >> I leverage the queue merging features to let multiple cfqqs share the
> > >> >> disk in the same timeslice.
> > >> >> I changed the queue split code to trigger on throughput drop instead
> > >> >> of on seeky pattern, so diverging queues can remain merged if they
> > >> >> have good throughput. Moreover, I measure the max bandwidth reached by
> > >> >> single queues and merged queues (you can see the values in the
> > >> >> bandwidth sysfs file).
> > >> >> If merged queues can outperform non-merged ones, the queue merging
> > >> >> code will try to opportunistically merge together queues that cannot
> > >> >> submit enough requests to fill half of the NCQ slots. I'd like to know
> > >> >> if you can see any improvements out of this on your hardware. There
> > >> >> are some magic numbers in the code, you may want to try tuning them.
> > >> >> Note that, since the opportunistic queue merging will start happening
> > >> >> only after merged queues have shown to reach higher bandwidth than
> > >> >> non-merged queues, you should use the disk for a while before trying
> > >> >> the test (and you can check sysfs), or the merging will not happen.
> > >> >
> > >> > Hi Corrado,
> > >> >
> > >> > I ran these patches and I did not see any improvement. I think the reason
> > >> > being that no cooperative queue merging took place and we did not have
> > >> > any data for throughput with coop flag on.
> > >> >
> > >> > #cat /sys/block/dm-3/queue/iosched/bandwidth
> > >> > 230     753     0
> > >> >
> > >> > I think we need to implement something similiar to hw_tag detection logic
> > >> > where we allow dispatches from multiple sync-idle queues at a time and try
> > >> > to observe the BW. After certain window once we have observed the window,
> > >> > then set the system behavior accordingly.
> > >> Hi Vivek,
> > >> thanks for testing. Can you try changing the condition to enable the
> > >> queue merging to also consider the case in which max_bw[1] == 0 &&
> > >> max_bw[0] > 100MB/s (notice that max_bw is measured in
> > >> sectors/jiffie).
> > >> This should rule out low end disks, and enable merging where it can be
> > >> beneficial.
> > >> If the results are good, but we find this enabling condition
> > >> unreliable, then we can think of a better way, but I'm curious to see
> > >> if the results are promising before thinking to the details.
> > >
> > > Ok, I made some changes and now some queue merging seems to be happening
> > > and I am getting little better BW. This will require more debugging. I
> > > will try to spare some time later.
> > >
> > > Kernel=2.6.34-rc5-corrado-multicfq
> > > DIR= /mnt/iostmnt/fio          DEV= /dev/mapper/mpathe
> > > Workload=bsr       iosched=cfq      Filesz=1G    bs=16K
> > > ==========================================================================
> > > job       Set NR  ReadBW(KB/s)   MaxClat(us)    WriteBW(KB/s)  MaxClat(us)
> > > ---       --- --  ------------   -----------    -------------  -----------
> > > bsr       1   1   136457         67353          0              0
> > > bsr       1   2   148008         192415         0              0
> > > bsr       1   4   180223         535205         0              0
> > > bsr       1   8   166983         542326         0              0
> > > bsr       1   16  176617         832188         0              0
> > >
> > > Output of iosched/bandwidth
> > >
> > > 0       546     740
> > >
> > > I did following changes on top of your patch.
> > This is becoming interesting. I think a major limitation of the
> > current approach is that it is too easy for a merged queue to be
> > separated again.
> > My code:
> >    if (cfq_cfqq_coop(cfqq) && bw <= cfqd->max_bw[1] * 9/10)
> >                 cfq_mark_cfqq_split_coop(cfqq);
> > will immediately split any merged queue as soon as max_bw[1] grows too
> > much, so it should be based on max_bw[0].
> > Moreover, this code will likely split off all cics from the merged
> > queue, while it would be much better to split off only the cics that
> > are receiving less than their fair share of the BW (this will also
> > improve the fairness of the scheduler when queues are merged).
> 
> Is there any update on the status of this issue?

How about running cfq with slice_idle=0 on high end storage. This should make
it very close to deadline behavior?

There has not been any further progress on my end for merging more
sequential queues for achieving better throughput.

Thanks
Vivek
