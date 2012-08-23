Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934303Ab2HWS4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:56:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37344 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934227Ab2HWS4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:56:01 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Borislav Petkov <bp@alien8.de>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Jean Sacren <sakiwit@gmail.com>, Arnaud Lacombe <lacombar@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Davidlohr Bueso <dave@gnu.org>, Wang YanQing <udknight@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Cheng Renquan <crquan@gmail.com>
Subject: [PATCH v2 5/6] menuconfig: Do not open code textbox scroll up/down
Date: Thu, 23 Aug 2012 14:55:07 -0400
Message-Id: <1345748108-12206-6-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1345748108-12206-1-git-send-email-bpoirier@suse.de>
References: <1345748108-12206-1-git-send-email-bpoirier@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to explicitely use ncurses' scroll(). ncurses performs
vertical-motion optimization at wrefresh() time.

Using strace I confirmed that with the following patch curses still sends only
the new line of text to the terminal when scrolling up/down one line at a
time.

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
---
 scripts/kconfig/lxdialog/textbox.c |   55 +++++++----------------------------
 1 files changed, 11 insertions(+), 44 deletions(-)

diff --git a/scripts/kconfig/lxdialog/textbox.c b/scripts/kconfig/lxdialog/textbox.c
index 506a095..3b3c5c4 100644
--- a/scripts/kconfig/lxdialog/textbox.c
+++ b/scripts/kconfig/lxdialog/textbox.c
@@ -166,40 +166,12 @@ do_resize:
 		case 'K':	/* Previous line */
 		case 'k':
 		case KEY_UP:
-			if (!begin_reached) {
-				int passed_end = 0;
-
-				back_lines(page_length + 1);
-
-				/* We don't call print_page() here but use
-				 * scrolling to ensure faster screen update.
-				 * However, 'end_reached' and 'page_length'
-				 * should still be updated, and 'page' should
-				 * point to start of next page. This is done
-				 * by calling get_line() in the following
-				 * 'for' loop. */
-				scrollok(box, TRUE);
-				wscrl(box, -1);	/* Scroll box region down one line */
-				scrollok(box, FALSE);
-				page_length = 0;
-				for (i = 0; i < boxh; i++) {
-					if (!i) {
-						/* print first line of page */
-						print_line(box, 0, boxw);
-						wnoutrefresh(box);
-					} else
-						/* Called to update 'end_reached' and 'page' */
-						get_line();
-					if (!passed_end)
-						page_length++;
-					if (end_reached && !passed_end)
-						passed_end = 1;
-				}
+			if (begin_reached)
+				break;
 
-				print_position(dialog);
-				wmove(dialog, cur_y, cur_x);	/* Restore cursor position */
-				wrefresh(dialog);
-			}
+			back_lines(page_length + 1);
+			refresh_text_box(dialog, box, boxh, boxw, cur_y,
+					 cur_x);
 			break;
 		case 'B':	/* Previous page */
 		case 'b':
@@ -214,17 +186,12 @@ do_resize:
 		case 'J':	/* Next line */
 		case 'j':
 		case KEY_DOWN:
-			if (!end_reached) {
-				begin_reached = 0;
-				scrollok(box, TRUE);
-				scroll(box);	/* Scroll box region up one line */
-				scrollok(box, FALSE);
-				print_line(box, boxh - 1, boxw);
-				wnoutrefresh(box);
-				print_position(dialog);
-				wmove(dialog, cur_y, cur_x);	/* Restore cursor position */
-				wrefresh(dialog);
-			}
+			if (end_reached)
+				break;
+
+			back_lines(page_length - 1);
+			refresh_text_box(dialog, box, boxh, boxw, cur_y,
+					 cur_x);
 			break;
 		case KEY_NPAGE:	/* Next page */
 		case ' ':
-- 
1.7.7

