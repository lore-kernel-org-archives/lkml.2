Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738Ab0ECMgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 08:36:18 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:53391 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758658Ab0ECMgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 08:36:16 -0400
Date: Mon, 3 May 2010 22:36:06 +1000
From: Dave Chinner <david@fromorbit.com>
To: Peter Palfrader <peter@palfrader.org>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, stable@kernel.org
Subject: Re: [regression,bisected] 2.6.32.12: find(1) on xfs causes OOM
Message-ID: <20100503123606.GG2591@dastard>
References: <20100503115438.GA16623@anguilla.noreply.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100503115438.GA16623@anguilla.noreply.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 01:54:38PM +0200, Peter Palfrader wrote:
> Hi,
> 
> I have an xfs filesystem in a KVM domain with 512megs of memory and 2 gigs of
> swap.
> 
> The filesystem is 750g in size, of which some 500g are in use in about 6
> million files.  (This XFS filesystem is exported via nfs4.  I haven't tested if
> this makes any difference.)
>
> Starting in 2.6.32.12 running something like "find | wc -l" on this
> filesystem's mountpoint causes the OOM killer to kill off most of the
> system.  (See kern.log[1])

Knwon problem.

As a workaraound, you can increase the frequency at which the
xfssyncd runs so that it is less than the default 30s between
background reclaim runs.

> With 2.6.32.11 the system does not behave like this.
> 
> Bisecting turned up the following commit.  Reverting it in 2.6.32.12
> also results in a system that works.
>
> | 9e1e9675fb29c0e94a7c87146138aa2135feba2f is first bad commit
> | commit 9e1e9675fb29c0e94a7c87146138aa2135feba2f
> | Author: Dave Chinner <david@fromorbit.com>
> | Date:   Fri Mar 12 09:42:10 2010 +1100
> | 
> |     xfs: reclaim all inodes by background tree walks

Reverting this leaves you running with a subtly altered and
completely untested reclaim path that I'm not sure does the right
thing in all situations. I wouldn't run that revert on my machines,
nor recommend it for anyone else. But it's up to you if you want to
run it on your machines....

The fix for this problem only got to mainline a couple of days ago.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9bf729c0af67897ea8498ce17c29b0683f7f2028

I've got to backport it to the stable kernel tree so the next stable
kernel should fix this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
