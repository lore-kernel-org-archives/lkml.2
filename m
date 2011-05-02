Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab1EBMi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 08:38:29 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:37954 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754561Ab1EBMi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 08:38:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJCkvk15LBza/2dsb2JhbACmG3jABg6FcgSdLQ
Date: Mon, 2 May 2011 22:38:24 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        minchan.kim@gmail.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110502123824.GB2978@dastard>
References: <20110427022655.GE12436@dastard>
 <alpine.DEB.2.01.1104270042510.18728@trent.utfs.org>
 <20110427102824.GI12436@dastard>
 <alpine.DEB.2.01.1104281008320.18728@trent.utfs.org>
 <20110428233751.GR12436@dastard>
 <alpine.DEB.2.01.1104291250480.18728@trent.utfs.org>
 <20110429201701.GA13166@x4.trippels.de>
 <alpine.DEB.2.01.1104291710340.18728@trent.utfs.org>
 <20110501080149.GD13542@dastard>
 <alpine.DEB.2.01.1105020210160.18728@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1105020210160.18728@trent.utfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 02:26:17AM -0700, Christian Kujau wrote:
> On Sun, 1 May 2011 at 18:01, Dave Chinner wrote:
> > I really don't know why the xfs inode cache is not being trimmed. I
> > really, really need to know if the XFS inode cache shrinker is
> > getting blocked or not running - do you have those sysrq-w traces
> > when near OOM I asked for a while back?
> 
> Here's another attempt at getting those:
> 
>   http://nerdbynature.de/bits/2.6.39-rc4/oom/
>   * messages-11.txt.gz & slabinfo-11.txt.bz2
>     - oom-killer at 00:05:04
>     - last sysrq-w to succeed at 00:05:03
> 
>   * messages-12.txt.gz & slabinfo-12.txt.bz2, along
>     with meminfo-post-oom-12.txt & sysrq-w_post-oom-12.jpg could
>     be more interesting:
>     - last sysrq-w to succeed at 01:27:08
>     - oom-killer at 01:27:11
> 
>    ...but after the OOM-killer was killing quite a few processes, MemFree
>    showed 511236 kB free memory, yet ssh logins were still being killed.
>    Finally I got a root shell on the box, issued sysrq-w again and even
>    executed /bin/sync, which came back. But looking at the logs now 
>    nothing went to the disk (/var/log resides on / which is a ext4 fs).
>    See sysrq-w_post-oom-12.jpg for a sysrq-w I took 2381s after boot time,
>    or 01:32 - syslog stopped on 01:27.

Same problem:

MemFree:          511236 kB
....
LowTotal:         759904 kB
LowFree:            3804 kB

i.e. that low memory is being exhausted by the slab cache, while
there is lots of free high memory, and the low memory zone is marked
as all unreclaimable....

The sysrq trace less than 1s before the first OOM shows this:

[c00770ec] __lock_acquire+0x43c/0x1818 (unreliable)
[c000a924] __switch_to+0x9c/0x128
[c0417580] schedule+0x274/0x8bc
[c0418128] schedule_timeout+0x16c/0x214
[c04172a0] io_schedule_timeout+0xb0/0x11c
[c00b153c] congestion_wait+0x8c/0xdc
[c00aa43c] kswapd+0x6d0/0x884
[c005e3d0] kthread+0x84/0x88
[c0010908] kernel_thread+0x4c/0x68

Background memory reclaim appears to be blocked by IO congestion....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
