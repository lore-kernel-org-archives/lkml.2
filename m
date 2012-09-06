Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab2IFRYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:24:16 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:39921 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173Ab2IFRYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:24:15 -0400
Date: Thu, 6 Sep 2012 19:24:13 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tty vt: Fix line garbage in virtual console on command line
 edition
Message-ID: <20120906192413.38b1d120@armhf>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-François Moine <moinejf@free.fr>

On some machines using a specific hardware for console screen output,
the update of the pixel frame buffer does not work correctly when
using command line edition. This may be due to a memory cache bug
in the machine on which the problem has been found, but an other
solution is possible.

This patch proposes to avoid touching directly the pixel frame buffer
and to rebuild each character using the standard putc() function
on command line edition.

The resulting code is smaller and not obviously slower (no read
access to the pixel frame buffer).

Tested on a Cubox (ARM Marvell Dove 88AP510 SoC).

Signed-off-by: Jean-François Moine <moinejf@free.fr>
---
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 84cbf29..13ae2fe 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -537,45 +537,27 @@ void complement_pos(struct vc_data *vc, int offset)
 
 static void insert_char(struct vc_data *vc, unsigned int nr)
 {
-	unsigned short *p, *q = (unsigned short *)vc->vc_pos;
+	unsigned short *p = (unsigned short *) vc->vc_pos;
 
-	p = q + vc->vc_cols - nr - vc->vc_x;
-	while (--p >= q)
-		scr_writew(scr_readw(p), p + nr);
-	scr_memsetw(q, vc->vc_video_erase_char, nr * 2);
+	scr_memmovew(p + nr, p, vc->vc_cols - vc->vc_x);
+	scr_memsetw(p, vc->vc_video_erase_char, nr * 2);
 	vc->vc_need_wrap = 0;
-	if (DO_UPDATE(vc)) {
-		unsigned short oldattr = vc->vc_attr;
-		vc->vc_sw->con_bmove(vc, vc->vc_y, vc->vc_x, vc->vc_y, vc->vc_x + nr, 1,
-				     vc->vc_cols - vc->vc_x - nr);
-		vc->vc_attr = vc->vc_video_erase_char >> 8;
-		while (nr--)
-			vc->vc_sw->con_putc(vc, vc->vc_video_erase_char, vc->vc_y, vc->vc_x + nr);
-		vc->vc_attr = oldattr;
-	}
+	if (DO_UPDATE(vc))
+		do_update_region(vc, (unsigned long) p,
+			(vc->vc_cols - vc->vc_x) / 2 + 1);
 }
 
 static void delete_char(struct vc_data *vc, unsigned int nr)
 {
-	unsigned int i = vc->vc_x;
-	unsigned short *p = (unsigned short *)vc->vc_pos;
+	unsigned short *p = (unsigned short *) vc->vc_pos;
 
-	while (++i <= vc->vc_cols - nr) {
-		scr_writew(scr_readw(p+nr), p);
-		p++;
-	}
-	scr_memsetw(p, vc->vc_video_erase_char, nr * 2);
+	scr_memcpyw(p, p + nr, vc->vc_cols - vc->vc_x - nr);
+	scr_memsetw(p + vc->vc_cols - vc->vc_x - nr, vc->vc_video_erase_char,
+			nr * 2);
 	vc->vc_need_wrap = 0;
-	if (DO_UPDATE(vc)) {
-		unsigned short oldattr = vc->vc_attr;
-		vc->vc_sw->con_bmove(vc, vc->vc_y, vc->vc_x + nr, vc->vc_y, vc->vc_x, 1,
-				     vc->vc_cols - vc->vc_x - nr);
-		vc->vc_attr = vc->vc_video_erase_char >> 8;
-		while (nr--)
-			vc->vc_sw->con_putc(vc, vc->vc_video_erase_char, vc->vc_y,
-				     vc->vc_cols - 1 - nr);
-		vc->vc_attr = oldattr;
-	}
+	if (DO_UPDATE(vc))
+		do_update_region(vc, (unsigned long) p,
+			(vc->vc_cols - vc->vc_x) / 2);
 }
 
 static int softcursor_original;
