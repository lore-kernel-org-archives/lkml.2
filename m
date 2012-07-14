Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab2GNDld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 23:41:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52949 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524Ab2GNDl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 23:41:29 -0400
Date: Fri, 13 Jul 2012 20:41:22 -0700
From: Tejun Heo <tj@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        joshhunt00@gmail.com, axboe@kernel.dk, rni@google.com,
        vgoyal@redhat.com, vwadekar@nvidia.com, herbert@gondor.hengli.com.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org, swhiteho@redhat.com,
        bpm@sgi.com, elder@kernel.org, xfs@oss.sgi.com, marcel@holtmann.org,
        gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, martin.petersen@oracle.com,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 6/6] workqueue: reimplement WQ_HIGHPRI using a separate
 worker_pool
Message-ID: <20120714034122.GA5638@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1341859315-17759-7-git-send-email-tj@kernel.org>
 <20120712130648.GA19214@localhost>
 <20120712170519.GA20167@google.com>
 <20120712214514.GD20167@google.com>
 <20120713020800.GA14026@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120713020800.GA14026@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jul 13, 2012 at 10:08:00AM +0800, Fengguang Wu wrote:
> [    0.165669] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
> [    0.167001] XXX cpu=0 gcwq=ffff88000dc0cfc0 base=ffff88000dc11e80
> [    0.167989] XXX cpu=0 nr_running=0 @ ffff88000dc11e80
> [    0.168988] XXX cpu=0 nr_running=0 @ ffff88000dc11e88
> [    0.169988] XXX cpu=1 gcwq=ffff88000dd0cfc0 base=ffff88000dd11e80
> [    0.170988] XXX cpu=1 nr_running=0 @ ffff88000dd11e80
> [    0.171987] XXX cpu=1 nr_running=0 @ ffff88000dd11e88
> [    0.172988] XXX cpu=8 nr_running=0 @ ffffffff81d7c430
> [    0.173987] XXX cpu=8 nr_running=12 @ ffffffff81d7c438

Heh, I found it.  get_pool_nr_running() stores the nr_running array to
use in a local pointer to array and then returns pointer to the
specific element from there depending on the priority.

	atomic_t (*nr_running)[NR_WORKER_POOLS];

	/* set @nr_running to the array to use */
	return nr_running[worker_pool_pri(pool)];

The [] operator in the return statement is indexing to the arrays
instead of the array elements, so if the index is 1, the above
statement offsets nr_running by sizeof(atomic_t [NR_WORKER_POOLS])
instead of sizeof(atomic_t).  This should have been
&(*nr_running)[worker_pool_pri(pool)] instead.

So, highpri ends up dereferencing out-of-bounds and depending on
variable layout, it may see garbage value from the beginning (what you
were seeing) or get interfered afterwards (what Tony was seeing).
This also explains why I didn't see it and Tony can no longer
reproduce it after debug patch.

Will post updated patches.

Thank you.

-- 
tejun
