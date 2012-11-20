Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab2KTQfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:35:20 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:49687 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271Ab2KTQfS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:35:18 -0500
Date: Tue, 20 Nov 2012 17:35:41 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Krzysztof Mazur <krzysiek@podlesie.net>
Subject: [PATCH] tty vt: Fix a regression in command line edition
Message-ID: <20121120173541.27e28d27@armhf>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-François Moine <moinejf@free.fr>

The commit 81732c3b2fede049a692e58a7ceabb6d18ffb18c
("Fix line garbage in virtual console on command line edition")
made a regression with some machines: some characters were not erased
after line edition.

This patch adjusts the number of moved characters and the size of the
region to be updated.

It may be applied on both kernels 3.6 and 3.7.

Signed-off-by: Jean-François Moine <moinejf@free.fr>
Tested-by: Krzysztof Mazur <krzysiek@podlesie.net>

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -539,25 +539,25 @@
 {
 	unsigned short *p = (unsigned short *) vc->vc_pos;
 
-	scr_memmovew(p + nr, p, vc->vc_cols - vc->vc_x);
+	scr_memmovew(p + nr, p, (vc->vc_cols - vc->vc_x) * 2);
 	scr_memsetw(p, vc->vc_video_erase_char, nr * 2);
 	vc->vc_need_wrap = 0;
 	if (DO_UPDATE(vc))
 		do_update_region(vc, (unsigned long) p,
-			(vc->vc_cols - vc->vc_x) / 2 + 1);
+			vc->vc_cols - vc->vc_x);
 }
 
 static void delete_char(struct vc_data *vc, unsigned int nr)
 {
 	unsigned short *p = (unsigned short *) vc->vc_pos;
 
-	scr_memcpyw(p, p + nr, vc->vc_cols - vc->vc_x - nr);
+	scr_memcpyw(p, p + nr, (vc->vc_cols - vc->vc_x - nr) * 2);
 	scr_memsetw(p + vc->vc_cols - vc->vc_x - nr, vc->vc_video_erase_char,
 			nr * 2);
 	vc->vc_need_wrap = 0;
 	if (DO_UPDATE(vc))
 		do_update_region(vc, (unsigned long) p,
-			(vc->vc_cols - vc->vc_x) / 2);
+			vc->vc_cols - vc->vc_x);
 }
 
 static int softcursor_original;

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
