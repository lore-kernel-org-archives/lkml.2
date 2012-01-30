Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab2A3L3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 06:29:03 -0500
Received: from mga03.intel.com ([143.182.124.21]:38373 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab2A3L3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 06:29:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101076719"
Date: Mon, 30 Jan 2012 19:18:54 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Cc: Li Shaohua <shaohua.li@intel.com>, Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: Bad SSD performance with recent kernels
Message-ID: <20120130111854.GA899@localhost>
References: <20120127060034.GG29272@MAIL.13thfloor.at>
 <20120128125108.GA9661@localhost>
 <1327757611.7199.6.camel@edumazet-laptop>
 <20120129055917.GB8513@localhost>
 <1327831380.14602.6.camel@edumazet-laptop>
 <20120129111645.GA5839@localhost>
 <1327842831.2718.2.camel@edumazet-laptop>
 <20120129161058.GA13156@localhost>
 <20120129201543.GJ29272@MAIL.13thfloor.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120129201543.GJ29272@MAIL.13thfloor.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 29, 2012 at 09:15:43PM +0100, Herbert Poetzl wrote:
> On Mon, Jan 30, 2012 at 12:10:58AM +0800, Wu Fengguang wrote:

> > Maybe the /dev/sda performance bug on your machine is sensitive to timing?
> 
> here are some more confusing results from tests with dd and bonnie++, 
> this time I focused on partition vs. loop vs. linear dm (of same partition)
> 
> kernel	  -------------- read --------------  -- write ---  all
> 	  -------- dd --------  -------- bonnie++ --------------
> 	  [MB/s]  real    %CPU  [MB/s]  %CPU  [MB/s]  %CPU  %CPU
> direct
> 2.6.38.8  262.91   81.90  28.7	 72.30   6.0  248.53  52.0  15.9
> 2.6.39.4   36.09  595.17   3.1	 70.62   6.0  250.25  53.0  16.3
> 3.0.18     50.47  425.65   4.1	 70.00   5.0  251.70  44.0  13.9
> 3.1.10     27.28  787.32   2.0	 75.65   5.0  251.96  45.0  13.3
> 3.2.2      27.11  792.28   2.0	 76.89   6.0  250.38  44.0  13.3
> 
> loop
> 2.6.38.8  242.89   88.50  21.5	246.58  15.0  240.92  53.0  14.4
> 2.6.39.4  241.06   89.19  21.5	238.51  15.0  257.59  57.0  14.8
> 3.0.18	  261.44   82.23  18.8	256.66  15.0  255.17  48.0  12.6
> 3.1.10	  253.93   84.64  18.1	107.66   7.0  156.51  28.0  10.6
> 3.2.2	  262.58   81.82  19.8	110.54   7.0  212.01  40.0  11.6
> 
> linear
> 2.6.38.8  262.57   82.00  36.8	 72.46   6.0  243.25  53.0  16.5
> 2.6.39.4   25.45  843.93   2.3	 70.70   6.0  248.05  54.0  16.6
> 3.0.18	   55.45  387.43   5.6	 69.72   6.0  249.42  45.0  14.3
> 3.1.10	   36.62  586.50   3.3	 74.74   6.0  249.99  46.0  13.4
> 3.2.2	   28.28  759.26   2.3	 74.20   6.0  248.73  46.0  13.6
> 
> 
> it seems that dd performance when using a loop device is unaffected
> and even improves with the kernel version, the filesystem performance
> OTOH degrades after 3.1 ...
> 
> in general, filesystem read performance is bad on everything but
> a loop device ... judging from the results I'd conclude that there
> are at least two different issues 
> 
> tests and test results are attached and can be found here:
> http://vserver.13thfloor.at/Stuff/SSD/
> 
> I plan to do some more tests on the filesystem with -b and -D
> tonight, please let me know if you want to see specific output
> and/or have any tests I should run with each kernel ...

I agree with Shaohua that there may be timing/plug issues. There
happen to be some plug patches and (maybe correlated) big performance
drop between 2.6.38 and 2.6.39. The obvious way to move forward is to
get some blktrace data on simple dd + new buggy kernel and let's check
what's exactly going on.

# start a background dd read
blktrace /dev/sda -w 10
blkparse -t sda

Thanks,
Fengguang
