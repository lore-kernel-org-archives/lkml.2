Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab2G1UoU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 16:44:20 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58128 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab2G1UoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 16:44:18 -0400
Subject: Re: [PATCH 2/3] Introduce percpu rw semaphores
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        "Alasdair G. Kergon" <agk@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
        lwoodman@redhat.com, Andrea Arcangeli <aarcange@redhat.com>,
        kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com>
	 <20120628111541.GB17515@quack.suse.cz>
	 <Pine.LNX.4.64.1207152051490.4240@file.rdu.redhat.com>
	 <x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com>
	 <Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com>
	 <x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com>
	 <Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com>
	 <Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 Jul 2012 22:44:12 +0200
Message-ID: <1343508252.2626.13184.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-28 at 12:41 -0400, Mikulas Patocka wrote:
> Introduce percpu rw semaphores
> 
> When many CPUs are locking a rw semaphore for read concurrently, cache
> line bouncing occurs. When a CPU acquires rw semaphore for read, the
> CPU writes to the cache line holding the semaphore. Consequently, the
> cache line is being moved between CPUs and this slows down semaphore
> acquisition.
> 
> This patch introduces new percpu rw semaphores. They are functionally
> identical to existing rw semaphores, but locking the percpu rw semaphore
> for read is faster and locking for write is slower.
> 
> The percpu rw semaphore is implemented as a percpu array of rw
> semaphores, each semaphore for one CPU. When some thread needs to lock
> the semaphore for read, only semaphore on the current CPU is locked for
> read. When some thread needs to lock the semaphore for write, semaphores
> for all CPUs are locked for write. This avoids cache line bouncing.
> 
> Note that the thread that is locking percpu rw semaphore may be
> rescheduled, it doesn't cause bug, but cache line bouncing occurs in
> this case.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

I am curious to see how this performs with 4096 cpus ?

Really you shouldnt use rwlock in a path if this might hurt performance.

RCU is probably a better answer.

(bdev->bd_block_size should be read exactly once )



