Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964978Ab1C3Vih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:38:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:61827 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964896Ab1C3VIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621237676"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: neilb@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [152/275] md: correctly handle probe of an 'mdp' device.
Message-Id: <20110330210633.B954E3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/md/md.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.35.y/drivers/md/md.c
===================================================================
--- linux-2.6.35.y.orig/drivers/md/md.c	2011-03-29 23:02:59.630309629 -0700
+++ linux-2.6.35.y/drivers/md/md.c	2011-03-29 23:53:36.584601568 -0700
@@ -441,6 +441,9 @@
 {
 	mddev_t *mddev, *new = NULL;
 
+	if (unit && MAJOR(unit) != MD_MAJOR)
+		unit &= ~((1<<MdpMinorShift)-1);
+
  retry:
 	spin_lock(&all_mddevs_lock);
 
