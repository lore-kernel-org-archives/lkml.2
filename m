Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab1JKRFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:05:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266Ab1JKRFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:05:06 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:12 2011
Message-Id: <20111011165712.257721450@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:36 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [26/38] dm table: avoid crash if integrity profile changes
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 876fbba1db4a377f050a2bb49b474c7527b2995d upstream.

Commit a63a5cf (dm: improve block integrity support) introduced a
two-phase initialization of a DM device's integrity profile.  This
patch avoids dereferencing a NULL 'template_disk' pointer in
blk_integrity_register() if there is an integrity profile mismatch in
dm_table_set_integrity().

This can occur if the integrity profiles for stacked devices in a DM
table are changed between the call to dm_table_prealloc_integrity() and
dm_table_set_integrity().

Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-table.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1184,14 +1184,15 @@ static void dm_table_set_integrity(struc
 		return;
 
 	template_disk = dm_table_get_integrity_disk(t, true);
-	if (!template_disk &&
-	    blk_integrity_is_initialized(dm_disk(t->md))) {
+	if (template_disk)
+		blk_integrity_register(dm_disk(t->md),
+				       blk_get_integrity(template_disk));
+	else if (blk_integrity_is_initialized(dm_disk(t->md)))
 		DMWARN("%s: device no longer has a valid integrity profile",
 		       dm_device_name(t->md));
-		return;
-	}
-	blk_integrity_register(dm_disk(t->md),
-			       blk_get_integrity(template_disk));
+	else
+		DMWARN("%s: unable to establish an integrity profile",
+		       dm_device_name(t->md));
 }
 
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,


