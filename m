Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab2B0OZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 09:25:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab2B0OZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 09:25:41 -0500
Date: Mon, 27 Feb 2012 09:25:29 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120227142529.GA27677@redhat.com>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
 <20120223144336.58742e1b.akpm@linux-foundation.org>
 <20120223230123.GL22536@google.com>
 <20120223231204.GM22536@google.com>
 <20120225034432.GA18391@redhat.com>
 <20120225214641.GB3401@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120225222113.GE3401@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120225222113.GE3401@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 26, 2012 at 07:21:13AM +0900, Tejun Heo wrote:
> On Sun, Feb 26, 2012 at 06:46:41AM +0900, Tejun Heo wrote:
> > Hello,
> > 
> > On Fri, Feb 24, 2012 at 10:44:32PM -0500, Vivek Goyal wrote:
> > > Booting with blkcg-stacking branch and changing io scheduler from cfq to
> > > deadline oopsed.
> > > 
> > > login: [   67.382768] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
> > > [   67.383037] CPU 1 
> > > [   67.383037] Modules linked in: floppy [last unloaded: scsi_wait_scan]
> > > [   67.383037] 
> > > [   67.383037] Pid: 4763, comm: bash Not tainted 3.3.0-rc3-tejun-misc+ #6 Hewlett-Packard HP xw6600 Workstation/0A9Ch
> > > [   67.383037] RIP: 0010:[<ffffffff81311793>]  [<ffffffff81311793>] cfq_put_queue+0xb3/0x1d0
> > 
> > Hmmm... weird.  Looking into it.  I'm away from office for a week and
> > will probably be slow.
> 
> It won't reproduce here.  Can you please explain how to trigger it?
> Can you please also run addr2line on the oops address?

I have BLK_CGROUP enabled. CFQ is deafult scheduler. I boot the system and
just change the scheduler to deadline on sda and crash happens. It is
consistently reproducible on my machine.

add2line points to, blk-cgroup.h

blkg_put() {
	WARN_ON_ONCE(blkg->refcnt <= 0);
}

I put more printk and we are putting down async queues when crash happens.

cfq_put_async_queues().

So looks like a group might have already been freed. May be it is a group
refcount issue. I see 6b6b6b... pattern in RBX. Sounds like a use after
free thing.

Thanks
Vivek
