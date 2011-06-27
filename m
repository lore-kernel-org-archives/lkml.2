Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab1F0RPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 13:15:34 -0400
Received: from diomedes.noc.ntua.gr ([147.102.222.220]:63317 "EHLO
	diomedes.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab1F0RP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 13:15:29 -0400
Date: Mon, 27 Jun 2011 20:18:42 +0300
From: Kornilios Kourtis <kkourt@cslab.ece.ntua.gr>
To: Vasileios Karakasis <bkk@cslab.ece.ntua.gr>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-numa@vger.kernel.org
Subject: Re: [BUG] Invalid return address of mmap() followed by mbind() in
 multithreaded context
Message-ID: <20110627171842.GA7554@solar.cslab.ece.ntua.gr>
References: <4DFB710D.7000902@cslab.ece.ntua.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFB710D.7000902@cslab.ece.ntua.gr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (diomedes.noc.ntua.gr [147.102.222.220]); Mon, 27 Jun 2011 20:15:19 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Fri, Jun 17, 2011 at 06:21:49PM +0300, Vasileios Karakasis wrote:
> Hi,
> 
> I am implementing a multithreaded numa aware code where each thread
> mmap()'s an anonymous private region and then mbind()'s it to its local
> node. The threads are performing a series of such mmap() + mbind()
> operations. My program crashed with SIGSEGV and I noticed that mmap()
> returned an invalid address.

I've taken a closer look at this issue.

As Vasileios said, it can be reproduced by having two threads doing the
following loop:
| for {
| 	addr = mmap(4096, MAP_ANONUMOUS)
| 	if (addr == (void *)-1)
| 		continue
| 	mbind(addr, 4096, 0x1) // do mbind on first NUMA node
| }
After a couple of iterations, mbind() will return EFAULT, although the addr is
valid.

Doing a bisect, pins it down to the following commit (Author added to To:):
	9d8cebd4bcd7c3878462fdfda34bbcdeb4df7ef4
	mm: fix mbind vma merge problem
Which adds merging of vmas in the mbind() path.
Reverting this commit, seems to fix the issue.

I 've added some printks to track down the issue, and EFAULT is returned on:
mm/mempolicy.c: mbind_range()
|   vma = find_vma_prev(mm. start, &prev);
|   if (!vma |vma->vm_start > start)
|       return EFAULT;
Where: vma->start > start

I am not sure what exactly happens, but concurrent merges and splits
of (already mapped) VMAs do not seem to work well together.

cheers,
-Kornilios

-- 
Kornilios Kourtis
