Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab0KHSCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 13:02:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261Ab0KHSB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 13:01:59 -0500
Date: Mon, 8 Nov 2010 19:01:47 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCHv2] tty: prevent DOS in the flush_to_ldisc
Message-ID: <20101108180147.GB3275@jolsa.brq.redhat.com>
References: <1288163451-3973-1-git-send-email-jolsa@redhat.com>
 <20101108134840.GA3275@jolsa.brq.redhat.com>
 <20101108140938.06b7ee65@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108140938.06b7ee65@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 02:09:38PM +0000, Alan Cox wrote:
> On Mon, 8 Nov 2010 14:48:41 +0100
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > hi, any feedback?
> 
> Don't think I saw this before.
> 
> > > The attached patch (based on -next tree) fixes this by adding threshold
> > > for processed data. When the threshold is reached, the current work is
> > > rescheduled, so another could run.
> > > 
> > > The threshold is set to the tty buffer maximum size.
> 
> That is an n_tty concept really - most other ldiscs simply eat stuff as
> it hits them. It's also something we've got some evidence may need to
> become a variable, but would still make sense.
> 
> Would it be simpler to remember the queue end before the first iteration
> and not go past the queue end as it was at the entry to flush_to_ldisc.

hi,

thanks for answering :)
I changed the patch to check on the tail buffer instead..
seems it's better.

wbr,
jirka
---

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

wbr,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 drivers/char/tty_buffer.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
index cc1e985..d8210ca 100644
--- a/drivers/char/tty_buffer.c
+++ b/drivers/char/tty_buffer.c
@@ -413,7 +413,8 @@ static void flush_to_ldisc(struct work_struct *work)
 	spin_lock_irqsave(&tty->buf.lock, flags);
 
 	if (!test_and_set_bit(TTY_FLUSHING, &tty->flags)) {
-		struct tty_buffer *head;
+		struct tty_buffer *head, *tail = tty->buf.tail;
+		int seen_tail = 0;
 		while ((head = tty->buf.head) != NULL) {
 			int count;
 			char *char_buf;
@@ -423,6 +424,15 @@ static void flush_to_ldisc(struct work_struct *work)
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
@@ -432,7 +442,7 @@ static void flush_to_ldisc(struct work_struct *work)
 			   line discipline as we want to empty the queue */
 			if (test_bit(TTY_FLUSHPENDING, &tty->flags))
 				break;
-			if (!tty->receive_room) {
+			if (!tty->receive_room || seen_tail) {
 				schedule_delayed_work(&tty->buf.work, 1);
 				break;
 			}
-- 
1.7.1

