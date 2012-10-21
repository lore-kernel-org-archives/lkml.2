Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab2JUWWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 18:22:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39353 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932626Ab2JUWWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 18:22:48 -0400
MIME-Version: 1.0
In-Reply-To: <0861696a510e833409520496cfe84d3c.squirrel@www.codeaurora.org>
References: <1349192378-1676-1-git-send-email-kdorfman@codeaurora.org>
	<1349192378-1676-2-git-send-email-kdorfman@codeaurora.org>
	<CAFEEs1=zU88dwY1K0+Q9PxdqyOpsNMtj6mZ3YkwebPugofyEEw@mail.gmail.com>
	<0861696a510e833409520496cfe84d3c.squirrel@www.codeaurora.org>
Date: Mon, 22 Oct 2012 00:22:46 +0200
Message-ID: <CAFEEs1=yA3NO23amyc0X5-4NUUDJp-xAMw6OwdmTQeWdAWc-Ew@mail.gmail.com>
Subject: Re: [PATCH] mmc: fix async request mechanism for sequential read scenarios
From: Per Forlin <per.lkml@gmail.com>
To: Konstantin Dorfman <kdorfman@codeaurora.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 6:17 PM, Konstantin Dorfman
<kdorfman@codeaurora.org> wrote:
> On Thu, 11 Oct 2012 17:19:01 +0200, Per Forlin <per.lkml@gmail.com>
> wrote:
> Hello Per,
>
>>I would like to start with some basic comments.
>>
>>1. Is this read sequential issue specific to MMC?
>>2. Or is it common with all other block-drivers that gets data from
>>the block layer (SCSI/SATA etc) ?
>>If (#2) can the issue be addressed inside the block layer instead?
>>
>>BR
>>Per
> This issue specific to MMC, others block drivers probably not using
> MMC mechanism for async request (or have more kernel threads for
> processing incoming blk requests).
> I think, since MMC actively fetches requests from block layer queue,
> the solution has nothing to do with block layer context.
>
>>
>>On Tue, Oct 2, 2012 at 5:39 PM, Konstantin Dorfman
>><kdorfman@codeaurora.org> wrote:
>>> The main assumption of the async request design is that the file
>>> system adds block requests to the block device queue asynchronously
>>> without waiting for completion (see the Rationale section of
>>> https://wiki.linaro.org/WorkingGroups/Kernel/Specs
>>> /StoragePerfMMC-async-req).
>>>
>>> We found out that in case of sequential read operations this is not
>>> the case, due to the read ahead mechanism.
>>Would it be possible to improve this mechanism to achieve the same result?
>>Allow an outstanding read ahead request on top of the current ongoing one.
>>
>
> I need to look on this mechanism,  but from first glance such
> behaviour may be result of libc/vfs/fs decisions and too complex
> comparing to the patch we are talking about.
One observation I have made is that if setting the mmc_req_size to
half READ_AHEAD changes the way block layer adds request to the MMC
queue.

Extract from https://wiki.linaro.org/WorkingGroups/Kernel/Specs/StoragePerfMMC-async-req#Unresolved_issues
--------------------------------
Forcing mmc host driver to set mmc_req_size 64k results in this behaviour.

dd if=/dev/mmcblk0 of=/dev/null bs=4k count=256
 [mmc_queue_thread] req d955f9b0 blocks 32
 [mmc_queue_thread] req   (null) blocks 0
 [mmc_queue_thread] req   (null) blocks 0
 [mmc_queue_thread] req d955f9b0 blocks 64
 [mmc_queue_thread] req   (null) blocks 0
 [mmc_queue_thread] req d955f8d8 blocks 128
 [mmc_queue_thread] req   (null) blocks 0
 [mmc_queue_thread] req d955f9b0 blocks 128
 [mmc_queue_thread] req d955f800 blocks 128
 [mmc_queue_thread] req d955f8d8 blocks 128
 [mmc_queue_thread] req d955fec0 blocks 128
 [mmc_queue_thread] req d955f800 blocks 128
 [mmc_queue_thread] req d955f9b0 blocks 128
 [mmc_queue_thread] req d967cd30 blocks 128
--------------------------------

This shows that the block layer can add request in a more asynchronous
manner. I have not investigate that mechanism enough to say what can
be done.
Do you have an explanation to why the block layer behaves like this?

BR
Per

>
>
> --
> Konstantin Dorfman,
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
>
