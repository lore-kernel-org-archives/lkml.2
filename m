Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab0J0HLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 03:11:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab0J0HLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 03:11:06 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: alan@lxorguk.ukuu.org.uk, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] tty: prevent DOS in the flush_to_ldisc
Date: Wed, 27 Oct 2010 09:10:51 +0200
Message-Id: <1288163451-3973-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

there's a small window inside the flush_to_ldisc function,
where the tty is unlocked and calling ldisc's receive_buf
function. If in this window new buffer is added to the tty,
the processing might never leave the flush_to_ldisc function.

This scenario will hog the cpu, causing other tty processing
starving, and making it impossible to interface the computer
via tty.

I was able to exploit this via pty interface by sending only
control characters to the master input, causing the flush_to_ldisc
to be scheduled, but never actually generate any output.

To reproduce, please run multiple instances of following code.

---
#define _XOPEN_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char **argv)
{
	int i, slave, master = getpt();
	char buf[8192];

	sprintf(buf, "%s", ptsname(master));
	grantpt(master);
	unlockpt(master);

	slave = open(buf, O_RDWR);
	if (slave < 0) {
		perror("open slave failed");
		return 1;
	}

	for(i = 0; i < sizeof(buf); i++)
		buf[i] = rand() % 32;

	while(1) {
		write(master, buf, sizeof(buf));
	}

	return 0;
}
---

The attached patch (based on -next tree) fixes this by adding threshold
for processed data. When the threshold is reached, the current work is
rescheduled, so another could run.

The threshold is set to the tty buffer maximum size.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 drivers/char/tty_buffer.c |   15 ++++++++++++++-
 include/linux/tty.h       |    1 +
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
index cc1e985..7703114 100644
--- a/drivers/char/tty_buffer.c
+++ b/drivers/char/tty_buffer.c
@@ -58,7 +58,7 @@ static struct tty_buffer *tty_buffer_alloc(struct tty_struct *tty, size_t size)
 {
 	struct tty_buffer *p;
 
-	if (tty->buf.memory_used + size > 65536)
+	if (tty->buf.memory_used + size > TTY_BUFFER_MAXSIZE)
 		return NULL;
 	p = kmalloc(sizeof(struct tty_buffer) + 2 * size, GFP_ATOMIC);
 	if (p == NULL)
@@ -414,6 +414,7 @@ static void flush_to_ldisc(struct work_struct *work)
 
 	if (!test_and_set_bit(TTY_FLUSHING, &tty->flags)) {
 		struct tty_buffer *head;
+		int count_acc = 0;
 		while ((head = tty->buf.head) != NULL) {
 			int count;
 			char *char_buf;
@@ -436,11 +437,23 @@ static void flush_to_ldisc(struct work_struct *work)
 				schedule_delayed_work(&tty->buf.work, 1);
 				break;
 			}
+			/*
+			 * There's a possibility tty might get new buffer
+			 * added during the unlock window below. We could
+			 * end up spinning in here forever hogging the CPU
+			 * completely. To avoid this let's have a rest each
+			 * time we process the maximum one tty can hold.
+			 */
+			if (count_acc > TTY_BUFFER_MAXSIZE) {
+				schedule_delayed_work(&tty->buf.work, 1);
+				break;
+			}
 			if (count > tty->receive_room)
 				count = tty->receive_room;
 			char_buf = head->char_buf_ptr + head->read;
 			flag_buf = head->flag_buf_ptr + head->read;
 			head->read += count;
+			count_acc += count;
 			spin_unlock_irqrestore(&tty->buf.lock, flags);
 			disc->ops->receive_buf(tty, char_buf,
 							flag_buf, count);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index e500171..708e299 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -80,6 +80,7 @@ struct tty_buffer {
  */
 
 #define TTY_BUFFER_PAGE	(((PAGE_SIZE - sizeof(struct tty_buffer)) / 2) & ~0xFF)
+#define TTY_BUFFER_MAXSIZE	(65536)
 
 
 struct tty_bufhead {
-- 
1.7.1

