Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab0DOGo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 02:44:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52613 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab0DOGoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 02:44:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20100415063219.GR2493@dastard>
References: <20100415133332.D183.A69D9226@jp.fujitsu.com> <20100415063219.GR2493@dastard>
Message-Id: <20100415154328.D18F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 15 Apr 2010 15:44:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Apr 15, 2010 at 01:35:17PM +0900, KOSAKI Motohiro wrote:
> > > Hi
> > > 
> > > > How about this? For now, we stop direct reclaim from doing writeback
> > > > only on order zero allocations, but allow it for higher order
> > > > allocations. That will prevent the majority of situations where
> > > > direct reclaim blows the stack and interferes with background
> > > > writeout, but won't cause lumpy reclaim to change behaviour.
> > > > This reduces the scope of impact and hence testing and validation
> > > > the needs to be done.
> > > 
> > > Tend to agree. but I would proposed slightly different algorithm for
> > > avoind incorrect oom.
> > > 
> > > for high order allocation
> > > 	allow to use lumpy reclaim and pageout() for both kswapd and direct reclaim
> > > 
> > > for low order allocation
> > > 	- kswapd:          always delegate io to flusher thread
> > > 	- direct reclaim:  delegate io to flusher thread only if vm pressure is low
> > > 
> > > This seems more safely. I mean Who want see incorrect oom regression?
> > > I've made some pathes for this. I'll post it as another mail.
> > 
> > Now, kernel compile and/or backup operation seems keep nr_vmscan_write==0.
> > Dave, can you please try to run your pageout annoying workload?
> 
> It's just as easy for you to run and observe the effects. Start with a VM
> with 1GB RAM and a 10GB scratch block device:
> 
> # mkfs.xfs -f /dev/<blah>
> # mount -o logbsize=262144,nobarrier /dev/<blah> /mnt/scratch
> 
> in one shell:
> 
> # while [ 1 ]; do dd if=/dev/zero of=/mnt/scratch/foo bs=1024k ; done
> 
> in another shell, if you have fs_mark installed, run:
> 
> # ./fs_mark -S0 -n 100000 -F -s 0 -d /mnt/scratch/0 -d /mnt/scratch/1 -d /mnt/scratch/3 -d /mnt/scratch/2 &
> 
> otherwise run a couple of these in parallel on different directories:
> 
> # for i in `seq 1 1 100000`; do echo > /mnt/scratch/0/foo.$i ; done

Thanks.

Unfortunately, I don't have unused disks. So, I'll try it at (probably)
next week.




