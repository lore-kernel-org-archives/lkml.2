Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab0GHIlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 04:41:16 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54216 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413Ab0GHIlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 04:41:14 -0400
Message-ID: <4C358F29.4020505@kernel.dk>
Date: Thu, 08 Jul 2010 10:41:13 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/7] block: push down BKL into .open and .release
References: <1278514289-21054-1-git-send-email-arnd@arndb.de> <1278514289-21054-4-git-send-email-arnd@arndb.de>
In-Reply-To: <1278514289-21054-4-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-07 16:51, Arnd Bergmann wrote:
> The open and release block_device_operations are currently
> called with the BKL held. In order to change that, we must
> first make sure that all drivers that currently rely
> on this have no regressions.
> 
> This blindly pushes the BKL into all .open and .release
> operations for all block drivers to prepare for the
> next step. The drivers can subsequently replace the BKL
> with their own locks or remove it completely when it can
> be shown that it is not needed.
> 
> The functions blkdev_get and blkdev_put are the only
> remaining users of the big kernel lock in the block
> layer, besides a few uses in the ioctl code, none
> of which need to serialize with blkdev_{get,put}.
> 
> Most of these two functions is also under the protection
> of bdev->bd_mutex, including the actual calls to
> ->open and ->release, and the common code does not
> access any global data structures that need the BKL.

This is missing an smp_lock.h include in i2o as well.
You seem to only add these sporadically, I think that
is a bit unsafe since you are relying on unknown
include hierarchies. That tends to break on one arch
or config even if it works in another.

-- 
Jens Axboe

