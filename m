Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab0CSPXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:23:42 -0400
Received: from kroah.org ([198.145.64.141]:45860 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab0CSPSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:18:38 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@csn.ul.ie>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/7] tty: Take a 256 byte padding into account when buffering below sub-page units
Date: Fri, 19 Mar 2010 08:18:31 -0700
Message-Id: <1269011916-8836-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <20100319151326.GC8541@kroah.com>
References: <20100319151326.GC8541@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mel@csn.ul.ie>

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
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/tty.h |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 568369a..593228a 100644
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
-- 
1.7.0.2

