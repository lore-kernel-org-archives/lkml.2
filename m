Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab1ELAgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 20:36:08 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:32885 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab1ELAgG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 20:36:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mEmlqWiBAdh1NIsF7y0ZxJj6ThHXzk77InDiM802Zte3iNDcoOKDwpLnv9S0NdwrNj
         hWFtmdtaCcfvZBy5KFOUHDbymtRPxX4o46aJ2eyibj3EcBSIOtiyLMwGtokSjxqkGcqE
         +jBa1JBwx3DHKCDgeLMmx48D0dUQq4DI4Ekos=
MIME-Version: 1.0
In-Reply-To: <20110510065238.GA32575@sli10-conroe.sh.intel.com>
References: <1305009600.21534.587.camel@debian>
	<20110510065238.GA32575@sli10-conroe.sh.intel.com>
Date: Thu, 12 May 2011 08:36:05 +0800
X-Google-Sender-Auth: 9o0evhxiW3djLATeH3Htoamv7BI
Message-ID: <BANLkTimPhB9wBuNt+CLMv2pvYkJ27t1o+w@mail.gmail.com>
Subject: Re: Perfromance drop on SCSI hard disk
From: Shaohua Li <shaohua.li@intel.com>
To: "Shi, Alex" <alex.shi@intel.com>, jaxboe@fusionio.com
Cc: "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tim.c.chen@intel.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/10 Shaohua Li <shaohua.li@intel.com>:
> On Tue, May 10, 2011 at 02:40:00PM +0800, Shi, Alex wrote:
>> commit c21e6beba8835d09bb80e34961 removed the REENTER flag and changed
>> scsi_run_queue() to punt all requests on starved_list devices to
>> kblockd. Yes, like Jens mentioned, the performance on slow SCSI disk was
>> hurt here.  :) (Intel SSD isn't effected here)
>>
>> In our testing on 12 SAS disk JBD, the fio write with sync ioengine drop
>> about 30~40% throughput, fio randread/randwrite with aio ioengine drop
>> about 20%/50% throughput. and fio mmap testing was hurt also.
>>
>> With the following debug patch, the performance can be totally recovered
>> in our testing. But without REENTER flag here, in some corner case, like
>> a device is keeping blocked and then unblocked repeatedly,
>> __blk_run_queue() may recursively call scsi_run_queue() and then cause
>> kernel stack overflow.
>> I don't know details of block device driver, just wondering why on scsi
>> need the REENTER flag here. :)
> Hi Jens,
> I want to add more analysis about the problem to help understand the issue.
> This is a severe problem, hopefully we can solve it before 2.6.39 release.
>
> Basically the offending patch has some problems:
> a. more context switches
> b. __blk_run_queue losts the recursive detection. In some cases, it could be
>  called recursively. For example, blk_run_queue in scsi_run_queue()
> c. fairness issue. Say we have sdev1 and sdev2 in starved_list. Then run
> scsi_run_queue():
>  1. remove both sdev1 and sdev2 from starved_list
>  2. async queue dispatches sdev1's request. host becames busy again.
>  3. add sdev1 into starved_list again. Since starved_list is empty,
>     sdev1 is added at the head
>  4. async queue checks sdev2, and add sdev2 into starved_list tail.
>  In this scenario, sdev1 is serviced first next time, so sdev2 is starved.
>  In our test, 12 disks connect to one HBA card. disk's queue depth is 64,
>  while HBA card queue depth is 128. Our test does sync write, so block size
>  is big, so just several requests can occurpy one disk's bandwidth. Saturate
>  one disk but starve others will hurt total throughput.
>
> problem a isn't a big problem in our test (we did observe higher context
> switch, which is about 4x more CS), but guess it will hurt high end system.
>
> problem b is easy to fix for scsi. just replace blk_run_queue with
> blk_run_queue_async in scsi_run_queue
>
> problem c is the root cause for the regression. I had a patch for it.
> Basically with my patch, we don't remove sdev from starved_list in
> scsi_run_queue, but we delay the removal in scsi_request_fn() till a
> starved device really dispatches a request. My patch can fully fix
> the regression.
>
> But given problem a, we should revert the patch (or Alex's patch if stack
> overflow isn't a big deal here), so I didn't post my patch here. Problem
> c actually exsists even we revert the patch (we could do async execution
> with small chance), but not that severe. I can post a fix after the
> patch is reverted.
Hi,
Ping again. I hope this issue isn't missed. The regression is big from
20% ~ 50% of IO throughput.

Thanks,
Shaohua
