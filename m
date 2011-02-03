Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab1BCNYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 08:24:35 -0500
Received: from gir.skynet.ie ([193.1.99.77]:40281 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab1BCNYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 08:24:34 -0500
Date: Thu, 3 Feb 2011 13:24:08 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jind??ich Makovi??ka <makovick@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: khugepaged: gets stuck when writing to USB flash, 2.6.38-rc2
Message-ID: <20110203132407.GF11958@csn.ul.ie>
References: <AANLkTi=uOpN0PwWdGh6iri-vJwuMS+WMPxmaZjv0-TrV@mail.gmail.com> <20110201154947.GX16981@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110201154947.GX16981@random.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 04:49:47PM +0100, Andrea Arcangeli wrote:
> On Mon, Jan 31, 2011 at 08:28:00PM +0100, Jind??ich Makovi??ka wrote:
> > Hi,
> > 
> > I am encountering problems when continuously writing larger amounts of
> > data to a USB flash drive. My configuration is
> > 
> > x86-64 kernel
> > USB stick with 10MB/s write, 30MB/s read speed,
> > HDD with ~60-80MB/s read/write
> > 8 GiB RAM
> > 
> > When copying 4GB or more in one go from HDD to Flash, during the
> > copying, fork() and probably other syscalls involving VM start
> > blocking (I first observed the problem in Chrome, which refused to
> > display content in new tabs). When one lets the copying finish, the
> > system returns to a usable state.
> > 
> > During the limbo, khugepaged is in D state (uninterruptible sleep).
> 
> That means no hugepage could be allocated. Maybe memory compaction is
> doing an overwork because all pagecache is dirty and can't be
> migrated. This should solve it if it's memory compaction:
> 

This is very likely. Compaction calls into migration which will wait on
dirty pages after a time. With a large number of dirty pages backed by a
slow drive such as a USB stick, it could be getting stalled there for a
long period of time. 

Whether migration sleeps or not can be controlled by the sync parameter
passed into try_to_compact_memory which could be always forced to false
if GFP_NO_KSWAPD?

> echo never >/sys/kernel/mm/transparent_hugepage/defrag
> 
> kswapd state would be interesting too. Can you sysrq+t?
> 
> Probably we should decrease the aggressiveness of memory compaction in
> direct reclaim. I've another report that memory compaction for order <
> 3 allocations is increasing latency, it's not like your problem but it
> may be related. The congestion_wait in compaction.c also makes me
> uncomfortable, it should bail out and fail I think. Maybe we should
> add a bitflag to differentiate the callers that can gracefully handle
> failure (like THP or most skb jumbo frame allocations) and those like
> the kernel stack that will return -ENOMEM if allocation fails.
> 

-- 
Mel Gorman
