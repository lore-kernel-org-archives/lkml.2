Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab0CaAHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:07:48 -0400
Received: from kroah.org ([198.145.64.141]:45229 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232Ab0C3XSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:18 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:38 2010
Message-Id: <20100330225638.054650490@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [061/116] tty: Keep the default buffering to sub-page units
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit d9661adfb8e53a7647360140af3b92284cbe52d4 upstream.

We allocate during interrupts so while our buffering is normally diced up
small anyway on some hardware at speed we can pressure the VM excessively
for page pairs. We don't really need big buffers to be linear so don't try
so hard.

In order to make this work well we will tidy up excess callers to request_room,
which cannot itself enforce this break up.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tty_buffer.c |    6 ++++--
 include/linux/tty.h       |   10 ++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/char/tty_buffer.c
+++ b/drivers/char/tty_buffer.c
@@ -247,7 +247,8 @@ int tty_insert_flip_string(struct tty_st
 {
 	int copied = 0;
 	do {
-		int space = tty_buffer_request_room(tty, size - copied);
+		int goal = min(size - copied, TTY_BUFFER_PAGE);
+		int space = tty_buffer_request_room(tty, goal);
 		struct tty_buffer *tb = tty->buf.tail;
 		/* If there is no space then tb may be NULL */
 		if (unlikely(space == 0))
@@ -283,7 +284,8 @@ int tty_insert_flip_string_flags(struct
 {
 	int copied = 0;
 	do {
-		int space = tty_buffer_request_room(tty, size - copied);
+		int goal = min(size - copied, TTY_BUFFER_PAGE);
+		int space = tty_buffer_request_room(tty, goal);
 		struct tty_buffer *tb = tty->buf.tail;
 		/* If there is no space then tb may be NULL */
 		if (unlikely(space == 0))
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -68,6 +68,16 @@ struct tty_buffer {
 	unsigned long data[0];
 };
 
+/*
+ * We default to dicing tty buffer allocations to this many characters
+ * in order to avoid multiple page allocations. We assume tty_buffer itself
+ * is under 256 bytes. See tty_buffer_find for the allocation logic this
+ * must match
+ */
+
+#define TTY_BUFFER_PAGE		((PAGE_SIZE  - 256) / 2)
+
+
 struct tty_bufhead {
 	struct delayed_work work;
 	spinlock_t lock;


