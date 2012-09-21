Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab2IUN0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 09:26:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:57738 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab2IUN0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 09:26:08 -0400
Message-ID: <505C6AD4.6030206@kernel.dk>
Date: Fri, 21 Sep 2012 15:25:40 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Joseph Glanville <joseph.glanville@orionvm.com.au>,
        cgroups <cgroups@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] block: lift the initial queue bypass mode on blk_register_queue()
 instead of blk_init_allocated_queue()
References: <CAOzFzEhf2LfT0BCNPAgPgxZ3=pj2KvJ4Z6kP7XF8nnxag1dfvg@mail.gmail.com> <CAOzFzEiC4313K4H9393ffzNyBo398BPYSxTk7ZEmuH4GfW5qtw@mail.gmail.com> <CAOzFzEhWk_7oQFOyW6Ri_9Cvsshj2s3pa=Oo-p8uL6r340MoTw@mail.gmail.com> <20120919194231.GF31860@redhat.com> <20120920183153.GI28934@google.com> <20120920184219.GH4681@redhat.com> <20120920191716.GI4681@redhat.com> <20120920192038.GJ28934@google.com> <20120920195759.GK4681@redhat.com> <20120920201815.GB7264@google.com> <20120920210852.GC7264@google.com>
In-Reply-To: <20120920210852.GC7264@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 11:08 PM, Tejun Heo wrote:
> b82d4b197c ("blkcg: make request_queue bypassing on allocation") made
> request_queues bypassed on allocation to avoid switching on and off
> bypass mode on a queue being initialized.  Some drivers allocate and
> then destroy a lot of queues without fully initializing them and
> incurring bypass latency overhead on each of them could add upto
> significant overhead.
> 
> Unfortunately, blk_init_allocated_queue() is never used by queues of
> bio-based drivers, which means that all bio-based driver queues are in
> bypass mode even after initialization and registration complete
> successfully.
> 
> Due to the limited way request_queues are used by bio drivers, this
> problem is hidden pretty well but it shows up when blk-throttle is
> used in combination with a bio-based driver.  Trying to configure
> (echoing to cgroupfs file) blk-throttle for a bio-based driver hangs
> indefinitely in blkg_conf_prep() waiting for bypass mode to end.
> 
> This patch moves the initial blk_queue_bypass_end() call from
> blk_init_allocated_queue() to blk_register_queue() which is called for
> any userland-visible queues regardless of its type.
> 
> I believe this is correct because I don't think there is any block
> driver which needs or wants working elevator and blk-cgroup on a queue
> which isn't visible to userland.  If there are such users, we need a
> different solution.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Joseph Glanville <joseph.glanville@orionvm.com.au>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: stable@vger.kernel.org
> ---
> Jens, while these are fixes, I think it isn't extremely urgent and
> routing these through 3.7-rc1 should be enough.

Agree, I'll shove them into for-3.7/core

-- 
Jens Axboe

