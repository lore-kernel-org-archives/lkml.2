Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471Ab1I1WuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:50:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933509Ab1I1WuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:50:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:50 2011
Message-Id: <20110928220150.045269041@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:03:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Salyzyn <msalyzyn@us.xyratex.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [234/244] [SCSI] libsas: fix failure to revalidate domain for anything but the first expander child.
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Salyzyn <mark_salyzyn@us.xyratex.com>

commit 24926dadc41cc566e974022b0e66231b82c6375f upstream.

In an enclosure model where there are chaining expanders to a large body
of storage, it was discovered that libsas, responding to a broadcast
event change, would only revalidate the domain of first child expander
in the list.

The issue is that the pointer value to the discovered source device was
used to break out of the loop, rather than the content of the pointer.

This still remains non-compliant as the revalidate domain code is
supposed to loop through all child expanders, and not stop at the first
one it finds that reports a change count. However, the design of this
routine does not allow multiple device discoveries and that would be a
more complicated set of patches reserved for another day. We are fixing
the glaring bug rather than refactoring the code.

Signed-off-by: Mark Salyzyn <msalyzyn@us.xyratex.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/libsas/sas_expander.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1721,7 +1721,7 @@ static int sas_find_bcast_dev(struct dom
 	list_for_each_entry(ch, &ex->children, siblings) {
 		if (ch->dev_type == EDGE_DEV || ch->dev_type == FANOUT_DEV) {
 			res = sas_find_bcast_dev(ch, src_dev);
-			if (src_dev)
+			if (*src_dev)
 				return res;
 		}
 	}


