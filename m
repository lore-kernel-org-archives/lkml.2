Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab1EMAMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 20:12:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:61940 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932356Ab1EMAMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 20:12:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,361,1301900400"; 
   d="scan'208";a="642033942"
Subject: Re: Perfromance drop on SCSI hard disk
From: "Alex,Shi" <alex.shi@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4DCC4340.6000407@fusionio.com>
References: <1305009600.21534.587.camel@debian>
	 <4DCC4340.6000407@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 08:11:43 +0800
Message-ID: <1305245503.21534.2090.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-13 at 04:29 +0800, Jens Axboe wrote:
> On 2011-05-10 08:40, Alex,Shi wrote:
> > commit c21e6beba8835d09bb80e34961 removed the REENTER flag and changed
> > scsi_run_queue() to punt all requests on starved_list devices to
> > kblockd. Yes, like Jens mentioned, the performance on slow SCSI disk was
> > hurt here.  :) (Intel SSD isn't effected here)
> > 
> > In our testing on 12 SAS disk JBD, the fio write with sync ioengine drop
> > about 30~40% throughput, fio randread/randwrite with aio ioengine drop
> > about 20%/50% throughput. and fio mmap testing was hurt also. 
> > 
> > With the following debug patch, the performance can be totally recovered
> > in our testing. But without REENTER flag here, in some corner case, like
> > a device is keeping blocked and then unblocked repeatedly,
> > __blk_run_queue() may recursively call scsi_run_queue() and then cause
> > kernel stack overflow. 
> > I don't know details of block device driver, just wondering why on scsi
> > need the REENTER flag here. :) 
> 
> This is a problem and we should do something about it for 2.6.39. I knew
> that there would be cases where the async offload would cause a
> performance degredation, but not to the extent that you are reporting.
> Must be hitting the pathological case.
> 
> I can think of two scenarios where it could potentially recurse:
> 
> - request_fn enter, end up requeuing IO. Run queue at the end. Rinse,
>   repeat.
> - Running starved list from request_fn, two (or more) devices could
>   alternately recurse.
> 
> The first case should be fairly easy to handle. The second one is
> already handled by the local list splice.
> 
> Looking at the code, is this a real scenario? Only potential recurse I
> see is:
> 
> scsi_request_fn()
>         scsi_dispatch_cmd()
>                 scsi_queue_insert()
>                         __scsi_queue_insert()
>                                 scsi_run_queue()
> 
> Why are we even re-running the queue immediately on a BUSY condition?
> Should only be needed if we have zero pending commands from this
> particular queue, and for that particular case async run is just fine
> since it's a rare condition (or performance would suck already).

Yeah, this is correct way to fix it. Let me try the patch on our
machine. 


