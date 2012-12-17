Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab2LQOht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 09:37:49 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38518 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab2LQOhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 09:37:47 -0500
Date: Mon, 17 Dec 2012 22:38:02 +0800
From: Wang YanQing <udknight@gmail.com>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, bp@alien8.de, yann.morin.1998@free.fr,
        sakiwit@gmail.com, lacombar@gmail.com, lucas.demarchi@profusion.mobi,
        dave@gnu.org, paul.gortmaker@windriver.com, crquan@gmail.com,
        bpoirier@suse.de
Subject: [PATCH] menuconfig:inputbox: support navigate input position
Message-ID: <20121217143802.GB16993@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, mmarek@suse.cz,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	rdunlap@xenotime.net, bp@alien8.de, yann.morin.1998@free.fr,
	sakiwit@gmail.com, lacombar@gmail.com,
	lucas.demarchi@profusion.mobi, dave@gnu.org,
	paul.gortmaker@windriver.com, crquan@gmail.com, bpoirier@suse.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support navigate input position *inside* the input
field with LEFT/RIGHT, so it is possible to modify the text in place.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 scripts/kconfig/lxdialog/inputbox.c | 121 +++++++++++++++++++++++++++---------
 1 file changed, 92 insertions(+), 29 deletions(-)

diff --git a/scripts/kconfig/lxdialog/inputbox.c b/scripts/kconfig/lxdialog/inputbox.c
index dd8e587..21404a0 100644
--- a/scripts/kconfig/lxdialog/inputbox.c
+++ b/scripts/kconfig/lxdialog/inputbox.c
@@ -45,7 +45,8 @@ int dialog_inputbox(const char *title, const char *prompt, int height, int width
                     const char *init)
 {
 	int i, x, y, box_y, box_x, box_width;
-	int input_x = 0, scroll = 0, key = 0, button = -1;
+	int input_x = 0, key = 0, button = -1;
+	int show_x, len, pos;
 	char *instr = dialog_input_result;
 	WINDOW *dialog;
 
@@ -97,14 +98,17 @@ do_resize:
 	wmove(dialog, box_y, box_x);
 	wattrset(dialog, dlg.inputbox.atr);
 
-	input_x = strlen(instr);
+	len = strlen(instr);
+	pos = len;
 
-	if (input_x >= box_width) {
-		scroll = input_x - box_width + 1;
+	if (len >= box_width) {
+		show_x = len - box_width + 1;
 		input_x = box_width - 1;
 		for (i = 0; i < box_width - 1; i++)
-			waddch(dialog, instr[scroll + i]);
+			waddch(dialog, instr[show_x + i]);
 	} else {
+		show_x = 0;
+		input_x = len;
 		waddstr(dialog, instr);
 	}
 
@@ -121,45 +125,104 @@ do_resize:
 			case KEY_UP:
 			case KEY_DOWN:
 				break;
-			case KEY_LEFT:
-				continue;
-			case KEY_RIGHT:
-				continue;
 			case KEY_BACKSPACE:
 			case 127:
-				if (input_x || scroll) {
+				if (pos) {
 					wattrset(dialog, dlg.inputbox.atr);
-					if (!input_x) {
-						scroll = scroll < box_width - 1 ? 0 : scroll - (box_width - 1);
-						wmove(dialog, box_y, box_x);
-						for (i = 0; i < box_width; i++)
-							waddch(dialog,
-							       instr[scroll + input_x + i] ?
-							       instr[scroll + input_x + i] : ' ');
-						input_x = strlen(instr) - scroll;
+					if (input_x == 0) {
+						show_x--;
 					} else
 						input_x--;
-					instr[scroll + input_x] = '\0';
-					mvwaddch(dialog, box_y, input_x + box_x, ' ');
+
+					if (pos < len) {
+						for (i = pos - 1; i < len; i++) {
+							instr[i] = instr[i+1];
+						}
+					}
+
+					pos--;
+					len--;
+					instr[len] = '\0';
+					wmove(dialog, box_y, box_x);
+					for (i = 0; i < box_width; i++) {
+						if (!instr[show_x + i]) {
+							waddch(dialog, ' ');
+							break;
+						}
+						waddch(dialog, instr[show_x + i]);
+					}
 					wmove(dialog, box_y, input_x + box_x);
 					wrefresh(dialog);
 				}
 				continue;
+			case KEY_LEFT:
+				if (pos > 0) {
+					if (input_x > 0) {
+						wmove(dialog, box_y, --input_x + box_x);
+					} else if (input_x == 0) {
+						show_x--;
+						wmove(dialog, box_y, box_x);
+						for (i = 0; i < box_width; i++) {
+							if (!instr[show_x + i]) {
+								waddch(dialog, ' ');
+								break;
+							}
+							waddch(dialog, instr[show_x + i]);
+						}
+						wmove(dialog, box_y, box_x);
+					}
+					pos--;
+				}
+				continue;
+			case KEY_RIGHT:
+				if (pos < len) {
+					if (input_x < box_width - 1) {
+						wmove(dialog, box_y, ++input_x + box_x);
+					} else if (input_x == box_width - 1) {
+						show_x++;
+						wmove(dialog, box_y, box_x);
+						for (i = 0; i < box_width; i++) {
+							if (!instr[show_x + i]) {
+								waddch(dialog, ' ');
+								break;
+							}
+							waddch(dialog, instr[show_x + i]);
+						}
+						wmove(dialog, box_y, input_x + box_x);
+					}
+					pos++;
+				}
+				continue;
 			default:
 				if (key < 0x100 && isprint(key)) {
-					if (scroll + input_x < MAX_LEN) {
+					if (len < MAX_LEN) {
 						wattrset(dialog, dlg.inputbox.atr);
-						instr[scroll + input_x] = key;
-						instr[scroll + input_x + 1] = '\0';
+						if (pos < len) {
+							for (i = len; i > pos; i--)
+								instr[i] = instr[i-1];
+							instr[pos] = key;
+						} else {
+							instr[len] = key;
+						}
+						pos++;
+						len++;
+						instr[len] = '\0';
+
 						if (input_x == box_width - 1) {
-							scroll++;
-							wmove(dialog, box_y, box_x);
-							for (i = 0; i < box_width - 1; i++)
-								waddch(dialog, instr [scroll + i]);
+							show_x++;
 						} else {
-							wmove(dialog, box_y, input_x++ + box_x);
-							waddch(dialog, key);
+							input_x++;
+						}
+
+						wmove(dialog, box_y, box_x);
+						for (i = 0; i < box_width; i++) {
+							if (!instr[show_x + i]) {
+								waddch(dialog, ' ');
+								break;
+							}
+							waddch(dialog, instr[show_x + i]);
 						}
+						wmove(dialog, box_y, input_x + box_x);
 						wrefresh(dialog);
 					} else
 						flash();	/* Alarm user about overflow */
-- 
1.7.11.1.116.g8228a23
