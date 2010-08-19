Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab0HSPTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:19:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:47572 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab0HSPTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:19:48 -0400
Message-ID: <4C6D4A9D.1020400@kernel.org>
Date: Thu, 19 Aug 2010 17:15:41 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        Tejun Heo <tj@kernle.org>
Subject: Re: [PATCH 3/5] lguest: replace VIRTIO_F_BARRIER support with VIRTIO_F_FLUSH
 support
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <1281977523-19335-4-git-send-email-tj@kernel.org>
In-Reply-To: <1281977523-19335-4-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 19 Aug 2010 15:19:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VIRTIO_F_BARRIER is deprecated.  Replace it with VIRTIO_F_FLUSH
support.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@lst.de>
---
FUA support dropped as suggested by Christoph.  Rusty, can you please
ack this version too?  I tested it with the updated virtio_blk and it
works fine.

Thanks.

 Documentation/lguest/lguest.c |   29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

Index: block/Documentation/lguest/lguest.c
===================================================================
--- block.orig/Documentation/lguest/lguest.c
+++ block/Documentation/lguest/lguest.c
@@ -1639,15 +1639,6 @@ static void blk_request(struct virtqueue
 	off = out->sector * 512;

 	/*
-	 * The block device implements "barriers", where the Guest indicates
-	 * that it wants all previous writes to occur before this write.  We
-	 * don't have a way of asking our kernel to do a barrier, so we just
-	 * synchronize all the data in the file.  Pretty poor, no?
-	 */
-	if (out->type & VIRTIO_BLK_T_BARRIER)
-		fdatasync(vblk->fd);
-
-	/*
 	 * In general the virtio block driver is allowed to try SCSI commands.
 	 * It'd be nice if we supported eject, for example, but we don't.
 	 */
@@ -1679,6 +1670,13 @@ static void blk_request(struct virtqueue
 			/* Die, bad Guest, die. */
 			errx(1, "Write past end %llu+%u", off, ret);
 		}
+
+		wlen = sizeof(*in);
+		*in = (ret >= 0 ? VIRTIO_BLK_S_OK : VIRTIO_BLK_S_IOERR);
+	} else if (out->type & VIRTIO_BLK_T_FLUSH) {
+		/* Flush */
+		ret = fdatasync(vblk->fd);
+		verbose("FLUSH fdatasync: %i\n", ret);
 		wlen = sizeof(*in);
 		*in = (ret >= 0 ? VIRTIO_BLK_S_OK : VIRTIO_BLK_S_IOERR);
 	} else {
@@ -1702,15 +1700,6 @@ static void blk_request(struct virtqueue
 		}
 	}

-	/*
-	 * OK, so we noted that it was pretty poor to use an fdatasync as a
-	 * barrier.  But Christoph Hellwig points out that we need a sync
-	 * *afterwards* as well: "Barriers specify no reordering to the front
-	 * or the back."  And Jens Axboe confirmed it, so here we are:
-	 */
-	if (out->type & VIRTIO_BLK_T_BARRIER)
-		fdatasync(vblk->fd);
-
 	/* Finished that request. */
 	add_used(vq, head, wlen);
 }
@@ -1735,8 +1724,8 @@ static void setup_block_file(const char
 	vblk->fd = open_or_die(filename, O_RDWR|O_LARGEFILE);
 	vblk->len = lseek64(vblk->fd, 0, SEEK_END);

-	/* We support barriers. */
-	add_feature(dev, VIRTIO_BLK_F_BARRIER);
+	/* We support FLUSH. */
+	add_feature(dev, VIRTIO_BLK_F_FLUSH);

 	/* Tell Guest how many sectors this device has. */
 	conf.capacity = cpu_to_le64(vblk->len / 512);
