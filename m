Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab1EaPhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:37:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38216 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab1EaPht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:37:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DN8vo8Knkt5EilwLiMo1k3Ojg2goDY4zqcmGXCsV2BGLvd5kY2VGEAMXTdBMq5HnQG
         4wEYULyqAxLYQVqZ5iEFjpoxMGDWCTpdHpp3RueFsVJ6WRlKvBfU8hDknRsg45nyq2jm
         C0S8N+Xjw+bsN5X3LIh5ZWq2DgL4v/5esTyTg=
Date: Wed, 1 Jun 2011 00:37:44 +0900
From: Tejun Heo <tj@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: blkdev_get() change causes OOPS...
Message-ID: <20110531153744.GB9048@mtj.dyndns.org>
References: <20110530.223506.424661345.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110530.223506.424661345.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 10:35:07PM -0700, David Miller wrote:
> 
> I don't think whole->bd_disk is guaranteed to be non-NULL where you're
> dereferencing it in blkdev_get() after commit
> d4dc210f69bcb0b4bef5a83b1c323817be89bad1 ("block: don't block events
> on excl write for non-optical devices")

Ah... right, it's there if open succeeded.  I should have put the test
after !res test.  Does the following patch fix the problem?

Thanks.

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 1f2b199..1a2421f 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1272,8 +1272,8 @@ int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder)
 		 * individual writeable reference is too fragile given the
 		 * way @mode is used in blkdev_get/put().
 		 */
-		if ((disk->flags & GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE) &&
-		    !res && (mode & FMODE_WRITE) && !bdev->bd_write_holder) {
+		if (!res && (mode & FMODE_WRITE) && !bdev->bd_write_holder &&
+		    (disk->flags & GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE)) {
 			bdev->bd_write_holder = true;
 			disk_block_events(disk);
 		}

