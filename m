Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466Ab1CaPrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:47:45 -0400
Received: from smtpbg52.qq.com ([64.71.138.43]:58507 "HELO smtpbg52.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758370Ab1CaPro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:47:44 -0400
X-QQ-mid: esmtp5t1301586388t827t20329
X-QQ-SSF: 00000000000000F0FG400F000000000
Date: Thu, 31 Mar 2011 23:46:37 +0800
From: "Lina Lu" <lulina_nuaa@foxmail.com>
To: "Vivek Goyal" <vgoyal@redhat.com>
Cc: "linux kernel mailing list" <linux-kernel@vger.kernel.org>
References: <201103302323256090890@foxmail.com>
Subject: Re: Re: cfq-iosched.c:Use cfqq->nr_sectors in charge the vdisktime
Message-ID: <201103312346349842625@foxmail.com>
X-mailer: Foxmail 6, 15, 201, 23 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-30 23:54:34, Vivek Goyal wrote:
> On Wed, Mar 30, 2011 at 11:23:30PM +0800, Lina Lu wrote:
> > Hi Vivek,
> >       I find the weight policy can be more accuracy with cfqq->nr_sectors instead
> > of cfqq->slice_dispatch. 
> >       Today, I try to modify cfq_group_served(), and use "charge = cfqq->nr_sectors; "
> > instead of "charge = cfqq->slice_dispatch; " . The test result seens more accuracy.
> > Why you choose slice_dispatch here? Is the nr_sectors will lower the total performance?
> 
> Lina,
> 
> CFQ fundamentally allocates time slices hence accounting is done in time
> and not in terms of sectors. The other reason is that accounting in
> terms of time can be more accurate where some process is seeking all
> over the disk and doing little IO. If we account in terms of sectors
> then such seeky process will get much more share.
> 
> >       And in iops mod, if I try to apply weight policy on two IO processes with different 
> > avgrq-sz, the test results will not exact match the weight value.
> 
> IOPS mode kicks in when slice_idle=0. I suspect that group does not drive
> enough IO to remain on service tree hence gets deleted and hence loses
> share.
> 
> Can you run a 20 sec backtrace and upload it somewhere.
> 

Here is 20 sec backtrace: 
http://www.fileden.com/files/2010/9/9/2965145/cfq_log.tar.gz

This time, I set two IO pid with weight 100, and the device is in iops_mod.  
linux-kzr4:/home/blkio # cat tst1/blkio.weight
100
linux-kzr4:/home/blkio # cat tst2/blkio.weight
100

iostat:
Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
dm-0              0.00     0.00  855.50    0.00     3.34     0.00     8.00     0.82    1.06   0.95  81.70
dm-1              0.00     0.00  844.00    0.00    26.38     0.00    64.00     0.83    0.98   0.98  82.60
Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
dm-0              0.00     0.00  840.00    0.00     3.28     0.00     8.00     0.90    0.95   1.07  89.55
dm-1              0.00     0.00  794.00    0.00    24.81     0.00    64.00     0.87    1.10   1.10  87.00
Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
dm-0              0.00     0.00  596.50    0.00     2.33     0.00     8.00     0.96    1.77   1.61  95.80
dm-1              0.00     0.00  626.00    0.00    19.56     0.00    64.00     0.94    1.48   1.50  93.70
Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
dm-0              0.00     0.00  815.50    0.00     3.19     0.00     8.00     0.81    0.83   1.00  81.40
dm-1              0.00     0.00  828.50    0.00    25.89     0.00    64.00     0.77    0.95   0.93  77.45
Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
dm-0              0.00     0.00  910.50    0.00     3.56     0.00     8.00     0.82    1.00   0.90  82.15
dm-1              0.00     0.00  845.00    0.00    26.41     0.00    64.00     0.81    0.96   0.96  80.95
Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
dm-0              0.00     0.00  928.86    0.00     3.63     0.00     8.00     0.79    0.90   0.86  79.45
dm-1              0.00     0.00  848.26    0.00    26.51     0.00    64.00     0.65    0.77   0.77  65.17

>From the result, we can see that the iops match the weight value very well, but
the rMB/s are not the same as they has different avgrq-sz.

If I use the following patch, the rMB/s will be more accuracy.

--- block/cfq-iosched.c     2011-03-31 23:43:55.000000000 +0800
+++ block/cfq-iosched.c 2011-03-31 23:44:30.000000000 +0800
@@ -951,7 +951,7 @@
        used_sl = charge = cfq_cfqq_slice_usage(cfqq);

        if (iops_mode(cfqd))
-               charge = cfqq->slice_dispatch;
+               charge = cfqq->nr_sectors;
        else if (!cfq_cfqq_sync(cfqq) && !nr_sync)
                charge = cfqq->allocated_slice;

Thanks
Lina
 
