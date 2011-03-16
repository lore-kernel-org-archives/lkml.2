Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab1CPVXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:23:25 -0400
Received: from mail.ch.keymile.com ([193.17.201.103]:34474 "HELO
	mail.ch.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755298Ab1CPVXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:23:17 -0400
X-Greylist: delayed 2124 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Mar 2011 17:23:17 EDT
Message-ID: <4D8121F6.9060600@keymile.com>
Date: Wed, 16 Mar 2011 21:47:50 +0100
From: Stefan Bigler <stefan.bigler@keymile.com>
Reply-To: stefan.bigler@keymile.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: TTY loosing data with u_serial gadget
Content-Type: text/plain;
	charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Mar 2011 20:47:50.0774 (UTC) FILETIME=[6A3BB960:01CBE41B]
X-ESAFE-STATUS: Mail allowed
X-ESAFE-DETAILS: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

I'm facing a problem with TTY loosing data using u_serial gadget.

I have a MPC8247 based system running 2.6.33. Data transfer is done 
bidirectional
to see the problem more often. I use tty in raw mode and do some delayed 
reads on the
receiver side to stress the throttling / un-throttling.

I tracked down the problem and was able to see that n_tty_receive_buf()
is not able to store all data in the read queue.

The function flush_to_ldisc() use the values of tty->receive_room to
schedule_delayed_work()or to pass data to receive_buf() and finally 
n_tty_receive_buf().
Also the number of passed bytes rely on variable receive_room.

I added debug code to re-calculate the real free space.
   left_space = N_TTY_BUF_SIZE - tty->read_cnt - 1;
Comparing receive_room and left_space showed in some cases big 
differences up to 1600
bytes. left_space was always smaller and sometimes zero.

receive_room is calculated in n_tty_set_room() without read locking.
There are various "FIXME does n_tty_set_room need locking ?"
My test showed, adding a read looking solves the problem.

I asked me why is the locking not done? How big is the risk for dead-locks?
To minimize this risk, I reduced the changes to a minimum (see the patch 
below).
The code in the patch only re-calculates the receive_room for raw mode 
right before
it is used in flush_to_ldisc().

Can somebody give me an advice, what is the best way to solve this problem?

Thanks for your help.

Regards Stefan


 From 91b04c875cecc890139ccdd101cfff6b02b5f22c Mon Sep 17 00:00:00 2001
From: Stefan Bigler <stefan.bigler@keymile.com>
Date: Wed, 16 Mar 2011 15:20:03 +0100
Subject: [PATCH 1/1] n_tty: fix race condition with receive_room

Do an additional update of receive_room with locking for raw tty.
The n_tty_set_room is done without locking what is known as a
potential problem.
In case of heavy load and raw tty  and flush_to_ldisc() determine
the number of char to send with receive_buf(). If there is not
enough space available in receive_buf() the data is lost.
This additional update of receive_room should reduce the risk of
have invalid receive_room. It is not a clean fix but the risk of
risk a dead-lock with clean protection is too high

Signed-off-by: Stefan Bigler <stefan.bigler@keymile.com>
---
  drivers/char/tty_buffer.c |   16 ++++++++++++++++
  1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
index f27c4d6..5db07fe 100644
--- a/drivers/char/tty_buffer.c
+++ b/drivers/char/tty_buffer.c
@@ -431,6 +431,22 @@ static void flush_to_ldisc(struct work_struct *work)
                 line discipline as we want to empty the queue */
              if (test_bit(TTY_FLUSHPENDING, &tty->flags))
                  break;
+
+            /* Take read_lock to update receive_room.
+               This avoids invalid free space information.
+               To limit the risk of introducing problems
+               only do it for raw tty */
+            if (tty->raw) {
+                unsigned long flags_r;
+                spin_lock_irqsave(&tty->read_lock,
+                    flags_r);
+                tty->receive_room =
+                    N_TTY_BUF_SIZE -
+                    tty->read_cnt - 1;
+                spin_unlock_irqrestore(&tty->read_lock,
+                    flags_r);
+            }
+
              if (!tty->receive_room) {
                  schedule_delayed_work(&tty->buf.work, 1);
                  break;
-- 
1.7.0.5




