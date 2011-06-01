Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162151Ab1FAJBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:01:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162116Ab1FAIRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:17:40 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:06 2011
Message-Id: <20110601081105.927148957@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:09:59 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [029/165] block: always allocate genhd->ev if check_events is
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 implemented
Content-Length: 1706
Lines: 45

From: Tejun Heo <tj@kernel.org>

commit 75e3f3ee3c64968d42f4843ec49e579f84b5aa0c upstream.

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
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/genhd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1728,7 +1728,7 @@ static void disk_add_events(struct gendi
 {
 	struct disk_events *ev;
 
-	if (!disk->fops->check_events || !(disk->events | disk->async_events))
+	if (!disk->fops->check_events)
 		return;
 
 	ev = kzalloc(sizeof(*ev), GFP_KERNEL);


