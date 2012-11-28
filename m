Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab2K1Rvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:51:31 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49995 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2K1Rv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:51:29 -0500
Message-ID: <1354125084.20578.1.camel@nja>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
From: Kay Sievers <kay@vrfy.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 28 Nov 2012 18:51:24 +0100
In-Reply-To: <CAPXgP11teRC8bFNzF2NHJ78Bj-jf0fgRz++5vjeHVEHY=+Xe+A@mail.gmail.com>
References: <1336004953.4240.9.camel@mop>
	 <CAHO5Pa2_D_L6wKPWccaYH2BYWYFc=4Khe0Om5GWU3D-tcAH0OQ@mail.gmail.com>
	 <CAPXgP12jXOJzTTgwQkm7XK_ig2iEKAbhgNkF+MRR6_S49Tqx_A@mail.gmail.com>
	 <CA+55aFxVyqScRU_c6RWVVub-tteuwjSq5JmThUtoxU-arBuh1w@mail.gmail.com>
	 <CAPXgP11teRC8bFNzF2NHJ78Bj-jf0fgRz++5vjeHVEHY=+Xe+A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2 (3.6.2-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-28 at 17:49 +0100, Kay Sievers wrote:
> On Wed, Nov 28, 2012 at 5:37 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Wed, Nov 28, 2012 at 8:22 AM, Kay Sievers <kay@vrfy.org> wrote:
> >> On Wed, Nov 28, 2012 at 2:33 PM, Michael Kerrisk <mtk.manpages@gmail.com> wrote:
> >>
> >>> On a 2.6.31 system, immediately after SYSLOG_ACTION_READ_CLEAR, a
> >>> SYSLOG_ACTION_SIZE_UNREAD returns 0.
> >>
> >> Hmm, sounds like the right thing to do.
> >
> > Right.
> >
> > And that's the *OLD* behavior (2.6.31).
> 
> Ah, hmm, I read 2.6... as 3.6... :)
> 
> > So the new behavior is insane and different. Let's fix it.
> 
> Yeah.
> 
> > It looks like it is because the new SYSLOG_ACTION_SIZE_UNREAD code
> > does not take the new clear_seq code into account. Hmm?
> 
> Right, something like that. I'll take a look now ...

From: Kay Sievers <kay@vrfy.org>
Subject: printk: respect SYSLOG_ACTION_READ_CLEAR for SYSLOG_ACTION_SIZE_UNREAD

On Wed, Nov 28, 2012 at 2:33 PM, Michael Kerrisk <mtk.manpages@gmail.com> wrote:
> It looks as though the changes here have broken SYSLOG_ACTION_SIZE_UNREAD.
> 
> On a 2.6.31 system, immediately after SYSLOG_ACTION_READ_CLEAR, a
> SYSLOG_ACTION_SIZE_UNREAD returns 0.
> 
> On 3.5, immediately after SYSLOG_ACTION_READ_CLEAR, the value returned
> by SYSLOG_ACTION_SIZE_UNREAD is unchanged (i.e., assuming that the
> value returned was non-zero before SYSLOG_ACTION_SIZE_UNREAD, it is
> still nonzero afterward), even though a subsequent
> SYSLOG_ACTION_READ_CLEAR indicates that there are zero bytes to read.

Fix SYSLOG_ACTION_SIZE_UNREAD to return the amount of available
characters by starting to count at the first available record after
the last SYSLOG_ACTION_READ_CLEAR, instead of the first message
record for SYSLOG_ACTION_READ.

Before:
  syslog(SYSLOG_ACTION_SIZE_UNREAD, 0, 0) = 286965
  syslog(SYSLOG_ACTION_READ_CLEAR, "<12>"..., 1000000) = 24000
  syslog(SYSLOG_ACTION_SIZE_UNREAD, 0, 0) = 286965

After:
  syslog(SYSLOG_ACTION_SIZE_UNREAD, 0, 0) = 90402
  syslog(SYSLOG_ACTION_READ_CLEAR, "<5>"..., 1000000) = 90402
  syslog(SYSLOG_ACTION_SIZE_UNREAD, 0, 0) = 0

Reported-By: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-Off-By: Kay Sievers <kay@vrfy.org>
---
 printk.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 2d607f4..35a7f4f 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1183,12 +1183,10 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 	/* Number of chars in the log buffer */
 	case SYSLOG_ACTION_SIZE_UNREAD:
 		raw_spin_lock_irq(&logbuf_lock);
-		if (syslog_seq < log_first_seq) {
+		if (clear_seq < log_first_seq) {
 			/* messages are gone, move to first one */
-			syslog_seq = log_first_seq;
-			syslog_idx = log_first_idx;
-			syslog_prev = 0;
-			syslog_partial = 0;
+			clear_seq = log_first_seq;
+			clear_idx = log_first_idx;
 		}
 		if (from_file) {
 			/*
@@ -1198,9 +1196,9 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 			 */
 			error = log_next_idx - syslog_idx;
 		} else {
-			u64 seq = syslog_seq;
-			u32 idx = syslog_idx;
-			enum log_flags prev = syslog_prev;
+			u64 seq = clear_seq;
+			u32 idx = clear_idx;
+			enum log_flags prev = 0;
 
 			error = 0;
 			while (seq < log_next_seq) {
@@ -1211,7 +1209,6 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 				seq++;
 				prev = msg->flags;
 			}
-			error -= syslog_partial;
 		}
 		raw_spin_unlock_irq(&logbuf_lock);
 		break;


