Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab1GFO5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 10:57:01 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47986 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab1GFO47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 10:56:59 -0400
Message-ID: <4E1477B9.1050701@kernel.dk>
Date: Wed, 06 Jul 2011 16:56:57 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Roland Dreier <roland@kernel.org>
CC: open list <linux-kernel@vger.kernel.org>
Subject: Re: warning because of race between userspace and add_disk()?
References: <CAG4TOxP1eTY_R_t57U1Ux=RTFa=3BWWL9yzL-p9sC+YWrpZmYQ@mail.gmail.com>
In-Reply-To: <CAG4TOxP1eTY_R_t57U1Ux=RTFa=3BWWL9yzL-p9sC+YWrpZmYQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-06 02:14, Roland Dreier wrote:
> Hi Jens!
> 
> I'm seeing the warning below (with 3.0-rc5) when I hot-add a disk.
> The system has a JBOD with 4 SAS paths, so we get 4 /dev/sdXX for the
> disk (I don't think this is strictly required to trigger this, but I
> think it makes the race bigger).
> 
> What I _think_ is happening is that add_disk() exposes the /dev/sdXX
> device to userspace before it does disk_add_events(), and the
> multipath daemon immediately tries to open the device.  This means
> that blkdev_get() (called from blkdev_open()) races with
> disk_add_events() and so the first call to disk_block_events() returns
> immediately because of
> 
> 	struct disk_events *ev = disk->ev;
> 	if (!ev)
> 		return;
> 
> but then on the way out, disk_unblock_events() finds that disk->ev has
> been set and so hits the warning.
> 
> I guess the fix would be to be more careful about the order we expose
> things when registering disks?

It certainly looks like it, we need to order disk_add_events() before
register_disk() or handle this more gracefully. I'll cook up a patch.

-- 
Jens Axboe

