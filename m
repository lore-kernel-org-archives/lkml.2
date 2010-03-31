Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab0CaWM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 18:12:59 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:51725 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753518Ab0CaWM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 18:12:58 -0400
Date: Thu, 1 Apr 2010 09:12:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: Denys Fedorysychenko <nuclearcat@nuclearcat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: endless sync on bdi_sched_wait()? 2.6.33.1
Message-ID: <20100331221254.GI7671@dastard>
References: <201003311907.31342.nuclearcat@nuclearcat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003311907.31342.nuclearcat@nuclearcat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 07:07:31PM +0300, Denys Fedorysychenko wrote:
> I have a proxy server with "loaded" squid. On some moment i did sync, and 
> expecting it to finish in reasonable time. Waited more than 30 minutes, still 
> "sync". Can be reproduced easily.
> 
> Here is some stats and info:
> 
> Linux SUPERPROXY 2.6.33.1-build-0051 #16 SMP Wed Mar 31 17:23:28 EEST 2010 
> i686 GNU/Linux
> 
> SUPERPROXY ~ # iostat -k -x -d 30
> Linux 2.6.33.1-build-0051 (SUPERPROXY)  03/31/10        _i686_  (4 CPU)
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz 
> avgqu-sz   await  svctm  %util
> sda               0.16     0.01    0.08    0.03     3.62     1.33    88.94     
> 0.15 1389.89  59.15   0.66
> sdb               4.14    61.25    6.22   25.55    44.52   347.21    24.66     
> 2.24   70.60   2.36   7.49
> sdc               4.37   421.28    9.95   98.31   318.27  2081.95    44.34    
> 20.93  193.21   2.31  24.96
> sdd               2.34   339.90    3.97  117.47    95.48  1829.52    31.70     
> 1.73   14.23   8.09  98.20
                 ^^^^  ^^^^^

/dev/sdd is IO bound doing small random writeback IO. A service time
of 8ms implies that it is doing lots of large seeks. If you've got
GBs of data to sync and that's the writeback pattern, then sync will
most definitely take a long, long time.

it may be that ext4 is allocating blocks far apart rather than close
together (as appears to be the case for /dev/sdc), so maybe this is
is related to how the filesytems are aging or how full they are...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
