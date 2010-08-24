Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934223Ab0HXXeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:34:20 -0400
Received: from kroah.org ([198.145.64.141]:40420 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932919Ab0HXW6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:58:50 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:15 2010
Message-Id: <20100824224215.427764528@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:42:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mikulas Patocka <mpatocka@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [39/91] dm snapshot: iterate origin and cow devices
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 1e5554c8428bc7209a83e2d07ca724be4d981ce3 upstream.

Iterate both origin and snapshot devices

iterate_devices method should call the callback for all the devices where
the bio may be remapped. Thus, snapshot_iterate_devices should call the callback
for both snapshot and origin underlying devices because it remaps some bios
to the snapshot and some to the origin.

snapshot_iterate_devices called the callback only for the origin device.
This led to badly calculated device limits if snapshot and origin were placed
on different types of disks.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-snap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1899,8 +1899,14 @@ static int snapshot_iterate_devices(stru
 				    iterate_devices_callout_fn fn, void *data)
 {
 	struct dm_snapshot *snap = ti->private;
+	int r;
 
-	return fn(ti, snap->origin, 0, ti->len, data);
+	r = fn(ti, snap->origin, 0, ti->len, data);
+
+	if (!r)
+		r = fn(ti, snap->cow, 0, get_dev_size(snap->cow->bdev), data);
+
+	return r;
 }
 
 


