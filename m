Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab1I1Wmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:42:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54109 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906Ab1I1Wmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:42:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:36 2011
Message-Id: <20110928220136.507230095@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [106/244] [SCSI] hpsa: fix physical device lun and target numbering problem
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

commit 01350d05539d1c95ef3568d062d864ab76ae7670 upstream.

If a physical device exposed to the OS by hpsa
is replaced (e.g. one hot plug tape drive is replaced
by another, or a tape drive is placed into "OBDR" mode
in which it acts like a CD-ROM device) and a rescan is
initiated, the replaced device will be added to the
SCSI midlayer with target and lun numbers set to -1.
After that, a panic is likely to ensue.  When a physical
device is replaced, the lun and target number should be
preserved.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/hpsa.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -676,6 +676,16 @@ static void hpsa_scsi_replace_entry(stru
 	BUG_ON(entry < 0 || entry >= HPSA_MAX_SCSI_DEVS_PER_HBA);
 	removed[*nremoved] = h->dev[entry];
 	(*nremoved)++;
+
+	/*
+	 * New physical devices won't have target/lun assigned yet
+	 * so we need to preserve the values in the slot we are replacing.
+	 */
+	if (new_entry->target == -1) {
+		new_entry->target = h->dev[entry]->target;
+		new_entry->lun = h->dev[entry]->lun;
+	}
+
 	h->dev[entry] = new_entry;
 	added[*nadded] = new_entry;
 	(*nadded)++;


