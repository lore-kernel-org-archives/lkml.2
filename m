Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab1EYVHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:07:04 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62096 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab1EYVHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:07:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=mrNZEfyrD9XU0Iruln7I4q6prdCxM5uMMHFuClaO12Wd68lHbCqTkafZhY+lsKKEDI
         NgO+HFzN8smHNLjJM2kqatbGkgkyQTcLm/2J9JABA+77sURe1VC9U+F4dpsxtb1XlCc0
         /UxOJfeYQYwuyycQjNRv4s7op7K5i/bWCbnW8=
Date: Wed, 25 May 2011 23:06:56 +0200
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux@rainbow-software.org
Subject: [PATCH] block: always allocate genhd->ev if check_events is
 implemented
Message-ID: <20110525210656.GA18894@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

9fd097b149 (block: unexport DISK_EVENT_MEDIA_CHANGE for legacy/fringe
drivers) removed DISK_EVENT_MEDIA_CHANGE from legacy/fringe block
drivers which have inadequate ->check_events().  Combined with earlier
change 7c88a168da (block: don't propagate unlisted DISK_EVENTs to
userland), this enables using ->check_events() for internal processing
while avoiding enabling in-kernel block event polling which can lead
to infinite event loop.

Unfortunately, this made many drivers including floppy without any bit
set in disk->events and ->async_events in which case disk_add_events()
simply skipped allocation of disk->ev, which disables whole event
handling.  As ->check_events() is still used during open processing
for revalidation, this can lead to open failure.

This patch always allocates disk->ev if ->check_events is implemented.
In the long term, it would make sense to simply include the event
structure inline into genhd as it's now used by virtually all block
devices.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ondrej Zary <linux@rainbow-software.org>
Reported-by: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Cc: stable@kernel.org
---
 block/genhd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index 2dd9887..95822ae 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1728,7 +1728,7 @@ static void disk_add_events(struct gendisk *disk)
 {
 	struct disk_events *ev;
 
-	if (!disk->fops->check_events || !(disk->events | disk->async_events))
+	if (!disk->fops->check_events)
 		return;
 
 	ev = kzalloc(sizeof(*ev), GFP_KERNEL);
