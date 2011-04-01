Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab1DAPWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:22:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab1DAPWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:22:47 -0400
Date: Fri, 1 Apr 2011 11:22:13 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Lina Lu <lulina_nuaa@foxmail.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Re: Re: cfq-iosched.c:Use cfqq->nr_sectors in charge the
 vdisktime
Message-ID: <20110401152213.GC20986@redhat.com>
References: <201103302323256090890@foxmail.com>
 <201103312346349842625@foxmail.com>
 <201104012259493129784@foxmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104012259493129784@foxmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 10:59:52PM +0800, Lina Lu wrote:
> On 2011-04-01 03:47:18, Vivek Goyal wrote:
> > On Thu, Mar 31, 2011 at 11:46:37PM +0800, Lina Lu wrote:
> > > On 2011-03-30 23:54:34, Vivek Goyal wrote:
> > > [..]
> > >    
> > > Here is 20 sec backtrace: 
> > > http://www.fileden.com/files/2010/9/9/2965145/cfq_log.tar.gz
> > > 
> > > This time, I set two IO pid with weight 100, and the device is in iops_mod.  
> > 
> > How did you put device in iops mode? What's the device you are using and
> > what kind of configuration dm-0 and dm-1 are in.
> 
> I echo 0 to /sys/block/sdb/queue/iosched/slice_idle to put the device in iops mod.
> 
> Here is the dmsetup table:
> sdbtest-2: 0 2097152 linear 8:16 23068672
> sdbtest-1: 0 2097152 linear 8:16 20971520     
> 
> Device dm-0 is sdbtest-1, and dm-1 is sdbtest-2. They are all linear logic devices 
> on sdb.
> 
> > 
> > > linux-kzr4:/home/blkio # cat tst1/blkio.weight
> > > 100
> > > linux-kzr4:/home/blkio # cat tst2/blkio.weight
> > > 100
> > > 
> > > iostat:
> > > Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> > > dm-0              0.00     0.00  855.50    0.00     3.34     0.00     8.00     0.82    1.06   0.95  81.70
> > > dm-1              0.00     0.00  844.00    0.00    26.38     0.00    64.00     0.83    0.98   0.98  82.60
> > > Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> > > dm-0              0.00     0.00  840.00    0.00     3.28     0.00     8.00     0.90    0.95   1.07  89.55
> > > dm-1              0.00     0.00  794.00    0.00    24.81     0.00    64.00     0.87    1.10   1.10  87.00
> > > Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> > > dm-0              0.00     0.00  596.50    0.00     2.33     0.00     8.00     0.96    1.77   1.61  95.80
> > > dm-1              0.00     0.00  626.00    0.00    19.56     0.00    64.00     0.94    1.48   1.50  93.70
> > > Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> > > dm-0              0.00     0.00  815.50    0.00     3.19     0.00     8.00     0.81    0.83   1.00  81.40
> > > dm-1              0.00     0.00  828.50    0.00    25.89     0.00    64.00     0.77    0.95   0.93  77.45
> > > Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> > > dm-0              0.00     0.00  910.50    0.00     3.56     0.00     8.00     0.82    1.00   0.90  82.15
> > > dm-1              0.00     0.00  845.00    0.00    26.41     0.00    64.00     0.81    0.96   0.96  80.95
> > > Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> > > dm-0              0.00     0.00  928.86    0.00     3.63     0.00     8.00     0.79    0.90   0.86  79.45
> > > dm-1              0.00     0.00  848.26    0.00    26.51     0.00    64.00     0.65    0.77   0.77  65.17
> > > 
> > > >From the result, we can see that the iops match the weight value very well, but
> > > the rMB/s are not the same as they has different avgrq-sz.
> > > 
> > > If I use the following patch, the rMB/s will be more accuracy.
> > > 
> > > --- block/cfq-iosched.c     2011-03-31 23:43:55.000000000 +0800
> > > +++ block/cfq-iosched.c 2011-03-31 23:44:30.000000000 +0800
> > > @@ -951,7 +951,7 @@
> > >         used_sl = charge = cfq_cfqq_slice_usage(cfqq);
> > > 
> > >         if (iops_mode(cfqd))
> > > -               charge = cfqq->slice_dispatch;
> > > +               charge = cfqq->nr_sectors;
> > 
> > In IOPS mode we calculate the number of IOPS (that is number of requests
> > dispatched) and not number of sectors. nr_sectors is more of getting
> > the equal bandwidth even when we are operating at different request sizes.
> > So instead of operating in iops mode, if you operate in regular time
> > based mode, you should get better results.
> > 
> > Why are you not using regular time based fairness mode?
> > 
> 
> I did the same test in regular time based fairness mode without the above patch.
> 
> Here is iostat result:
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> dm-0              0.00     0.00 1813.00    0.00     7.08     0.00     8.00     0.81    0.42   0.45  81.40
> dm-1              0.00     0.00  627.00    0.00    19.59     0.00    64.00     0.92    1.61   1.47  92.20
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> dm-0              0.00     0.00 1799.00    0.00     7.03     0.00     8.00     0.80    0.44   0.44  80.00
> dm-1              0.00     0.00  660.00    0.00    20.62     0.00    64.00     0.95    1.44   1.43  94.70
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> dm-0              0.00     0.00 1875.00    0.00     7.32     0.00     8.00     0.68    0.39   0.36  67.60
> dm-1              0.00     0.00  540.00    0.00    16.88     0.00    64.00     0.94    1.59   1.75  94.50
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> dm-0              0.00     0.00 1494.06    0.00     5.84     0.00     8.00     0.73    0.45   0.49  73.27
> dm-1              0.00     0.00  688.12    0.00    21.50     0.00    64.00     0.90    1.44   1.31  90.40
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> dm-0              0.00     0.00 2079.00    0.00     8.12     0.00     8.00     0.80    0.41   0.38  79.50
> dm-1              0.00     0.00  623.00    0.00    19.47     0.00    64.00     0.94    1.43   1.50  93.70
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> dm-0              0.00     0.00 1991.00    0.00     7.78     0.00     8.00     0.87    0.44   0.44  86.80
> dm-1              0.00     0.00  708.00    0.00    22.12     0.00    64.00     0.89    1.25   1.26  89.30
> 
> If I apply the above patch, and test in iops mode, the bandwidth will be equal.
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> dm-0              0.00     0.00 2579.00    0.00    10.07     0.00     8.00     0.92    0.35   0.36  91.80
> dm-1              0.00     0.00  253.00    0.00     7.91     0.00    64.00     0.98    3.93   3.88  98.10
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> dm-0              0.00     0.00 2394.00    0.00     9.35     0.00     8.00     0.93    0.40   0.39  93.00
> dm-1              0.00     0.00  326.00    0.00    10.19     0.00    64.00     0.91    2.41   2.80  91.30
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> dm-0              0.00     0.00 2339.00    0.00     9.14     0.00     8.00     0.91    0.37   0.39  90.50
> dm-1              0.00     0.00  267.00    0.00     8.34     0.00    64.00     0.97    4.10   3.63  96.90
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> dm-0              0.00     0.00 2298.00    0.00     8.98     0.00     8.00     0.59    0.25   0.26  59.00
> dm-1              0.00     0.00  286.00    0.00     8.94     0.00    64.00     0.98    3.43   3.43  98.10
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> dm-0              0.00     0.00 2298.00    0.00     8.98     0.00     8.00     0.37    0.18   0.16  37.00
> dm-1              0.00     0.00  292.00    0.00     9.12     0.00    64.00     0.98    2.83   3.35  97.80
> 
> But it seens the total performance is lower.

Lina, 

We really don't have any equal bandwidth mode. In time mode, every queue
is given specific time slice of disk. If a group is doing bigger size
IO and can get higher bandwidth from disk in allotted time slice then
it makes sense. That group made better use of its time slice.

Trying to penalize the group which is doing bigger size IO because some
other group is doing small size IO does not make much sense to me. Similar
thing is true for sequential vs seeky load. If you run sequential
process on dm-0 and seeky process on dm-1, you will see overall bandwdith
difference.

If you want to give higher bandwidth to the group doing small size
IO, just bump up its weight and you should get similar results as
you are getting with your patch applied.

Thanks
Vivek
