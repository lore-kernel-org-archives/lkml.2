Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab1DYU4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:56:31 -0400
Received: from 1wt.eu ([62.212.114.60]:33865 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533Ab1DYUX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:59 -0400
Message-Id: <20110425200235.602626966@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:32 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: NeilBrown <neilb@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 060/173] md: correctly handle probe of an mdp device.
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 8f5f02c460b7ca74ce55ce126ce0c1e58a3f923d upstream.

'mdp' devices are md devices with preallocated device numbers
for partitions. As such it is possible to mknod and open a partition
before opening the whole device.

this causes  md_probe() to be called with a device number of a
partition, which in-turn calls mddev_find with such a number.

However mddev_find expects the number of a 'whole device' and
does the wrong thing with partition numbers.

So add code to mddev_find to remove the 'partition' part of
a device number and just work with the 'whole device'.

This patch addresses https://bugzilla.kernel.org/show_bug.cgi?id=28652

Reported-by: hkmaly@bigfoot.com
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -305,6 +305,9 @@ static mddev_t * mddev_find(dev_t unit)
 {
 	mddev_t *mddev, *new = NULL;
 
+	if (unit && MAJOR(unit) != MD_MAJOR)
+		unit &= ~((1<<MdpMinorShift)-1);
+
  retry:
 	spin_lock(&all_mddevs_lock);
 


