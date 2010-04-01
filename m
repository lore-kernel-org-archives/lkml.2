Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab0DAKnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 06:43:23 -0400
Received: from hosting.visp.net.lb ([194.146.153.11]:45511 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab0DAKnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 06:43:16 -0400
From: Denys Fedorysychenko <nuclearcat@nuclearcat.com>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: endless sync on bdi_sched_wait()? 2.6.33.1
Date: Thu, 1 Apr 2010 13:42:42 +0300
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-rt21-home1; KDE/4.3.5; x86_64; ; )
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <201003311907.31342.nuclearcat@nuclearcat.com> <20100331221254.GI7671@dastard>
In-Reply-To: <20100331221254.GI7671@dastard>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004011342.42467.nuclearcat@nuclearcat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 April 2010 01:12:54 Dave Chinner wrote:
> On Wed, Mar 31, 2010 at 07:07:31PM +0300, Denys Fedorysychenko wrote:
> > I have a proxy server with "loaded" squid. On some moment i did sync, and
> > expecting it to finish in reasonable time. Waited more than 30 minutes,
> > still "sync". Can be reproduced easily.
> >
> > Here is some stats and info:
> >
> > Linux SUPERPROXY 2.6.33.1-build-0051 #16 SMP Wed Mar 31 17:23:28 EEST
> > 2010 i686 GNU/Linux
> >
> > SUPERPROXY ~ # iostat -k -x -d 30
> > Linux 2.6.33.1-build-0051 (SUPERPROXY)  03/31/10        _i686_  (4 CPU)
> >
> > Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
> > avgrq-sz avgqu-sz   await  svctm  %util
> > sda               0.16     0.01    0.08    0.03     3.62     1.33   
> > 88.94 0.15 1389.89  59.15   0.66
> > sdb               4.14    61.25    6.22   25.55    44.52   347.21   
> > 24.66 2.24   70.60   2.36   7.49
> > sdc               4.37   421.28    9.95   98.31   318.27  2081.95   
> > 44.34 20.93  193.21   2.31  24.96
> > sdd               2.34   339.90    3.97  117.47    95.48  1829.52   
> > 31.70 1.73   14.23   8.09  98.20
> 
>                  ^^^^  ^^^^^
> 
> /dev/sdd is IO bound doing small random writeback IO. A service time
> of 8ms implies that it is doing lots of large seeks. If you've got
> GBs of data to sync and that's the writeback pattern, then sync will
> most definitely take a long, long time.
> 
> it may be that ext4 is allocating blocks far apart rather than close
> together (as appears to be the case for /dev/sdc), so maybe this is
> is related to how the filesytems are aging or how full they are...
Thats correct, it is quite busy cache server.

Well, if i stop squid(cache) sync will finish enough fast.
If i don't - it took more than hour. Actually i left that PC after 1 hour, and 
it didn't finish yet. I don't think it is normal.
Probably sync taking new data and trying to flush it too, and till he finish 
that, more data comes. 
Actually all what i need - to sync config directory. I cannot use fsync, 
because it is multiple files opened before by other processes, and sync is 
doing trick like this. I got dead process, and only fast way to recover system 
- kill the cache process, so I/O pumping will stop for a while, and sync() 
will have chance to finish.
Sure there is way just to "remount" config partition to ro, but i guess just 
sync must flush only current buffer cache pages.

I will do more tests now and will give exact numbers, how much time it needs 
with running squid and if i kill it shortly after running sync.
> 
> Cheers,
> 
> Dave.
> 
