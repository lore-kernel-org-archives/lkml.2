Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab1BPPEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 10:04:15 -0500
Received: from relay2.sgi.com ([192.48.179.30]:49289 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751358Ab1BPPEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 10:04:12 -0500
Date: Wed, 16 Feb 2011 09:04:06 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Jack Steiner <steiner@sgi.com>
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu, raz@scalemp.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, a.p.zijlstra@chello.nl,
        efault@gmx.de, cpw@sgi.com, travis@sgi.com, tglx@linutronix.de,
        hpa@zytor.com, sivanich@sgi.com
Subject: Re: [BUG] soft lockup while booting machine with more than 700
 cores
Message-ID: <20110216150406.GA1623@sgi.com>
References: <1297236453.2756.9.camel@raz.scalemp.com>
 <20110210123937.GD26094@elte.hu>
 <20110210205648.GA10341@sgi.com>
 <20110210.130325.112603217.davem@davemloft.net>
 <20110210211223.GB10757@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110210211223.GB10757@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 03:12:23PM -0600, Jack Steiner wrote:
> On Thu, Feb 10, 2011 at 01:03:25PM -0800, David Miller wrote:
> > From: Jack Steiner <steiner@sgi.com>
> > Date: Thu, 10 Feb 2011 14:56:48 -0600
> > 
> > > We also noticed that the rebalance_domains() code references many per-cpu
> > > run queue structures. All of the structures have identical offsets relative
> > > to the size of a cache leaf. The result is that all index into the same lines in the
> > > L3 caches. That causes many evictions. We tried an experimental to
> > > stride the run queues at 128 byte offsets. That helped in some cases but the
> > > results were mixed.  We are still experimenting with the patch.
> > 
> > I think chasing after cache alignment issues misses the point entirely.
> > 
> > The core issue is that rebalance_domains() is insanely expensive, by
> > design.  It's complexity is N factorial for the idle non-HZ cpu that is
> > selected to balance every single domain.
> > 
> > A statistic datastructure that is approximately 128 bytes in size is
> > repopulated N! times each time this global rebalance thing runs.
> > 
> > I've been seeing rebalance_domains() in my perf top output on 128 cpu
> > machines for several years now.  Even on an otherwise idle machine,
> > the system churns in thus code path endlessly.
> 
> Completely agree! Idle rebalancing is also a big problem. We've seen
> significant improvements on large systems in network thruput by
> disabling IDLE load balancing for the higher (2 & 3) scheduling domains.
> 
> This is not a real fix but points to a problem.
>

Here are some TCP STREAMS test numbers from a large, otherwise idle UV system.

With SD_BALANCE_NEWIDLE turned on for all domain levels:

TCP STREAM TEST from localhost (::1) port 0 AF_INET6 to localhost (::1) port 0
AF_INET6 : cpu bind
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec
 87380  16384  16384    10.00     115.32

With SD_BALANCE_NEWIDLE turned off for domain levels 2 & 3 (NODES & ALLNODES):
 87380  16384  16384    10.00    14685.51

I am curious as to why there would be such a large discrepancy.
