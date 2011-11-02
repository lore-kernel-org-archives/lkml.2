Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab1KCB4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:56:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51171 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934376Ab1KCBkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:40:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:43 2011
Message-Id: <20111102222743.674244367@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mark Salyzyn <msalyzyn@us.xyratex.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [043/101] [SCSI] libsas: fix failure to revalidate domain for anything but the first expander child.
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -1712,7 +1712,7 @@ static int sas_find_bcast_dev(struct dom
 	list_for_each_entry(ch, &ex->children, siblings) {
 		if (ch->dev_type == EDGE_DEV || ch->dev_type == FANOUT_DEV) {
 			res = sas_find_bcast_dev(ch, src_dev);
-			if (src_dev)
+			if (*src_dev)
 				return res;
 		}
 	}


