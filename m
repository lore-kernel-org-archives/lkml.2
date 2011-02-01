Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab1BAPuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 10:50:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab1BAPus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:50:48 -0500
Date: Tue, 1 Feb 2011 16:49:47 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: =?utf-8?Q?Jind=C5=99ich_Makovi=C4=8Dka?= <makovick@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: khugepaged: gets stuck when writing to USB flash, 2.6.38-rc2
Message-ID: <20110201154947.GX16981@random.random>
References: <AANLkTi=uOpN0PwWdGh6iri-vJwuMS+WMPxmaZjv0-TrV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=uOpN0PwWdGh6iri-vJwuMS+WMPxmaZjv0-TrV@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 08:28:00PM +0100, Jindřich Makovička wrote:
> Hi,
> 
> I am encountering problems when continuously writing larger amounts of
> data to a USB flash drive. My configuration is
> 
> x86-64 kernel
> USB stick with 10MB/s write, 30MB/s read speed,
> HDD with ~60-80MB/s read/write
> 8 GiB RAM
> 
> When copying 4GB or more in one go from HDD to Flash, during the
> copying, fork() and probably other syscalls involving VM start
> blocking (I first observed the problem in Chrome, which refused to
> display content in new tabs). When one lets the copying finish, the
> system returns to a usable state.
> 
> During the limbo, khugepaged is in D state (uninterruptible sleep).

That means no hugepage could be allocated. Maybe memory compaction is
doing an overwork because all pagecache is dirty and can't be
migrated. This should solve it if it's memory compaction:

echo never >/sys/kernel/mm/transparent_hugepage/defrag

kswapd state would be interesting too. Can you sysrq+t?

Probably we should decrease the aggressiveness of memory compaction in
direct reclaim. I've another report that memory compaction for order <
3 allocations is increasing latency, it's not like your problem but it
may be related. The congestion_wait in compaction.c also makes me
uncomfortable, it should bail out and fail I think. Maybe we should
add a bitflag to differentiate the callers that can gracefully handle
failure (like THP or most skb jumbo frame allocations) and those like
the kernel stack that will return -ENOMEM if allocation fails.
