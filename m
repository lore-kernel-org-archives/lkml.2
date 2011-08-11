Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab1HKWVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 18:21:04 -0400
Received: from mga07.intel.com ([143.182.124.22]:64257 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753437Ab1HKWVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 18:21:03 -0400
MIME-Version: 1.0
In-Reply-To: <1313046710.27321.7.camel@sli10-conroe>
References: <1313046710.27321.7.camel@sli10-conroe>
Date: Thu, 11 Aug 2011 15:21:01 -0700
Message-ID: <CABE8wwsND02NBMLpxhLAbYp==793uQFBwgaw05pQd84VkUw_uw@mail.gmail.com>
Subject: Re: [patch]block: revert a patch
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, boyu.mt@taobao.com,
        Christoph Hellwig <hch@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 12:11 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> This patch reverts commit 35ae66e0a09ab70ed(block: Make rq_affinity = 1
> work as expected). The purpose is to avoid an unnecessary IPI.
> Let's take an example. My test box has cpu 0-7, one socket. Say request is
> added from CPU 1, blk_complete_request() occurs at CPU 7. Without the reverted
> patch, softirq will be done at CPU 7. With it, an IPI will be directed to CPU
> 0, and softirq will be done at CPU 0. In this case, doing softirq at CPU 0 and
> CPU 7 have no difference from cache sharing point view and we can avoid an
> ipi if doing it in CPU 7.
> An immediate concern is this is just like QUEUE_FLAG_SAME_FORCE, but actually
> not. blk_complete_request() is running in interrupt handler, and currently
> I/O controller doesn't support multiple interrupts (I checked several LSI
> cards and AHCI), so only one CPU can run blk_complete_request(). This is
> still quite different as QUEUE_FLAG_SAME_FORCE.
> Since only one CPU runs softirq, the only difference with below patch is
> softirq not always runs at the first CPU of a group.

Ah, so I misinterpreted the initial implementation in a beneficial way.

I suspect this might be the real root cause of the iops bump in the
rq_affinity=1 case that we saw when testing this patch set [1].
Because the hack [2] of looking at the state of ksoftirqd on 'ccpu'
missed the 'waking' state of ksoftirqd, and when that was added
performance did not improve it actually went down a bit.

--
Dan

[1]: https://lkml.org/lkml/2011/7/22/294
[2]: https://lkml.org/lkml/2011/7/22/296
