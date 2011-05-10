Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab1EJGwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 02:52:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:29556 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab1EJGwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 02:52:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,345,1301900400"; 
   d="scan'208";a="690524228"
Date: Tue, 10 May 2011 14:52:38 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: "Shi, Alex" <alex.shi@intel.com>, jaxboe@fusionio.com
Cc: "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tim.c.chen@intel.com
Subject: Re: Perfromance drop on SCSI hard disk
Message-ID: <20110510065238.GA32575@sli10-conroe.sh.intel.com>
References: <1305009600.21534.587.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305009600.21534.587.camel@debian>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 02:40:00PM +0800, Shi, Alex wrote:
> commit c21e6beba8835d09bb80e34961 removed the REENTER flag and changed
> scsi_run_queue() to punt all requests on starved_list devices to
> kblockd. Yes, like Jens mentioned, the performance on slow SCSI disk was
> hurt here.  :) (Intel SSD isn't effected here)
> 
> In our testing on 12 SAS disk JBD, the fio write with sync ioengine drop
> about 30~40% throughput, fio randread/randwrite with aio ioengine drop
> about 20%/50% throughput. and fio mmap testing was hurt also. 
> 
> With the following debug patch, the performance can be totally recovered
> in our testing. But without REENTER flag here, in some corner case, like
> a device is keeping blocked and then unblocked repeatedly,
> __blk_run_queue() may recursively call scsi_run_queue() and then cause
> kernel stack overflow. 
> I don't know details of block device driver, just wondering why on scsi
> need the REENTER flag here. :) 
Hi Jens,
I want to add more analysis about the problem to help understand the issue.
This is a severe problem, hopefully we can solve it before 2.6.39 release.

Basically the offending patch has some problems:
a. more context switches
b. __blk_run_queue losts the recursive detection. In some cases, it could be
  called recursively. For example, blk_run_queue in scsi_run_queue()
c. fairness issue. Say we have sdev1 and sdev2 in starved_list. Then run
scsi_run_queue():
  1. remove both sdev1 and sdev2 from starved_list
  2. async queue dispatches sdev1's request. host becames busy again.
  3. add sdev1 into starved_list again. Since starved_list is empty,
     sdev1 is added at the head
  4. async queue checks sdev2, and add sdev2 into starved_list tail.
  In this scenario, sdev1 is serviced first next time, so sdev2 is starved.
  In our test, 12 disks connect to one HBA card. disk's queue depth is 64,
  while HBA card queue depth is 128. Our test does sync write, so block size
  is big, so just several requests can occurpy one disk's bandwidth. Saturate
  one disk but starve others will hurt total throughput.

problem a isn't a big problem in our test (we did observe higher context
switch, which is about 4x more CS), but guess it will hurt high end system.

problem b is easy to fix for scsi. just replace blk_run_queue with
blk_run_queue_async in scsi_run_queue

problem c is the root cause for the regression. I had a patch for it.
Basically with my patch, we don't remove sdev from starved_list in
scsi_run_queue, but we delay the removal in scsi_request_fn() till a
starved device really dispatches a request. My patch can fully fix
the regression.

But given problem a, we should revert the patch (or Alex's patch if stack
overflow isn't a big deal here), so I didn't post my patch here. Problem
c actually exsists even we revert the patch (we could do async execution
with small chance), but not that severe. I can post a fix after the
patch is reverted.

Thanks,
Shaohua
