Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab1CCAqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 19:46:31 -0500
Received: from mga03.intel.com ([143.182.124.21]:19219 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755960Ab1CCAq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 19:46:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,256,1297065600"; 
   d="scan'208";a="396661414"
Subject: Re: cfq-iosched preempt issues
From: Shaohua Li <shaohua.li@intel.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "czoccolo@gmail.com" <czoccolo@gmail.com>,
        "guijianfeng@cn.fujitsu.com" <guijianfeng@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <x49wrkh33ar.fsf@segfault.boston.devel.redhat.com>
References: <20110302124341.GA23940@sli10-conroe.sh.intel.com>
	 <x49wrkh33ar.fsf@segfault.boston.devel.redhat.com>
Content-Type: multipart/mixed; boundary="=-6Srf6V01cBhhY9i0oo79"
Date: Thu, 03 Mar 2011 08:46:16 +0800
Message-ID: <1299113176.19589.69.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6Srf6V01cBhhY9i0oo79
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Thu, 2011-03-03 at 00:17 +0800, Jeff Moyer wrote:
> Shaohua Li <shaohua.li@intel.com> writes:
> 
> > queue preemption is good for some workloads and not for others. With commit
> > f8ae6e3eb825, the impact is amplified. I currently have two issues with it:
> > 1. In a multi-threaded workload, each thread runs a random read/write (for
> > example, mmap write) with iodepth 1. I found the queue depth gets smaller
> > with commit f8ae6e3eb825. The reason is write gets preempted, so more threads
> > are waitting for write, and on the other hand, there are less threads doing
> > read. This will make the queue depth small, so performance drops a little.
> > So in this case, speed up write can speed up read too, but we can't detect
> > it.
> 
> I don't fully understand your workload.  What is the aio-stress or fio
> command line/config file?
ha, sure, this is a fio workload. attached is the fio script. it's
basically a simple mmap rand write workload.

> > 2. cfq_may_dispatch doesn't limit queue depth if the queue is the sole queue.
> > What about if there are two queues, one sync and one async? If the sync queue's
> > think time is small, we can treat it as the sole queue, because the sync queue
> > will preempt async queue, so we don't need care about the async queue's latency.
> > The issue exists before, but f8ae6e3eb825 amplifies it. Below is a patch for it.
> 
> I'm not sure I entirely agree with that reasoning.  Do you have real
> workloads that are regressing due to this commit, or is it just these
> cooked up benchmarks?
this is an aiostress with option: '-O -l -L -s 1200m -i 1 -r 16k'
the random read throughput has impact with preemption.

Thanks,
Shaohua

--=-6Srf6V01cBhhY9i0oo79
Content-Disposition: attachment; filename="jobfile"
Content-Type: text/plain; name="jobfile"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[global]
direct=0
ioengine=mmap
size=8G
bs=4k
numjobs=1
loops=5
overwrite=1
runtime=600
group_reporting
invalidate=0
directory=/mnt/stp/fiodata
file_service_type=random:36

[job_sdb1_sub0]
startdelay=0
rw=randwrite
filename=data0/f1:data0/f2:data0/f3:data0/f4:data0/f5:data0/f6:data0/f7:data0/f8

[job_sdb1_sub1]
startdelay=0
rw=randwrite
filename=data0/f2:data0/f3:data0/f4:data0/f5:data0/f6:data0/f7:data0/f8:data0/f1

[job_sdb1_sub2]
startdelay=0
rw=randwrite
filename=data0/f3:data0/f4:data0/f5:data0/f6:data0/f7:data0/f8:data0/f1:data0/f2

[job_sdb1_sub3]
startdelay=0
rw=randwrite
filename=data0/f4:data0/f5:data0/f6:data0/f7:data0/f8:data0/f1:data0/f2:data0/f3

[job_sdb1_sub4]
startdelay=0
rw=randwrite
filename=data0/f5:data0/f6:data0/f7:data0/f8:data0/f1:data0/f2:data0/f3:data0/f4

[job_sdb1_sub5]
startdelay=0
rw=randwrite
filename=data0/f6:data0/f7:data0/f8:data0/f1:data0/f2:data0/f3:data0/f4:data0/f5

[job_sdb1_sub6]
startdelay=0
rw=randwrite
filename=data0/f7:data0/f8:data0/f1:data0/f2:data0/f3:data0/f4:data0/f5:data0/f6

[job_sdb1_sub7]
startdelay=0
rw=randwrite
filename=data0/f8:data0/f1:data0/f2:data0/f3:data0/f4:data0/f5:data0/f6:data0/f7

[job_sdc1_sub0]
startdelay=0
rw=randwrite
filename=data1/f1:data1/f2:data1/f3:data1/f4:data1/f5:data1/f6:data1/f7:data1/f8

[job_sdc1_sub1]
startdelay=0
rw=randwrite
filename=data1/f2:data1/f3:data1/f4:data1/f5:data1/f6:data1/f7:data1/f8:data1/f1

[job_sdc1_sub2]
startdelay=0
rw=randwrite
filename=data1/f3:data1/f4:data1/f5:data1/f6:data1/f7:data1/f8:data1/f1:data1/f2

[job_sdc1_sub3]
startdelay=0
rw=randwrite
filename=data1/f4:data1/f5:data1/f6:data1/f7:data1/f8:data1/f1:data1/f2:data1/f3

[job_sdc1_sub4]
startdelay=0
rw=randwrite
filename=data1/f5:data1/f6:data1/f7:data1/f8:data1/f1:data1/f2:data1/f3:data1/f4

[job_sdc1_sub5]
startdelay=0
rw=randwrite
filename=data1/f6:data1/f7:data1/f8:data1/f1:data1/f2:data1/f3:data1/f4:data1/f5

[job_sdc1_sub6]
startdelay=0
rw=randwrite
filename=data1/f7:data1/f8:data1/f1:data1/f2:data1/f3:data1/f4:data1/f5:data1/f6

[job_sdc1_sub7]
startdelay=0
rw=randwrite
filename=data1/f8:data1/f1:data1/f2:data1/f3:data1/f4:data1/f5:data1/f6:data1/f7

[job_sdd1_sub0]
startdelay=0
rw=randwrite
filename=data2/f1:data2/f2:data2/f3:data2/f4:data2/f5:data2/f6:data2/f7:data2/f8

[job_sdd1_sub1]
startdelay=0
rw=randwrite
filename=data2/f2:data2/f3:data2/f4:data2/f5:data2/f6:data2/f7:data2/f8:data2/f1

[job_sdd1_sub2]
startdelay=0
rw=randwrite
filename=data2/f3:data2/f4:data2/f5:data2/f6:data2/f7:data2/f8:data2/f1:data2/f2

[job_sdd1_sub3]
startdelay=0
rw=randwrite
filename=data2/f4:data2/f5:data2/f6:data2/f7:data2/f8:data2/f1:data2/f2:data2/f3

[job_sdd1_sub4]
startdelay=0
rw=randwrite
filename=data2/f5:data2/f6:data2/f7:data2/f8:data2/f1:data2/f2:data2/f3:data2/f4

[job_sdd1_sub5]
startdelay=0
rw=randwrite
filename=data2/f6:data2/f7:data2/f8:data2/f1:data2/f2:data2/f3:data2/f4:data2/f5

[job_sdd1_sub6]
startdelay=0
rw=randwrite
filename=data2/f7:data2/f8:data2/f1:data2/f2:data2/f3:data2/f4:data2/f5:data2/f6

[job_sdd1_sub7]
startdelay=0
rw=randwrite
filename=data2/f8:data2/f1:data2/f2:data2/f3:data2/f4:data2/f5:data2/f6:data2/f7

[job_sde1_sub0]
startdelay=0
rw=randwrite
filename=data3/f1:data3/f2:data3/f3:data3/f4:data3/f5:data3/f6:data3/f7:data3/f8

[job_sde1_sub1]
startdelay=0
rw=randwrite
filename=data3/f2:data3/f3:data3/f4:data3/f5:data3/f6:data3/f7:data3/f8:data3/f1

[job_sde1_sub2]
startdelay=0
rw=randwrite
filename=data3/f3:data3/f4:data3/f5:data3/f6:data3/f7:data3/f8:data3/f1:data3/f2

[job_sde1_sub3]
startdelay=0
rw=randwrite
filename=data3/f4:data3/f5:data3/f6:data3/f7:data3/f8:data3/f1:data3/f2:data3/f3

[job_sde1_sub4]
startdelay=0
rw=randwrite
filename=data3/f5:data3/f6:data3/f7:data3/f8:data3/f1:data3/f2:data3/f3:data3/f4

[job_sde1_sub5]
startdelay=0
rw=randwrite
filename=data3/f6:data3/f7:data3/f8:data3/f1:data3/f2:data3/f3:data3/f4:data3/f5

[job_sde1_sub6]
startdelay=0
rw=randwrite
filename=data3/f7:data3/f8:data3/f1:data3/f2:data3/f3:data3/f4:data3/f5:data3/f6

[job_sde1_sub7]
startdelay=0
rw=randwrite
filename=data3/f8:data3/f1:data3/f2:data3/f3:data3/f4:data3/f5:data3/f6:data3/f7

[job_sdf1_sub0]
startdelay=0
rw=randwrite
filename=data4/f1:data4/f2:data4/f3:data4/f4:data4/f5:data4/f6:data4/f7:data4/f8

[job_sdf1_sub1]
startdelay=0
rw=randwrite
filename=data4/f2:data4/f3:data4/f4:data4/f5:data4/f6:data4/f7:data4/f8:data4/f1

[job_sdf1_sub2]
startdelay=0
rw=randwrite
filename=data4/f3:data4/f4:data4/f5:data4/f6:data4/f7:data4/f8:data4/f1:data4/f2

[job_sdf1_sub3]
startdelay=0
rw=randwrite
filename=data4/f4:data4/f5:data4/f6:data4/f7:data4/f8:data4/f1:data4/f2:data4/f3

[job_sdf1_sub4]
startdelay=0
rw=randwrite
filename=data4/f5:data4/f6:data4/f7:data4/f8:data4/f1:data4/f2:data4/f3:data4/f4

[job_sdf1_sub5]
startdelay=0
rw=randwrite
filename=data4/f6:data4/f7:data4/f8:data4/f1:data4/f2:data4/f3:data4/f4:data4/f5

[job_sdf1_sub6]
startdelay=0
rw=randwrite
filename=data4/f7:data4/f8:data4/f1:data4/f2:data4/f3:data4/f4:data4/f5:data4/f6

[job_sdf1_sub7]
startdelay=0
rw=randwrite
filename=data4/f8:data4/f1:data4/f2:data4/f3:data4/f4:data4/f5:data4/f6:data4/f7

[job_sdg1_sub0]
startdelay=0
rw=randwrite
filename=data5/f1:data5/f2:data5/f3:data5/f4:data5/f5:data5/f6:data5/f7:data5/f8

[job_sdg1_sub1]
startdelay=0
rw=randwrite
filename=data5/f2:data5/f3:data5/f4:data5/f5:data5/f6:data5/f7:data5/f8:data5/f1

[job_sdg1_sub2]
startdelay=0
rw=randwrite
filename=data5/f3:data5/f4:data5/f5:data5/f6:data5/f7:data5/f8:data5/f1:data5/f2

[job_sdg1_sub3]
startdelay=0
rw=randwrite
filename=data5/f4:data5/f5:data5/f6:data5/f7:data5/f8:data5/f1:data5/f2:data5/f3

[job_sdg1_sub4]
startdelay=0
rw=randwrite
filename=data5/f5:data5/f6:data5/f7:data5/f8:data5/f1:data5/f2:data5/f3:data5/f4

[job_sdg1_sub5]
startdelay=0
rw=randwrite
filename=data5/f6:data5/f7:data5/f8:data5/f1:data5/f2:data5/f3:data5/f4:data5/f5

[job_sdg1_sub6]
startdelay=0
rw=randwrite
filename=data5/f7:data5/f8:data5/f1:data5/f2:data5/f3:data5/f4:data5/f5:data5/f6

[job_sdg1_sub7]
startdelay=0
rw=randwrite
filename=data5/f8:data5/f1:data5/f2:data5/f3:data5/f4:data5/f5:data5/f6:data5/f7

[job_sdh1_sub0]
startdelay=0
rw=randwrite
filename=data6/f1:data6/f2:data6/f3:data6/f4:data6/f5:data6/f6:data6/f7:data6/f8

[job_sdh1_sub1]
startdelay=0
rw=randwrite
filename=data6/f2:data6/f3:data6/f4:data6/f5:data6/f6:data6/f7:data6/f8:data6/f1

[job_sdh1_sub2]
startdelay=0
rw=randwrite
filename=data6/f3:data6/f4:data6/f5:data6/f6:data6/f7:data6/f8:data6/f1:data6/f2

[job_sdh1_sub3]
startdelay=0
rw=randwrite
filename=data6/f4:data6/f5:data6/f6:data6/f7:data6/f8:data6/f1:data6/f2:data6/f3

[job_sdh1_sub4]
startdelay=0
rw=randwrite
filename=data6/f5:data6/f6:data6/f7:data6/f8:data6/f1:data6/f2:data6/f3:data6/f4

[job_sdh1_sub5]
startdelay=0
rw=randwrite
filename=data6/f6:data6/f7:data6/f8:data6/f1:data6/f2:data6/f3:data6/f4:data6/f5

[job_sdh1_sub6]
startdelay=0
rw=randwrite
filename=data6/f7:data6/f8:data6/f1:data6/f2:data6/f3:data6/f4:data6/f5:data6/f6

[job_sdh1_sub7]
startdelay=0
rw=randwrite
filename=data6/f8:data6/f1:data6/f2:data6/f3:data6/f4:data6/f5:data6/f6:data6/f7

[job_sdi1_sub0]
startdelay=0
rw=randwrite
filename=data7/f1:data7/f2:data7/f3:data7/f4:data7/f5:data7/f6:data7/f7:data7/f8

[job_sdi1_sub1]
startdelay=0
rw=randwrite
filename=data7/f2:data7/f3:data7/f4:data7/f5:data7/f6:data7/f7:data7/f8:data7/f1

[job_sdi1_sub2]
startdelay=0
rw=randwrite
filename=data7/f3:data7/f4:data7/f5:data7/f6:data7/f7:data7/f8:data7/f1:data7/f2

[job_sdi1_sub3]
startdelay=0
rw=randwrite
filename=data7/f4:data7/f5:data7/f6:data7/f7:data7/f8:data7/f1:data7/f2:data7/f3

[job_sdi1_sub4]
startdelay=0
rw=randwrite
filename=data7/f5:data7/f6:data7/f7:data7/f8:data7/f1:data7/f2:data7/f3:data7/f4

[job_sdi1_sub5]
startdelay=0
rw=randwrite
filename=data7/f6:data7/f7:data7/f8:data7/f1:data7/f2:data7/f3:data7/f4:data7/f5

[job_sdi1_sub6]
startdelay=0
rw=randwrite
filename=data7/f7:data7/f8:data7/f1:data7/f2:data7/f3:data7/f4:data7/f5:data7/f6

[job_sdi1_sub7]
startdelay=0
rw=randwrite
filename=data7/f8:data7/f1:data7/f2:data7/f3:data7/f4:data7/f5:data7/f6:data7/f7

[job_sdj1_sub0]
startdelay=0
rw=randwrite
filename=data8/f1:data8/f2:data8/f3:data8/f4:data8/f5:data8/f6:data8/f7:data8/f8

[job_sdj1_sub1]
startdelay=0
rw=randwrite
filename=data8/f2:data8/f3:data8/f4:data8/f5:data8/f6:data8/f7:data8/f8:data8/f1

[job_sdj1_sub2]
startdelay=0
rw=randwrite
filename=data8/f3:data8/f4:data8/f5:data8/f6:data8/f7:data8/f8:data8/f1:data8/f2

[job_sdj1_sub3]
startdelay=0
rw=randwrite
filename=data8/f4:data8/f5:data8/f6:data8/f7:data8/f8:data8/f1:data8/f2:data8/f3

[job_sdj1_sub4]
startdelay=0
rw=randwrite
filename=data8/f5:data8/f6:data8/f7:data8/f8:data8/f1:data8/f2:data8/f3:data8/f4

[job_sdj1_sub5]
startdelay=0
rw=randwrite
filename=data8/f6:data8/f7:data8/f8:data8/f1:data8/f2:data8/f3:data8/f4:data8/f5

[job_sdj1_sub6]
startdelay=0
rw=randwrite
filename=data8/f7:data8/f8:data8/f1:data8/f2:data8/f3:data8/f4:data8/f5:data8/f6

[job_sdj1_sub7]
startdelay=0
rw=randwrite
filename=data8/f8:data8/f1:data8/f2:data8/f3:data8/f4:data8/f5:data8/f6:data8/f7

[job_sdk1_sub0]
startdelay=0
rw=randwrite
filename=data9/f1:data9/f2:data9/f3:data9/f4:data9/f5:data9/f6:data9/f7:data9/f8

[job_sdk1_sub1]
startdelay=0
rw=randwrite
filename=data9/f2:data9/f3:data9/f4:data9/f5:data9/f6:data9/f7:data9/f8:data9/f1

[job_sdk1_sub2]
startdelay=0
rw=randwrite
filename=data9/f3:data9/f4:data9/f5:data9/f6:data9/f7:data9/f8:data9/f1:data9/f2

[job_sdk1_sub3]
startdelay=0
rw=randwrite
filename=data9/f4:data9/f5:data9/f6:data9/f7:data9/f8:data9/f1:data9/f2:data9/f3

[job_sdk1_sub4]
startdelay=0
rw=randwrite
filename=data9/f5:data9/f6:data9/f7:data9/f8:data9/f1:data9/f2:data9/f3:data9/f4

[job_sdk1_sub5]
startdelay=0
rw=randwrite
filename=data9/f6:data9/f7:data9/f8:data9/f1:data9/f2:data9/f3:data9/f4:data9/f5

[job_sdk1_sub6]
startdelay=0
rw=randwrite
filename=data9/f7:data9/f8:data9/f1:data9/f2:data9/f3:data9/f4:data9/f5:data9/f6

[job_sdk1_sub7]
startdelay=0
rw=randwrite
filename=data9/f8:data9/f1:data9/f2:data9/f3:data9/f4:data9/f5:data9/f6:data9/f7

[job_sdl1_sub0]
startdelay=0
rw=randwrite
filename=data10/f1:data10/f2:data10/f3:data10/f4:data10/f5:data10/f6:data10/f7:data10/f8

[job_sdl1_sub1]
startdelay=0
rw=randwrite
filename=data10/f2:data10/f3:data10/f4:data10/f5:data10/f6:data10/f7:data10/f8:data10/f1

[job_sdl1_sub2]
startdelay=0
rw=randwrite
filename=data10/f3:data10/f4:data10/f5:data10/f6:data10/f7:data10/f8:data10/f1:data10/f2

[job_sdl1_sub3]
startdelay=0
rw=randwrite
filename=data10/f4:data10/f5:data10/f6:data10/f7:data10/f8:data10/f1:data10/f2:data10/f3

[job_sdl1_sub4]
startdelay=0
rw=randwrite
filename=data10/f5:data10/f6:data10/f7:data10/f8:data10/f1:data10/f2:data10/f3:data10/f4

[job_sdl1_sub5]
startdelay=0
rw=randwrite
filename=data10/f6:data10/f7:data10/f8:data10/f1:data10/f2:data10/f3:data10/f4:data10/f5

[job_sdl1_sub6]
startdelay=0
rw=randwrite
filename=data10/f7:data10/f8:data10/f1:data10/f2:data10/f3:data10/f4:data10/f5:data10/f6

[job_sdl1_sub7]
startdelay=0
rw=randwrite
filename=data10/f8:data10/f1:data10/f2:data10/f3:data10/f4:data10/f5:data10/f6:data10/f7

[job_sdm1_sub0]
startdelay=0
rw=randwrite
filename=data11/f1:data11/f2:data11/f3:data11/f4:data11/f5:data11/f6:data11/f7:data11/f8

[job_sdm1_sub1]
startdelay=0
rw=randwrite
filename=data11/f2:data11/f3:data11/f4:data11/f5:data11/f6:data11/f7:data11/f8:data11/f1

[job_sdm1_sub2]
startdelay=0
rw=randwrite
filename=data11/f3:data11/f4:data11/f5:data11/f6:data11/f7:data11/f8:data11/f1:data11/f2

[job_sdm1_sub3]
startdelay=0
rw=randwrite
filename=data11/f4:data11/f5:data11/f6:data11/f7:data11/f8:data11/f1:data11/f2:data11/f3

[job_sdm1_sub4]
startdelay=0
rw=randwrite
filename=data11/f5:data11/f6:data11/f7:data11/f8:data11/f1:data11/f2:data11/f3:data11/f4

[job_sdm1_sub5]
startdelay=0
rw=randwrite
filename=data11/f6:data11/f7:data11/f8:data11/f1:data11/f2:data11/f3:data11/f4:data11/f5

[job_sdm1_sub6]
startdelay=0
rw=randwrite
filename=data11/f7:data11/f8:data11/f1:data11/f2:data11/f3:data11/f4:data11/f5:data11/f6

[job_sdm1_sub7]
startdelay=0
rw=randwrite
filename=data11/f8:data11/f1:data11/f2:data11/f3:data11/f4:data11/f5:data11/f6:data11/f7

--=-6Srf6V01cBhhY9i0oo79--

