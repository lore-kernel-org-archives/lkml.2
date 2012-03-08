Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab2CHSIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:08:46 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33525 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab2CHSIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:08:39 -0500
Date: Thu, 8 Mar 2012 10:08:33 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, axboe@kernel.dk,
        hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120308180833.GA25508@google.com>
References: <20120227194321.GF27677@redhat.com>
 <20120229173639.GB5930@redhat.com>
 <20120305221321.GF1263@google.com>
 <20120306210954.GF32148@redhat.com>
 <20120306132034.ecaf8b20.akpm@linux-foundation.org>
 <20120306213437.GG32148@redhat.com>
 <20120306135531.828ca78e.akpm@linux-foundation.org>
 <20120307145556.GA11262@redhat.com>
 <20120307150549.955d6f9c.akpm@linux-foundation.org>
 <20120308175708.GB22922@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308175708.GB22922@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Thu, Mar 08, 2012 at 12:57:08PM -0500, Vivek Goyal wrote:
> Ok, here is the patch which gets rid of allocating per cpu stats in case
> of UP. Here are the size stats with and without patch.
> 
> Without patch (UP kernel)
> -------------------------
> # size block/blk-cgroup.o
>    text    data     bss     dec     hex filename
>   13377    5504      58   18939    49fb block/blk-cgroup.o
> 
> With patch (UP kernel)
> ----------------------
> # size block/blk-cgroup.o
>    text    data     bss     dec     hex filename
>   12678    5312      49   18039    4677 block/blk-cgroup.o
> 
> Do you think it is worth introducing these ifdefs.

I'd rather not.  The whole thing goes away if blkio cgroup is
configured out so it's not like we're adding an unconditional burden
to minimal configurations.  Let's keep things simple.

> Anyway, I am assuming that optimization for UP issue is not blocking the
> acceptance of other alloc per cpu patch. I have replaced msleep()
> with queue_delayed_work(). Hopefully it is little less miserable now.

Yeah, I was gonna send the merged patchset yesterday.  Just got caught
up in something else.

> Tejun, I noticed that in UP case, once in a while cgroup removal is
> hanging. Looks like it is hung in cgroup_rmdir() somewhere. I will debug
> more to find out what is happening. May be blkcg->refcount issue.

It's probably from something forgetting to put cgroup and pre_destroy
waiting for it.  Such bugs would have been masked before but now show
up as stalls during rmdir.  I'm not too happy with how cgroup is
handling cgroup file additions and removals and hoping to implement
proper 'sever' semantics similar to that of sysfs.  In the longer
term, such behavior should go away but for now we'll just have to hunt
down the actual bug to avoid stalls (which we have to do anyway but
it's more visible now).

Thanks.

-- 
tejun
