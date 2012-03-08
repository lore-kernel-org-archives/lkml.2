Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab2CHIMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 03:12:50 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42202 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375Ab2CHIMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 03:12:46 -0500
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Subject: [PATCH RESEND 1/2] menuconfig: basic string editing in inputbox
 support
To: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 08 Mar 2012 10:12:40 +0200
Message-ID: <20120308081240.3221.39451.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For me the most irritating thing in linux kernel was absence
of string editing in menuconfig's inputbox. If you wanted to
change first symbol you had to delete all string and then type
it all again.
New implementation handles right/left cursor, backspace and
delete keys. It does a little bit more terminal manipulations
as string area is fully redrawn on each event.

Signed-off-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>
---

 scripts/kconfig/lxdialog/inputbox.c |   87 +++++++++++++++++++++--------------
 1 files changed, 53 insertions(+), 34 deletions(-)

diff --git a/scripts/kconfig/lxdialog/inputbox.c b/scripts/kconfig/lxdialog/inputbox.c
index dd8e587..834eee9 100644
--- a/scripts/kconfig/lxdialog/inputbox.c
+++ b/scripts/kconfig/lxdialog/inputbox.c
@@ -44,7 +44,7 @@ static void print_buttons(WINDOW * dialog, int height, int width, int selected)
 int dialog_inputbox(const char *title, const char *prompt, int height, int width,
                     const char *init)
 {
-	int i, x, y, box_y, box_x, box_width;
+	int i, len, x, y, box_y, box_x, box_width;
 	int input_x = 0, scroll = 0, key = 0, button = -1;
 	char *instr = dialog_input_result;
 	WINDOW *dialog;
@@ -54,6 +54,8 @@ int dialog_inputbox(const char *title, const char *prompt, int height, int width
 	else
 		strcpy(instr, init);
 
+	len = strlen(instr);
+
 do_resize:
 	if (getmaxy(stdscr) <= (height - 2))
 		return -ERRDISPLAYTOOSMALL;
@@ -97,14 +99,13 @@ do_resize:
 	wmove(dialog, box_y, box_x);
 	wattrset(dialog, dlg.inputbox.atr);
 
-	input_x = strlen(instr);
-
-	if (input_x >= box_width) {
-		scroll = input_x - box_width + 1;
+	if (len >= box_width) {
+		scroll = len - box_width + 1;
 		input_x = box_width - 1;
 		for (i = 0; i < box_width - 1; i++)
 			waddch(dialog, instr[scroll + i]);
 	} else {
+		input_x = len;
 		waddstr(dialog, instr);
 	}
 
@@ -121,50 +122,68 @@ do_resize:
 			case KEY_UP:
 			case KEY_DOWN:
 				break;
-			case KEY_LEFT:
-				continue;
 			case KEY_RIGHT:
+				if (scroll + input_x < len) {
+					if (input_x == box_width - 1)
+						scroll++;
+					else
+						input_x++;
+					goto redraw;
+				}
 				continue;
+			case KEY_LEFT:
 			case KEY_BACKSPACE:
 			case 127:
 				if (input_x || scroll) {
-					wattrset(dialog, dlg.inputbox.atr);
-					if (!input_x) {
-						scroll = scroll < box_width - 1 ? 0 : scroll - (box_width - 1);
-						wmove(dialog, box_y, box_x);
-						for (i = 0; i < box_width; i++)
-							waddch(dialog,
-							       instr[scroll + input_x + i] ?
-							       instr[scroll + input_x + i] : ' ');
-						input_x = strlen(instr) - scroll;
-					} else
+					/* 
+					 * Some fancy scrolling, so you can see what
+					 * you will be deleting with backspace
+					 */
+					if (!input_x || (input_x < box_width / 4 && scroll))
+						scroll--;
+					else
 						input_x--;
-					instr[scroll + input_x] = '\0';
-					mvwaddch(dialog, box_y, input_x + box_x, ' ');
-					wmove(dialog, box_y, input_x + box_x);
-					wrefresh(dialog);
+
+					if (key != KEY_LEFT) {
+						int pos = scroll + input_x;
+						memmove(&instr[pos], &instr[pos + 1], len-- - pos + 1);
+					}
+					goto redraw;
+				}
+				continue;
+			case KEY_DC:
+				if (scroll + input_x < len) {
+					int pos = scroll + input_x;
+					memmove(&instr[pos], &instr[pos + 1], len-- - pos + 1);
+					goto redraw;
 				}
 				continue;
 			default:
 				if (key < 0x100 && isprint(key)) {
-					if (scroll + input_x < MAX_LEN) {
-						wattrset(dialog, dlg.inputbox.atr);
-						instr[scroll + input_x] = key;
-						instr[scroll + input_x + 1] = '\0';
-						if (input_x == box_width - 1) {
+					if (len < MAX_LEN) {
+						int pos = scroll + input_x;
+						memmove(&instr[pos + 1], &instr[pos], len++ - pos + 1);
+						instr[pos] = key;
+						if (input_x == box_width - 1)
 							scroll++;
-							wmove(dialog, box_y, box_x);
-							for (i = 0; i < box_width - 1; i++)
-								waddch(dialog, instr [scroll + i]);
-						} else {
-							wmove(dialog, box_y, input_x++ + box_x);
-							waddch(dialog, key);
-						}
-						wrefresh(dialog);
+						else
+							input_x++;
+						goto redraw;
 					} else
 						flash();	/* Alarm user about overflow */
 					continue;
 				}
+				break;
+			redraw:
+				wattrset(dialog, dlg.inputbox.atr);
+				wmove(dialog, box_y, box_x);
+				for (i = 0; i < box_width - 1; i++)
+					waddch(dialog,
+					       scroll + i < len ?
+					       instr[scroll + i] : ' ');
+				wmove(dialog, box_y, input_x + box_x);
+				wrefresh(dialog);
+				continue;
 			}
 		}
 		switch (key) {

