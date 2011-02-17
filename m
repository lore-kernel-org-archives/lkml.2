Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab1BQRFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:05:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756918Ab1BQRFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:05:02 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: NeilBrown <neilb@suse.de>
Cc: Andrew Patterson <andrew.patterson@hp.com>, Jens Axboe <axboe@kernel.dk>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix over-zealous flush_disk when changing device size.
References: <20110217165057.5c50e566@notabene.brown>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 17 Feb 2011 12:03:48 -0500
In-Reply-To: <20110217165057.5c50e566@notabene.brown> (NeilBrown's message of
	"Thu, 17 Feb 2011 16:50:57 +1100")
Message-ID: <x494o82wq2z.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NeilBrown <neilb@suse.de> writes:

> Hi Andrew (and others)
>  I wonder if you would review the following for me and comment.
>
> Thanks,
> NeilBrown
>
>
>
> From e7f75c2a757108cdd83ce8c808a16bf27686c95f Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Thu, 17 Feb 2011 16:37:30 +1100
> Subject: [PATCH] Fix over-zealous flush_disk when changing device size.
>
> There are two cases when we call flush_disk.
> In one, the device has disappeared (check_disk_change) so any
> data will hold becomes irrelevant.
> In the oter, the device has changed size (check_disk_size_change)
> so data we hold may be irrelevant.
>
> In both cases it makes sense to discard any 'clean' buffers,
> so they will be read back from the device if needed.
>
> In the former case it makes sense to discard 'dirty' buffers
> as there will never be anywhere safe to write the data.  In the
> second case it *does*not* make sense to discard dirty buffers
> as that will lead to file system corruption when you simply enlarge
> the containing devices.
>
> flush_disk calls __invalidate_devices.
> __invalidate_device calls both invalidate_inodes and invalidate_bdev.
>
> invalidate_inodes *does* discard I_DIRTY inodes and this does lead
> to fs corruption.
>
> invalidate_bev *does*not* discard dirty pages, but I don't really care
> about that at present.
>
> So this patch adds a flag to __invalidate_device (calling it
> __invalidate_device2) to indicate whether dirty buffers should be
> killed, and this is passed to invalidate_inodes which can choose to
> skip dirty inodes.
>
> flusk_disk then passes true from check_disk_change and false from
> check_disk_size_change.
>
> dm avoids tripping over this problem by calling i_size_write directly
> rathher than using check_disk_size_change.
>
> md does use check_disk_size_change and so is affected.
>
> This regression was introduced by commit 608aeef17a
> which causes check_disk_size_change to call
> flush_disk.

This makes sense to me.  Nice write-up, Neil.

Acked-by: Jeff Moyer <jmoyer@redhat.com>
