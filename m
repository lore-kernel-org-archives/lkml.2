Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760420Ab1CEBP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:15:59 -0500
Received: from kroah.org ([198.145.64.141]:50212 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760338Ab1CEBAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:09 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:36 2011
Message-Id: <20110305005636.828717449@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>
Subject: [23/73] md: correctly handle probe of an mdp device.
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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
@@ -553,6 +553,9 @@ static mddev_t * mddev_find(dev_t unit)
 {
 	mddev_t *mddev, *new = NULL;
 
+	if (unit && MAJOR(unit) != MD_MAJOR)
+		unit &= ~((1<<MdpMinorShift)-1);
+
  retry:
 	spin_lock(&all_mddevs_lock);
 