@@ -1172,45 +1154,26 @@ static void csi_J(struct vc_data *vc, int vpar)
 		case 0:	/* erase from cursor to end of display */
 			count = (vc->vc_scr_end - vc->vc_pos) >> 1;
 			start = (unsigned short *)vc->vc_pos;
-			if (DO_UPDATE(vc)) {
-				/* do in two stages */
-				vc->vc_sw->con_clear(vc, vc->vc_y, vc->vc_x, 1,
-					      vc->vc_cols - vc->vc_x);
-				vc->vc_sw->con_clear(vc, vc->vc_y + 1, 0,
-					      vc->vc_rows - vc->vc_y - 1,
-					      vc->vc_cols);
-			}
 			break;
 		case 1:	/* erase from start to cursor */
 			count = ((vc->vc_pos - vc->vc_origin) >> 1) + 1;
 			start = (unsigned short *)vc->vc_origin;
-			if (DO_UPDATE(vc)) {
-				/* do in two stages */
-				vc->vc_sw->con_clear(vc, 0, 0, vc->vc_y,
-					      vc->vc_cols);
-				vc->vc_sw->con_clear(vc, vc->vc_y, 0, 1,
-					      vc->vc_x + 1);
-			}
 			break;
 		case 3: /* erase scroll-back buffer (and whole display) */
 			scr_memsetw(vc->vc_screenbuf, vc->vc_video_erase_char,
 				    vc->vc_screenbuf_size >> 1);
 			set_origin(vc);
-			if (CON_IS_VISIBLE(vc))
-				update_screen(vc);
 			/* fall through */
 		case 2: /* erase whole display */
 			count = vc->vc_cols * vc->vc_rows;
 			start = (unsigned short *)vc->vc_origin;
-			if (DO_UPDATE(vc))
-				vc->vc_sw->con_clear(vc, 0, 0,
-					      vc->vc_rows,
-					      vc->vc_cols);
 			break;
 		default:
 			return;
 	}
 	scr_memsetw(start, vc->vc_video_erase_char, 2 * count);
+	if (DO_UPDATE(vc))
+		do_update_region(vc, (unsigned long) start, count);
 	vc->vc_need_wrap = 0;
 }
 
@@ -1223,29 +1186,22 @@ static void csi_K(struct vc_data *vc, int vpar)
 		case 0:	/* erase from cursor to end of line */
 			count = vc->vc_cols - vc->vc_x;
 			start = (unsigned short *)vc->vc_pos;
-			if (DO_UPDATE(vc))
-				vc->vc_sw->con_clear(vc, vc->vc_y, vc->vc_x, 1,
-						     vc->vc_cols - vc->vc_x);
 			break;
 		case 1:	/* erase from start of line to cursor */
 			start = (unsigned short *)(vc->vc_pos - (vc->vc_x << 1));
 			count = vc->vc_x + 1;
-			if (DO_UPDATE(vc))
-				vc->vc_sw->con_clear(vc, vc->vc_y, 0, 1,
-						     vc->vc_x + 1);
 			break;
 		case 2: /* erase whole line */
 			start = (unsigned short *)(vc->vc_pos - (vc->vc_x << 1));
 			count = vc->vc_cols;
-			if (DO_UPDATE(vc))
-				vc->vc_sw->con_clear(vc, vc->vc_y, 0, 1,
-					      vc->vc_cols);
 			break;
 		default:
 			return;
 	}
 	scr_memsetw(start, vc->vc_video_erase_char, 2 * count);
 	vc->vc_need_wrap = 0;
+	if (DO_UPDATE(vc))
+		do_update_region(vc, (unsigned long) start, count);
 }
 
 static void csi_X(struct vc_data *vc, int vpar) /* erase the following vpar positions */


-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
