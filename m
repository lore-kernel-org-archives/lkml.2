Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab2CHTGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 14:06:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab2CHTGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 14:06:20 -0500
Date: Thu, 8 Mar 2012 11:06:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, hughd@google.com,
        avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org, dpshah@google.com, ctalbott@google.com,
        rni@google.com
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-Id: <20120308110618.9bed7bf8.akpm@linux-foundation.org>
In-Reply-To: <20120308175708.GB22922@redhat.com>
References: <20120227091141.GG3401@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120227194321.GF27677@redhat.com>
	<20120229173639.GB5930@redhat.com>
	<20120305221321.GF1263@google.com>
	<20120306210954.GF32148@redhat.com>
	<20120306132034.ecaf8b20.akpm@linux-foundation.org>
	<20120306213437.GG32148@redhat.com>
	<20120306135531.828ca78e.akpm@linux-foundation.org>
	<20120307145556.GA11262@redhat.com>
	<20120307150549.955d6f9c.akpm@linux-foundation.org>
	<20120308175708.GB22922@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2012 12:57:08 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Wed, Mar 07, 2012 at 03:05:49PM -0800, Andrew Morton wrote:
> 
> [..]
> > > > btw, speaking of uniprocessor: please do perform a uniprocessor build
> > > > and see what impact the patch has upon the size(1) output for the .o
> > > > files.  We should try to minimize the pointless bloat for the UP
> > > > kernel.
> > > 
> > > But this logic is required both for UP and SMP kernels. So bloat on UP
> > > is not unnecessary?
> > 
> > UP doesn't need a per-cpu variable, hence it doesn't need to run
> > alloc_per_cpu() at all.  For UP all we need to do is to aggregate a
> > `struct blkio_group_stats' within `struct blkg_policy_data'?
> > 
> > This could still be done with suitable abstraction and wrappers. 
> > Whether that's desirable depends on how fat the API ends up, I guess.
> > 
> 
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

That's a fairly nice improvement and the ifdeffery isn't excessive.

I'd be concerned about having two such different code paths though: it
weakens our performance testing coverage and I expect that most core
kernel developers only test SMP.

Perhaps a better approach would be to make the percpu stuff separately
configurable, so that SMP people can test it and so that small SMP can
avoid it as well.  (Do we know that the percpu feature is a net win on
a 2-way?).

It's quite common for us to degrade UP in favor of SMP, often in the
area of percpuification.  This is bad.  But blkcg surely isn't the most
appropriate place to start addressing this :(

