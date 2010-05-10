Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121Ab0EJX1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:27:50 -0400
Received: from kroah.org ([198.145.64.141]:33405 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932550Ab0EJWw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:58 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:26 2010
Message-Id: <20100510223326.682389596@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:33:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [103/117] md: restore ability of spare drives to spin down.
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 1176568de7e066c0be9e46c37503b9fd4730edcf upstream.

Some time ago we stopped the clean/active metadata updates
from being written to a 'spare' device in most cases so that
it could spin down and say spun down.  Device failure/removal
etc are still recorded on spares.

However commit 51d5668cb2e3fd1827a55 broke this 50% of the time,
depending on whether the event count is even or odd.
The change log entry said:

   This means that the alignment between 'odd/even' and
    'clean/dirty' might take a little longer to attain,

how ever the code makes no attempt to create that alignment, so it
could take arbitrarily long.

So when we find that clean/dirty is not aligned with odd/even,
force a second metadata-update immediately.  There are already cases
where a second metadata-update is needed immediately (e.g. when a
device fails during the metadata update).  We just piggy-back on that.

Reported-by: Joe Bryant <tenminjoe@yahoo.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2108,12 +2108,18 @@ repeat:
 		if (!mddev->in_sync || mddev->recovery_cp != MaxSector) { /* not clean */
 			/* .. if the array isn't clean, an 'even' event must also go
 			 * to spares. */
-			if ((mddev->events&1)==0)
+			if ((mddev->events&1)==0) {
 				nospares = 0;
+				sync_req = 2; /* force a second update to get the
+					       * even/odd in sync */
+			}
 		} else {
 			/* otherwise an 'odd' event must go to spares */
-			if ((mddev->events&1))
+			if ((mddev->events&1)) {
 				nospares = 0;
+				sync_req = 2; /* force a second update to get the
+					       * even/odd in sync */
+			}
 		}
 	}
 


