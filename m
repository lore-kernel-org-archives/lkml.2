Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab0C3XVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:21:33 -0400
Received: from kroah.org ([198.145.64.141]:46150 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932558Ab0C3XUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:15 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:03 2010
Message-Id: <20100330224803.432266659@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mel Gorman <mel@csn.ul.ie>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [066/156] tty: Take a 256 byte padding into account when buffering below sub-page units
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mel Gorman <mel@csn.ul.ie>

commit 352fa6ad16b89f8ffd1a93b4419b1a8f2259feab upstream.

The TTY layer takes some care to ensure that only sub-page allocations
are made with interrupts disabled. It does this by setting a goal of
"TTY_BUFFER_PAGE" to allocate. Unfortunately, while TTY_BUFFER_PAGE takes the
size of tty_buffer into account, it fails to account that tty_buffer_find()
rounds the buffer size out to the next 256 byte boundary before adding on
the size of the tty_buffer.

This patch adjusts the TTY_BUFFER_PAGE calculation to take into account the
size of the tty_buffer and the padding. Once applied, tty_buffer_alloc()
should not require high-order allocations.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/tty.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -70,12 +70,13 @@ struct tty_buffer {
 
 /*
  * We default to dicing tty buffer allocations to this many characters
- * in order to avoid multiple page allocations. We assume tty_buffer itself
- * is under 256 bytes. See tty_buffer_find for the allocation logic this
- * must match
+ * in order to avoid multiple page allocations. We know the size of
+ * tty_buffer itself but it must also be taken into account that the
+ * the buffer is 256 byte aligned. See tty_buffer_find for the allocation
+ * logic this must match
  */
 
-#define TTY_BUFFER_PAGE		((PAGE_SIZE  - 256) / 2)
+#define TTY_BUFFER_PAGE	(((PAGE_SIZE - sizeof(struct tty_buffer)) / 2) & ~0xFF)
 
 
 struct tty_bufhead {


