Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626Ab0HLAeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:34:10 -0400
Received: from kroah.org ([198.145.64.141]:43490 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759138Ab0HKX6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:47 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:02 2010
Message-Id: <20100811235502.045387262@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Josef Bacik <josef@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [071/111] Btrfs: do not mark the chunk as readonly if in degraded mode
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Josef Bacik <josef@redhat.com>

commit f48b90756bd834dda852ff514f2690d3175b1f44 upstream.

If a RAID setup has chunks that span multiple disks, and one of those
disks has failed, btrfs_chunk_readonly will return 1 since one of the
disks in that chunk's stripes is dead and therefore not writeable.  So
instead if we are in degraded mode, return 0 so we can go ahead and
allocate stuff.  Without this patch all of the block groups in a RAID1
setup will end up read-only, which will mean we can't add new disks to
the array since we won't be able to make allocations.

Signed-off-by: Josef Bacik <josef@redhat.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/btrfs/volumes.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2538,6 +2538,11 @@ int btrfs_chunk_readonly(struct btrfs_ro
 	if (!em)
 		return 1;
 
+	if (btrfs_test_opt(root, DEGRADED)) {
+		free_extent_map(em);
+		return 0;
+	}
+
 	map = (struct map_lookup *)em->bdev;
 	for (i = 0; i < map->num_stripes; i++) {
 		if (!map->stripes[i].dev->writeable) {


