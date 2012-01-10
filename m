Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab2AJXMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:12:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52617 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934201Ab2AJXCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:02:20 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:56:03 2012
Message-Id: <20120110215603.282928038@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:55:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Boaz Harrosh <bharrosh@panasas.com>
Subject: [20/49] ore: fix BUG_ON, too few sgs when reading
In-Reply-To: <20120110215609.GA22505@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boaz Harrosh <bharrosh@panasas.com>

commit 361aba569f55dd159b850489a3538253afbb3973 upstream.

When reading RAID5 files, in rare cases, we calculated too
few sg segments. There should be two extra for the beginning
and end partial units.

Also "too few sg segments" should not be a BUG_ON there is
all the mechanics in place to handle it, as a short read.
So just return -ENOMEM and the rest of the code will gracefully
split the IO.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/exofs/ore.c      |    2 +-
 fs/exofs/ore_raid.c |    6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/fs/exofs/ore.c
+++ b/fs/exofs/ore.c
@@ -266,7 +266,7 @@ int  ore_get_rw_state(struct ore_layout
 
 			/* first/last seg is split */
 			num_raid_units += layout->group_width;
-			sgs_per_dev = div_u64(num_raid_units, data_devs);
+			sgs_per_dev = div_u64(num_raid_units, data_devs) + 2;
 		} else {
 			/* For Writes add parity pages array. */
 			max_par_pages = num_raid_units * pages_in_unit *
--- a/fs/exofs/ore_raid.c
+++ b/fs/exofs/ore_raid.c
@@ -551,7 +551,11 @@ int _ore_add_parity_unit(struct ore_io_s
 			    unsigned cur_len)
 {
 	if (ios->reading) {
-		BUG_ON(per_dev->cur_sg >= ios->sgs_per_dev);
+		if (per_dev->cur_sg >= ios->sgs_per_dev) {
+			ORE_DBGMSG("cur_sg(%d) >= sgs_per_dev(%d)\n" ,
+				per_dev->cur_sg, ios->sgs_per_dev);
+			return -ENOMEM;
+		}
 		_ore_add_sg_seg(per_dev, cur_len, true);
 	} else {
 		struct __stripe_pages_2d *sp2d = ios->sp2d;


