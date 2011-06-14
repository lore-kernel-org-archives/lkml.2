Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab1FNDpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 23:45:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:7374 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab1FNDp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 23:45:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,362,1304319600"; 
   d="scan'208";a="14191122"
Date: Tue, 14 Jun 2011 11:45:25 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] bdi write bandwidth estimation
Message-ID: <20110614034525.GA5835@localhost>
References: <20110612151821.601514494@intel.com>
 <20110613152330.056e2eba.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110613152330.056e2eba.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 06:23:30AM +0800, Andrew Morton wrote:
> On Sun, 12 Jun 2011 23:18:21 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > Do bdi write bandwidth estimation in the flusher thread at 200ms intervals,
> 
> stdrant: anything which is paced using "seconds" is basically always
> wrong.  The bandwidth of storage systems varies by who-knows-how-many
> orders of magnitude.  If 200ms is correct for one system then it is
> vastly incorrect for another.
> 
> A more suitable clock for this estimate would be "per 200 requests",
> for a block-based BDI.
> 
> Also of course the bandwidth of a particular BDI varies vastly
> depending on workload.  For the purpose of this work, that's probably
> a desirable thing.

It would be good to be able to get more timely estimation for fast
devices. However have to balance between "timely" and "fluctuations"..

The main problem is, IO completions may come in bursts. The NFS commit
can be as large as seconds worth of data. The XFS completions may be 
half second worth of data if we are going to increase the write chunk
size to half second worth of data.

Looking at the other filesystems, eg. ext4

http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v8/3G/ext4-1dd-4k-8p-2948M-20:10-3.0.0-rc2-next-20110610+-2011-06-12.21:57/balance_dirty_pages-bandwidth.png

You'll notice fluctuations with the time period of around 5 seconds.

Here is another pattern with irregular periods of up to 20 seconds on SSD:

http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/1SSD-64G/ext4-1dd-1M-64p-64288M-20%25-2.6.38-rc6-dt6+-2011-03-01-16-19/balance_dirty_pages-bandwidth.png

That's why I'm not only doing the estimation at 200ms intervals, but
also averaging them over a period of 3 seconds and then go further to
do another level of smoothing (the avg_write_bandwidth).

Since it's a reasonable optimization for the filesystems to do IO
completions in batches, the time based interval would be suitable to
average out the bursts and being efficient enough for both fast/slow
storages.


Another important fact is: the estimation is carried out on every
200ms when the flusher thread is _already busy_.

In this way, it won't lead to pointless CPU wakeups at idle time.

The estimated bandwidth will be reflecting how fast the device can
writeout when fully utilized, so won't drop to 0 when it goes idle.
The value will remain constant at disk idle time. At busy write time,
if not considering fluctuations, it will also remain high unless be
knocked down by possible concurrent reads that take some disk time and
bandwidth away.

Thanks,
Fengguang
