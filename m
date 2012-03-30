Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935286Ab2C3Wqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:46:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37370 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935108Ab2C3VGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:06:44 -0400
Message-Id: <20120330195732.222210258@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:58:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 070/108] UBI: fix eraseblock picking criteria
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit 7eb3aa65853e1b223bfc786b023b702018cb76c0 upstream.

The 'find_wl_entry()' function expects the maximum difference as the second
argument, not the maximum absolute value. So the "unknown" eraseblock picking
was incorrect, as Shmulik Ladkani spotted. This patch fixes the issue.

Reported-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reviewed-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/ubi/wl.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -386,7 +386,7 @@ static struct ubi_wl_entry *find_wl_entr
  */
 int ubi_wl_get_peb(struct ubi_device *ubi, int dtype)
 {
-	int err, medium_ec;
+	int err;
 	struct ubi_wl_entry *e, *first, *last;
 
 	ubi_assert(dtype == UBI_LONGTERM || dtype == UBI_SHORTTERM ||
@@ -424,7 +424,7 @@ retry:
 		 * For unknown data we pick a physical eraseblock with medium
 		 * erase counter. But we by no means can pick a physical
 		 * eraseblock with erase counter greater or equivalent than the
-		 * lowest erase counter plus %WL_FREE_MAX_DIFF.
+		 * lowest erase counter plus %WL_FREE_MAX_DIFF/2.
 		 */
 		first = rb_entry(rb_first(&ubi->free), struct ubi_wl_entry,
 					u.rb);
@@ -433,10 +433,8 @@ retry:
 		if (last->ec - first->ec < WL_FREE_MAX_DIFF)
 			e = rb_entry(ubi->free.rb_node,
 					struct ubi_wl_entry, u.rb);
-		else {
-			medium_ec = (first->ec + WL_FREE_MAX_DIFF)/2;
-			e = find_wl_entry(&ubi->free, medium_ec);
-		}
+		else
+			e = find_wl_entry(&ubi->free, WL_FREE_MAX_DIFF/2);
 		break;
 	case UBI_SHORTTERM:
 		/*


